// DMA configuration class

class dma_config;
  // create all mailboxes required in the environment 
  static mailbox gen2drv = new();
  static mailbox drv2gen = new();
  static mailbox gen2chk = new();
  static mailbox gen2ref = new(); // shouldn't there be drv2ref ???, not this???
  static mailbox mon2cov = new();
  //static mailbox mon2sb // TODO delete this line;
  static mailbox gen2sb = new();
  static mailbox mon2chk = new();
  static mailbox sb2ck = new();
  //static mailbox ref2sb; // TODO delete this line
  
  // create virtual interface handle to pass to all classes from test bench top
  static virtual dma_if vif;
  
  static int error_count;
  static string testcase;
  
  static bit verbose = 0;
  
  // Number of transactions
  static int num_trans = 0;
  
  // DMA Timing parameters
	const static int TCY =  200;
	const static int TAEL = 200;
	const static int TAET = 130;
	const static int TAFAB = 90;
	const static int TAFC = 120;
	const static int TAFDB = 170;
	const static int TAHR = TCY-100;
	const static int TAHS = 30;
	const static int TAHW = TCY-50;
	const static int TAK = 170;
	const static int TASM =  170;
	const static int TASS =  100;
	const static int TCH =  80;
	const static int TCL =  68;
	const static int TDCL = 190;
	const static int TDCTR = 190;
	const static int TDCTW = 130;
	const static int TDQ1 = 120;
	const static int TDQ2 = 120;
	const static int TEPS = 40;
	const static int TEPW = 220;
	const static int TFAAB = 170;
	const static int TFAC = 150;
	const static int TFADB = 200;
	const static int THS = 75;
	const static int TIDH = 0;
	const static int TIDS = 170;
	const static int TODH = 10;
	const static int TODV = 125;
	const static int TQS = 0;
	const static int TRH = 20;
	const static int TRS = 60;
	const static int TSTL = 130;
	const static int TSTT = 90;
	const static int TAR = 50;
	const static int TAW = 130;
	const static int TCW = 130;
	const static int TDW = 130;
	const static int TRA = 0;
	const static int TRDE = 140;
	const static int TRDF = 70;
	const static int TRSTD = 500;
	const static int TRSTS = 2*TCY;
	const static int TRSTW = 300;
	const static int TRW = 200;
	const static int TWA = 20;
	const static int TWC = 20;
	const static int TWD = 30;
	const static int TWWS = 160;
	const static int TWR = 0;
	const static int CFG_WRITE_CURRENT = 5;

  
endclass : dma_config
