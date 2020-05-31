// Checker class performs the protocol functional checks and reports any mismatch

virtual class dma_checker;
	
	dma_transaction tx;
	tx_type_t tx_type;

	// factory for testbench
	function dma_checker create_tester(dma_config cfg);
		dma_checker checker_inst;
		dma_checker_standard standard;

		if (cfg::testcase == "standard") begin
			standard = new();
			checker_inst = standard;
		end else begin
			$display("Unknown checker\n");
		end

		return checker_inst;
	endfunction
	
	// checking methods
	virtual task run();
		forever mon2chk.get(tx);
	endtask : run
	
endclass : dma_checker
