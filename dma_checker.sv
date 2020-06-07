// Checker class performs the protocol functional checks and reports any mismatch

class dma_checker;

	bit [15:0] exp_data, actual_data;
	bit flag;
	string reg_name;
	dma_transaction exp_tx, tx;
	// dma_transaction exp_txQ[$], act_txQ[$};
	// checking methods
	task run();
	$display("[CHECKER]: Inside DMA checker run task!");
		forever begin
		mon2chk.get(tx);
		// exp_txQ.push_back(tx);
		// checker logic
		// register read response
		if(tx.cycle == IDLE)
		if(tx.tx_type == REG_WRITE_CFG || tx.tx_type == BASE_REG_CFG) 
			exp_data 		= tx.data_in;
			flag = 0;
		if(tx.tx_type == REG_READ_CFG || tx.tx_type == BASE_REG_READ_CFG)	
			actual_data	= tx.data_out;
			flag = 1;
		if(flag)
			get_register_name();
			if(exp_data != actual_data)
			$display("[CHECKER]: Register Read failed for register %s with Expected data = %0h and Actual data = %0h", reg_name, exp_data, actual_data);
		end
		
		// Address generation check
			if(tx.cycle == ACTIVE && tx.is_addr_valid == 1)
			if(tx.valid_addr != {tx.data_out, tx.addr_up_out, tx.addr_low_out})
				$display("[CHECKER]: Address generated is invalid with Expected data = %0h and Actual data = %0h", tx.valid_addr, {tx.data_out, tx.addr_up_out, tx.addr_low_out});
	
		// DACK check
			if(tx.cycle == ACTIVE && tx.sample_dack == 1)
				if(tx.dack != tx.dack_sampled) 
				$display("[CHECKER]: DACK polarity check failed with Expected data = %0h and Actual data = %0h", tx.dack, tx.dack_sampled);
		end
	endtask : run
	
	task get_register_name();
		if(tx.addr_lo_in == CMD_REG_ADDR)
		reg_name = COMMAND_REG;	
		if(tx.addr_lo_in == MODE_REG_ADDR)
		reg_name = MODE_REG;	
		if(tx.addr_lo_in == MASK_REG_ADDR)
		reg_name = MASK_REG;	
		if(tx.addr_lo_in == REQUEST_REG_ADDR)
		reg_name = REQUEST_REG;	
		if(tx.addr_lo_in == STATUS_REG_ADDR)
		reg_name = STATUS_REG;	

		if(tx.addr_lo_in == BASE_ADDR_REG_CH0_ADDR)
		reg_name = BASE_ADDR_REG0;	
		if(tx.addr_lo_in == BASE_ADDR_REG_CH1_ADDR)
		reg_name = BASE_ADDR_REG1;	
		if(tx.addr_lo_in == BASE_ADDR_REG_CH2_ADDR)
		reg_name = BASE_ADDR_REG2;	
		if(tx.addr_lo_in == BASE_ADDR_REG_CH3_ADDR)
		reg_name = BASE_ADDR_REG3;	
		if(tx.addr_lo_in == BASE_WORD_COUNT_REG_CH0_ADDR)
		reg_name = BASE_WORD_COUNT_REG0;	
		if(tx.addr_lo_in == BASE_WORD_COUNT_REG_CH1_ADDR)
		reg_name = BASE_WORD_COUNT_REG1;	
		if(tx.addr_lo_in == BASE_WORD_COUNT_REG_CH0_ADDR)
		reg_name = BASE_WORD_COUNT_REG2;	
		if(tx.addr_lo_in == BASE_WORD_COUNT_REG_CH3_ADDR)
		reg_name = BASE_WORD_COUNT_REG3;	
	endtask : check_register
	
	
endclass : dma_checker
