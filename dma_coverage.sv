class dma_coverage;

	// transaction class handle (not object!) to use in this class
	dma_transaction tx;
	
	function new();
		dma_cg  = new();
	endfunction
	
	// covergroup for Dma 
	covergroup dma_cg;
	option.comment = "DMA:COVERAGE";
		CS_IN_CP: coverpoint tx.cs{
					option.at_least = 10; //Coverage Threshold
					bins cs_low  = {0};
					bins cs_high = {1};
					}
		
		HLDA_IN_CP:coverpoint tx.hlda{
					option.at_least = 10;
					bins hlda_low  = {0};
					bins hlda_high = {1};
					}
				
		DREQ_IN_CP:coverpoint tx.dreq{
					option.at_least = 5;
					CHREQ[]:{[0:3]}; 
					}
					
		IOR_IN_CP:coverpoint tx.ior_in{
					option.at_least = 5;
					bins ior_in_low  = {0};
					bins ior_in_high = {1};
					}
		IOR_OUT_CP:coverpoint tx.ior_out{
					option.at_least = 5;
					bins ior_out_low  = {0};
					bins ior_out_high = {1};
					}			
					
		IOW_IN_CP:coverpoint tx.iow_in{
					option.at_least = 5;
					bins iow_in_low  = {0};
					bins iow_in_high = {1};
					}
		IOW_OUT_CP:coverpoint tx.iow_out{
					option.at_least = 5;
					bins iow_out_low  = {0};
					bins iow_out_high = {1};
					}		

		MEMR_OUT_CP:coverpoint tx.iow_out{
					option.at_least = 5;
					bins memr_out_low  = {0};
					bins memr_out_high = {1};
					}
					
		MEMW_OUT_CP:coverpoint tx.iow_out{
					option.at_least = 5;
					bins memw_out_low  = {0};
					bins memw_out_high = {1};
					}			
					
		EOP_OUT_CP:coverpoint tx.eop{
					option.at_least = 5;
					bins eop_low  = {0};
					bins eop_high = {1};
					}
					
		HRQ_OUT_CP:coverpoint tx.hrq{
					option.at_least = 5;
					bins hrq_low  = {0};
					bins hrq_high = {1};
					}
		AEN_OUT_CP:coverpoint tx.aen{
					option.at_least = 5;
					bins aen_low  = {0};
					bins aen_high = {1};
		
		ADSTB_OUT_CP:coverpoint tx.adstb{
					option.at_least = 5;
					bins adstb_low  = {0};
					bins adstb_high = {1};			
		
				
		DACK_OUT_CP:coverpoint tx.dack{
					option.at_least = 5;
						CHDACK[]:{[0:3]}; 
					}
					
		DATA_IN_CP:coverpoint tx.data_in{
					option.at_least = 5;
					option.auto_bin_max = 4;
					}
		DATA_OUT_CP:coverpoint tx.data_out{
					option.at_least = 5;
					option.auto_bin_max = 4;
					}			
					
		ADDRESS_LOW_IN_CP:coverpoint tx.addr_lo_in{
					option.at_least = 5;
					option.auto_bin_max = 4;
					}
					
		ADDRESS_HIGH_OUT_CP:coverpoint tx.addr_up_out{
					option.at_least = 5;
					option.auto_bin_max = 4;
					}
					
		HLDA_HRQ_CROSS:
		HLDA_AEN_CROSS:
		HLDA_AEN_CROSS:
		AEN_ADSTRB_CROSS:
		IOR_MEMW_CROSS:
		IOW_MEMR_CROSS:
		
				
	endgroup
	
	task run();
		$display("DMA_COVERAGE:: Entered in COVERAGE run method!");
		forever begin
		dma_cfg::mon2cov.get(tx);		// get the transaction from monitor class
		dma_cg.sample();			// use coverage in built sample() method to sample the transaction for coverage
		end
	endtask


endclass