class dma_env;

	// instantiate all classes in environment
	dma_generator 	gen;
	dma_driver 		drv;
	dma_monitor 	mon;
	dma_coverage 	cov;
	dma_sb 			sb;
	// dma_ref_model rm;
	
	// create object for all classes
	function new();
		gen =	new();
		drv =	new();
		mon =	new();
		cov =	new();
		sb  =	new();
		rm  =   new();
	endfunction : new

	// call all run methods of each call in parallel using fork-join_none
	task run();
		fork
		gen.run();
		drv.run();
		mon.run();
		cov.run();
		sb.run();
		// rm.run();
		join_none
	endtask : run

	task report_results();
		// errors should be zero for test pass
		//also check for Number of transactions generated and processed match
		if((dma_config::error_count != 0) && (gen.num_trans != sb.num_trans)) 	
			$display("Test failed with errors = %d", dma_config::error_count);
		else
			$display("TEST PASS: dma Works as expected!!!");
	endtask : report_results
	
endclass