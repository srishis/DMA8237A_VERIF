// DMA Registers and Buffers module

module dma_reg_file(dma_if.DP dif, dma_control_if.TC cif);  

import dma_reg_pkg::*;

  // Read Buffer
  always_ff@(posedge dif.CLK) begin
            if(dif.RESET || dif.MASTER_CLEAR_CMD) READ_BUF    <= '0;
     	    // Read CH0 current address register
     	    else if(dif.READ_CURR_ADDR_CH0_REG_CMD == 1)
     	      if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
     	        READ_BUF <= CURR_ADDR_CH0_REG[15:8];
     	      else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
     	        READ_BUF <= CURR_ADDR_CH0_REG[7:0];
     	    // Read CH1 current address register
     	    else if(dif.READ_CURR_ADDR_CH1_REG_CMD == 1)
     	      if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
     	        READ_BUF <= CURR_ADDR_CH1_REG[15:8];
     	      else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
     	        READ_BUF <= CURR_ADDR_CH1_REG[7:0];
     	    // Read CH2 current address register
     	    else if(dif.READ_CURR_ADDR_CH2_REG_CMD == 1)
     	      if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
     	        READ_BUF <= CURR_ADDR_CH2_REG[15:8];
     	      else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
     	        READ_BUF <= CURR_ADDR_CH2_REG[7:0];
     	    // Read CH3 current address register
     	    else if(dif.READ_CURR_ADDR_CH3_REG_CMD == 1)
     	      if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
     	        READ_BUF <= CURR_ADDR_CH3_REG[15:8];
     	      else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
     	        READ_BUF <= CURR_ADDR_CH3_REG[7:0];
     	    // Read CH0 current word count register
     	    else if(dif.READ_CURR_WORD_COUNT_CH0_REG_CMD == 1)
     	      if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
     	        READ_BUF <= CURR_WORD_COUNT_CH0_REG[15:8];
     	      else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
     	        READ_BUF <= CURR_WORD_COUNT_CH0_REG[7:0];
     	    // Read CH1 current word count register
     	    else if(dif.READ_CURR_WORD_COUNT_CH1_REG_CMD == 1)
     	      if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
     	        READ_BUF <= CURR_WORD_COUNT_CH1_REG[15:8];
     	      else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
     	        READ_BUF <= CURR_WORD_COUNT_CH1_REG[7:0];
     	    // Read CH2 current word count register
     	    else if(dif.READ_CURR_WORD_COUNT_CH2_REG_CMD == 1)
     	      if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
     	        READ_BUF <= CURR_WORD_COUNT_CH2_REG[15:8];
     	      else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
     	        READ_BUF <= CURR_WORD_COUNT_CH2_REG[7:0];
     	    // Read CH3 current word count register
     	    else if(dif.READ_CURR_WORD_COUNT_CH3_REG_CMD == 1)
     	      if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
     	        READ_BUF <= CURR_WORD_COUNT_CH3_REG[15:8];
     	      else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
     	        READ_BUF <= CURR_WORD_COUNT_CH3_REG[7:0];
  end	// end of Read BUffer
  
// Write Buffer
  always_ff@(posedge dif.CLK) begin
            if(dif.RESET || dif.MASTER_CLEAR_CMD) WRITE_BUF <= '0;
            else if(dif.IOR_N && !dif.IOW_N)	  WRITE_BUF <= IO_DATA_BUF;
  end	// end of Write BUffer
		  
