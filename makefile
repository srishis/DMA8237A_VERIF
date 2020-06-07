all: setup compile run_sanity_test clean

setup:
		vlib work
		vmap work work

compile:
		vlog dma_files.svh
		vopt dma_tb_top -o top_optimized  +acc +cover=sbfec 
		
run_regression:
		vsim top_optimized -coverage + testcase =Regression 

run_sanity_test:
		vsim top_optimized -coverage + testcase =basic_read_write_sanity_test

run_basic_i/o_mem read test:
		vsim top_optimized -coverage + testcase =dma_io_to_mem_read_transfer

run_basic_i/o_mem write test:
		vsim top_optimized -coverage + testcase =dma_io_to_mem_write_transfer
			
clean: 
		rm -rf work transcript *~ vsim.wlf *.log
		