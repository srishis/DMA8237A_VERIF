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
		tx.hlda 	= vif.dma_cb.HLDA;
		// based on CS and HLDA set the dma cycle as IDLE or ACTIVE
		if(!tx.cs && !tx.hlda)	tx.cycle = IDLE;
		else if(tx.hlda)		tx.cycle = ACTIVE;
		if(tx.cycle == IDLE) begin
			tx.dreq 	= vif.dma_cb.DREQ;
			@(vif.dma_cb);
			tx.hrq 		= vif.dma_cb.HRQ;
			tx.addr_lo_in 	= vif.dma_cb.ADDR_L;
			tx.ior_in 	= vif.dma_cb.IOR_N;
			tx.iow_in 	= vif.dma_cb.IOW_N;
			// check if register read or write
			if(!tx.iow_in)
				if(tx.addr_lo_in inside {[0:7]}) begin	// base registers address range is from 4'h0-4'h7
				tx.tx_type	= BASE_REG_CFG;
				tx.data_in[7:0]   = vif.dma_cb.DB;
				@(vif.dma_cb);
				tx.data_in[15:8]   = vif.dma_cb.DB;
				end
				else begin
				tx.tx_type	= REG_WRITE_CFG;
				tx.data_in[7:0]   = vif.dma_cb.DB;
				end
			if(!tx.ior_in)
				if(tx.addr_lo_in inside {[0:7]}) begin	// base registers address range is from 4'h0-4'h7
				tx.tx_type	= BASE_REG_READ_CFG;
				tx.data_out[7:0]   = vif.dma_cb.DB;
				@(vif.dma_cb);
				tx.data_out[15:8]   = vif.dma_cb.DB;
				end
				else begin
				tx.tx_type	= REG_READ_CFG;
				tx.data_out[7:0]   = vif.dma_cb.DB;
				end
		end
		else if(tx.cycle == ACTIVE) begin
			if(tx.hrq == 1) begin
				@(vif.dma_cb);
				tx.aen 		= vif.dma_cb.AEN;
				tx.adstb 	= vif.dma_cb.ADSTB;
				tx.sample_dack  = 1;
				tx.dack_sampled	= vif.dma_cb.DACK;
				@(vif.dma_cb);
				tx.is_addr_valid = 1;
				// get the valid address
				tx.data_out[15:8]    	= vif.dma_cb.DB;
				tx.addr_lo_out[7:4]     = vif.dma_cb.ADDR_U;
				tx.addr_up_out[3:0]  	= vif.dma_cb.ADDR_L;
				// check if it is read or write transfer
				tx.ior_out 	= vif.dma_cb.IOR_N;
				tx.memw_out 	= vif.dma_cb.MEMW_N;
				tx.memr_out 	= vif.dma_cb.MEMR_N;
				tx.iow_out 	= vif.dma_cb.IOW_N;
				if(!tx.ior_out && !tx.memw_out)  tx.tx_type = DMA_WRITE;
				if(!tx.iow_out && !tx.memr_out)  tx.tx_type = DMA_READ;	
				@(vif.dma_cb);
				@(vif.dma_cb);
				tx.eop = vif.dma_cb.EOP_N;
			end
		end
		
		// send them to coverage, scoreaboard/checker for further processing
		dma_config::mon2cov.put(tx);		// send transaction to coverage module
		dma_config::mon2chk.put(tx);		// send transaction to scoreboard/checker
		end
	endtask : run

endclass : dma_monitor
