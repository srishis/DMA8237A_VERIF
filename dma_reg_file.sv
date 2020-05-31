// DMA Registers and Buffers module

module dma_reg_file(dma_if.DP dif, dma_control_if.DP cif);  

import dma_reg_pkg::*;

// timeout status bits
logic TC[4];	

// Register commands
logic master_clear;
logic FF;

// DMA Registers SW command codes
localparam [7:0] READCURRADDR[4]         = {8'b10010000,8'b10010010,8'b10010100,8'b10010110};
localparam [7:0] WRITEBASECURRADDR[4]    = {8'b10100000,8'b10100010,8'b10100100,8'b10100110};
localparam [7:0] WRITEBASECURRCOUNT[4]   = {8'b10100001,8'b10100011,8'b10100101,8'b10100111};
localparam [7:0] READCURRCOUNT[4]        = {8'b10010001,8'b10010011,8'b10010101,8'b10010111};
localparam [7:0] MODEREGWRITE[4]         = {8'b10101011,8'b10101011,8'b10101011,8'b10101011};
localparam WRITECOMMANDREG               = 8'b10101000;
localparam WRITEREQUESTREG               = 8'b10101001;
localparam WRITESINGLEMASKREG            = 8'b10101010; 
localparam WRITEALLMASKREG               = 8'b10101111;
localparam READTEMPREG                   = 8'b10011101;
localparam READSTATUSREG                 = 8'b10011000;
localparam CLEARFF                       = 8'b10101100;
localparam CLEARMASKREG                  = 8'b10101110;
localparam MASTERCLEARREG                = 8'b10101101;


// Buffers Reset condition
  always_ff@(posedge dif.CLK) begin
  if(dif.RESET) begin			
  	IO_ADDR_BUF  <= '0;
  	IO_DATA_BUF  <= '0;
  	OUT_ADDR_BUF <= '0;
  	READ_BUF     <= '0;
  	WRITE_BUF    <= '0;
  end
  else begin
  	IO_ADDR_BUF  <= IO_ADDR_BUF;
  	IO_DATA_BUF  <= IO_DATA_BUF;
  	OUT_ADDR_BUF <= OUT_ADDR_BUF;
  	READ_BUF     <= READ_BUF;
  	WRITE_BUF    <= WRITE_BUF;
  end
  end
  
// Read Buffer
 // always_ff@(posedge dif.CLK) begin
 //           if(dif.RESET || master_clear) READ_BUF    <= '0;
 //           else		   	  IO_DATA_BUF <= READ_BUF;
 // end
  
// Write Buffer
  
 // always_ff@(posedge dif.CLK) begin
 //           if(dif.RESET || master_clear) WRITE_BUF <= '0;
 //           else		   	    WRITE_BUF <= IO_DATA_BUF;
 // end
		  
