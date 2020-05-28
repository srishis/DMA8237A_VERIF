program dma_test;

	// instantiate environment class
	dma_env env;
	
	// create env class object and call run method which triggers the call chain of run methods in each sub-class in the environment
	initial begin
		env = new();
		env.run();
		env.report_results();
	end


endprogram : dma_test