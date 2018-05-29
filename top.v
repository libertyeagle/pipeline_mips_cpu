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
	output [3:0] sel,
	output [7:0] seg,
	output [5:0] led
    );
	 
	wire clk_slow_seg;
	wire clk_slow_change_addr;
	
	wire [6:0] read_addr;
	wire [31:0] mem_read_result;
	wire [15:0] data_display;
	
	CPU cpu_module(clk, ~rst, read_addr[6:1], mem_read_result);
	clk_divide clk_slow_seg_gen(clk, ~rst, clk_slow_seg);
	clk_divide_addr clk_slow_change_addr_gen(clk, ~rst, clk_slow_change_addr);
	read_addr_gen read_addr_generator(clk_slow_change_addr, ~rst, read_addr);
	
	assign data_display = (read_addr[0] == 1'b0) ? mem_read_result[31:16] : mem_read_result[15:0];
	seg data_displayer(clk_slow_seg, ~rst, data_display, sel, seg);
	
	assign led = read_addr[6:1]; 
endmodule
