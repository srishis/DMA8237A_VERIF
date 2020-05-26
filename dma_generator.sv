class dma_generator;

	dma_transaction tx,rx;
	dma_transaction txQ[$];
	
	int reg_test,reg_pass,reg_fail;
	
	task run();
	
	//use of rand sequence for different tests
	randsequence(main)
	main: test_1;
	test_1: basic_read_write_sanity_test;
	endsequence
		
	endtask
// test cases for design

	// simple basic_read_write_sanity_test for DMA with 
		
		
		task basic_read_write_sanity_test;
		//READING REGISTERS
		for(int i = 0; i<`ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs = 1'b0; tx.ior = 1'b0; tx.iow = 1'b1;  tx.addr_lo = i; tx.dreq = 4'b0; tx.hlda = 1'b0; tx.eop = 1'b1;}) $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST:PRE WRITE READ");
		// mailbox for inter communication between classes
		dma_cfg::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method
		dma_cfg::drv2gen.get(rx);
		$display("RESET REGISTER ")
		rx.print();
		end
		
		//WRITTING REGISTERS
		for(int i = 0; i<`ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs = 1'b0; tx.ior = 1'b1; tx.iow = 1'b0; tx.addr_lo = i; tx.data = 8'ha5; tx.dreq = 4'b0; tx.hlda = 1'b0; tx.eop = 1'b1;}) $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST: WRITE ");
		// mailbox for inter communication between classes
		dma_cfg::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method
		txQ.push_front(tx);
		reg_test++;
		end	
		
		//READING REGISTERS
		for(int i = 0; i<`ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs = 1'b0; tx.ior = 1'b0; tx.iow = 1'b1;  tx.addr_lo = i; tx.dreq = 4'b0; tx.hlda = 1'b0; tx.eop = 1'b1;}) $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST:POST WRITE READ");
		// mailbox for inter communication between classes
		dma_cfg::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method
		dma_cfg::drv2gen.get(rx);// get transaction from driver which is output of design  
		txQ.pop_back(tx);
		if(tx.data == rx.data)
		reg_check_pass++;
		else
		reg_check_fail++;
		end
		
		if(reg_test == reg_check_pass)
		dma_cfg::num_trans++;
		else
		$display("ERROR:DMA GENERATOR::BASIC READ WRITE SANITY TEST:TEST FAILED");
		endtask
		
	//random_rd_wr_test
	//dma_request_priority_test
	//dma_eop_directed_test
	//dma_polarity_control_directed_test
	//
// REGISTER READ TASK
//REGISTER WRITE TASK

endclass