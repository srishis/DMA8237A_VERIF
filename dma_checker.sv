// Checker class performs the protocol functional checks and reports any mismatch

class dma_checker;

   typedef enum { SI, S0, S1, S2, S3, S4,
                  S11, S12, S13, S14,
                  S21, S22, S23, S24
   } dmaState;

   //bit [7:0] exp_data, actual_data;
   dma_transaction txin, txout;
   tx_type_t tx_type;
   dmaState state;

   bit [7:0] dmaRegFile [32];

   // get register value
   function automatic bit [7:0]  getRegisterValue(bit [4:0] address);
      return dmaRegFile[address];
   endfunction : getRegisterValue

   // set register value
   function automatic void setRegisterValue(bit [4:0] address, bit [7:0] data);
      dmaRegFile[address] = data;
   endfunction : setRegisterValue

   // run through tests
   task run();
      string reg_name;
      bit programMode;
      bit [7:0] value;

      $display("[CHECKER]: Inside DMA checker run task!");

      // initialize values
      state = SI;
      programMode = 1'b0;

      // loop through using values from generator to determine expected values
      // then check them against actual values out of DUT
      forever begin
	 sb2ck.get(txin);     // input values from generator (same passed to driver)
         mon2chk.get(txout);  // output values from monitor
				
         // update state for each new cycle
         updateState();

	 programMode = ((state == SI) && (!tx.cs) && (!tx.hlda));

         // register read response
         //if(txin.cycle == IDLE && txin.tx_type == REG_READ_CFG) begin
         if(programMode && (!txin.ior_in)) begin
            //exp_data 	= tx.data_in;
            //actual_data	= tx.data_out;
            reg_name = get_register_name(txin.addr_lo_in);
            value = getRegisterValue({ 1'b0, txin.addr_lo_in }); // for now ignore extra internal addr bit

            if(value != txout.data_out)
               $display("[CHECKER]: Register Read failed for register %s with Expected data = %0h and Actual data = %0h", reg_name, exp_data, actual_data);
	 end else if (programMode && (!txin.iow_in)) begin // not sure of precedence ior vs iow
            setRegisterValue({ 1'b0, txin.addr_lo_in }, txin.data_in);
	 end

         // Address generation check
         if(tx.is_addr_valid == 1)
         if(tx.valid_addr != {tx.data_out, tx.addr_up_out, tx.addr_low_out})
         $display("[CHECKER]: Address generated is invalid with Expected data = %0h and Actual data = %0h", tx.valid_addr, {tx.data_out, tx.addr_up_out, tx.addr_low_out});
	
         // DACK check
         if(tx.sample_dack == 1)
         if(tx.dack != tx.dack_sampled) 
         $display("[CHECKER]: DACK polarity check failed with Expected data = %0h and Actual data = %0h", tx.dack, tx.dack_sampled);
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
	
   function automatic string get_register_name(input bit[3:0] addr_low_in);
      string reg_name;

      if(addr_low_in == CMD_REG_ADDR)
         reg_name = COMMAND_REG;	
      else if(addr_low_in == MODE_REG_ADDR)
         reg_name = MODE_REG;	
      else if(addr_low_in == MASK_REG_ADDR)
         reg_name = MASK_REG;	
      else if(addr_low_in == REQUEST_REG_ADDR)
         reg_name = REQUEST_REG;	
      else if(addr_low_in == STATUS_REG_ADDR)
         reg_name = STATUS_REG;	

      else if(addr_low_in == BASE_ADDR_REG_CH0_ADDR)
         reg_name = BASE_ADDR_REG0;	
      else if(addr_low_in == BASE_ADDR_REG_CH1_ADDR)
         reg_name = BASE_ADDR_REG1;	
      else if(addr_low_in == BASE_ADDR_REG_CH2_ADDR)
         reg_name = BASE_ADDR_REG2;	
      else if(addr_low_in == BASE_ADDR_REG_CH3_ADDR)
         reg_name = BASE_ADDR_REG3;	
      else if(addr_low_in == BASE_WORD_COUNT_REG_CH0_ADDR)
         reg_name = BASE_WORD_COUNT_REG0;	
      else if(addr_low_in == BASE_WORD_COUNT_REG_CH1_ADDR)
         reg_name = BASE_WORD_COUNT_REG1;	
      else if(addr_low_in == BASE_WORD_COUNT_REG_CH0_ADDR)
         reg_name = BASE_WORD_COUNT_REG2;	
      else if(addr_low_in == BASE_WORD_COUNT_REG_CH3_ADDR)
         reg_name = BASE_WORD_COUNT_REG3;	
      else
         reg_name = "";

      return reg_name;
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
