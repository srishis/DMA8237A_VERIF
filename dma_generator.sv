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
	unique case();
	"Regression":begin basic_read_write_sanity_test; end
	"basic_read_write_sanity_test":basic_read_write_sanity_test;
	"random_rd_wr_test":
	"dma_request_priority_test":
	"dma_io_to_mem_read_transfer":
	"dma_io_to_mem_write_transfer":
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
		endtask
		
	//random_rd_test 
		task random_rd_test; //channel 0
		
		//current address reg
		reg_write(`BASE_REG_CH0_ADDR,8'h01100000,);
		//current base reg
		//command register (ack=low, dreq=low, write=X, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
		reg_write(`CMD_RED_ADDR,15'h01100000);
		//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 0)
		reg_write(`MODE_RED_ADDR,15'h0101100);
		//request res()
		
		endtask
	//random_wr_test (ack=low, dreq=low, write=X, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
		task random_wr_test;
		reg_write
		
		
		
		
		endtask
	
	//random_rd_wr_test
		task random_rd_wr_test;
		reg_write
		
		
		
		
		endtask
	
	//dma_request_priority_test
	
	//dma_eop_directed_test
	
	//dma_polarity_control_directed_test
	

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
	if(address == 4'h0000 || address == 4'h0010 || address == 4'h0100 || address == 4'h0110 ||
	address == 4'h0001 || address == 4'h0011 || address == 4'h0101 || address == 4'h0111) begin
	dma_config::drv2gen.get(rx);
	data[7:0] = rx.data;
	dma_config::drv2gen.get(rx);
	data[15:8] = rx.data;
	end
	else
	dma_config::drv2gen.get(rx);
	endtask

	//REGISTER WRITE TASK
	task reg_write(bit[3:0] address, bit[15:0] data);
	tx = new();
	
	if(address == 4'h0000 || address == 4'h0010 || address == 4'h0100 || address == 4'h0110)
	tx.tx_type = BASE_ADDR_CFG;
	else if(address == 4'h0001 || address == 4'h0011 || address == 4'h0101 || address == 4'h0111)
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
	
	if(address == 4'h0000 || address == 4'h0010 || address == 4'h0100 || address == 4'h0110) begin
		tx.data = data[7:0];
		dma_config::gen2drv.put(tx);
		tx.data = data[15:8];
		dma_config::gen2drv.put(tx);
	end	
	else if(address == 4'h0001 || address == 4'h0011 || address == 4'h0101 || address == 4'h0111)begin 
		tx.data = data[7:0];
		dma_config::gen2drv.put(tx);
		tx.data = data[15:8];
		dma_config::gen2drv.put(tx);
	end	
	else begin
	tx.data = data;
	dma_config::gen2drv.put(tx);
	end
	endtask

endclass