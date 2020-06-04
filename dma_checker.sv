// Checker class performs the protocol functional checks and reports any mismatch

class dma_checker;

	typedef enum { SI, SP, S0, S1, S2, S3, S4,
		       S11, S12, S13, S14,
		       S21, S22, S23, S24
	} dmaState;

	dma_transaction tx;
	tx_type_t tx_type;
	dmaState state;

	// run through tests
	task run();
		state = SI;
		forever begin
			// get transaction from mailbox and check results
			mon2chk.get(tx);
			// update state at end of cycle
			updateState();
		end
	endtask : run

	// task to update state
	task updateState();
		case (state)
			SI: if (tx.dreq)
				state = S0;
			    else
                                state = SI;
			S0: if (tx.hlda)
			        state = S1;
			    else if (!tx.hlda)
				state = S0;.
			    else if (!tx.eop)
				state = SI;
			S1: if (!tx.eop)
				state = SI;
			    else
				state = S2;
			S2: if (!tx.eop)
				state = SI;
			    else
				state = S3;
			S3: if (!tx.eop)
				state = SI;
			    else
				state = S4;
			S4:
				state = SI;
		endcase
	endtask
	
	// check HRQ signal
	// get transaction from mailbox and check results
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
