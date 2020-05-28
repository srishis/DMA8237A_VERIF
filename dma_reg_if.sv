// Interface for DMA Registers 

interface dma_reg_if(input logic CLK, RESET);

import dma_reg_pkg::*;

// Datapath modport
modport DP(
 input  CLK,
 input  RESET
);

 // Control logic modport
modport TC(
 input  CLK,
 input  RESET,
 input  MODE_REG,
 input  CMD_REG,
 input  STATUS_REG
);

// Priority logic modport
modport PR(
 input  CLK,
 input  RESET,
 input  CMD_REG,
 input  REQ_REG,
 input  MASK_REG
);

endinterface : dma_reg_if
