class dma_scoreboard;
  
  //used to count the number of transactions
  int num_trans;
  
  dma_transaction  tx, tx1;
  
  task run();
    
    forever begin
      //dma_cfg::mon2sb.get(tx);
      //dma_cfg::ref2sb.get(tx1);
      dma_cfg::gen2sb(tx); // for now just pass the data directly from sb to checker
      dma_cfg::sb2ck(tx);

      //if (!tx1.compare(tx)) begin
	  //$display("ERROR: Scoreboard: Mismatch expected=%0p, actual=%0p", tx1, tx);
	  //dma_cfg::error_count++;
      //end
      num_trans++;
    end
 
  endtask : run
  
endclass : dma_scoreboard
