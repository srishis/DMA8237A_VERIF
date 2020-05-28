class dma_scoreboard;
  
  //used to count the number of transactions
  int num_trans;
  
  dma_transaction  tx, tx1;
  
  task run();
    
    forever begin
      dma_cfg::mon2sb.get(tx);
      dma_cfg::ref2sb.get(tx1);
      
      num_trans++;
    end
 
  endtask : run
  
endclass : dma_scoreboard
