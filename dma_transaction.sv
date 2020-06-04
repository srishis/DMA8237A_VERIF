// DMA Transaction class
//TODO: update properties in all methods

// transaction types
typedef enum {REQ_TX, BASE_REG_READ_CFG, BASE_REG_CFG, REG_WRITE_CFG, REG_READ_CFG, DMA_WRITE, DMA_READ} tx_type_t;
// DMA cycles
typedef enum {IDLE, ACTIVE} dma_cycles_t;


class dma_transaction;

import dma_reg_pkg::*;

  tx_type_t 	tx_type; 
  dma_cycles_t	cycle; 
  // Properties
  // declare all inputs and controls signals as rand to generate random values from them
  rand bit [3:0] dreq;
  rand bit [7:0] data_in;
  rand bit ior_in;
  rand bit iow_in;
  rand bit hlda;
  rand bit cs;
  rand bit [3:0] addr_lo_in;
 // outputs will be generated by the DUT hence no rand
  bit [7:0] data_out;
  bit [15:0] valid_addr;
  bit ior_out;
  bit memr_out;
  bit memw_out;
  bit iow_out;
  bit eop;
  bit [3:0] addr_up_out;
  bit hrq;
  bit aen;
  bit adstb;
  bit [3:0] dreq_old;
  bit [3:0] dack;
  bit [3:0] dack_sampled;
  bit sample_dack;
  bit ctrl_regs_wr_done;
  bit late_write_en;
  bit is_addr_valid;
  
  
  // Methods
  // deep copy method
  function void copy(output dma_transaction tx);
    tx = new;
    tx.dreq = this.dreq;
    tx.dreq_old = this.dreq_old;
    tx.data_in = this.data_in;
    tx.ior_in = this.ior_in;
    tx.iow_in = this.iow_in;
    tx.memr_in = this.memr_in;
    tx.memw_in = this.memw_in;
    tx.data_out = this.data_out;
    tx.ior_out = this.ior_out;
    tx.iow_out = this.iow_out;
    tx.memr_out = this.memr_out;
    tx.memw_out = this.memw_out;
    tx.eop = this.eop
    tx.hlda = this.hlda;
    tx.cs = this.cs;
    tx.addr_up_out = this.addr_up_out;
    tx.dack_sampled = this.dack_sampled;
    tx.hrq = this.hrq;
    tx.aen = this.aen;
    tx.adstb = this.adstb;
    tx.late_write_en = this.late_write_en;
    tx.ctrl_regs_wr_done = this.ctrl_regs_wr_done;
  endfunction
  
//TODO: updated properties in all methods
  function void compare(input dma_transaction tx);
    if(
      tx.ior != this.ior ||
      tx.iow != this.iow ||
      tx.data != this.data ||
      tx.addr_lo != this.addr_lo ||
      tx.eop != this.eop ||
      tx.dreq != this.dreq ||
      tx.hlda != this.hlda ||
      tx.cs != this.cs ||
      tx.addr_hi != this.addr_hi ||
      tx.dack != this.dack ||
      tx.hrq != this.hrq ||
      tx.aen != this.aen ||
      tx.adstb != this.adstb)
        return 0;         // compare failed
    else
        return 1;         // compare passed
  endfunction
  
  function void print();
      	$display("-----PRINTING TRANSACTION CLASS PROPERTIES---------");
      	$display("\t IOR = %0h", tx.ior);
      	$display("\t IOW = %0h", tx.iow);
	$display("\t DATA = %0h", tx.data);
	$display("\t ADDR_L = %0h", tx.addr_lo);
	$display("\t ADDR_H = %0h", tx.addr_hi);
	$display("\t EOP = %0h", tx.eop);
	$display("\t DREQ = %0h", tx.dreq);
	$display("\t DACK = %0h", tx.dack);
	$display("\t HLDA = %0h", tx.hlda);
	$display("\t HRQ = %0h", tx.hrq);
	$display("\t CS = %0h", tx.cs);
	$display("\t AEN = %0h", tx.aen);
	$display("\t ADSTB = %0h", tx.adstb);
	$display("---------------------------------------------------");
  endfunction

// Initialize the registers	
task regs_init();	
	CMD_REG					= '0;
	REQ_REG					= '0;
	MASK_REG				= '0;
	STATUS_REG				= '0;
	TEMP_DATA_REG			= '0;
	foreach(MODE_REG[i])				MODE_REG[i] 			= '0;
	foreach(BASE_ADDR_REG[i])			BASE_ADDR_REG[i]		= '0;
	foreach(BASE_WORD_COUNT_REG[i]) 	BASE_WORD_COUNT_REG		= '0;
	foreach(CURR_ADDR_REG[i])			CURR_ADDR_REG 			= '0;
	foreach(CURR_WORD_COUNT_REG[i])		CURR_WORD_COUNT_REG		= '0;
endtask : regs_init

// Constraints
	constraint dreq_c{
		//dreq inside {[0:15]};
		dreq != dreq_old;
	}
	
	function void post_randomize();
		dreq_old = dreq;
	endfunction
	
// TODO: use rand variables for register fields
// TODO : Add constraints for other control signals
// Register Constraints
/*
constraint mode_reg_c {
	foreach(MODE_REG[i])  MODE_REG.mode_sel == 1;			// Only single  transfer mode supported
	foreach(MODE_REG[i])  MODE_REG.trans_type inside {1,2}; // Only read/write transfers supported
}

constraint cmd_reg_c {
	CMD_REG.mem2mem_en == 0;		// memory to memory transfers not supported
	CMD_REG.ch0_addr_hold == 0;		// Channel 0 address hold disabled
	CMD_REG.timing_type == 0; 		// Only normal timing_type supported
	CMD_REG.priority_type == 1; 	// Rotating priority_type supported
	CMD_REG.dreq_sense == 1;
	CMD_REG.dack_sense == 0;
}

constraint request_reg_c {
	REQ_REG.reserved == 0;
}

constraint mask_reg_c {
	MASK_REG.reserved == 0;
}
*/
endclass : dma_transaction
