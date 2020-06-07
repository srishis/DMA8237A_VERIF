interface dma_if(input logic CLK, input logic RESET);

	/* interface to 8086 processor */
	logic 	    MEMR_N;   	// memory read
	logic 	    MEMW_N;		// memory write
	wire 	    IOR_N;		// IO read
	wire 	    IOW_N;		// IO write
	logic 	    HLDA;		// Hold acknowledge from CPU to indicate it has relinquished bus control
	logic 	    HRQ;		// Hold request from DMA to CPU for bus control

	/* address and data bus interface */
	logic [3:0] ADDR_U;		// upper address which connects to address A7-A4 of 8086 CPU
	wire  [3:0] ADDR_L;		// lower address which connects to address A3-A0 of 8086 CPU
	wire  [7:0] DB;			// data
	logic       CS_N; 		// Chip select
	logic       AEN;		// address enable

	/* Request and Acknowledge interface */
	logic  [3:0] DREQ;		// asynchronous DMA channel request lines
	logic  [3:0] DACK;		// DMA acknowledge lines to indicate access granted to peripheral who has raised a request

	/* interface signal to 8-bit Latch */
	logic       ADSTB;		// Address strobe

	/* EOP signal */
	wire 	    EOP_N;		// bi-directional signal to end DMA active transfers
	
	// DMA SW Commands in Program mode
	logic READ_ANY_REG_CMD;
	
	logic WRITE_BASE_ADDR_CH0_REG_CMD;
	logic WRITE_BASE_ADDR_CH1_REG_CMD;
	logic WRITE_BASE_ADDR_CH2_REG_CMD;
	logic WRITE_BASE_ADDR_CH3_REG_CMD;
	
	logic WRITE_BASE_WORD_COUNT_CH0_REG_CMD;
	logic WRITE_BASE_WORD_COUNT_CH1_REG_CMD;
	logic WRITE_BASE_WORD_COUNT_CH2_REG_CMD;
	logic WRITE_BASE_WORD_COUNT_CH3_REG_CMD;
	
	logic READ_CURR_ADDR_CH0_REG_CMD;
	logic READ_CURR_ADDR_CH1_REG_CMD;
	logic READ_CURR_ADDR_CH2_REG_CMD;
	logic READ_CURR_ADDR_CH3_REG_CMD;
	
	logic READ_CURR_WORD_COUNT_CH0_REG_CMD;
	logic READ_CURR_WORD_COUNT_CH1_REG_CMD;
	logic READ_CURR_WORD_COUNT_CH2_REG_CMD;
	logic READ_CURR_WORD_COUNT_CH3_REG_CMD;
	
	logic WRITE_COMMAND_REG_CMD;
	logic READ_STATUS_REG_CMD;
	
	logic WRITE_REQUEST_REG_CMD;
	
	logic WRITE_MODE_REG_CMD;
	logic READ_MODE_REG_CMD;
	
	logic CLEAR_BYTE_POINTER_CMD;
	logic SET_BYTE_POINTER_CMD;
	
	logic MASTER_CLEAR_CMD;
	
	logic CLEAR_MASK_REG_CMD;
	logic CLEAR_MODE_REG_COUNT_CMD;
	
	logic WRITE_MASK_REG_CMD;
	logic READ_MASK_REG_CMD;
	
	// modport for top level design
	modport DUT(
			input  CLK,
			input  RESET,
			inout  IOR_N,
			inout  IOW_N,
			inout  DB,
			inout  ADDR_L,

			inout  EOP_N,

			input  DREQ,
			input  HLDA,
			input  CS_N,

			output ADDR_U,
			output DACK,
			output HRQ,
			output AEN,
			output ADSTB
	       	);

	// modport for Datapath logic
	modport DP(
			input  CLK,
			input  RESET,
			input  IOR_N,
			input  IOW_N,
			input  HLDA,		
			input  CS_N,
			inout  DB,
			inout  ADDR_L,
			output ADDR_U		
	);
	
	// modport for Priority logic
	modport PR(
			input  CLK,
			input  RESET,
			output DACK,
			output HRQ,	
			input  DREQ,
			input  HLDA		
	);
	
	// modport for Timing Control logic
	modport TC(
			input   CLK,
			input   RESET,
			input   HLDA,
		   	output  IOR_N,
			output  IOW_N,
			output 	MEMR_N,	
			output 	MEMW_N,		
			input   CS_N,
			inout   EOP_N,
			output  AEN,
			output  ADSTB
	);
	
	/* Modport for Test Bench */
	modport TB(clocking dma_cb);
	
	// Modport for driver
	modport DRIVER(clocking dma_cb, RESET);
	
	// Modport for monitor
	modport MON(
			input  CLK,
			input  RESET,
			input  IOR_N,
			input  IOW_N,
			input  DB,
			input  ADDR_L,

			input  EOP_N,

			input  DREQ,
			input  HLDA,
			input  CS_N,

			input ADDR_U,
			input DACK,
			input HRQ,
			input AEN,
			input ADSTB
	);
	
	/* Clocking Block to drive stimulus at cycle level */
	clocking dma_cb @(posedge CLK);
			
			default input #0 output #1;
			
			inout  	IOR_N;
			inout  	IOW_N;
			inout   DB;
			inout  	ADDR_L;
			inout  	EOP_N;
			output  DREQ;
			output  HLDA;
			output	CS_N;
			input 	ADDR_U;
			input 	MEMR_N;
			input 	MEMW_N;
			input 	DACK;
			input 	HRQ;
			input 	AEN;
			input 	ADSTB;
			
	endclocking : dma_cb

	// Reset method
	task apply_reset;
		repeat(5)@(posedge CLK);
		RESET = 1;
		repeat(10)@(posedge CLK);	
		RESET = 0;
	endtask : apply_reset
	
endinterface : dma_if

