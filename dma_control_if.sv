//  DMA Timing and Control module interface 

interface dma_control_if(input logic CLK, RESET);    

// FSM control signals
logic eop;		
logic aen;		
logic adstb;		
logic ior;		
logic iow;
logic memr;		
logic memw;	
logic hrq;
logic VALID_DACK;
logic timeout;
logic en_addr_out;
logic VALID_DREQ0;
logic VALID_DREQ1;
logic VALID_DREQ2;
logic VALID_DREQ3;

modport TC(
	    input  CLK,
	    input  RESET,
	    input  VALID_DREQ0,
	    input  VALID_DREQ1,
	    input  VALID_DREQ2,
	    input  VALID_DREQ3,
	    output hrq,
	    output eop,		
	    output aen,		
	    output adstb,		
	    output ior,		
	    output iow,
	    output memr,		
	    output memw,	
	    output timeout,
	    output en_addr_out,
	    output VALID_DACK
);
modport PR(
	    input  CLK,
	    input  RESET,
	    input  hrq,
	    input  VALID_DACK,
	    output VALID_DREQ0,
	    output VALID_DREQ1,
	    output VALID_DREQ2,
	    output VALID_DREQ3
);

endinterface : dma_control_if
