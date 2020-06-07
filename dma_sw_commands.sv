module dma_sw_commands(dma_if.dif);

/*
single request bit, single mask bit commands are not supported
*/

  // DMA SW Commands in Program mode
  // base address register write command
  // dif.WRITE_BASE_ADDR_CH0_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h0 && dif.IOR_N && !dif.IOW_N)
  		dif.WRITE_BASE_ADDR_CH0_REG_CMD = 1'b1;
  	else	dif.WRITE_BASE_ADDR_CH0_REG_CMD = 1'b0;
  else	dif.WRITE_BASE_ADDR_CH0_REG_CMD = 1'bx;
  end
  
  // dif.WRITE_BASE_ADDR_CH1_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h2 && dif.IOR_N && !dif.IOW_N)
  		dif.WRITE_BASE_ADDR_CH1_REG_CMD = 1'b1;
  	else	dif.WRITE_BASE_ADDR_CH1_REG_CMD = 1'b0;
  else	dif.WRITE_BASE_ADDR_CH1_REG_CMD = 1'bx;
  end
  
  // dif.WRITE_BASE_ADDR_CH2_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h4 && dif.IOR_N && !dif.IOW_N)
  		dif.WRITE_BASE_ADDR_CH2_REG_CMD = 1'b1;
  	else	dif.WRITE_BASE_ADDR_CH2_REG_CMD = 1'b0;
  else	dif.WRITE_BASE_ADDR_CH2_REG_CMD = 1'bx;
  end
  
  // dif.WRITE_BASE_ADDR_CH3_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h6 && dif.IOR_N && !dif.IOW_N)
  		dif.WRITE_BASE_ADDR_CH3_REG_CMD = 1'b1;
  	else	dif.WRITE_BASE_ADDR_CH3_REG_CMD = 1'b0;
  else	dif.WRITE_BASE_ADDR_CH3_REG_CMD = 1'bx;
  end
  
  // current address register read command
  // dif.READ_CURR_ADDR_CH0_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h0 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_CURR_ADDR_CH0_REG_CMD = 1'b1;
  	else	dif.READ_CURR_ADDR_CH0_REG_CMD = 1'b0;
  else	dif.READ_CURR_ADDR_CH0_REG_CMD = 1'bx;
  end
  
  // dif.READ_CURR_ADDR_CH1_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h2 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_CURR_ADDR_CH1_REG_CMD = 1'b1;
  	else	dif.READ_CURR_ADDR_CH1_REG_CMD = 1'b0;
  else	dif.READ_CURR_ADDR_CH1_REG_CMD = 1'bx;
  end
  
  // dif.READ_CURR_ADDR_CH2_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h4 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_CURR_ADDR_CH2_REG_CMD = 1'b1;
  	else	dif.READ_CURR_ADDR_CH2_REG_CMD = 1'b0;
  else	dif.READ_CURR_ADDR_CH2_REG_CMD = 1'bx;
  end
  
  // dif.READ_CURR_ADDR_CH3_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h6 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_CURR_ADDR_CH3_REG_CMD = 1'b1;
  	else	dif.READ_CURR_ADDR_CH3_REG_CMD = 1'b0;
  else	dif.READ_CURR_ADDR_CH3_REG_CMD = 1'bx;
  end
  
  // base word count register write command
  // dif.WRITE_BASE_WORD_COUNT_CH0_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h1 && dif.IOR_N && !dif.IOW_N)
  		dif.WRITE_BASE_WORD_COUNT_CH0_REG_CMD = 1'b1;
  	else	dif.WRITE_BASE_WORD_COUNT_CH0_REG_CMD = 1'b0;
  else	dif.WRITE_BASE_WORD_COUNT_CH0_REG_CMD = 1'bx;
  end
  
  // dif.WRITE_BASE_WORD_COUNT_CH1_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h3 && dif.IOR_N && !dif.IOW_N)
  		dif.WRITE_BASE_WORD_COUNT_CH1_REG_CMD = 1'b1;
  	else	dif.WRITE_BASE_WORD_COUNT_CH1_REG_CMD = 1'b0;
  else	dif.WRITE_BASE_WORD_COUNT_CH1_REG_CMD = 1'bx;
  end
  
  // dif.WRITE_BASE_WORD_COUNT_CH2_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h5 && dif.IOR_N && !dif.IOW_N)
  		dif.WRITE_BASE_WORD_COUNT_CH2_REG_CMD = 1'b1;
  	else	dif.WRITE_BASE_WORD_COUNT_CH2_REG_CMD = 1'b0;
  else	dif.WRITE_BASE_WORD_COUNT_CH2_REG_CMD = 1'bx;
  end
  
  // dif.WRITE_BASE_WORD_COUNT_CH3_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h7 && dif.IOR_N && !dif.IOW_N)
  		dif.WRITE_BASE_WORD_COUNT_CH3_REG_CMD = 1'b1;
  	else	dif.WRITE_BASE_WORD_COUNT_CH3_REG_CMD = 1'b0;
  else	dif.WRITE_BASE_WORD_COUNT_CH3_REG_CMD = 1'bx;
  end
  
  // current address register read command
  // dif.READ_CURR_WORD_COUNT_CH0_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h1 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_CURR_WORD_COUNT_CH0_REG_CMD = 1'b1;
  	else	dif.READ_CURR_WORD_COUNT_CH0_REG_CMD = 1'b0;
  else	dif.READ_CURR_WORD_COUNT_CH0_REG_CMD = 1'bx;
  end
  
  // dif.READ_CURR_WORD_COUNT_CH1_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h3 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_CURR_WORD_COUNT_CH1_REG_CMD = 1'b1;
  	else	dif.READ_CURR_WORD_COUNT_CH1_REG_CMD = 1'b0;
  else	dif.READ_CURR_WORD_COUNT_CH1_REG_CMD = 1'bx;
  end
  
  // dif.READ_CURR_WORD_COUNT_CH2_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h5 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_CURR_WORD_COUNT_CH2_REG_CMD = 1'b1;
  	else	dif.READ_CURR_WORD_COUNT_CH2_REG_CMD = 1'b0;
  else	dif.READ_CURR_WORD_COUNT_CH2_REG_CMD = 1'bx;
  end
  
  // dif.READ_CURR_WORD_COUNT_CH3_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h7 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_CURR_WORD_COUNT_CH3_REG_CMD = 1'b1;
  	else	dif.READ_CURR_WORD_COUNT_CH3_REG_CMD = 1'b0;
  else	dif.READ_CURR_WORD_COUNT_CH3_REG_CMD = 1'bx;
  end
  
  // write command register command
  // dif.WRITE_COMMAND_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h8 && !dif.IOW_N && dif.IOR_N)
  		dif.WRITE_COMMAND_REG_CMD = 1'b1;
  	else	dif.WRITE_COMMAND_REG_CMD = 1'b0;
  else	dif.WRITE_COMMAND_REG_CMD = 1'bx;
  end
  
  // read status register command
  // dif.READ_STATUS_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h8 && dif.IOW_N && !dif.IOR_N)
  		dif.READ_STATUS_REG_CMD = 1'b1;
  	else	dif.READ_STATUS_REG_CMD = 1'b0;
  else	dif.READ_STATUS_REG_CMD = 1'bx;
  end
   
  // write request register command
  // dif.WRITE_REQUEST_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'h9 && !dif.IOW_N && dif.IOR_N)
  		dif.WRITE_REQUEST_REG_CMD = 1'b1;
  	else	dif.WRITE_REQUEST_REG_CMD = 1'b0;
  else	dif.WRITE_REQUEST_REG_CMD = 1'bx;
  end

  // write mode register command
  // dif.WRITE_MODE_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hB && !dif.IOW_N && dif.IOR_N)
  		dif.WRITE_MODE_REG_CMD = 1'b1;
  	else	dif.WRITE_MODE_REG_CMD = 1'b0;
  else	dif.WRITE_MODE_REG_CMD = 1'bx;
  end
  
  // read mode register command
  // dif.READ_MODE_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hB && dif.IOW_N && !dif.IOR_N)
  		dif.READ_MODE_REG_CMD = 1'b1;
  	else	dif.READ_MODE_REG_CMD = 1'b0;
  else	dif.READ_MODE_REG_CMD = 1'bx;
  end
  
  // clear byte pointer command 
  // dif.CLEAR_BYTE_POINTER_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hC && !dif.IOW_N && dif.IOR_N)
  		dif.CLEAR_BYTE_POINTER_CMD = 1'b1;
  	else	dif.CLEAR_BYTE_POINTER_CMD = 1'b0;
  else	dif.CLEAR_BYTE_POINTER_CMD = 1'bx;
  end
  
  // set byte pointer command 
  // dif.SET_BYTE_POINTER_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hC && dif.IOW_N && !dif.IOR_N)
  		dif.SET_BYTE_POINTER_CMD = 1'b1;
  	else	dif.SET_BYTE_POINTER_CMD = 1'b0;
  else	dif.SET_BYTE_POINTER_CMD = 1'bx;
  end
  
  // master clear command 
  // dif.MASTER_CLEAR_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hD && !dif.IOW_N && dif.IOR_N)
  		dif.MASTER_CLEAR_CMD = 1'b1;
  	else	dif.MASTER_CLEAR_CMD = 1'b0;
  else	dif.MASTER_CLEAR_CMD = 1'bx;
  end
  
  // clear mask register command 
  // dif.CLEAR_MASK_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hE && !dif.IOW_N && dif.IOR_N)
  		dif.CLEAR_MASK_REG_CMD = 1'b1;
  	else	dif.CLEAR_MASK_REG_CMD = 1'b0;
  else	dif.CLEAR_MASK_REG_CMD = 1'bx;
  end
  
