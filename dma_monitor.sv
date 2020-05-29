// DMA monitor continously check for the valid content on the interface
class dma_monitor;

	dma_transaction tx;
	
	virtual	dma_if.MON vif;
	
	// If valid content is present sample the data and store into transaction
	// Send it to the other components like coverage class, reference model, checker, scoreboard for further processing
	task run();
		vif = dma_cfg::vif;
		forever begin
		tx 	= new;
		// sample inputs
		tx.cs		= vif.dma_cb.CS_N;
		tx.aen 		= vif.dma_cb.AEN;
		tx.adstb 	= vif.dma_cb.ADSTB;
		tx.dreq 	= vif.dma_cb.DREQ;
		tx.hlda 	= vif.dma_cb.HLDA;
		// sample outputs
		tx.addr_hi 	= vif.dma_cb.ADDR_U;
		tx.dack 	= vif.dma_cb.DACK;
		tx.hrq 		= vif.dma_cb.HRQ;
		// sample bi-directional signals
		tx.eop  	= vif.dma_cb.EOP_N;
		tx.ior  	= vif.dma_cb.IOR_N;
		tx.iow  	= vif.dma_cb.IOW_N;
		tx.data     = vif.dma_cb.DB;
		tx.addr_lo  = vif.dma_cb.ADDR_L;
		
		// sample control register read values from the design
	
		// send them to coverage, scoreaboard/checker
		dma_cfg::mon2cov.put(tx);		// send transaction to coverage module
		dma_cfg::mon2chk.put(tx);		// send transaction to scoreboard/checker
		
		end
	endtask : run

endclass : dma_monitor