// DMA Registers logic
// Base Address Registers
   always_ff@(posedge dif.CLK) begin
     if(dif.RESET || dif.MASTER_CLEAR_CMD)  begin                
           BASE_ADDR_CH0_REG <= '0;
           BASE_ADDR_CH1_REG <= '0;
           BASE_ADDR_CH2_REG <= '0;
           BASE_ADDR_CH3_REG <= '0;
      end
     //the command code for Writing the base address register -> base Address Reg 0     
     else if(dif.WRITE_BASE_ADDR_CH0_REG_CMD == 1)
             if(SET_BYTE_POINTER_CMD == 1)	  // load upper byte 
               BASE_ADDR_CH0_REG[15:8] <= WRITE_BUF;
             else if(CLEAR_BYTE_POINTER_CMD == 1) // load lower byte
               BASE_ADDR_CH0_REG[7:0]  <= WRITE_BUF;
             end
     //the command code for Writing the base address register -> base Address Reg 1     
     else if(dif.WRITE_BASE_ADDR_CH1_REG_CMD == 1)
             if(SET_BYTE_POINTER_CMD == 1)	  // load upper byte 
               BASE_ADDR_CH0_REG[15:8] <= WRITE_BUF;
             else if(CLEAR_BYTE_POINTER_CMD == 1) // load lower byte
               BASE_ADDR_CH0_REG[7:0]  <= WRITE_BUF;
             end
     //the command code for Writing the base address register -> base Address Reg 2     
     else if(dif.WRITE_BASE_ADDR_CH2_REG_CMD == 1)
             if(SET_BYTE_POINTER_CMD == 1)	  // load upper byte 
               BASE_ADDR_CH0_REG[15:8] <= WRITE_BUF;
             else if(CLEAR_BYTE_POINTER_CMD == 1) // load lower byte
               BASE_ADDR_CH0_REG[7:0]  <= WRITE_BUF;
             end
     //the command code for Writing the base address register -> base Address Reg 3     
     else if(dif.WRITE_BASE_ADDR_CH3_REG_CMD == 1)
             if(SET_BYTE_POINTER_CMD == 1)	  // load upper byte 
               BASE_ADDR_CH0_REG[15:8] <= WRITE_BUF;
             else if(CLEAR_BYTE_POINTER_CMD == 1) // load lower byte
               BASE_ADDR_CH0_REG[7:0]  <= WRITE_BUF;
             end
     else begin
          BASE_ADDR_CH0_REG <= BASE_ADDR_CH0_REG;
          BASE_ADDR_CH1_REG <= BASE_ADDR_CH1_REG;
          BASE_ADDR_CH2_REG <= BASE_ADDR_CH2_REG;
          BASE_ADDR_CH3_REG <= BASE_ADDR_CH3_REG;
     end
   end

// Current Address Registers
   always_ff@(posedge dif.CLK) begin
     if(dif.RESET || dif.MASTER_CLEAR_CMD)  begin                
           CURR_ADDR_CH0_REG <= '0;
           CURR_ADDR_CH1_REG <= '0;
           CURR_ADDR_CH2_REG <= '0;
           CURR_ADDR_CH3_REG <= '0;
      end
    // CH0 current address register
     else if(dif.WRITE_BASE_ADDR_CH0_REG_CMD == 1 && MODE_REG[0].auto_init_en == 0)
       if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
         CURR_ADDR_CH0_REG[15:8] <= WRITE_BUF;
       else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
         CURR_ADDR_CH0_REG[7:0]  <= WRITE_BUF;
     else if(!dif.EOP_N)begin	// auto initialization is enabled and EOP is asserted
         CURR_ADDR_CH0_REG <= BASE_ADDR_CH0_REG;
    // CH1 current address register
     else if(dif.WRITE_BASE_ADDR_CH0_REG_CMD == 1 && MODE_REG[1].auto_init_en == 0)
       if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
         CURR_ADDR_CH1_REG[15:8] <= WRITE_BUF;
       else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
         CURR_ADDR_CH1_REG[7:0]  <= WRITE_BUF;
     else if(!dif.EOP_N)begin	// auto initialization is enabled and EOP is asserted
         CURR_ADDR_CH1_REG <= BASE_ADDR_CH1_REG;
    // CH2 current address register
     else if(dif.WRITE_BASE_ADDR_CH2_REG_CMD == 1 && MODE_REG[2].auto_init_en == 0)
       if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
         CURR_ADDR_CH2_REG[15:8] <= WRITE_BUF;
       else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
         CURR_ADDR_CH2_REG[7:0]  <= WRITE_BUF;
     else if(!dif.EOP_N)begin	// auto initialization is enabled and EOP is asserted
         CURR_ADDR_CH2_REG <= BASE_ADDR_CH2_REG;
    // CH3 current address register
     else if(dif.WRITE_BASE_ADDR_CH3_REG_CMD == 1 && MODE_REG[3].auto_init_en == 0)
       if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
         CURR_ADDR_CH3_REG[15:8] <= WRITE_BUF;
       else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
         CURR_ADDR_CH3_REG[7:0]  <= WRITE_BUF;
     else if(!dif.EOP_N)begin	// auto initialization is enabled and EOP is asserted
         CURR_ADDR_CH3_REG <= BASE_ADDR_CH3_REG;
     else begin
           CURR_ADDR_CH0_REG <= CURR_ADDR_CH0_REG;
           CURR_ADDR_CH1_REG <= CURR_ADDR_CH1_REG;
           CURR_ADDR_CH2_REG <= CURR_ADDR_CH2_REG;
           CURR_ADDR_CH3_REG <= CURR_ADDR_CH3_REG;
      end

