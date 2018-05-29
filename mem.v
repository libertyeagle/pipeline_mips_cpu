`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:07:01 05/28/2018 
// Design Name: 
// Module Name:    mem 
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
module mem_stage(
    input clk,
    input rst_n,
    input ex_mem_alu_beq_sig,
    input ex_mem_alu_bgez_sig,
    input ex_mem_alu_bgtz_sig,
    input ex_mem_alu_blez_sig,
    input ex_mem_alu_bltz_sig,
    input ex_mem_alu_bne_sig,
    input [31:0] ex_mem_alu_out,
    input ex_mem_ctrl_branch,
    input [2:0] ex_mem_ctrl_branch_type,
    input ex_mem_ctrl_jump,
    input ex_mem_ctrl_jump_reg,
    input [2:0] ex_mem_ctrl_load_type,
    input ex_mem_ctrl_mem_to_reg,
    input ex_mem_ctrl_mem_write,
    input ex_mem_ctrl_reg_write,
    input [1:0] ex_mem_ctrl_store_type,
    input [31:0] ex_mem_pc_branch,
    input [31:0] ex_mem_pc_jump,
    input [4:0] ex_mem_rd,
    input [31:0] ex_mem_reg_b_data,
	 input [5:0] board_mem_read_addr,
    output reg branch_taken,
    output jump_taken,
    output reg [2:0] mem_wb_ctrl_load_type,
    output reg mem_wb_ctrl_reg_write,
	 output reg mem_wb_ctrl_mem_to_reg,
    output reg [31:0] mem_wb_data,
    output reg [4:0] mem_wb_rd,
    output reg [1:0] mem_wb_low_two_bits,
	 output [31:0] board_mem_read_result
);

    parameter BRANCH_BEQ = 3'd0;
    parameter BRANCH_BGEZ = 3'd1; 
    parameter BRANCH_BGTZ = 3'd2;
    parameter BRANCH_BLEZ = 3'd3;
    parameter BRANCH_BLTZ = 3'd4;
    parameter BRANCH_BNE = 3'd5;

    wire [31:0] data_mem_read;
    wire [31:0] split_data_write;

    split_word_store split_word_store_module(
        ex_mem_reg_b_data,
        data_mem_read,
        ex_mem_ctrl_store_type,
        ex_mem_alu_out[1:0],
        split_data_write
    );

	 data_mem data_memory (
        .a(ex_mem_alu_out[7:2]),
        .d(split_data_write),
        .clk(clk),
        .we(ex_mem_ctrl_mem_write),
        .spo(data_mem_read),
	 	  .dpra(board_mem_read_addr),
	     .dpo(board_mem_read_result)
    );
	 
    always @(*)
    begin
        case(ex_mem_ctrl_branch_type)
            BRANCH_BEQ:
                branch_taken = ex_mem_ctrl_branch && ex_mem_alu_beq_sig;
            BRANCH_BGEZ:
                branch_taken = ex_mem_ctrl_branch && ex_mem_alu_bgez_sig;
            BRANCH_BGTZ:
                branch_taken = ex_mem_ctrl_branch && ex_mem_alu_bgtz_sig;
            BRANCH_BLEZ:
                branch_taken = ex_mem_ctrl_branch && ex_mem_alu_blez_sig;
            BRANCH_BLTZ:
                branch_taken = ex_mem_ctrl_branch && ex_mem_alu_bltz_sig;
            BRANCH_BNE:
                branch_taken = ex_mem_ctrl_branch && ex_mem_alu_bne_sig;
            default:
                branch_taken = 1'b0;
		  endcase
    end

    assign jump_taken = ex_mem_ctrl_jump || ex_mem_ctrl_jump_reg;

    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
        begin
            mem_wb_ctrl_reg_write <= 1'b0;
            mem_wb_ctrl_load_type <= 1'b0;
				mem_wb_ctrl_mem_to_reg <= 1'b0;

            mem_wb_low_two_bits <= 2'b00;
            mem_wb_data <= 32'b0;
            mem_wb_rd <= 5'b0;
        end
        else
        begin
            mem_wb_ctrl_reg_write <= ex_mem_ctrl_reg_write;
            mem_wb_ctrl_load_type <= ex_mem_ctrl_load_type;
				mem_wb_ctrl_mem_to_reg <= ex_mem_ctrl_mem_to_reg;

            mem_wb_low_two_bits <= ex_mem_alu_out[1:0];
            mem_wb_data <= (ex_mem_ctrl_mem_to_reg) ? data_mem_read : ex_mem_alu_out;
            mem_wb_rd <= ex_mem_rd;
        end
    end
endmodule