
module top;
	
timeunit 1ns;
timeprecision 1ns;
	
bit CLK, RESET;
	
dma_if dif(CLK, RESET);
	
Dma8237aTop DMT (dif);

// 5 Mhz clock ie 200 ns time period
initial begin
forever #100  CLK = ~CLK; 
end

// Apply and life reset
initial begin
	repeat(10)@(negedge CLK); RESET = 1;
	repeat(100)@(negedge CLK); RESET = 0;
end

endmodule




