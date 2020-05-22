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