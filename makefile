all: setup compile run clean

setup:
		vlib work
		vmap work work

compile:
		vlog dma_transaction.sv dma_reg_pkg.sv dma_if.sv dma_config.sv dma_generator.sv 
		vlog dma_driver.sv dma_monitor.sv dma_coverage.sv dma_env.sv dma_test.sv dma_datapath.sv
		vlog dma_priority.sv dma_reg_file.sv dma_control.sv dma_reg_if.sv dma_control_if.sv dma_reg_pkg.sv dma_top.sv dma_tb_top.sv
		vopt dma_tb_top -o top_optimized  +acc +cover=sbfec 
		
run:
		vsim top_optimized -coverage  

clean: 
		rm -rf work transcript *~ vsim.wlf *.log
		