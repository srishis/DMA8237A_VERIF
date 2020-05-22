class dma_monitor;

	// transaction class handle (not object!) to use in this class
	dma_transaction tx;
	// As monitor interacts with the interface it needs a virtual interface handle!
	virtual	dma_if.MON vif; //TODO: MOdport for monitor

	function new();
		this.vif = dma_cfg::vif;
	endfunction

	task run();
		forever begin
		// always create a new transaction object for each transaction to avoid conflicts
		tx 	= new;		// transaction class object created
		
		//monitor the interface and collect the randomized inputs and send to coverage block and scoreboard
		//start
		
		
		
		//end
		
		dff_cfg::mon2cov.put(tx);		// send transaction to coverage module
		dff_cfg::mon2sb.put(tx);		// send transaction to scoreaboard/checker
		end
	endtask

endclass