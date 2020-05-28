`include "dma_files.svh"
module dma_tb_top;

	timeunit 1ns;
	timeprecision 1ns; 
	parameter CLK_PERIOD 	 = 200;
	parameter GLOBAL_TIMEOUT = 10000000;
	parameter CYCLES		 = 10;
	
	// top level clock and reset signals
	bit CLK, RESET;

	//generate top level clock to be passed to the design and test bench
	initial forever #(CLK_PERIOD/2) CLK = ~CLK;

	// Apply and release RESET
	initial apply_reset();
	
	// DMA main physical interface instantiation
	dma_if pif(CLK, RESET);

	// DMA design instantiation
	dma_top DUT (pif);

	// dma Testbench instantiation
	dma_test TB ();
	
	// dma assertion binding to dma design and instantiation
	// bind dma dma_assertions DA (pif);
	
	// hook up design and Testbench using physical interface handle pif to virtual interface handle
	initial begin
		dma_config::vif = pif;
	end
	
	 // Test case ending using finish
	 initial begin
  	 	#GLOBAL_TIMEOUT;
  	 	$finish;
 	end

endmodule