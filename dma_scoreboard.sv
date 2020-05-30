class dma_scoreboard;
  
  //used to count the number of transactions
  int num_trans;
  
  dma_transaction  tx, tx1;
  
  task run();
    
    forever begin
      dma_cfg::mon2sb.get(tx);
      dma_cfg::ref2sb.get(tx1);

      if ((tx.d == 0) && (tx1.d == 0))
        if (!tx1.compare(tx)) begin
	  $display("ERROR: Scoreboard: Mismatch when d is equal to 0, expected=%0p, actual=%0p", tx1, tx);
	  dma_cfg::error_count++;
	end
      else if ((tx.d == 1) && (tx1.d == 1))
	if (!tx1.compare(tx)) begin
	  $display("ERROR: Scoreboard: Mismatch when d is equal to 1, expected=%0p, actual=%0p", tx1, tx);
	  dma_cfg::error_count++;
	end
      num_trans++;
    end
 
  endtask : run
  
endclass : dma_scoreboard
