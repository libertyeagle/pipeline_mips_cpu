`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:13 05/28/2018 
// Design Name: 
// Module Name:    flush_control 
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
module flush_control(
    input branch_taken,
    input jump_taken,
    output flush_if,
    output flush_id,
    output flush_ex
);

    assign flush_if = (jump_taken || branch_taken) ? 1'b1 : 1'b0;
    assign flush_id = (jump_taken || branch_taken) ? 1'b1 : 1'b0;
    assign flush_ex = (jump_taken || branch_taken) ? 1'b1 : 1'b0;

endmodule