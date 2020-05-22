class dma_coverage;

	// transaction class handle (not object!) to use in this class
	dma_transaction tx;
	
	function new();
		dma_cg  = new();
	endfunction
	
	// covergroup for Dma 
	covergroup dma_cg;
		CS_CP: coverpoint tx.cs{
					option.at_least = 10;
					bins cs_low  = {0};
					bins cs_high = {1};
					}
		
		HLDA_CP:coverpoint tx.hlda{
					option.at_least = 10;
					bins hlda_low  = {0};
					bins hlda_high = {1};
					}
		//TODO			
		DREQ_CP:coverpoint tx.dreq{
					option.at_least = 10;
					}
					
		IOR_CP:coverpoint tx.ior{
					option.at_least = 10;
					bins ior_low  = {0};
					bins ior_high = {1};
					}
					
		IOW_CP:coverpoint tx.iow{
					option.at_least = 10;
					bins iow_low  = {0};
					bins iow_high = {1};
					}
					
		EOP_CP:coverpoint tx.eop{
					option.at_least = 10;
					bins eop_low  = {0};
					bins eop_high = {1};
					}
					
		HRQ_CP:coverpoint tx.hrq{
					option.at_least = 10;
					bins hrq_low  = {0};
					bins hrq_high = {1};
					}
		AEN_CP:coverpoint tx.aen{
					option.at_least = 10;
					bins aen_low  = {0};
					bins aen_high = {1};
		
		ADSTB_CP:coverpoint tx.adstb{
					option.at_least = 10;
					bins adstb_low  = {0};
					bins adstb_high = {1};			
		
		//TODO		
		DACK_CP:coverpoint tx.dack{
					option.at_least = 5;
					}
					
		DATA_CP:coverpoint tx.cs{
					option.at_least = 5;
					}
		ADDRESS_LOW_CP:
		ADDRESS_HIGH_CP:
	endgroup
	
	task run();
		forever begin
		dma_cfg::mon2cov.get(tx);		// get the transaction from monitor class
		dma_cg.sample();			// use coverage in built sample() method to sample the transaction for coverage
		end
	endtask


endclass