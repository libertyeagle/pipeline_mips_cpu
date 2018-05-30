`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:16:03 05/29/2018 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
	input clk,
	input rst,
	input mode_change,
	input continue_sig,
	input [5:0] addr_in,
	output [3:0] sel,
	output [7:0] seg,
	output [5:0] led,
	output high_low,
	output at_breakpoint
    );
	 
	wire mode_change_stable;
	wire continue_sig_stable;
	 
	wire clk_slow_seg;
	wire clk_slow_change_addr;
	
	wire [6:0] read_addr;
	wire [6:0] read_addr_seq;
	wire [6:0] read_addr_select;
	wire [31:0] mem_read_result;
	wire [15:0] data_display;
	
	
	reg curr_mode;
	
	initial
		curr_mode <= 1'b0;
	
	CPU cpu_module(clk, ~rst, continue_sig_stable, read_addr[6:1], mem_read_result, at_breakpoint);
	clk_divide clk_slow_seg_gen(clk, ~rst, clk_slow_seg);
	clk_divide_addr clk_slow_change_addr_gen(clk, ~rst, clk_slow_change_addr);
	button_jitter mode_change_jitter(clk, ~rst, mode_change, mode_change_stable);
	button_jitter continue_sig_jitter(clk, ~rst, continue_sig, continue_sig_stable);
	read_addr_gen read_addr_generator_mode_seq(clk_slow_change_addr, ~rst, read_addr_seq);
	read_addr_gen_single read_addr_generator_mode_select(clk_slow_change_addr, ~rst, addr_in, read_addr_select);
	
	always @(posedge mode_change_stable or posedge rst)
	begin
		if (rst)
			curr_mode<= 1'b0;
		else
		curr_mode <= ~curr_mode;
	end
	
	assign read_addr = (curr_mode) ? read_addr_select : read_addr_seq;
	
	assign data_display = (read_addr[0] == 1'b0) ? mem_read_result[31:16] : mem_read_result[15:0];
	seg data_displayer(clk_slow_seg, ~rst, data_display, sel, seg);
	
	assign high_low = (read_addr[0] == 1'b0);
	
	assign led = read_addr[6:1]; 
endmodule
