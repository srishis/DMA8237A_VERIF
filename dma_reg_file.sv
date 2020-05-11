module dma_reg_file(dma_reg_if rif);


   always_ff@(posedge dif.CLK) begin
            
            if(dif.RESET||masterClear)
               rif.commandReg <= '0;
            else if({cif.Program,dif.CS_N,dif.IOR_N,dif.IOW_N,ioAddrBuf} == WRITECOMMANDREG)
                 rif.commandReg <= ioDataBuf;            
            else 
                rif.commandReg <=  rif.commandReg;
            end

endmodule
