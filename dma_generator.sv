class dma_generator;

	dma_transaction tx,rx;
	dma_transaction txQ[$];
	
	bit[ADDRESS_LENGTH-1:0] Status;
	
	int reg_test,reg_pass,reg_fail;
	
	task run();
	$display("DMA_GENERATOR:: Entered in GENERATOR run method!");
	unique case(dma_config::testcase)
	"Regression":begin 					basic_read_write_sanity_test;
										dma_io_to_mem_read_transfer;
										dma_io_to_mem_write_transfer;
										dma_io_to_mem_write_read_transfer;
										dma_fixed_priority_test;
										dma_fixed_priority_ch0_test;
										dma_fixed_priority_ch1_test;
										dma_fixed_priority_ch2_test;
										dma_fixed_priority_ch3_test;
										dma_rotational_priority_test;
										dma_eop_directed_test;
										dma_polarity_test;
										dma_status_register_test;
				end
	"basic_read_write_sanity_test": 	 basic_read_write_sanity_test;
	"dma_io_to_mem_read_transfer": 		 dma_io_to_mem_read_transfer;
	"dma_io_to_mem_write_transfer":		 dma_io_to_mem_write_transfer;
	"dma_io_to_mem_write_read_transfer": dma_io_to_mem_write_read_transfer;
	"dma_fixed_priority_test":			 dma_fixed_priority_test;
	"dma_fixed_priority_ch0_test":		 dma_fixed_priority_ch0_test;
	"dma_fixed_priority_ch1_test":		 dma_fixed_priority_ch1_test;
	"dma_fixed_priority_ch2_test":		 dma_fixed_priority_ch2_test;
	"dma_fixed_priority_ch3_test":		 dma_fixed_priority_ch3_test;
	"dma_rotational_priority_test":		 dma_rotational_priority_test;
	"dma_eop_directed_test":			 dma_eop_directed_test;
	"dma_polarity_control_directed_test":dma_polarity_test;
	"dma_status_register_test":			 dma_status_register_test;
	endcase
	
	endtask
