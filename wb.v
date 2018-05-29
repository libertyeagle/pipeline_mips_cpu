`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:12:33 05/28/2018 
// Design Name: 
// Module Name:    wb 
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
module wb_stage(
    input [2:0] mem_wb_ctrl_load_type,
    input mem_wb_ctrl_reg_write,
	 input mem_wb_ctrl_mem_to_reg,
    input [4:0] mem_wb_rd,
    input [31:0] mem_wb_data,
    input [1:0] mem_wb_low_two_bits,
    output final_reg_write,
    output [31:0] final_data_reg_write,
    output [4:0] final_dst_reg_write
);
	
	 wire [31:0] load_data_splited;
	 
    split_word_load split_word_load_module(
        mem_wb_data,
        mem_wb_ctrl_load_type,
        mem_wb_low_two_bits,
        load_data_splited
    );

    assign final_reg_write = mem_wb_ctrl_reg_write;
	 assign final_dst_reg_write = mem_wb_rd;
	 assign final_data_reg_write = (mem_wb_ctrl_mem_to_reg) ? load_data_splited : mem_wb_data; 
endmodule