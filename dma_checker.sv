// Checker class performs the protocol functional checks and reports any mismatch

class dma_checker;

	bit [7:0] exp_data, actual_data;
	string reg_name;
	dma_transaction tx;
	tx_type_t tx_type;
	
	// checking methods
	task run();
	$display("[CHECKER]: Inside DMA checker run task!");
		forever mon2chk.get(tx);
		// checker logic
		// register read response
		if(tx.cycle == IDLE && tx.tx_type == REG_READ_CFG) begin
			exp_data 	= tx.data_in;
			actual_data	= tx.data_out;
			get_register_name();
			if(exp_data != actual_data)
			$display("[CHECKER]: Register Read failed for register %s with Expected data = %0h and Actual data = %0h", reg_name, exp_data, actual_data);
		end
		// Address generation check
			if(tx.is_addr_valid == 1)
			if(tx.valid_addr != {tx.data_out, tx.addr_up_out, tx.addr_low_out})
				$display("[CHECKER]: Address generated is invalid with Expected data = %0h and Actual data = %0h", tx.valid_addr, {tx.data_out, tx.addr_up_out, tx.addr_low_out});
	
		// DACK check
			if(tx.sample_dack == 1)
				if(tx.dack != tx.dack_sampled) 
				$display("[CHECKER]: DACK polarity check failed with Expected data = %0h and Actual data = %0h", tx.dack, tx.dack_sampled);
				
		// priority check
		
	endtask : run
	
	task get_register_name();
		if(tx.addr_low_in == CMD_REG_ADDR)
		reg_name = COMMAND_REG;	
		if(tx.addr_low_in == MODE_REG_ADDR)
		reg_name = MODE_REG;	
		if(tx.addr_low_in == MASK_REG_ADDR)
		reg_name = MASK_REG;	
		if(tx.addr_low_in == REQUEST_REG_ADDR)
		reg_name = REQUEST_REG;	
		if(tx.addr_low_in == STATUS_REG_ADDR)
		reg_name = STATUS_REG;	

		if(tx.addr_low_in == BASE_ADDR_REG_CH0_ADDR)
		reg_name = BASE_ADDR_REG0;	
		if(tx.addr_low_in == BASE_ADDR_REG_CH1_ADDR)
		reg_name = BASE_ADDR_REG1;	
		if(tx.addr_low_in == BASE_ADDR_REG_CH2_ADDR)
		reg_name = BASE_ADDR_REG2;	
		if(tx.addr_low_in == BASE_ADDR_REG_CH3_ADDR)
		reg_name = BASE_ADDR_REG3;	
		if(tx.addr_low_in == BASE_WORD_COUNT_REG_CH0_ADDR)
		reg_name = BASE_WORD_COUNT_REG0;	
		if(tx.addr_low_in == BASE_WORD_COUNT_REG_CH1_ADDR)
		reg_name = BASE_WORD_COUNT_REG1;	
		if(tx.addr_low_in == BASE_WORD_COUNT_REG_CH0_ADDR)
		reg_name = BASE_WORD_COUNT_REG2;	
		if(tx.addr_low_in == BASE_WORD_COUNT_REG_CH3_ADDR)
		reg_name = BASE_WORD_COUNT_REG3;	
	endtask : check_register

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
