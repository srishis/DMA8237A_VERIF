// DMA Top module

module dma_top(dma_if.DUT dif);

// DMA interface instantiation
dma_control_if cif(dif.CLK, dif.RESET);
dma_reg_if rif(dif.CLK, dif.RESET);

// DMA internal module instantiation
// Datapath module
dma_datapath DMA_DATAPATH(dif, cif, rif);
		
// Timing and Control module
dma_control DMA_CONTROL(dif, cif, rif);

// Priority logic
dma_priority DMA_PRIORITY(dif, cif, rif);

endmodule : dma_top
