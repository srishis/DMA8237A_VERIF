// DMA Data path module

module dma_datapath(dma_if.DP dif);

import dma_reg_pkg::*;

// Data bus logic
  // input mode
  always_ff@(posedge dif.CLK) if(!dif.CS_N && !dif.IOW_N) ioDataBuf <= dif.DB;
  // output mode
  assign dif.DB = (~dif.CS_N && ~dif.IOR_N) ? ioDataBuf : 8'bz;
  
// Address Bus logic
  // input mode
  always_ff@(posedge dif.CLK) if(!dif.CS_N && ~dif.HLDA) ioAddrBuf <= dif.ADDR_L;
  // output mode
  assign dif.ADDR_L = (~dif.CS_N && dif.HLDA) ? ioAddrBuf : 4'bz;
  assign dif.ADDR_U = (~dif.CS_N && dif.HLDA) ? outAddrBuf : 4'bz;

endmodule : dma_datapath
