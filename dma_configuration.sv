
`define COMMAND_REG 4'h1000
`define MODE_REG 4'h1011
`define REQUEST_REG 4'h1001
`define MASK_REG 4'h1010
`define MASK_REG 4'h1111
`define TEMPORARY_REG 4'h1101
`define STATUS_REG 4'h1000


class dma_configuration;
  // create all mailboxes required in the environment 
  static mailbox gen2drv;
  static mailbox gen2ref;
  static mailbox mon2cov;
  static mailbox mon2sb;
  static mailbox ref2sb;
  
  // create virtual interface handle to pass to all classes from top
  static virtual dma_if vif;
  
  static int error_count;
  
  // Number of transactions
  static int num_trans;
  
endclass