// Base word count Registers
   always_ff@(posedge dif.CLK) begin
     if(dif.RESET || dif.MASTER_CLEAR_CMD)  begin                
           BASE_WORD_COUNT_CH0_REG <= '0;
           BASE_WORD_COUNT_CH1_REG <= '0;
           BASE_WORD_COUNT_CH2_REG <= '0;
           BASE_WORD_COUNT_CH3_REG <= '0;
      end
     //the command code for Writing the base word count register -> base word count Reg 0     
     else if(dif.WRITE_BASE_WORD_COUNT_CH0_REG_CMD == 1)
             if(SET_BYTE_POINTER_CMD == 1)	  // load upper byte 
               BASE_WORD_COUNT_CH0_REG[15:8] <= WRITE_BUF;
             else if(CLEAR_BYTE_POINTER_CMD == 1) // load lower byte
               BASE_WORD_COUNT_CH0_REG[7:0]  <= WRITE_BUF;
             end
     //the command code for Writing the base word count register -> base word count Reg 1     
     else if(dif.WRITE_BASE_WORD_COUNT_CH1_REG_CMD == 1)
             if(SET_BYTE_POINTER_CMD == 1)	  // load upper byte 
               BASE_WORD_COUNT_CH0_REG[15:8] <= WRITE_BUF;
             else if(CLEAR_BYTE_POINTER_CMD == 1) // load lower byte
               BASE_WORD_COUNT_CH0_REG[7:0]  <= WRITE_BUF;
             end
     //the command code for Writing the base address register -> base word count Reg 2     
     else if(dif.WRITE_BASE_WORD_COUNT_CH2_REG_CMD == 1)
             if(SET_BYTE_POINTER_CMD == 1)	  // load upper byte 
               BASE_WORD_COUNT_CH0_REG[15:8] <= WRITE_BUF;
             else if(CLEAR_BYTE_POINTER_CMD == 1) // load lower byte
               BASE_WORD_COUNT_CH0_REG[7:0]  <= WRITE_BUF;
             end
     //the command code for Writing the base word count register -> base word count Reg 3     
     else if(dif.WRITE_BASE_WORD_COUNT_CH3_REG_CMD == 1)
             if(SET_BYTE_POINTER_CMD == 1)	  // load upper byte 
               BASE_WORD_COUNT_CH0_REG[15:8] <= WRITE_BUF;
             else if(CLEAR_BYTE_POINTER_CMD == 1) // load lower byte
               BASE_WORD_COUNT_CH0_REG[7:0]  <= WRITE_BUF;
             end
     else begin
          BASE_WORD_COUNT_CH0_REG <= BASE_WORD_COUNT_CH0_REG;
          BASE_WORD_COUNT_CH1_REG <= BASE_WORD_COUNT_CH1_REG;
          BASE_WORD_COUNT_CH2_REG <= BASE_WORD_COUNT_CH2_REG;
          BASE_WORD_COUNT_CH3_REG <= BASE_WORD_COUNT_CH3_REG;
     end
   end

