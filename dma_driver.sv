// DMA driver class which drives the transactions generated to the design.

// TX types: REG_WRITE_CFG, REG_READ_CFG, BASE_REG_CFG, DMA_IO_WRITE_MEM_READ, DMA_IO_READ_MEM_WRITE

class dma_driver;
	
	dma_transaction tx;
	tx_type_t tx_type;
	virtual dma_if.DRIVER vif;
	
	// int num_trans = 0;
	
	// function new();
		// this.vif = dma_cfg::vif;	// pass interface from top to each class which needs it as virtual interface handle
	 // endfunction
	
	task run();
		$display("DMA_DRIVER:: Entered in DRIVER run method!");
		vif = dma_config::vif;
		//wait for DUT to come out of reset
		@(negedge vif.cb.RESET);
		// Chip select and end of process MUST be asserted at the beginning to enable DMA.
		vif.dma_cb.CS_N 	<= 0;
		vif.dma_cb.EOP_N 	<= 0;
		forever begin
		// get transaction from generator
		dma_config::gen2drv.get(tx);
		// drive transactions to DUT
		drive_stimulus(tx);
		if(VERBOSE) tx.print;
		dma_config::num_trans++;
	end
	endtask
	
	// task to drive transactions to DUT
	task drive_dut(dma_transaction tx);
		if(tx.tx_type == REG_WRITE_CFG)			drive_control_regs_cfg(tx);
		else if(tx.tx_type == BASE_REG_CFG)		drive_base_regs_cfg(tx);
		else if(tx.tx_type == REG_READ_CFG)		drive_read_cfg(tx);
		//else if(tx.tx_type == BASE_COUNT_CFG) drive_base_count_cfg(tx);
		//else if(tx.tx_type == DMA_WRITE)		drive_dma_write_tx(tx);
		//else if(tx.tx_type == DMA_READ) 		drive_dma_read_tx(tx);
		//else									drive_dma_stimulus(tx);
		// drive transactions at clock edge using clocking block
		@(vif.cb);
		// convert object level information(tx) to signal level(vif) to drive it to the DUT
	endtask
	
	// task to configure all control registers
	task drive_control_regs_cfg(dma_transaction tx);
		vif.dma_cb.CS_N 	<= 0;
		vif.dma_cb.IOW_N 	<= 0;
		vif.dma_cb.IOR_N 	<= 1;
		repeat(10)@(vif.cb);
		vif.dma_cb.ADDR_L	<= tx.addr_lo;
		vif.dma_cb.DB		<= tx.data; 	// data_in
		@(vif.cb);
		//TODO: get response from the DUT after register configuration
		//dma_config::drv2gen.put(tx);
		vif.dma_cb.IOW_N 	<= 1;
		// DB and ADDR_L pins are expected to be tri-stated if we de-assert IOW_N.
		assert($isunknown(vif.dma_cb.DB));
		assert($isunknown(vif.dma_cb.ADDR_L));
	endtask : drive_control_regs_cfg
	
	// task to configure the Base Address and Word count registers
	task drive_base_regs_cfg(dma_transaction tx);
		vif.dma_cb.CS_N 	<= 0;
		vif.dma_cb.IOW_N 	<= 0;
		vif.dma_cb.IOR_N 	<= 1;
		repeat(10)@(vif.cb);
		vif.dma_cb.ADDR_L	<= tx.addr_lo;
		vif.dma_cb.DB		<= tx.data[7:0]; 	// low order 8 bits of data
		@(vif.cb);
		vif.dma_cb.DB		<= tx.data[15:8]; 	// order order 8 bits of data
		@(vif.cb);
		//TODO: get response from the DUT after register configuration
		//dma_config::drv2gen.put(tx);
		vif.dma_cb.IOW_N 	<= 1;
		// DB and ADDR_L pins are expected to be tri-stated if we de-assert IOW_N.
		assert($isunknown(vif.dma_cb.DB));
		assert($isunknown(vif.dma_cb.ADDR_L));
	endtask : drive_base_regs_cfg
	
	//TODO: task registers read status
	
	// task to drive DMA stimulus
	task drive_dma_stimulus(dma_transaction tx);
		// enable DMA controller by asserting Chip select
		vif.dma_cb.CS_N 	<= 0;
		repeat(10)@(vif.cb);
		vif.dma_cb.DREQ 	<= tx.dreq;
		// wait for HRQ from DMA for one cycle
		fork
			wait(vif.dma_cb.HRQ == 1);
			@(vif.cb);
		join_any
		// check HRQ is asserted
		//TODO: check_hrq(1);
		assert(vif.dma_cb.HRQ == 1)
		else $error("ERROR:DMA DRIVER:: HRQ NOT asserted!!!!");
		// call drive_dut to configure control registers
		//TODO: ensure all control registers are written before moving on
		while(vif.dma_cb.EOP_N == 1)
		if(vif.dma_cb.HRQ == 1) begin
			drive_dut(tx);
			// wait(ctrl_regs_wr_done == 1);
			// Give acknowledge to DMA that CPU is handing over the bus to DMA
			vif.dma_cb.HLDA	<= 1;
			@(vif.cb);
			vif.dma_cb.AEN		<= 1;
			vif.dma_cb.ADSTB	<= 1;
			/*	
				write a check to verify valid 16 bit address is latched
				Read TEMP_ADDR_REG[15:8] or IO Data buffer to get the high order Address[A8-A15]
				Read TEMP_ADDR_REG[7:0] or both IO Address buffer and Output Address buffer
				or {ADDR_L, ADDR_U} to get the low order Address[A0-A7]
				check_address_match();
			*/
			
			// assert(virt_inf.cb.DB === test_Addr[channels[3]]) else $error("Wrong Base address asserted for the channel when ADSTB is asserted");
			// wait for DACK from DMA for one cycle
			fork
				wait(vif.dma_cb.DACK == tx.dack_sampled);
				@(vif.dma_cb);
			join_any
			//TODO: check DACK matches the sampled value
			// check_dack(tx.dack_sampled);
			assert(vif.dma_cb.DACK != tx.dack_sampled)
			else $error("ERROR:DMA DRIVER:: DACK NOT asserted!!!!");
			if(vif.dma_cb.DACK == tx.dack_sampled) begin
				// assert Read/Write signals
				if(tx.type == DMA_IO_WRITE_MEM_READ) begin
					vif.dma_cb.IOW_N 	<= 0;
					vif.dma_cb.MEMR_N 	<= 0;
					vif.dma_cb.IOR_N 	<= 1;
					vif.dma_cb.MEMW_N 	<= 1;
				end
				else if(tx.type == DMA_IO_READ_MEM_WRITE) begin
					vif.dma_cb.IOR_N 	<= 0;
					vif.dma_cb.MEMW_N 	<= 0;
					vif.dma_cb.IOW_N 	<= 1;
					vif.dma_cb.MEMR_N 	<= 1;	
				end
				// de-assert read signals immediately after DACK is asserted
				vif.dma_cb.MEMR_N 	<= 1;
				vif.dma_cb.IOR_N 	<= 1;
				// de-assert write signals after one cycle if extended write enabled
				// late write enabled
				if(tx.late_write_en == 1) begin
					vif.dma_cb.IOW_N 	<= 1;
					vif.dma_cb.MEMW_N 	<= 1;
				end
				// extended write enabled
				else if(tx.late_write_en == 0) begin
					@(vif.dma_cb);
					vif.dma_cb.MEMW_N 	<= 1;
					vif.dma_cb.IOW_N 	<= 1;
				end
				// de-assert DREQ
				@(vif.dma_cb);
				vif.dma_cb.DREQ 	<= ~tx.dreq;
				// wait for one cycle for timeout/end of process which marks end of transfer
				fork
					wait(vif.dma_cb.EOP_N == 0);
					@(vif.dma_cb);
				join_any
				//TODO: check EOP is asserted after transfer
				// check_eop(0);
				assert(vif.dma_cb.EOP_N != 0)
				else $error("ERROR:DMA DRIVER:: EOP_N NOT asserted!!!!");
			
			end 	// end of DACK check
			
		end 	// end of HRQ check
		
			
	endtask : drive_dma_stimulus
	
	
endclass : dma_driver
