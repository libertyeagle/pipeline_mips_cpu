`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:48:51 05/28/2018
// Design Name:   CPU
// Module Name:   C:/FPGA/pipeline_mips_cpu/testbench.v
// Project Name:  pipeline_mips_cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbench;

	// Inputs
	reg clk;
	reg continue_sig;
	reg rst_n;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
		.clk(clk), 
		.rst_n(rst_n),
		.continue_sig(continue_sig)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		continue_sig = 0;
			
		// Wait 100 ns for global reset to finish
		#100;
		rst_n = 1;

		#5000;
		continue_sig = 1;
		#10;
		continue_sig = 0;
		
		#5000;
		continue_sig = 1;
		#10;
		continue_sig = 0;
        
		// Add stimulus here

	end
	
	always
		#10 clk = ~clk;
      
endmodule

