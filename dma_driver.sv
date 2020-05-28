class dma_driver;
	
	dma_transaction tx;
	
	virtual dma_if.DRIVER vif;
	
	int num_trans = 0;
	
	function new();
		this.vif = dma_cfg::vif;	// pass interface from top to each class which needs it as virtual interface handle
	endfunction
	
	task run();
		forever begin
		// get transaction from generator
		dma_cfg::gen2drv.get(tx);
		// drive transactions to DUT
		drive_trans(tx);
		num_trans++;
	end
	endtask
	
	// task to drive transactions/inputs to DUT
	task drive_trans(dma_transaction tx)
		// drive transactions at clock edge using clocking block
		@(vif.dma_cb)
		// convert object level information(tx) to signal level(vif) to drive it to the DUT
	endtask
	
endclass : dma_driver
