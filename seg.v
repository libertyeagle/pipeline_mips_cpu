`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:43 11/22/2017 
// Design Name: 
// Module Name:    seg 
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
module seg(
	input clk,
	input rst_n,
	input [15:0] data,
	output reg [3:0] sel,
	output reg [7:0] segment
	);
	
	reg [1:0] counter;
	wire [7:0] segment3;
	wire [7:0] segment2;
	wire [7:0] segment1;
	wire [7:0] segment0;
	decoder digit3(data[15:12], segment3);
	decoder digit2(data[11:8], segment2);
	decoder digit1(data[7:4], segment1);
	decoder digit0(data[3:0], segment0);
	
	initial
		counter<=2'd0;
		
	always @(posedge clk or negedge rst_n)
	 begin
	 	if (~rst_n)
	 	 begin
	 	 	counter<=2'd0;
	 	 	sel<=4'b0000;
	 	 	segment<=8'b0000_0000;
	 	 end
	 	 else begin
	 	 	case (counter)
	 	 		2'd0: begin sel<=4'b1110; segment<=segment3; end
	 	 		2'd1: begin sel<=4'b1101; segment<=segment2; end
	 	 		2'd2: begin sel<=4'b1011; segment<=segment1; end
	 	 		2'd3: begin sel<=4'b0111; segment<=segment0; end
	 	 	endcase
	 	 	if (counter<2'd3) counter<=counter+2'd1;
	 	 	else counter<=2'b0;
	 	 end
	 end
endmodule