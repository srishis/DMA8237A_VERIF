// DMA Timing Control Module 
s
module dma_control(dma_if.TC dif, dma_control_if.TC cif);

import dma_reg_pkg::*;

// FSM control signals
logic checkWriteExtend;
logic checkEOP;
logic checkRead;
logic checkWrite;

 // index for each state
 enum {
  	iSI   = 0,
  	iS0   = 1,
  	iS1   = 2,
  	iS2   = 3,
  	iS3   = 4,
  	iS4   = 5
  } stateIndex;
  
  // declaration of fsm states onehot encoding
 enum logic [5:0] {
  	SI   = 6'b000001 << iSI, 
  	S0   = 6'b000001 << iS0, 
  	S1   = 6'b000001 << iS1, 
  	S2   = 6'b000001 << iS2, 
  	S3   = 6'b000001 << iS3, 
  	S4   = 6'b000001 << iS4 
  	} state, nextstate;

	
// Reset condition
always_ff@(posedge dif.CLK) begin
  if(dif.RESET) begin
  	dif.AEN    <= '0;
  	dif.ADSTB  <= '0;
	state      <= SI;       // Initial FSM state
  end
  else begin
// AEN & ADSTB functionality
  	dif.AEN    <= cif.aen;
  	dif.ADSTB  <= cif.adstb;
	state      <= nextstate;
  end
end

// IO Read logic
  assign dif.IOR_N = (~dif.CS_N && dif.HLDA) ? cif.ior : 1'bz;       // access data from peripheral during DMA write transfer

// IO Write logic
  assign dif.IOW_N = (~dif.CS_N && dif.HLDA) ? cif.iow : 1'bz;       // load data to peripheral during DMA read transfer
	
// MEM Read logic
  assign  dif.MEMR_N = (~dif.CS_N && dif.HLDA) ? cif.memr : 1'bz;   // access data from peripheral during DMA write transfer
	
// MEM Write logic
  assign dif.MEMW_N = (~dif.CS_N && dif.HLDA) ? cif.memw : 1'bz;   // load data to peripheral during DMA read transfer
	
// EOP logic
  assign (pull0, pull1) dif.EOP_N = '1;   // pullup resistor logic
  assign dif.EOP_N = (~dif.CS_N && dif.HLDA) ? cif.eop : 1'bz;

// Write extend & Read or Write operation
always_comb begin
if(checkWriteExtend)
	//if (rif.commandReg[5] == 1'b1 && rif.modeReg[0][3:2] == 2'b01 || rif.modeReg[1][3:2] == 2'b01 || rif.modeReg[2][3:2] == 2'b01 || rif.modeReg[3][3:2] == 2'b01 && rif.commandReg[0] == 1'b0)
	if(COMMAND_REG[5] == 1'b1 && (MODE_REG[0][3:2] == 2'b01 || MODE_REG[1][3:2] == 2'b01 || MODE_REG[2][3:2] == 2'b01 || MODE_REG[3][3:2] == 2'b01))
			begin cif.memw = 1'b0; cif.ior = 1'b0; end   
	else    begin cif.memw = 1'b1; cif.ior = 1'b1; end   
else if(checkWrite)
	if(COMMAND_REG[5] == 1'b0 && (MODE_REG[0][3:2] == 2'b01 || MODE_REG[1][3:2] == 2'b01 || MODE_REG[2][3:2] == 2'b01 || MODE_REG[3][3:2] == 2'b01)) 
			begin cif.memw = 1'b0; cif.ior = 1'b0; end   
	else    begin cif.memw = 1'b1; cif.ior = 1'b1; end   
	
else if(checkRead)
	if(MODE_REG[0][3:2] == 2'b10 || MODE_REG[1][3:2] == 2'b10 || MODE_REG[2][3:2] == 2'b10 || MODE_REG[3][3:2] == 2'b10)    			
			begin cif.memr = 1'b0; cif.iow = 1'b0; end   
	else    begin cif.memr = 1'b1; cif.iow = 1'b1; end   
end

// End of process on terminal count 
always_comb begin
if(checkEOP || STATUS_REG[3:0])    cif.eop = 1'b0;  
else		                   	   cif.eop = 1'b1;
end

// Next state logic
always_comb begin   

        nextstate = state;      //default value for nextstate
              
        unique case(1'b1)       // reverse case       
            state[iSI]:
					   begin
					   if(cif.VALID_DREQ0 || cif.VALID_DREQ1 || cif.VALID_DREQ2 || cif.VALID_DREQ3) 	nextstate = S0;
					   else  																			nextstate = SI;
					   end
		        
            state[iS0]:
					   begin
					   if(dif.HLDA) 									nextstate = S1;
					   else if(!dif.HLDA) 								nextstate = S0;
					   else if(dif.MASTER_CLEAR_CMD) 					nextstate = SI;
					   end
		       
            state[iS1]:
					   begin 
					   if(dif.MASTER_CLEAR_CMD) 						nextstate = SI;
					   else 											nextstate = S2;
					   end
		       
            state[iS2]:  
						begin 
						if(dif.MASTER_CLEAR_CMD) 						nextstate = SI;
						else 											nextstate = S3;
						end

            state[iS3]:
                      begin 
						if(dif.MASTER_CLEAR_CMD) 						nextstate = SI;
						else 											nextstate = S4;
					  end
		       
            state[iS4]:										        	nextstate = SI;
 										
        endcase
end
	  
// Output logic
always_comb begin 

// default values for FSM control outputs
{cif.aen, cif.adstb, checkEOP, checkRead, checkWrite, checkWriteExtend} = 6'b000000;  
{cif.ldCurrAddrTemp, cif.ldCurrWordTemp, cif.ldTempCurrAddr, cif.ldTempCurrWord, cif.en_addr_out, cif.VALID_DACK} = 6'b000000;
cif.timeout = 0;		 

    unique case(1'b1)  // reverse case

	    state[iSI]   : begin  cif.hrq = 1'b0;  end

	    state[iS0]   : begin  cif.hrq = 1'b1; end
		           	
	    state[iS1]   : begin  cif.hrq = 1'b1; cif.aen = 1'b1; cif.adstb = 1'b1; cif.VALID_DACK = 1'b1; cif.en_addr_out = 1'b1; end
		// cif.ldCurrAddrTemp= 1'b1; cif.ldCurrWordTemp = 1'b1;  end
        
	    state[iS2]   : begin  cif.aen = 1'b1; cif.adstb = 1'b0; checkRead = 1'b1; cif.hrq = 1'b1; checkWriteExtend = 1'b1; cif.en_addr_out = 1'b0; end
		// cif.enCurrAddr = 1'b0; cif.ldCurrAddrTemp= 1'b0; cif.ldCurrWordTemp = 1'b0; cif.ldTempCurrAddr= 1'b1; cif.ldTempCurrWord = 1'b1; end
		           	

	    state[iS3]   : begin cif.aen = 1'b1; checkWrite = 1'b1; cif.hrq = 1'b1; end
		
	    state[iS4]   : begin   cif.VALID_DACK = 1'b0; checkEOP = 1'b1; cif.hrq = 1'b0; cif.aen = 1'b0; cif.timeout = 1'b1; end  
				   // cif.ldTempCurrAddr= 1'b0; cif.ldTempCurrWord = 1'b0;
			
					
    endcase
end
				 
endmodule : dma_control
