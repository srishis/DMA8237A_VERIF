// DMA Data path module

module dma_datapath(dma_if.DP dif);

import dma_reg_pkg::*;

// DMA enters program mode when CS_N is asserted and HLDA is not asserted
// DMA writes to internal registers when IOW_N is asserted
// DMA reads data from the internal registers when IOR_N is asserted from DB pins

// Data bus logic
  // DB input mode
  // check if DMA is in progam mode using CS and HLDA
  // next check if write is enabled
  always_ff@(posedge dif.CLK) begin
	if(!dif.CS_N && !dif.HLDA) 
		if(!IOW_N) IO_DATA_BUF <= dif.DB; 
  end
  
  // DB output mode
  // check if DMA is in progam mode using CS and HLDA with read enabled
  // or check if DMA is in active mode using CS and HLDA
  assign dif.DB = ((~dif.CS_N && !dif.HLDA && ~dif.IOR_N) || (~dif.CS_N && dif.HLDA)) ? IO_DATA_BUF : 8'bz;
  
// Address Bus logic
  // ADDR_L input mode
  // check if DMA is in progam mode using CSand HLDA
  always_ff@(posedge dif.CLK) begin
	if(!dif.CS_N && !dif.HLDA) 
		IO_ADDR_BUF <= dif.ADDR_L;
  end

  // ADDR_L output mode
  assign dif.ADDR_L = (~dif.CS_N && dif.HLDA) ? IO_ADDR_BUF  : 4'bz;

  // ADDR_U output mode
  assign dif.ADDR_U = (~dif.CS_N && dif.HLDA) ? OUT_ADDR_BUF : 4'bz;

endmodule : dma_datapath
