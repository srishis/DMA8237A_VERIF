 // DMA Register package

package dma_reg_pkg;

dma_transaction tx;

// TODO: Register Address Map
`define CMD_REG_ADDR 		4'h1000
`define MODE_REG_ADDR 		4'h1011
`define REQUEST_REG_ADDR 	4'h1001
`define MASK_REG_ADDR 		4'h1010
// TODO: `define MASK_REG_ADDR 		4'h1111
`define TEMP_DATA_REG  		4'h1101
`define STATUS_REG_ADDR 	4'h1000

// 4 x Mode Register
typedef struct packed{
	logic [1:0] mode_sel;		// MODE_REG[7:6]
	logic addr_inc_dec;			// MODE_REG[5]
	logic auto_init_en;			// MODE_REG[4]
	logic [1:0] trans_type; 	// MODE_REG[3:2]
	logic [1:0] ch_sel; 		// MODE_REG[1:0]
} mode_reg_t;

mode_reg_t MODE_REG[4];

// Command Register
typedef struct packed{
	logic dack_sense;		// CMD_REG[7]
	logic dreq_sense;		// CMD_REG[6]
	logic late_ext_wr_sel;	// CMD_REG[5]
	logic priority_type; 	// CMD_REG[4]
	logic timing_type;		// CMD_REG[3]
	logic dma_en;			// CMD_REG[2]
	logic ch0_addr_hold;	// CMD_REG[1]
	logic mem2mem_en;		// CMD_REG[0]
} cmd_reg_t;

cmd_reg_t CMD_REG;

// Request Register
typedef struct packed{
	logic [4:0] dont_care;		// REQ_REG[7:3]
	logic request_bit;			// REQ_REG[2]
	logic [1:0] ch_sel; 		// REQ_REG[1:0]
} req_reg_t;

req_reg_t REQ_REG;

// Mask Register
typedef struct packed{
	logic [3:0] dont_care;		// MASK_REG[7:4]
	logic [3:0] ch_mask_bit;	// MASK_REG[3:0]
} mask_reg_t;

mask_reg_t MASK_REG;

// Status Register
typedef struct packed{
	logic [3:0] ch_request;		// STATUS_REG[7:4]
	logic [3:0] ch_timeout;		// STATUS_REG[3:0]
} status_reg_t;

status_reg_t STATUS_REG;

// Temporary Register
logic [7:0] TEMP_DATA_REG;

// 4 x Current Address Register
logic [15:0] CURR_ADDR_REG[4];

// 4 x Current Word Count Register
logic [15:0] CURR_WORD_COUNT_REG[4];

// 4 x Base Address Register
logic [15:0] BASE_ADDR_REG[4];

// 4 x Base Word Count Register
logic [15:0] BASE_WORD_COUNT_REG[4];

// Temporary Address Register
logic [15:0] TEMP_ADDR_REG;

// Temporary Address Register
logic [15:0] TEMP_WORD_COUNT_REG;

task regs_init();	
	CMD_REG					= '0;
	REQ_REG					= '0;
	MASK_REG				= '0;
	STATUS_REG				= '0;
	TEMP_DATA_REG			= '0;
	foreach(MODE_REG[i])				MODE_REG[i] 			= '0;
	foreach(TEMP_ADDR_REG[i])			TEMP_ADDR_REG[i]		= '0;
	foreach(TEMP_WORD_COUNT_REG[i]) 	TEMP_WORD_COUNT_REG[i]  = '0;
	foreach(BASE_ADDR_REG[i])			BASE_ADDR_REG[i]		= '0;
	foreach(BASE_WORD_COUNT_REG[i]) 	BASE_WORD_COUNT_REG		= '0;
	foreach(CURR_ADDR_REG[i])			CURR_ADDR_REG 			= '0;
	foreach(CURR_WORD_COUNT_REG[i])		CURR_WORD_COUNT_REG		= '0;
endtask : regs_init

// TODO : confirm prototype
// Read Register
task regs_read(bit[3:0] address, bit [15:0] data);
	tx = new();
	tx.pkt_type = REG_READ;
	tx.cs = 1'b0;
	tx.ior = 1'b0;
	tx.iow = 1'b1;
	tx.addr_lo = address;
	tx.dreq = 4'b0;
	tx.hlda = 1'b0;
	tx.eop = 1'b1;
	dma_cfg::gen2drv.put(tx);
	//wait for a clock in driver for data
	dma_cfg::drv2gen.get(rx);
	data = rx.data;
endtask : regs_read

// TODO : confirm prototype
// Write Register 
task regs_write(bit[3:0] address, bit [15:0] data);
	tx = new();
	tx.cs = 1'b0; 
	tx.ior = 1'b1;
	tx.iow = 1'b0;
	tx.addr_lo = address;
	tx.data = data;
	tx.dreq = 4'b0;
	tx.hlda = 1'b0; 
	tx.eop = 1'b1;
	tx.pkt_type = REG_WRITE;
	dma_cfg::gen2drv.put(tx);
endtask : regs_write

endpackage : dma_reg_pkg
