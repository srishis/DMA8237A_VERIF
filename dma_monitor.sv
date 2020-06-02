// DMA monitor continously check for the valid content on the interface
class dma_monitor;

	dma_transaction tx;
	
	virtual	dma_if.MON vif;
	
	// If valid content is present sample the data and store into transaction
	// Send it to the other components like coverage class, reference model, checker, scoreboard for further processing
	task run();
		vif = dma_config::vif;
		forever begin
		tx 	= new;

		// sample inputs
		tx.cs		= vif.dma_cb.CS_N;
		tx.dreq 	= vif.dma_cb.DREQ;
		tx.hlda 	= vif.dma_cb.HLDA;
		// sample outputs
		tx.addr_up_out 	= vif.dma_cb.ADDR_U;
		tx.dack_sampled	= vif.dma_cb.DACK;
		tx.hrq 		= vif.dma_cb.HRQ;
		tx.aen 		= vif.dma_cb.AEN;
		tx.adstb 	= vif.dma_cb.ADSTB;
		// sample bi-directional signals
		tx.eop  	= vif.dma_cb.EOP_N;
		if(tx.cycle == IDLE) begin	
			tx.data_in     	= vif.dma_cb.DB;
			tx.addr_low_in 	= vif.dma_cb.ADDR_L;
			tx.ior_in 	= vif.dma_cb.IOR_N;
			tx.iow_in 	= vif.dma_cb.IOW_N;
			tx.memr_in 	= vif.dma_cb.MEMR_N;
			tx.memw_in 	= vif.dma_cb.MEMW_N;
			if(!tx.iow_in)
				tx.tx_type	= REG_WRITE_CFG;
			if(!tx.ior_in)
				tx.tx_type	= REG_READ_CFG;
		end
		if(tx.cycle == ACTIVE) begin	
			tx.data_out    	= vif.dma_cb.DB;
			tx.addr_lo  	= vif.dma_cb.ADDR_L;
			tx.ior_out 	= vif.dma_cb.IOR_N;
			tx.iow_out 	= vif.dma_cb.IOW_N;
			tx.memr_out 	= vif.dma_cb.MEMR_N;
			tx.memw_out 	= vif.dma_cb.MEMW_N;
			if(!tx.iow_out)  tx.tx_type = DMA_WRITE;
			if(!tx.ior_out)  tx.tx_type = DMA_READ;
			if((!tx.ior_out && !tx.memw_out)|| (!tx.iow_out && !tx.memr_out)) begin
			tx.is_addr_valid = 1;
			tx.sample_dack   = 1;
			end
		end
		
		// send them to coverage, scoreaboard/checker
		dma_config::mon2cov.put(tx);		// send transaction to coverage module
		dma_config::mon2chk.put(tx);		// send transaction to scoreboard/checker
		
		end
	endtask : run

endclass : dma_monitor
