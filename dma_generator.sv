class dma_generator;

	dma_transaction tx;
	dma_transaction txQ[$];
	
	task run();
	
	//use of rand sequence for different tests
	randsequence(main)
	main: test_1;
	test_1: dma_test;
	endsequence
		
	endtask
// test cases for design

	// simple test for DMA with 10 random transactions
		task dma_test;
		repeat(10) begin
		tx = new;
		if(!tx.randomize()) $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED");
		
		// mailbox for inter communication between classes
		dma_cfg::gen2drv.put(tx); 	// send transaction to Driver to drive it to the DUT using mailbox put() method
		dma_cfg::gen2ref.put(tx); 	// send transaction to reference model for generating expected values using mailbox put() method
		dma_cfg::num_trans++;
		end // repeat
		endtask


endclass