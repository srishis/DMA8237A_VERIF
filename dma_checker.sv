// Checker class performs the protocol functional checks and reports any mismatch

class dma_checker;

	// checking methods
	task run();
		forever begin
			mon2chk.get(tx);
			// checker logic
		end
	endtask : run
	
	// check HRQ signal
	task check_hrq(bit data);
		
	endtask : check_hrq
	
	// check Address generation
	task check_address_gen();
	
	endtask : check_address_match
	
	// check DACK
	task check_dack();
	
	endtask : check_dack
	
	// check read write signals
	// check if IOW = 0, MEMR_N = 0, IOR = 1, MEMW_N = 0
	task check_read_write_signals(bit iow, bit memr, bit ior, bit memw);
		
	endtask : check_read_write_signals
	
	// check EOP_N signal
	task check_eop(bit data);
		
	endtask : check_eop
	
	
endclass : dma_checker
