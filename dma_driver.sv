// DMA driver class which drives the transactions generated to the design.

// TX types: REG_WRITE_CFG, REG_READ_CFG, BASE_REG_CFG, DMAWRITE, DMA_READ

class dma_driver;
	
	dma_transaction tx;
	tx_type_t tx_type;
	virtual dma_if.DRIVER vif;
	
	task run();
		$display("[DRIVER]: Inside DMA DRIVER run method!");
		// get the virtual interface handle
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
		drive_dut(tx);
		dma_config::driver_done = 1;
		if(VERBOSE) tx.print;
		dma_config::num_trans++;
	end
	endtask
	
	// task to drive transactions to DUT
	// drive transactions at clock edge using clocking block
	// convert object level information(tx) to signals to drive it on the DUT using interface handle vif
	task drive_dut(dma_transaction tx);
		if(tx.tx_type == REG_WRITE_CFG)			 drive_regs_write_cfg(tx);
		else if(tx.tx_type == BASE_REG_CFG)		 drive_base_regs_write_cfg(tx);
		else if(tx.tx_type == BASE_REG_READ_CFG) drive_base_regs_read_cfg(tx);
		else if(tx.tx_type == REG_READ_CFG)		 drive_regs_read_cfg(tx);	
		else if(tx.tx_type == REQ_TX)			 drive_dreq(tx);
		// assert HLDA after all registers are configured
		if(tx.ctrl_regs_wr_done == 1)			 vif.dma_cb.HLDA <= 1;
	endtask
	
	task drive_dreq(dma_transaction tx);
		vif.dma_cb.DREQ 	<= tx.dreq;
	endtask : drive_dreq
	
	// task to configure/write all control registers
	task drive_regs_write_cfg(dma_transaction tx);
		// give the register write command  using ADDR_L, IOR, & IOW and data
		vif.dma_cb.CS_N 	<= tx.cs;
		vif.dma_cb.IOW_N 	<= tx.iow_in;
		vif.dma_cb.IOR_N 	<= tx.ior_in;
		// repeat(10)@(vif.cb);
		vif.dma_cb.ADDR_L	<= tx.addr_lo_in;
		vif.dma_cb.DB		<= tx.data_in;
		@(vif.cb);
		vif.dma_cb.IOW_N 	<= 1;
		// DB and ADDR_L pins are expected to be tri-stated if we de-assert IOW_N.
		assert($isunknown(vif.dma_cb.DB)) else $error("[DRIVER]: DB pins are not tri-stated!");
		assert($isunknown(vif.dma_cb.ADDR_L)) else $error("[DRIVER]: ADDR_L pins are not tri-stated!");
	endtask : drive_regs_write_cfg
	
	// task to configure/write the Base Address and Word count registers
	task drive_base_regs_write_cfg(dma_transaction tx);
		// give the register write command  using ADDR_L, IOR, & IOW and data
		vif.dma_cb.CS_N 	<= tx.cs;
		vif.dma_cb.IOW_N 	<= tx.iow_in;
		vif.dma_cb.IOR_N 	<= tx.ior_in;
		// repeat(10)@(vif.cb);
		vif.dma_cb.ADDR_L	<= tx.addr_lo_in;
		vif.dma_cb.DB		<= tx.data[7:0]; 	// low order 8 bits of data
		@(vif.cb);
		vif.dma_cb.DB		<= tx.data[15:8]; 	// order order 8 bits of data
		@(vif.cb);
		vif.dma_cb.IOW_N 	<= 1;
		// DB and ADDR_L pins are expected to be tri-stated if we de-assert IOW_N.
		assert($isunknown(vif.dma_cb.DB)) else $error("[DRIVER]: DB pins are not tri-stated!");
		assert($isunknown(vif.dma_cb.ADDR_L)) else $error("[DRIVER]: ADDR_L pins are not tri-stated!");
	endtask : drive_base_regs_write_cfg
	
	// task to configure/write all control registers
	task drive_regs_read_cfg(dma_transaction tx);
		// give the register write command  using ADDR_L, IOR, & IOW and data
		vif.dma_cb.CS_N 	<= tx.cs;
		vif.dma_cb.IOW_N 	<= tx.iow_in;
		vif.dma_cb.IOR_N 	<= tx.ior_in;
		// repeat(10)@(vif.cb);
		vif.dma_cb.ADDR_L	<= tx.addr_lo_in;
		@(vif.cb);
		vif.dma_cb.IOR_N 	<= 1;
		// DB and ADDR_L pins are expected to be tri-stated if we de-assert IOW_N.
		assert($isunknown(vif.dma_cb.DB)) else $error("[DRIVER]: DB pins are not tri-stated!");
		assert($isunknown(vif.dma_cb.ADDR_L)) else $error("[DRIVER]: ADDR_L pins are not tri-stated!");
	endtask : drive_regs_read_cfg
	
	// task to configure the Base Address and Word count registers
	task drive_base_regs_read_cfg(dma_transaction tx);
		// give the register write command  using ADDR_L, IOR, & IOW and data
		vif.dma_cb.CS_N 	<= tx.cs;
		vif.dma_cb.IOW_N 	<= tx.iow_in;
		vif.dma_cb.IOR_N 	<= tx.ior_in;
		// repeat(10)@(vif.cb);
		vif.dma_cb.ADDR_L	<= tx.addr_lo_in;
		@(vif.cb);
		vif.dma_cb.IOR_N 	<= 1;
		// DB and ADDR_L pins are expected to be tri-stated if we de-assert IOW_N.
		assert($isunknown(vif.dma_cb.DB)) else $error("[DRIVER]: DB pins are not tri-stated!");
		assert($isunknown(vif.dma_cb.ADDR_L)) else $error("[DRIVER]: ADDR_L pins are not tri-stated!");
	endtask : drive_base_regs_read_cfg
	
endclass : dma_driver