// Current word count Registers
// NOTE: As we are doing single transfers only, we do not need to decrement word count
//       but we need some alternative logic to raise timeout flag
   always_ff@(posedge dif.CLK) begin
     if(dif.RESET || dif.MASTER_CLEAR_CMD)  begin                
           CURR_WORD_COUNT_CH0_REG <= '0;
           CURR_WORD_COUNT_CH1_REG <= '0;
           CURR_WORD_COUNT_CH2_REG <= '0;
           CURR_WORD_COUNT_CH3_REG <= '0;
      end
    // CH0 current word count register
     else if(dif.WRITE_BASE_WORD_COUNT_CH0_REG_CMD == 1 && MODE_REG[0].auto_init_en == 0)
       if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
         CURR_WORD_COUNT_CH0_REG[15:8] <= WRITE_BUF;
       else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
         CURR_WORD_COUNT_CH0_REG[7:0]  <= WRITE_BUF;
     else if(!dif.EOP_N)begin	// auto initialization is enabled and EOP is asserted
         CURR_WORD_COUNT_CH0_REG <= BASE_WORD_COUNT_CH0_REG;
    // CH1 current word count register
     else if(dif.WRITE_BASE_WORD_COUNT_CH0_REG_CMD == 1 && MODE_REG[1].auto_init_en == 0)
       if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
         CURR_WORD_COUNT_CH1_REG[15:8] <= WRITE_BUF;
       else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
         CURR_WORD_COUNT_CH1_REG[7:0]  <= WRITE_BUF;
     else if(!dif.EOP_N)begin	// auto initialization is enabled and EOP is asserted
         CURR_WORD_COUNT_CH1_REG <= BASE_WORD_COUNT_CH1_REG;
    // CH2 current word count register
     else if(dif.WRITE_BASE_WORD_COUNT_CH2_REG_CMD == 1 && MODE_REG[2].auto_init_en == 0)
       if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
         CURR_WORD_COUNT_CH2_REG[15:8] <= WRITE_BUF;
       else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
         CURR_WORD_COUNT_CH2_REG[7:0]  <= WRITE_BUF;
     else if(!dif.EOP_N)begin	// auto initialization is enabled and EOP is asserted
         CURR_WORD_COUNT_CH2_REG <= BASE_WORD_COUNT_CH2_REG;
    // CH3 current word count register
     else if(dif.WRITE_BASE_WORD_COUNT_CH3_REG_CMD == 1 && MODE_REG[3].auto_init_en == 0)
       if(SET_BYTE_POINTER_CMD == 1) begin    		// load upper byte 
         CURR_WORD_COUNT_CH3_REG[15:8] <= WRITE_BUF;
       else if(CLEAR_BYTE_POINTER_CMD == 1) begin	// load lower byte
         CURR_WORD_COUNT_CH3_REG[7:0]  <= WRITE_BUF;
     else if(!dif.EOP_N)begin	// auto initialization is enabled and EOP is asserted
         CURR_WORD_COUNT_CH3_REG <= BASE_WORD_COUNT_CH3_REG;
     else begin
           CURR_WORD_COUNT_CH0_REG <= CURR_WORD_COUNT_CH0_REG;
           CURR_WORD_COUNT_CH1_REG <= CURR_WORD_COUNT_CH1_REG;
           CURR_WORD_COUNT_CH2_REG <= CURR_WORD_COUNT_CH2_REG;
           CURR_WORD_COUNT_CH3_REG <= CURR_WORD_COUNT_CH3_REG;
      end
  
  // Mode Register
  always_ff@(posedge dif.CLK) begin
            if(dif.RESET || dif.MASTER_CLEAR_CMD) begin
                MODE_REG[0] <= '0;
                MODE_REG[1] <= '0;
                MODE_REG[2] <= '0;
                MODE_REG[3] <= '0;
              end
            else if(WRITE_MODE_REG_CMD == 1)
                MODE_REG[IO_DATA_BUF[1:0]] <= IO_DATA_BUF;  
            else begin
                MODE_REG[0] <=  MODE_REG[0];
                MODE_REG[1] <=  MODE_REG[1];
                MODE_REG[2] <=  MODE_REG[2];
                MODE_REG[3] <=  MODE_REG[3];
            end
 end
                 
  // Command Register
  always_ff@(posedge dif.CLK) begin
            if(dif.RESET || dif.MASTER_CLEAR_CMD) 
               	 COMMAND_REG <= '0;
            else if(WRITE_COMMAND_REG_CMD == 1)
                 COMMAND_REG <= IO_DATA_BUF;            
            else COMMAND_REG <= COMMAND_REG;
  end
  
  //Request Register
  always_ff@(posedge dif.CLK) begin
            if(dif.RESET || dif.MASTER_CLEAR_CMD) 
                 REQUEST_REG <= '0;
            else if(WRITE_REQUEST_REG_CMD == 1)
                 REQUEST_REG <= IO_DATA_BUF;            
            else 
                 REQUEST_REG <=  REQUEST_REG;
  end
                 
  // Mask Register
  always_ff@(posedge dif.CLK) begin
            if(dif.RESET || dif.MASTER_CLEAR_CMD) 
                 MASK_REG= '0;          
            else if(WRITE_MASK_REG_CMD == 1)
                 MASK_REG <= IO_DATA_BUF;  
            else MASK_REG <= MASK_REG; 
  end
    
  // Status Register
  always_ff@(posedge dif.CLK) begin
           if(dif.RESET || dif.MASTER_CLEAR_CMD)
               STATUS_REG <= '0;
	   else if(cif.timeout) 
		if(cif.VALID_DREQ0) begin
			STATUS_REG[0] <= 1'b1;
			STATUS_REG[4] <= 1'b0;
		end
		else if(cif.VALID_DREQ1) begin
			STATUS_REG[1] <= 1'b1;
			STATUS_REG[5] <= 1'b0;
		end
		else if(cif.VALID_DREQ2) begin
			STATUS_REG[2] <= 1'b1;
			STATUS_REG[6] <= 1'b0;
		end
		else if(cif.VALID_DREQ3) begin
			STATUS_REG[3] <= 1'b1;
			STATUS_REG[7] <= 1'b0;
		end
           else         STATUS_REG <= STATUS_REG;
  end