// DMA Registers logic
//Base Address Register
  always_ff@(posedge dif.CLK) begin
    if(dif.RESET||master_clear)  begin                
          BASE_ADDR_CH0_REG <= '0;
          BASE_ADDR_CH1_REG <= '0;
          BASE_ADDR_CH2_REG <= '0;
          BASE_ADDR_CH3_REG <= '0;
     end
    //the command code for Writing the base and current register -> base Address Reg 0     
     else if({cif.Program, dif.CS_N, dif.IOR_N, dif.IOW_N, IO_ADDR_BUF} == WRITEBASECURRADDR[0])
             begin
          if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
            BASE_ADDR_CH0_REG[15:8] <= WRITE_BUF;
          else
            BASE_ADDR_CH0_REG[7:0] <= WRITE_BUF;
             end
    
  //the command code for Writing the base and current register -> base Address Reg 1
     else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRADDR[1])
             begin
                 if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                   BASE_ADDR_CH1_REG[15:8] <= WRITE_BUF;
                 else
                   BASE_ADDR_CH1_REG[7:0] <= WRITE_BUF;
                    end
  //the command code for Writing the base and current register -> base Address Reg 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRADDR[2])
                    begin
                        if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                          BASE_ADDR_CH2_REG[15:8] <= WRITE_BUF;
                        else
                          BASE_ADDR_CH2_REG[7:0] <= WRITE_BUF;
                    end
  //the command code for Writing the base and current register -> base Address Reg 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRADDR[3])
                    begin
                        if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded                               
                          BASE_ADDR_CH3_REG[15:8] <= WRITE_BUF;
                        else
                          BASE_ADDR_CH3_REG[7:0] <= WRITE_BUF;
                    end
            else
                begin 
                 BASE_ADDR_CH0_REG <= BASE_ADDR_CH0_REG;
                 BASE_ADDR_CH1_REG <= BASE_ADDR_CH1_REG;
                 BASE_ADDR_CH2_REG <= BASE_ADDR_CH2_REG;
                 BASE_ADDR_CH3_REG <= BASE_ADDR_CH3_REG;
                end
  
           
         end
  
  
  //Base Word Register
  always_ff@(posedge dif.CLK)
        begin
            if(dif.RESET||master_clear)
               begin
                 BASE_WORD_COUNT_CH0_REG[0] <= '0;
                 BASE_WORD_COUNT_CH0_REG[1] <= '0;
                 BASE_WORD_COUNT_CH0_REG[2] <= '0;
                 BASE_WORD_COUNT_CH0_REG[3] <= '0;
               end
  // command code to write the base and current word count register - base count reg 0
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRCOUNT[0])
                    begin
                      if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                         BASE_WORD_COUNT_CH0_REG[0][15:8] <= WRITE_BUF;
                      else
                         BASE_WORD_COUNT_CH0_REG[0][7:0] <= WRITE_BUF;
                    end
  // command code to write the base and current word count register - base count reg 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRCOUNT[1])
                    begin
                      if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                         BASE_WORD_COUNT_CH0_REG[1][15:8] <= WRITE_BUF;
                      else
                         BASE_WORD_COUNT_CH0_REG[1][7:0] <= WRITE_BUF;
                    end
  // command code to write the base and current word count register - base count reg 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRCOUNT[2])
                    begin
                      if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                         BASE_WORD_COUNT_CH0_REG[2][15:8] <= WRITE_BUF;
                      else
                         BASE_WORD_COUNT_CH0_REG[2][7:0] <= WRITE_BUF;
                    end
  
  // command code to write the base and current word count register - base count reg 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRCOUNT[3])
                    begin
                      if(FF)    // when FF = 1, upper byte is loaded . when FF = 0, lower byte is loaded 
                         BASE_WORD_COUNT_CH0_REG[3][15:8] <= WRITE_BUF;
                      else
                         BASE_WORD_COUNT_CH0_REG[3][7:0] <= WRITE_BUF;
                    end
  
            else 
                begin 
                  BASE_WORD_COUNT_CH0_REG[0] <= BASE_WORD_COUNT_CH0_REG[0] ;
                  BASE_WORD_COUNT_CH0_REG[1] <= BASE_WORD_COUNT_CH0_REG[1] ;
                  BASE_WORD_COUNT_CH0_REG[2] <= BASE_WORD_COUNT_CH0_REG[2] ;
                  BASE_WORD_COUNT_CH0_REG[3] <= BASE_WORD_COUNT_CH0_REG[3] ;
                end
  
         end          
  
  
  // Current Address Register
  
  always_ff@(posedge dif.CLK)
        begin
   
            if(dif.RESET||master_clear)
               begin
                    CURR_ADDR_CH0_REG <= '0;
                    CURR_ADDR_CH0_REG <= '0;
                    CURR_ADDR_CH0_REG <= '0;
                    CURR_ADDR_CH0_REG <= '0;
               end
  //When TC is reached and the auto initialization is disabled, the value to be set to zero
              else if ((TC[REQUEST_REG[1:0]])&&(MODE_REG[4]==0))
                  begin    
                    CURR_ADDR_CH0_REG[REQUEST_REG[1:0]] <= '0;
                  end
  //When TC is reached and the auto initialization is enabled, the value to be re-initialised from the base registers
            else if ((TC[REQUEST_REG[1:0]]) && (MODE_REG[4]==1))        
                  begin  
                    CURR_ADDR_CH0_REG[REQUEST_REG[1:0]] <= BASE_ADDR_CH0_REG[REQUEST_REG[1:0]]; 
                  end
  //command code to write curr and base address registers     current Address Reg 0      
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRADDR[0])
                    begin
                      if(FF)
                         CURR_ADDR_CH0_REG[15:8] <= WRITE_BUF;
                      else
                         CURR_ADDR_CH0_REG[7:0] <= WRITE_BUF;
                    end
  //command code to write curr and base address registers     current Address Reg 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRADDR[1])
                    begin
                      if(FF)
                         CURR_ADDR_CH0_REG[15:8] <= WRITE_BUF;
                      else
                         CURR_ADDR_CH0_REG[7:0] <= WRITE_BUF;
                    end
  //command code to write curr and base address registers     current Address Reg 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRADDR[2])
                    begin
                      if(FF)
                         CURR_ADDR_CH0_REG[15:8] <= WRITE_BUF;
                      else
                         CURR_ADDR_CH0_REG[7:0] <= WRITE_BUF;
                    end
  //command code to write curr and base address registers     current Address Reg 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRADDR[3])
                    begin
                      if(FF)
                         CURR_ADDR_CH0_REG[15:8] <= WRITE_BUF;
                      else
                         CURR_ADDR_CH0_REG[7:0] <= WRITE_BUF;
                    end
  
  //Read Current Address Register 0 
  
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READCURRADDR[0])
                    begin
                      if(FF)
                         READ_BUF <= CURR_ADDR_CH0_REG[15:8];
                      else
                         READ_BUF <= CURR_ADDR_CH0_REG[7:0];
                    end
  //Read Current Address Register 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READCURRADDR[1])
                    begin
                      if(FF)
                         READ_BUF <= CURR_ADDR_CH1_REG[15:8];
                      else
                         READ_BUF <= CURR_ADDR_CH1_REG[7:0];
                    end
  //Read Current Address Register 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READCURRADDR[2])
                    begin
                      if(FF)
                         READ_BUF <= CURR_ADDR_CH2_REG[15:8];
                      else
                         READ_BUF <= CURR_ADDR_CH2_REG[7:0];
                    end
  //Read Current Address Register 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READCURRADDR[3])
                    begin
                      if(FF)
                         READ_BUF <= CURR_ADDR_CH3_REG[15:8];
                      else
                         READ_BUF <= CURR_ADDR_CH3_REG[7:0];
                    end
  
            else if(cif.enCurrAddr) 
                    begin         // to give the most significant 8 bits as output to the i/o data bus
                      IO_DATA_BUF <= CURR_ADDR_CH0_REG[REQUEST_REG[1:0]][15:8];
                    end
             else if(cif.ldTempCurrAddr)      //signal to load the temporary address register to current address register value 
                    CURR_ADDR_CH0_REG[REQUEST_REG[1:0]] <= TEMP_ADDR_REG;
            else
                begin
                    CURR_ADDR_CH0_REG <= CURR_ADDR_CH0_REG;
                    CURR_ADDR_CH1_REG <= CURR_ADDR_CH1_REG;
                    CURR_ADDR_CH2_REG <= CURR_ADDR_CH2_REG;
                    CURR_ADDR_CH3_REG <= CURR_ADDR_CH3_REG;
                  end             
           end
            
  // Current Word Register                     
  always_ff@(posedge dif.CLK)
        begin
   
  	      if(dif.RESET||master_clear)
              begin
                 CURR_WORD_COUNT_CH0_REG <= '0; 
                 CURR_WORD_COUNT_CH1_REG <= '0; 
                 CURR_WORD_COUNT_CH2_REG <= '0; 
                 CURR_WORD_COUNT_CH3_REG <= '0; 
              end 
         
            else if((TC[REQUEST_REG[1:0]])&&(MODE_REG[4]==0))
               begin
                 CURR_WORD_COUNT_CH0_REG[REQUEST_REG[1:0]] <= '0;
               end
  
            else if((TC[REQUEST_REG[1:0]]) && (MODE_REG[4]==1))
               begin
                   CURR_WORD_COUNT_CH0_REG[REQUEST_REG[1:0]] <= BASE_WORD_COUNT_CH0_REG[REQUEST_REG[1:0]];
               end
  //write Current word 0
           else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRCOUNT[0])
                    begin
                      if(FF)
                         CURR_WORD_COUNT_CH0_REG[15:8] <= WRITE_BUF;
                      else
                         CURR_WORD_COUNT_CH0_REG[7:0] <= WRITE_BUF;
                    end
  //write Current word 1
           else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRCOUNT[1])
                    begin
                      if(FF)
                         CURR_WORD_COUNT_CH1_REG[15:8] <= WRITE_BUF;
                      else
                         CURR_WORD_COUNT_CH1_REG[7:0] <= WRITE_BUF;
                    end
  //write Current word 2
           else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRCOUNT[2])
                    begin
                      if(FF)
                         CURR_WORD_COUNT_CH2_REG[15:8] <= WRITE_BUF;
                      else
                         CURR_WORD_COUNT_CH2_REG[7:0] <= WRITE_BUF;
                    end
  //write Current word 3
           else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEBASECURRCOUNT[3])
                    begin
                      if(FF)
                         CURR_WORD_COUNT_CH3_REG[15:8] <= WRITE_BUF;
                      else
                         CURR_WORD_COUNT_CH3_REG[7:0] <= WRITE_BUF;
                    end
  
  //read current word 0
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READCURRCOUNT[0])
                    begin
                      if(FF)
                         READ_BUF <= CURR_WORD_COUNT_CH0_REG[15:8];
                      else
                         READ_BUF <= CURR_WORD_COUNT_CH0_REG[7:0];
                    end
  //read current word 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READCURRCOUNT[1])
                    begin
                      if(FF)
                         READ_BUF <= CURR_WORD_COUNT_CH1_REG[15:8];
                      else
                         READ_BUF <= CURR_WORD_COUNT_CH1_REG[7:0];
                    end
  //read current word 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READCURRCOUNT[2])
                    begin
                      if(FF)
                         READ_BUF <= CURR_WORD_COUNT_CH2_REG[15:8];
                      else
                         READ_BUF <= CURR_WORD_COUNT_CH3_REG[7:0];
                    end
  //read current word 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READCURRCOUNT[3])
                    begin
                      if(FF)
                         READ_BUF <= CURR_WORD_COUNT_CH3_REG[15:8];
                      else
                         READ_BUF <= CURR_WORD_COUNT_CH3_REG[7:0];
                    end
             else if(cif.ldTempCurrWord)     //signal to load the temporary address register to current address register value
                  begin
                    CURR_WORD_COUNT_CH0_REG[REQUEST_REG[1:0]] <= TEMP_WORD_COUNT_REG;
                  end
            else
                begin 
                 CURR_WORD_COUNT_CH0_REG <= CURR_WORD_COUNT_CH0_REG;
                 CURR_WORD_COUNT_CH1_REG <= CURR_WORD_COUNT_CH1_REG;
                 CURR_WORD_COUNT_CH2_REG <= CURR_WORD_COUNT_CH2_REG;
                 CURR_WORD_COUNT_CH3_REG <= CURR_WORD_COUNT_CH3_REG;
                end               
                      
         end                
        
      
  //Temporary Address Register and Increment or Decrement
  
  always_ff@(posedge dif.CLK)
           begin
               if(dif.RESET||master_clear)
                 begin
                     TEMP_ADDR_REG <= '0;
  
                  end 
              else if(cif.ldCurrAddrTemp)     //to load the current address into temporary register and then increment or decrement
                      begin   
                        TEMP_ADDR_REG <= CURR_ADDR_CH0_REG[REQUEST_REG[1:0]];
                        {OUT_ADDR_BUF,IO_ADDR_BUF} = CURR_WORD_COUNT_CH0_REG[REQUEST_REG[1:0]][7:0];
                        if(MODE_REG[5] == 0)
                            TEMP_ADDR_REG <= TEMP_ADDR_REG  + 16'b0000000000000001;
                        else
                            TEMP_ADDR_REG <= TEMP_ADDR_REG  - 16'b0000000000000001;
                      end
               else
                    begin
                   TEMP_ADDR_REG <= TEMP_ADDR_REG;
                    end
           end
  
  // Temporary Word Register
  
  always_ff@(posedge dif.CLK)
           begin
             if(dif.RESET||master_clear)
                     begin
                     TEMP_WORD_COUNT_REG <= '0;
  
                       end 
              else if(cif.ldCurrWordTemp)
                  begin
                   TEMP_WORD_COUNT_REG <= CURR_WORD_COUNT_CH0_REG[REQUEST_REG[1:0]];
                   TEMP_WORD_COUNT_REG <= TEMP_WORD_COUNT_REG - 16'b0000000000000001;
                 end
             if(TEMP_WORD_COUNT_REG ==0)
               begin
                TC[REQUEST_REG[1:0]] <= 1;
                TEMP_WORD_COUNT_REG <= 16'b1111111111111111;
               end
              else
                 begin 
                TEMP_WORD_COUNT_REG <= TEMP_WORD_COUNT_REG;
       
                end 
            end
   
  
  // Mode Register
  // cif.Programmed by the CPU
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||master_clear)
              begin
               MODE_REG[0] <= 16'b0;
               MODE_REG[1] <= 16'b0;
               MODE_REG[2] <= 16'b0;
               MODE_REG[3] <= 16'b0;
              end
  //Mode Register 0
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == MODEREGWRITE[0])
                 MODE_REG[IO_DATA_BUF[1:0]] <= IO_DATA_BUF[7:2];  
  //Mode Register 1
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == MODEREGWRITE[1])
                 MODE_REG[IO_DATA_BUF[1:0]] <= IO_DATA_BUF[7:2];
  //Mode Register 2
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == MODEREGWRITE[2])
                 MODE_REG[IO_DATA_BUF[1:0]] <= IO_DATA_BUF[7:2];
  //Mode Register 3
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == MODEREGWRITE[3])
                 MODE_REG[IO_DATA_BUF[1:0]] <= IO_DATA_BUF[7:2];          
            else 
                begin
                MODE_REG[0] <=  MODE_REG[0] ;
                MODE_REG[1] <=  MODE_REG[1] ;
                MODE_REG[2] <=  MODE_REG[2] ;
                MODE_REG[3] <=  MODE_REG[3] ;
                end
            end
                 
  
  
  
  // Command Register
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||master_clear)
               COMMAND_REG <= '0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITECOMMANDREG)
                 COMMAND_REG <= IO_DATA_BUF;            
            else 
                COMMAND_REG <=  COMMAND_REG;
            end
                 
  
  
  //Request Register
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||master_clear)
               REQUEST_REG= '0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEREQUESTREG)
                 REQUEST_REG <= IO_DATA_BUF;            
            else 
                REQUEST_REG <=  REQUEST_REG ;
            end
                 
  
  
  // Mask Register
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||master_clear)
                 MASK_REG= '0;          
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == WRITEALLMASKREG)
                begin 
                 MASK_REG[3:0] <= IO_DATA_BUF[3:0];  
                end        
            else 
                MASK_REG <= MASK_REG ;
            end
                    
                         
               
  //Temporary Register
  
  always_ff@(posedge dif.CLK)
            begin
            
            if(dif.RESET||master_clear)
               TEMP_DATA_REG <= 0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READTEMPREG)
                 IO_DATA_BUF <= TEMP_DATA_REG;            
            else 
                TEMP_DATA_REG <=  TEMP_DATA_REG ;
            end
  
  
  //Status Register
  
  always_ff@(posedge dif.CLK)
          begin
  
                   STATUS_REG[0] <= (TC[0])?1'b1:1'b0;
                   STATUS_REG[1] <= (TC[1])?1'b1:1'b0;
                   STATUS_REG[2] <= (TC[2])?1'b1:1'b0;
                   STATUS_REG[3] <= (TC[3])?1'b1:1'b0;  
                   STATUS_REG[4] <= (cif.VALID_DREQ0)?1'b1:1'b0;  
                   STATUS_REG[5] <= (cif.VALID_DREQ1)?1'b1:1'b0; 
                   STATUS_REG[6] <= (cif.VALID_DREQ2)?1'b1:1'b0; 
                   STATUS_REG[7] <= (cif.VALID_DREQ3)?1'b1:1'b0; 
  
            if(dif.RESET||master_clear)
               STATUS_REG <= '0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == READSTATUSREG)
               IO_DATA_BUF <= STATUS_REG;
            else  
               STATUS_REG <= STATUS_REG;
            
                         
          end       
            
  // CLEAR FF
  always_ff@(posedge dif.CLK) begin
  if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == CLEARFF)
      FF <= 1'b0;
   else
      FF <= 1'b1;
  end
  
  //Master Clear
  always_ff@(posedge dif.CLK) begin
   if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == CLEARMASKREG)     
              master_clear <= 1;
     else
              master_clear <= '0;
   end
  
  //Clear Mask Register
  always_ff@(posedge dif.CLK) begin
            if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,IO_ADDR_BUF} == CLEARMASKREG)
                        MASK_REG <= '0;
            else
                        MASK_REG <= MASK_REG;
  
          end  

endmodule : dma_reg_file
