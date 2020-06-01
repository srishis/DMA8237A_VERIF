class dma_generator;

	dma_transaction tx,rx;
	dma_transaction txQ[$];
	
	int reg_test,reg_pass,reg_fail;
	
	task run();
	/*
	//use of rand sequence for different tests
	randsequence(main)
	main: test_1;
	test_1: basic_read_write_sanity_test;
	endsequence
	*/
	unique case(dma_config::testcase);
	"Regression":begin basic_read_write_sanity_test; io_rd_test; io_wr_test; end
	"basic_read_write_sanity_test": basic_read_write_sanity_test;
	"dma_io_to_mem_read_transfer": dma_io_to_mem_read_transfer;
	"dma_io_to_mem_write_transfer":dma_io_to_mem_write_transfer;
	"random_rd_wr_test":
	"dma_request_priority_test":
	
	"dma_io_to_mem_write_read_transfer":
	"dma_eop_directed_test":
	"dma_request_mask_directed_test":
	"dma_auto_intialization_directed_test":
	"dma_polarity_control_directed_test":
	"dma_sw_commands_directed_test":
	endcase
	
	endtask
// test cases for design

	// simple basic_read_write_sanity_test for DMA with 
		
		
		task basic_read_write_sanity_test;
		//READING REGISTERS
		for(int i = 0; i<`ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs == 1'b0; 
								 tx.ior == 1'b0;
								 tx.iow == 1'b1;
								 tx.addr_lo == i;
								 tx.dreq == 4'b0;
								 tx.hlda == 1'b0;
								 tx.eop == 1'b1;
								 }) 
								 $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST:PRE WRITE READ");
		// mailbox for inter communication between classes
		tx.tx_type = REG_READ_CFG;
		dma_config::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method
		dma_config::drv2gen.get(rx);
		$display("RESET REGISTER");
		rx.print();
		end
		
		//WRITTING REGISTERS
		for(int i = 0; i<`ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs == 1'b0;
								 tx.ior == 1'b1;
								 tx.iow == 1'b0;
								 tx.addr_lo == i;
								 tx.data == 8'ha5;
								 tx.dreq == 4'b0;
								 tx.hlda == 1'b0;
								 tx.eop == 1'b1;
								 }) 
								 $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST: WRITE ");
		// mailbox for inter communication between classes
		tx.tx_type = REG_WRITE_CFG;
		if(i == 15) tx.ctrl_regs_wr_done = 1;
		else tx.ctrl_regs_wr_done = 0;
		
		dma_config::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method
		txQ.push_front(tx);
		reg_test++;
		end	
		
		//READING REGISTERS
		for(int i = 0; i<`ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs == 1'b0;
								 tx.ior == 1'b0;
								 tx.iow == 1'b1;
								 tx.addr_lo == i;
								 tx.dreq == 4'b0;
								 tx.hlda == 1'b0;
								 tx.eop == 1'b1;
								 })
								 $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST:POST WRITE READ");
		// mailbox for inter communication between classes
		tx.tx_type = REG_READ_CFG;
		dma_config::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method
		dma_config::drv2gen.get(rx);// get transaction from driver which is output of design  
		txQ.pop_back(tx);
		if(tx.data == rx.data)
		reg_pass++;
		else
		reg_fail++;
		end
		
		if(reg_test == reg_pass)
		dma_config::num_trans++;
		else
		$display("ERROR:DMA GENERATOR::BASIC READ WRITE SANITY TEST:TEST FAILED");
		endtask : basic_read_write_sanity_test
		
	//directed_rd_test 
		task dma_io_to_mem_read_transfer; //channel 0
			tx.dreq = 4'h1;
			dma_config::gen2drv.put(tx);
			//current address reg
			reg_write(`BASE_REG_CH0_ADDR,16'h00ab,0);
			//current base reg
			reg_write(`BASE_REG_CH0_COUNT,16'h0001,0);
			//control registers
			cfg_control_registers(1,1,1); //dack,dreq active high
			
			/*
			//command register (ack=low, dreq=low, write=0, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(`CMD_RED_ADDR,16'h0060);
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 0)
			reg_write(`MODE_RED_ADDR,16'h0058);
			//request res(set/reset(1/0) =set,channel= 0)
			reg_write(`REQUEST_REG_ADDR,16'h0004);
			//mask register 
			tx.ctrl_regs_wr_done = 1'b1;
			reg_write(`MASK_REG_ADDR,16'h0004);*/
			
		endtask
	
	//directed_wr_test (ack=low, dreq=low, write=0, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
		task dma_io_to_mem_write_transfer; //channel 0
			tx.dreq = 4'h1;
			dma_config::gen2drv.put(tx);
			//current address reg
			reg_write(`BASE_REG_CH0_ADDR,16'h00ac,0);
			//current base reg
			reg_write(`BASE_REG_CH0_COUNT,16'h0001,0);
			
			cfg_control_registers(1,1,1); //dack,dreq active high
			/*
			//command register (ack=low, dreq=low, write=0, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(`CMD_RED_ADDR,16'h0040);
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 0)
			reg_write(`MODE_RED_ADDR,16'h0054);
			//request res(set/reset(1/0) =set,channel= 0)
			reg_write(`REQUEST_REG_ADDR,16'h0004);
			//mask register 
			tx.ctrl_regs_wr_done = 1'b1;
			reg_write(`MASK_REG_ADDR,16'h0004);	*/
		endtask
	

	
	
	
	//dma_eop_directed_test
	
	//dma_polarity_control_directed_test
	task dma_polarity_test;
			tx.dreq = 4'h0; //dreq = 0000 means highest priority channel should be services that is 0 and dack should be on dack0
			dma_config::gen2drv.put(tx);
			//current address reg
			reg_write(`BASE_REG_CH0_ADDR,16'h00ad,0);
			//current base reg
			reg_write(`BASE_REG_CH0_COUNT,16'h0001,0);
			cfg_control_registers(0,0,0);//dack,dreq active low
			
			dma_config::drv2gen.get(rx);
			if(rx.dack == 4'b1110)
			//TODO: TEST ++
			else
			$display("ERROR:DMA GENERATOR::DMA POLARITY TEST: LOW POLARITY TEST FAILED");
			
			
			tx.dreq = 4'h0; //dreq = 0000 means highest priority channel should be services that is 0 and dack should be on dack0
			dma_config::gen2drv.put(tx);
			//current address reg
			reg_write(`BASE_REG_CH0_ADDR,16'h00ad,0);
			//current base reg
			reg_write(`BASE_REG_CH0_COUNT,16'h0001,0);
			cfg_control_registers(0,0,1);//dack,dreq active high
			
			dma_config::drv2gen.get(rx);
			if(rx.dack == 4'b0001)
			//TODO: TEST ++
			else
			$display("ERROR:DMA GENERATOR::DMA POLARITY TEST: HIGH POLARITY TEST FAILED");
	
	endtask : dma_fixed_priority_test
	
	
	//dma_request_priority_test
	task dma_fixed_priority_test;
			tx.dreq = 4'h0; //dreq = 0000 means highest priority channel should be services that is 0 and dack should be on dack0
			dma_config::gen2drv.put(tx);
			//current address reg
			reg_write(`BASE_REG_CH0_ADDR,16'h00ad,0);
			//current base reg
			reg_write(`BASE_REG_CH0_COUNT,16'h0001,0);
			cfg_control_registers(0,0,0); //dack,dreq active low
			
			
			dma_config::drv2gen.get(rx);
			if(rx.dack == 4'b1110)
			//TODO: TEST ++
			else
			$display("ERROR:DMA GENERATOR::DMA FIXED PRORITY TEST: PRIORITY TEST FAILED");
			
			
	
	endtask : dma_fixed_priority_test
	
	task dma_rotational_priority_test;
			tx.dreq = 4'h3; //dreq = 1111 means highest priority channel should be services that is 0 and dack should be on dack0
			dma_config::gen2drv.put(tx);
			//current address reg
			reg_write(`BASE_REG_CH0_ADDR,16'h00ad,0);
			//current base reg
			reg_write(`BASE_REG_CH0_COUNT,16'h0001,0);
			cfg_control_registers(0,1,0); //dack,dreq active low
			
			dma_config::drv2gen.get(rx);
			if(rx.dack == 4'b1110)
			//TODO: TEST ++
			else
			$display("ERROR:DMA GENERATOR::DMA FIXED PRORITY TEST: PRIORITY TEST FAILED");
			
	
	endtask : dma_rotational_priority_test
	
	//Tasks
	
	//Write Configure Control Registers
	task cfg_control_registers(int channel,bit rf_priority,bit polarity);//rf_priority = 1 rotating rf_priority = 0 fixed 
	if(rf_priority)//rotating
		if(polarity)
			reg_write(`CMD_RED_ADDR,16'hb4,0);
		else
			//command register (ack=low, dreq=low, write=0, priority=rotating, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(`CMD_RED_ADDR,16'h0054,0);
	else //fixed
		if(polarity)
			reg_write(`CMD_RED_ADDR,16'h0094,0);
		else		
			//command register (ack=low, dreq=low, write=0, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(`CMD_RED_ADDR,16'h0044,0);	
			
		
	if(channel == 0) begin
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 0)
			reg_write(`MODE_RED_ADDR,16'h0054,0);
			//request res(set/reset(1/0) =set,channel= 0)
			reg_write(`REQUEST_REG_ADDR,16'h0004,0);
			//mask register
			reg_write(`MASK_REG_ADDR,16'h0001,0);	
	end
	else if(channel == 1)begin
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 0)
			reg_write(`MODE_RED_ADDR,16'h0055,0);
			//request res(set/reset(1/0) =set,channel= 0)
			reg_write(`REQUEST_REG_ADDR,16'h0005,0);
			//mask register 
			reg_write(`MASK_REG_ADDR,16'h0002,0);	
	end
	else if(channel == 2)begin
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 0)
			reg_write(`MODE_RED_ADDR,16'h0056,0);
			//request res(set/reset(1/0) =set,channel= 0)
			reg_write(`REQUEST_REG_ADDR,16'h0006,0);
			//mask register 
			reg_write(`MASK_REG_ADDR,16'h0004,0);	
		
	end
	else if(channel == 3)begin
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 0)
			reg_write(`MODE_RED_ADDR,16'h0057,0);
			//request res(set/reset(1/0) =set,channel= 0)
			reg_write(`REQUEST_REG_ADDR,16'h0007,0);
			//mask register 
			reg_write(`MASK_REG_ADDR,16'h0008,0);	
	end
	
	if(rf_priority)//rotating
		if(polarity)
			reg_write(`CMD_RED_ADDR,16'hb0,1);
		else
			//command register (ack=low, dreq=low, write=0, priority=rotating, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(`CMD_RED_ADDR,16'h0050,1);
	else //fixed
		if(polarity)
			reg_write(`CMD_RED_ADDR,16'h0090,1);
		else		
			//command register (ack=low, dreq=low, write=0, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(`CMD_RED_ADDR,16'h0040,1);	
	
	endtask :cfg_control_registers
	
	// REGISTER READ TASK
	task reg_read(bit[3:0] address,output bit[15:0] data);
		tx = new();
		tx.tx_type = REG_READ_CFG;
		tx.cs = 1'b0;
		tx.ior = 1'b0;
		tx.iow = 1'b1;
		tx.addr_lo = address;
		tx.dreq = 4'b0;
		tx.hlda = 1'b0;
		tx.eop = 1'b1;
		dma_config::gen2drv.put(tx);
		//wait for a clock in driver for data
		if(address == `BASE_REG_CH0_ADDR || address == `BASE_REG_CH1_ADDR || address == `BASE_REG_CH2_ADDR || address == `BASE_REG_CH3_ADDR ||
		address == `BASE_REG_CH0_COUNT || address == `BASE_REG_CH1_COUNT || address == `BASE_REG_CH2_COUNT || address == `BASE_REG_CH3_COUNT) begin
		dma_config::drv2gen.get(rx);
		data[7:0] = rx.data;
		dma_config::drv2gen.get(rx);
		data[15:8] = rx.data;
		end
		else
		dma_config::drv2gen.get(rx);
	endtask : reg_read

	//REGISTER WRITE TASK
	task reg_write(bit[3:0] address, bit[15:0] data, bit last);
		tx = new();
		
		if((address == `BASE_REG_CH0_ADDR || address == `BASE_REG_CH1_ADDR || address == `BASE_REG_CH2_ADDR || address == `BASE_REG_CH3_ADDR)
		tx.tx_type = BASE_ADDR_CFG;
		else if(address == `BASE_REG_CH0_COUNT || address == `BASE_REG_CH1_COUNT || address == `BASE_REG_CH2_COUNT || address == `BASE_REG_CH3_COUNT)
		tx.tx_type = BASE_COUNT_CFG;
		else 
		tx.tx_type = REG_WRITE_CFG;
		
		tx.cs = 1'b0; 
		tx.ior = 1'b1;
		tx.iow = 1'b0;
		tx.addr_lo = address;
		tx.dreq = 4'b0;
		tx.hlda = 1'b0;
		tx.eop = 1'b1;
		
		if(address == `BASE_REG_CH0_ADDR || address == `BASE_REG_CH1_ADDR || address == `BASE_REG_CH2_ADDR || address == `BASE_REG_CH3_ADDR 
		|| address == `BASE_REG_CH0_COUNT || address == `BASE_REG_CH1_COUNT || address == `BASE_REG_CH2_COUNT || address == `BASE_REG_CH3_COUNT) begin
			tx.data = data[7:0];
			dma_config::gen2drv.put(tx);
			tx.data = data[15:8];
			dma_config::gen2drv.put(tx);
		end	 
		else begin
		tx.data = data;
		
		//for letting the driver know if its a last register write
		if(last)
		tx.ctrl_regs_wr_done = 1;
		else
		tx.ctrl_regs_wr_done = 0;
		
		dma_config::gen2drv.put(tx);
	end
	endtask : reg_write

endclass