// clear mode register counter command 
  // dif.CLEAR_MODE_REG_COUNT_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hE && dif.IOW_N && !dif.IOR_N)
  		dif.CLEAR_MODE_REG_COUNT_CMD = 1'b1;
  	else	dif.CLEAR_MODE_REG_COUNT_CMD = 1'b0;
  else	dif.CLEAR_MODE_REG_COUNT_CMD = 1'bx;
  end

  // write mask register command
  // dif.WRITE_MASK_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hF && !dif.IOW_N && dif.IOR_N)
  		dif.WRITE_MASK_REG_CMD = 1'b1;
  	else	dif.WRITE_MASK_REG_CMD = 1'b0;
  else	dif.WRITE_MASK_REG_CMD = 1'bx;
  end
  
  // read mask register command
  // dif.READ_MASK_REG_CMD
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// write to register
  	if(dif.ADDR_L == 4'hF && dif.IOW_N && !dif.IOR_N)
  		dif.READ_MASK_REG_CMD = 1'b1;
  	else	dif.READ_MASK_REG_CMD = 1'b0;
  else	dif.READ_MASK_REG_CMD = 1'bx;
  end
  
  // READ ANY REGISTER
  always_comb begin
  if(!dif.CS_N && !dif.HLDA)
  	// read to register
  	if(dif.IOW_N && !dif.IOR_N)
  		    dif.READ_ANY_REG_CMD = 1'b1;
  	else	dif.READ_ANY_REG_CMD = 1'b0;
  else	  dif.READ_ANY_REG_CMD = 1'bx;
  end
  
endmodule : dma_sw_commands