// test cases for design

	// simple basic_read_write_sanity_test for DMA with 
		
		task basic_read_write_sanity_test;
		//READING REGISTERS
		for(int i = 0; i< ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs == 1'b0; 
								 tx.ior_in == 1'b0;
								 tx.iow_in == 1'b1;
								 tx.addr_lo_in == i;
								 tx.hlda == 1'b0;
								 tx.dreq == 4'h0;
								 }) 
								 $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST:PRE WRITE READ");
		// mailbox for inter communication between classes
		if(i == BASE_ADDR_REG_CH0_ADDR || i == BASE_ADDR_REG_CH1_ADDR || i == BASE_ADDR_REG_CH2_ADDR || i == BASE_ADDR_REG_CH3_ADDR 
		|| i == BASE_WORD_COUNT_REG_CH0_ADDR || i == BASE_WORD_COUNT_REG_CH1_ADDR || i == BASE_WORD_COUNT_REG_CH2_ADDR || i == BASE_WORD_COUNT_REG_CH3_ADDR)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
		tx.tx_type = BASE_REG_READ_CFG;
		else
		tx.tx_type = REG_READ_CFG;
		
		// mailbox for inter communication between classes
		dma_config::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method
	
		end
		
		//WRITTING REGISTERS
		for(int i = 0; i< ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs == 1'b0;
								 tx.ior_in == 1'b1;
								 tx.iow_in == 1'b0;
								 tx.addr_lo_in == i;
								 tx.data_in == 16'haaaa; //WRITTING CHECKER BOARD PATTERN IN ALL THE REGISTERS
								 tx.hlda == 1'b0;
								 tx.dreq == 4'h0;
								 }) 
								 $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST: WRITE ");
		
		if(i == BASE_ADDR_REG_CH0_ADDR || i == BASE_ADDR_REG_CH1_ADDR || i == BASE_ADDR_REG_CH2_ADDR || i == BASE_ADDR_REG_CH3_ADDR 
		|| i == BASE_WORD_COUNT_REG_CH0_ADDR || i == BASE_WORD_COUNT_REG_CH1_ADDR || i == BASE_WORD_COUNT_REG_CH2_ADDR || i == BASE_WORD_COUNT_REG_CH3_ADDR)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
		//TODO:Gen2Chk if needed
		tx.tx_type = BASE_REG_CFG;
		else
		tx.tx_type = REG_WRITE_CFG;
		
		if(i == 15) tx.ctrl_regs_wr_done = 1;
		else tx.ctrl_regs_wr_done = 0;
		
		// mailbox for inter communication between classes
		dma_config::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method

		end	
		
		//READING REGISTERS
		for(int i = 0; i< ADDRESS_LENGTH; i++)begin
		tx = new();
		if(!tx.randomize() with {tx.cs == 1'b0;
								 tx.ior_in == 1'b0;
								 tx.iow_in == 1'b1;
								 tx.addr_lo_in == i;
								 tx.hlda == 1'b0;
								 tx.dreq == 4'h0;
								 })
								 $display("ERROR:DMA GENERATOR::RANDOMIZATION FAILED FOR BASIC READ WRITE SANITY TEST:POST WRITE READ");
		
		if(i == BASE_ADDR_REG_CH0_ADDR || i == BASE_ADDR_REG_CH1_ADDR || i == BASE_ADDR_REG_CH2_ADDR || i == BASE_ADDR_REG_CH3_ADDR 
		|| i == BASE_WORD_COUNT_REG_CH0_ADDR || i == BASE_WORD_COUNT_REG_CH1_ADDR || i == BASE_WORD_COUNT_REG_CH2_ADDR || i == BASE_WORD_COUNT_REG_CH3_ADDR)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
		tx.tx_type = BASE_REG_READ_CFG;
		else
		tx.tx_type = REG_READ_CFG;
		// mailbox for inter communication between classes
		dma_config::gen2drv.put(tx);// send transaction to Driver to drive it to the DUT using mailbox put() method
		
		end
		endtask : basic_read_write_sanity_test
		
	//directed dma_io_to_mem_read_transfer test 
		task dma_io_to_mem_read_transfer; //channel 0
			tx = new();
			tx.tx_type = REQ_TX;
			tx.dreq = 4'h1;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(0, 16'h00ab, 1); //channel =0, transfer address = 16'h00ab, polarity = active high
			//Write control registers
			cfg_control_registers(0,0,1,0); //channel = 0, priority = fixed, dack,dreq = active high, mem read
			
		endtask : dma_io_to_mem_read_transfer
	
	//directed dma_io_to_mem_write_transfer test 
		task dma_io_to_mem_write_transfer; //channel 1
			tx = new();
			tx.tx_type = REQ_TX;
			tx.dreq = 4'h2;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(1, 16'h00ac, 1); //channel =1, transfer address = 16'h00ac, polarity = active high
			//Write control registers	
			cfg_control_registers(1,0,1,1); //channel = 1, priority = fixed, dack,dreq = active high, mem write
			
		endtask : dma_io_to_mem_write_transfer
	
	//dma_io_to_mem_write_read_transfer
		task dma_io_to_mem_write_read_transfer; //channel 1
			tx = new();
			tx.tx_type = REQ_TX;
			tx.dreq = 4'h2;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(1, 16'h00ac, 1); //channel =1, transfer address = 16'h00ac, polarity = active high
			//Write control registers	
			cfg_control_registers(1,0,1,1); //channel = 1, priority = fixed, dack,dreq = active high, mem write
			
			tx = new();
			tx.tx_type = REQ_TX;
			tx.dreq = 4'h1;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(0, 16'h00ac, 1); //channel =0, transfer address = 16'h00ab, polarity = active high
			//Write control registers
			cfg_control_registers(0,0,1,0); //channel = 0, priority = fixed, dack,dreq = active high, mem read
			
		endtask : dma_io_to_mem_write_read_transfer
		
	//dma_eop_directed_test
		task dma_eop_directed_test; //channel 2
			tx = new();
			tx.tx_type = REQ_TX;
			tx.dreq = 4'h4;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(2, 16'h00ac, 1); //channel =2, transfer address = 16'h00ac, polarity = active high
			//Write control registers
			cfg_control_registers(2,0,1,0); //channel = 2, priority = fixed, dack,dreq = active high, mem read
			
		endtask : dma_eop_directed_test
		
	//status register test	
		task dma_status_register_test; //channel 2
			tx = new();
			tx.tx_type = REQ_TX;
			tx.dreq = 4'h4;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(2, 16'h00ac, 1); //channel =2, transfer address = 16'h00ac, polarity = active high
			//Write control registers
			cfg_control_registers(2,0,1,1); //channel = 2, priority = fixed, dack,dreq = active high, mem write
			
			reg_read(STATUS_REG_ADDR,Status);
			$display("Status Resgister Output = %b",Status);
		endtask	: dma_status_register_test
	
	
	//dma_polarity_control_directed_test
	task dma_polarity_test; //channel 3
			tx = new();
			tx.dreq = 4'h7; //dreq = 0111 means priority channel should be serviced is 3 and dack should be on dack3
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(3, 16'h00ad, 0); //channel =3, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(3,0,0,1);//channel = 0, priority = fixed, dack,dreq = active low, mem write
			
			
			tx = new();
			tx.dreq = 4'h8; //dreq = 1000 means priority channel should be serviced is 3 and dack should be on dack3
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(3, 16'h00ad, 1); //channel =3, transfer address = 16'h00ad, polarity = active high
			//Write control registers
			cfg_control_registers(3,0,1,1);//channel = 0, priority = fixed, dack,dreq = active high, mem write
	
	endtask : dma_polarity_test
	
	
	//dma_request_priority_test
	task dma_fixed_priority_test;
			tx = new();
			tx.dreq = 4'h0; //dreq = 0000 means  priority channel should be serviced is 0 and dack should be on dack0
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(0, 16'h00ad, 0); //channel =0, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(0,0,0,1); //channel = 0, priority = fixed, dack,dreq = active low, mem write
			
			tx = new();
			tx.dreq = 4'hf; //dreq = 1111 means  priority channel should be serviced is 0 and dack should be on dack0
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(0, 16'h00ad, 1); //channel =0, transfer address = 16'h00ad, polarity = active high
			//Write control registers
			cfg_control_registers(0,0,1,0); //channel = 0, priority = fixed, dack,dreq = active high, mem read
				
	endtask : dma_fixed_priority_test
	
	
	task dma_fixed_priority_ch0_test;
			tx = new();
			tx.dreq = 4'he; //dreq = 1110 means  priority channel should be serviced is 0 and dack should be on dack0
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(0, 16'h00ad, 0); //channel =0, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(0,0,0,1); //channel = 0, priority = fixed, dack,dreq = active low, mem write
			
	endtask : dma_fixed_priority_ch0_test
	
	
	task dma_fixed_priority_ch1_test;
			tx = new();
			tx.dreq = 4'he; //dreq = 1110 means  priority channel should be serviced is 1 and dack should be on dack1
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(1, 16'h00ad, 0); //channel =1, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(1,0,0,1); //channel = 0, priority = fixed, dack,dreq = active low, mem write
			
	endtask : dma_fixed_priority_ch1_test
	
	
	task dma_fixed_priority_ch2_test;
			tx = new();
			tx.dreq = 4'hd; //dreq = 1101 means  priority channel should be serviced is 2 and dack should be on dack2
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(2, 16'h00ad, 0); //channel =2, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(2,0,0,0); //channel = 0, priority = fixed, dack,dreq = active low, mem read
			
	endtask : dma_fixed_priority_ch2_test
	
	
	task dma_fixed_priority_ch3_test;
			tx = new();
			tx.dreq = 4'h7; //dreq = 0111 means  priority channel should be serviced is 0 and dack should be on dack0
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(3, 16'h00ad, 0); //channel =3, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(3,0,0,0); //channel = 0, priority = fixed, dack,dreq = active low, mem read
			
	endtask : dma_fixed_priority_ch3_test
	
	
	task dma_rotational_priority_test;
			tx = new();
			tx.dreq = 4'hb; //dreq = 1011 means channel 2 should be services dack should be on dack2
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(2, 16'h00ad, 0); //channel =2, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(2,1,0,1); //channel = 2, priority = rotating, dack,dreq = active low, mem write
		
			tx = new();
			tx.dreq = 4'h9;//dreq = 1001 means channel 1 should be services and dack should be on dack1
			tx.tx_type = REQ_TX;			
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(1, 16'h00ad, 0); //channel =1, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(1,1,0,1); //channel = 1, priority = rotating, dack,dreq = active low, mem write
			
			tx = new();
			tx.dreq = 4'h1; //dreq = 0001 means channel 3 should be services and dack should be on dack3
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(3, 16'h00ad, 0); //channel =3, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(3,1,0,0); //channel = 1, priority = rotating, dack,dreq = active low, mem read
			
			tx = new();
			tx.dreq = 4'h0; //dreq = 0000 means channel 0 should be services and dack should be on dack0
			tx.tx_type = REQ_TX;
			dma_config::gen2drv.put(tx);
			
			//Write base address and count registers
			cfg_base_registers(0, 16'h00ad, 0); //channel =0, transfer address = 16'h00ad, polarity = active low
			//Write control registers
			cfg_control_registers(0,1,0,0); //channel = 1, priority = rotating, dack,dreq = active low, mem read
			
	endtask : dma_rotational_priority_test
	
	
	//Tasks
	
	task cfg_base_registers(int channel, bit [15:0] data, bit polarity);
	//TOD:Valid Address Dack to chk
	tx = new();
	tx.valid_addr = data;
	if(channel == 0) 	  	begin reg_write(BASE_ADDR_REG_CH0_ADDR,data,0);  		
								//base count reg
								reg_write(BASE_WORD_COUNT_REG_CH0_ADDR,16'h0001,0); 
								if(polarity)
								tx.dack = 4'b0001;
								else
								tx.dack = 4'b1110;			
						    end
	else if(channel == 1) 	begin reg_write(BASE_ADDR_REG_CH1_ADDR,data,0);
								//base count reg
								reg_write(BASE_WORD_COUNT_REG_CH1_ADDR,16'h0001,0); 
								if(polarity)
								tx.dack = 4'b0010;
								else
								tx.dack = 4'b1101;	
							end
	else if(channel == 2) 	begin reg_write(BASE_ADDR_REG_CH2_ADDR,data,0);
								//base count reg   
								reg_write(BASE_WORD_COUNT_REG_CH2_ADDR,16'h0001,0); 
								if(polarity)
								tx.dack = 4'b0100;
								else
								tx.dack = 4'b1011;	
							end
	else if(channel == 3) 	begin //base address reg
								reg_write(BASE_ADDR_REG_CH3_ADDR,data,0);
								//base count reg
								reg_write(BASE_WORD_COUNT_REG_CH3_ADDR,16'h0001,0);
								if(polarity)
								tx.dack = 4'b1000;
								else
								tx.dack = 4'b0111;									
							end
	//gen to chk 						
	dma_config::gen2chk.put(tx);							
	endtask :  cfg_base_registers
	
	
	//Write Configure Control Registers
	task cfg_control_registers(int channel,bit rf_priority,bit polarity, bit mem_read_write);//rf_priority = 1 rotating rf_priority = 0 fixed 
	if(rf_priority)//rotating
		if(polarity)
			reg_write(COMMAND_REG_ADDR,16'h00b0 );
		else
			//command register (ack=low, dreq=low, write=0, priority=rotating, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(COMMAND_REG_ADDR,16'h0050,0);
	else //fixed
		if(polarity)
			reg_write(COMMAND_REG_ADDR,16'h0090,0);
		else		
			//command register (ack=low, dreq=low, write=0, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(COMMAND_REG_ADDR,16'h0040,0);	
			
		
	if(channel == 0) begin
			if(mem_read_write)//write
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = write, channel = 0)
			reg_write(MODE_REG_ADDR,16'h0054,0);
			else //read
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 0)
			reg_write(MODE_REG_ADDR,16'h0058,0);
			//request res(set/reset(1/0) =set,channel= 0)
			reg_write(REQUEST_REG_ADDR,16'h0004,0);
			//mask register
			reg_write(MASK_REG_ADDR,16'h0001,0);	
	end
	else if(channel == 1)begin
			if(mem_read_write)//write
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = write, channel = 1)
			reg_write(MODE_REG_ADDR,16'h0055,0);
			else //read
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 1)
			reg_write(MODE_REG_ADDR,16'h0059,0);
			//request res(set/reset(1/0) =set,channel= 1)
			reg_write(REQUEST_REG_ADDR,16'h0005,0);
			//mask register 
			reg_write(MASK_REG_ADDR,16'h0002,0);	
	end
	else if(channel == 2)begin
			if(mem_read_write)//write
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = write, channel = 2)
			reg_write(MODE_REG_ADDR,16'h0056,0);
			else //read
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 2)
			reg_write(MODE_REG_ADDR,16'h005a,0);
			//request res(set/reset(1/0) =set,channel= 2)
			reg_write(REQUEST_REG_ADDR,16'h0006,0);
			//mask register 
			reg_write(MASK_REG_ADDR,16'h0004,0);	
		
	end
	else if(channel == 3)begin
			if(mem_read_write)//write
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = write, channel = 3)
			reg_write(MODE_REG_ADDR,16'h0057,0);
			else //read
			//mode register (mode=single mode, addr = incr, auto_in = en, transfer type = read, channel = 3)
			reg_write(MODE_REG_ADDR,16'h005b,0);
			//request res(set/reset(1/0) =set,channel= 3)
			reg_write(REQUEST_REG_ADDR,16'h0007,0);
			//mask register 
			reg_write(MASK_REG_ADDR,16'h0008,0);	
	end
	
	if(rf_priority)//rotating
		if(polarity)
			reg_write(COMMAND_REG_ADDR,16'hb0,1);
		else
			//command register (ack=low, dreq=low, write=0, priority=rotating, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(COMMAND_REG_ADDR,16'h0050,1);
	else //fixed
		if(polarity)
			reg_write(COMMAND_REG_ADDR,16'h0090,1);
		else		
			//command register (ack=low, dreq=low, write=0, priority=fixed, timing=normal, c_enable=0, channel 0 hold=0, mem to mem=disable)
			reg_write(COMMAND_REG_ADDR,16'h0040,1);	
	
	endtask :cfg_control_registers
	
	// REGISTER READ TASK
	task reg_read(bit[3:0] address,output bit[15:0] data);
		tx = new();
		if(address == BASE_ADDR_REG_CH0_ADDR || address == BASE_ADDR_REG_CH1_ADDR || address == BASE_ADDR_REG_CH2_ADDR || address == BASE_ADDR_REG_CH3_ADDR 
		|| address == BASE_WORD_COUNT_REG_CH0_ADDR || address == BASE_WORD_COUNT_REG_CH1_ADDR || address == BASE_WORD_COUNT_REG_CH2_ADDR || address == BASE_WORD_COUNT_REG_CH3_ADDR)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
		tx.tx_type = BASE_REG_READ_CFG;
		else
		tx.tx_type = REG_READ_CFG;
		tx.cs = 1'b0;
		tx.ior_in = 1'b0;
		tx.iow_in = 1'b1;
		tx.addr_lo_in = address;
		tx.dreq = 4'b0;
		tx.hlda = 1'b0;
		tx.eop = 1'b1;
		dma_config::gen2drv.put(tx);
		
	endtask : reg_read

	//REGISTER WRITE TASK
	task reg_write(bit[3:0] address, bit[15:0] data, bit last = 0);
		tx = new();
		
		if(address == (BASE_ADDR_REG_CH0_ADDR || BASE_ADDR_REG_CH1_ADDR || BASE_ADDR_REG_CH2_ADDR || BASE_ADDR_REG_CH3_ADDR ||
		BASE_WORD_COUNT_REG_CH0_ADDR || BASE_WORD_COUNT_REG_CH1_ADDR || BASE_WORD_COUNT_REG_CH2_ADDR || BASE_WORD_COUNT_REG_CH3_ADDR ))
		tx.tx_type = BASE_REG_CFG;
		else 
		tx.tx_type = REG_WRITE_CFG;
		
		tx.cs = 1'b0; 
		tx.ior_in = 1'b1;
		tx.iow_in = 1'b0;
		tx.addr_lo_in = address;
		tx.dreq = 4'b0;
		tx.hlda = 1'b0;
		tx.eop = 1'b1;
		tx.data_in = data;
		
		//for letting the driver know if its a last register write
		if(last)
		tx.ctrl_regs_wr_done = 1;
		else
		tx.ctrl_regs_wr_done = 0;
		
		dma_config::gen2drv.put(tx);
	
	endtask : reg_write

endclass