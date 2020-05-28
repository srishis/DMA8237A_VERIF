class dma_monitor;

	dma_transaction tx;
	
	virtual	dma_if.MON vif;

	function new();
		this.vif = dma_cfg::vif;
	endfunction

	task run();
		forever begin
		
		tx 	= new;
		
		//monitor the interface and collect the randomized inputs and send to coverage block and scoreboard
		//start
		
		
		
		//end
		
		dma_cfg::mon2cov.put(tx);		// send transaction to coverage module
		dma_cfg::mon2sb.put(tx);		// send transaction to scoreaboard/checker
		end
	endtask

endclass : dma_monitor
