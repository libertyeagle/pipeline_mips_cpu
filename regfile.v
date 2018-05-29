`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:13:11 05/28/2018 
// Design Name: 
// Module Name:    regfile 
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
module reg_file(
	input clk,
	input rst_n,
	input [4:0] rAddr,
	output [31:0] rDout,
	input [4:0] rAddr2,
	output [31:0] rDout2,
	input [4:0] wAddr,
	input [31:0] wIn,
	input wEna
);
	reg [31:0] data [31:0];
	integer i;

	assign rDout = (rAddr)? ((rAddr == wAddr) ? wIn : data[rAddr]) : 32'b0;
	assign rDout2 = (rAddr2) ? ((rAddr2 == wAddr) ? wIn : data[rAddr2]) : 32'b0;
	// register 0 is always zero ($zero)
	
	always @(posedge clk or negedge rst_n)
	begin
		if (~rst_n)
		begin
			for (i = 0; i < 32; i = i + 1)
			begin
				data[i] <= 32'h00000000;
			end
		end
		else if (wEna)
		begin
			if (wAddr != 5'd0) data[wAddr] <= wIn;
		end
	end

endmodule