// Data buffer
  always_ff@(posedge dif.CLK) begin
	  if(dif.RESET || dif.MASTER_CLEAR_CMD) 	  IO_DATA_BUF <= '0; 
	  else if(!CS_N && !dif.IOR_N && dif.IOW_N)	  IO_DATA_BUF <= READ_BUF;
            else if(cif.en_addr_out) 
                    // to give the most significant 8 bits as output to the i/o data bus
		      if(REQUEST_REG[1:0] == 2'b00)
                      	IO_DATA_BUF <= CURR_ADDR_CH0_REG[15:8];
		      else if(REQUEST_REG[1:0] == 2'b01)
                      	IO_DATA_BUF <= CURR_ADDR_CH1_REG[15:8];
		      else if(REQUEST_REG[1:0] == 2'b10)
                      	IO_DATA_BUF <= CURR_ADDR_CH2_REG[15:8];
		      else if(REQUEST_REG[1:0] == 2'b11)
                      	IO_DATA_BUF <= CURR_ADDR_CH3_REG[15:8];
            else if(READ_STATUS_REG_CMD == 1)
               		IO_DATA_BUF <= STATUS_REG;
	    else 	IO_DATA_BUF <= IO_DATA_BUF;
  end

// Address Buffers
  always_ff@(posedge dif.CLK) begin
            if(dif.RESET || dif.MASTER_CLEAR_CMD) begin
		IO_ADDR_BUF  <= '0;
		OUT_ADDR_BUF <= '0; 
	    end
            else if(cif.en_addr_out) 
                    // to give the least significant 8 bits as output to the i/o data bus
		      if(REQUEST_REG[1:0] == 2'b00)
                      	{OUT_ADDR_BUF,IO_ADDR_BUF} <= CURR_ADDR_CH0_REG[7:0];
		      else if(REQUEST_REG[1:0] == 2'b01)
                      	{OUT_ADDR_BUF,IO_ADDR_BUF} <= CURR_ADDR_CH1_REG[7:0];
		      else if(REQUEST_REG[1:0] == 2'b10)
                      	{OUT_ADDR_BUF,IO_ADDR_BUF} <= CURR_ADDR_CH2_REG[7:0];
		      else if(REQUEST_REG[1:0] == 2'b11)
                      	{OUT_ADDR_BUF,IO_ADDR_BUF} <= CURR_ADDR_CH3_REG[7:0];
	    else begin
		IO_ADDR_BUF  <= IO_ADDR_BUF ;
		OUT_ADDR_BUF <= OUT_ADDR_BUF; 
	    end
  end
                         
endmodule : dma_reg_file

