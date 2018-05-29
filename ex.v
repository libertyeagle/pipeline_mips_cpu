`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:07:50 05/28/2018 
// Design Name: 
// Module Name:    ex 
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
module ex_stage(
    input clk,
    input rst_n,
    input [4:0] id_ex_rs,
    input [4:0] id_ex_rt,
    input [4:0] id_ex_rd,
    input [31:0] id_ex_imm_sign_extended,
    input [4:0] id_ex_shamt,
    input [31:0] id_ex_reg_a_data,
    input [31:0] id_ex_reg_b_data,
    input [31:0] id_ex_pc_next,
    input [3:0] id_ex_ctrl_alu_control,
    input id_ex_ctrl_alu_src,
    input id_ex_ctrl_alu_shift_shamt,
    input id_ex_ctrl_branch,
    input id_ex_ctrl_jump,
    input id_ex_ctrl_jump_reg,
    input [2:0] id_ex_ctrl_load_type,
    input [1:0] id_ex_ctrl_store_type,
    input [2:0] id_ex_ctrl_branch_type,
    input id_ex_ctrl_mem_to_reg,
    input id_ex_ctrl_mem_write,
    input id_ex_ctrl_reg_dst,
    input id_ex_ctrl_reg_write,
    input [31:0] mem_wb_data,
    input [4:0] mem_wb_rd,
    input mem_wb_ctrl_reg_write,
	 input flush_ex,
    output reg ex_mem_alu_beq_sig,
    output reg ex_mem_alu_bgez_sig,
    output reg ex_mem_alu_bgtz_sig,
    output reg ex_mem_alu_blez_sig,
    output reg ex_mem_alu_bltz_sig,
    output reg ex_mem_alu_bne_sig,
    output reg [31:0] ex_mem_alu_out,
    output reg ex_mem_ctrl_branch,
    output reg [2:0] ex_mem_ctrl_branch_type,
    output reg ex_mem_ctrl_jump,
    output reg ex_mem_ctrl_jump_reg,
    output reg [2:0] ex_mem_ctrl_load_type,
    output reg ex_mem_ctrl_mem_to_reg,
    output reg ex_mem_ctrl_mem_write,
    output reg ex_mem_ctrl_reg_write,
    output reg [1:0] ex_mem_ctrl_store_type,
    output reg [31:0] ex_mem_pc_branch,
    output reg [31:0] ex_mem_pc_jump,
    output reg [4:0] ex_mem_rd,
    output reg [31:0] ex_mem_reg_b_data
);

    wire [31:0] alu_src_a_reg;
    wire [31:0] alu_src_b_reg;
    wire [4:0] write_reg_dst;
	 
	 wire [31:0] alu_src_a;
	 wire [31:0] alu_src_b;
	 wire [31:0] alu_out;

    forwarding_alu CPU_ALU_FORWARDING(
        id_ex_rs,
        id_ex_rt,
        ex_mem_rd,
        mem_wb_rd,
        ex_mem_ctrl_reg_write,
        mem_wb_ctrl_reg_write,
        id_ex_reg_a_data, 
        id_ex_reg_b_data, 
        ex_mem_alu_out, 
        mem_wb_data, 
        alu_src_a_reg,
        alu_src_b_reg
    );

    assign alu_src_a = (id_ex_ctrl_alu_shift_shamt) ? id_ex_shamt : alu_src_a_reg;
    assign alu_src_b = (id_ex_ctrl_alu_src) ? id_ex_imm_sign_extended : alu_src_b_reg;

    alu CPU_ALU(
        alu_src_a, 
        alu_src_b, 
        id_ex_ctrl_alu_control, 
        alu_out, 
        alu_beq_sig,
        alu_bgez_sig,
        alu_bgtz_sig,
        alu_blez_sig,
        alu_bltz_sig,
        alu_bne_sig
    );

    // target register 
    assign write_reg_dst = (id_ex_ctrl_reg_dst) ? id_ex_rd : id_ex_rt; 

    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
        begin
            ex_mem_ctrl_reg_write <= 1'b0;
            ex_mem_ctrl_mem_to_reg <= 1'b0;
            ex_mem_ctrl_mem_write <= 1'b0;
            ex_mem_ctrl_jump <= 1'b0;
            ex_mem_ctrl_jump_reg <= 1'b0;
            ex_mem_ctrl_branch <= 1'b0;
            ex_mem_ctrl_branch_type <= 3'd0;
            ex_mem_ctrl_load_type <= 3'd0;
            ex_mem_ctrl_store_type <= 2'd0;

            ex_mem_alu_out <= 32'b0;
            ex_mem_reg_b_data <= 32'b0;
            ex_mem_pc_branch <= 32'd0;
            ex_mem_pc_jump <= 32'd0;   
            ex_mem_rd <= 5'd0;

            ex_mem_alu_beq_sig <= 1'b0;
            ex_mem_alu_bgez_sig <= 1'b0;
            ex_mem_alu_bgtz_sig <= 1'b0;
            ex_mem_alu_blez_sig <= 1'b0;
            ex_mem_alu_bltz_sig <= 1'b0;
            ex_mem_alu_bne_sig <= 1'b0;
        end 
        else if (flush_ex)
        begin
            ex_mem_ctrl_reg_write <= 1'b0;
            ex_mem_ctrl_mem_to_reg <= 1'b0;
            ex_mem_ctrl_mem_write <= 1'b0;
            ex_mem_ctrl_jump <= 1'b0;
            ex_mem_ctrl_jump_reg <= 1'b0;
            ex_mem_ctrl_branch <= 1'b0;
            ex_mem_ctrl_branch_type <= 3'd0;
            ex_mem_ctrl_load_type <= 3'd0;
            ex_mem_ctrl_store_type <= 2'd0;

            ex_mem_alu_out <= 32'b0;
            ex_mem_reg_b_data <= 32'b0;
            ex_mem_pc_branch <= 32'd0;
            ex_mem_pc_jump <= 32'd0;   
            ex_mem_rd <= 5'd0;

            ex_mem_alu_beq_sig <= 1'b0;
            ex_mem_alu_bgez_sig <= 1'b0;
            ex_mem_alu_bgtz_sig <= 1'b0;
            ex_mem_alu_blez_sig <= 1'b0;
            ex_mem_alu_bltz_sig <= 1'b0;
            ex_mem_alu_bne_sig <= 1'b0;
        end
		  else
        begin
            ex_mem_ctrl_reg_write <= id_ex_ctrl_reg_write;
            ex_mem_ctrl_mem_to_reg <= id_ex_ctrl_mem_to_reg;
            ex_mem_ctrl_mem_write <= id_ex_ctrl_mem_write;
            ex_mem_ctrl_jump <= id_ex_ctrl_jump;
            ex_mem_ctrl_jump_reg <= id_ex_ctrl_jump_reg;
            ex_mem_ctrl_branch <= id_ex_ctrl_branch;
            ex_mem_ctrl_branch_type <= id_ex_ctrl_branch_type;
            ex_mem_ctrl_load_type <= id_ex_ctrl_load_type;
            ex_mem_ctrl_store_type <= id_ex_ctrl_store_type;

            ex_mem_alu_out <= alu_out;
            ex_mem_reg_b_data <= alu_src_b_reg;
            ex_mem_pc_branch <= id_ex_pc_next + (id_ex_imm_sign_extended << 2);
            ex_mem_pc_jump <= 
            (id_ex_ctrl_jump_reg) ? alu_src_a : {id_ex_pc_next[31:28], id_ex_imm_sign_extended[25:0], 2'b00};
            ex_mem_rd <= write_reg_dst;

            ex_mem_alu_beq_sig <= alu_beq_sig;
            ex_mem_alu_bgez_sig <= alu_bgez_sig;
            ex_mem_alu_bgtz_sig <= alu_bgtz_sig;
            ex_mem_alu_blez_sig <= alu_blez_sig;
            ex_mem_alu_bltz_sig <= alu_bltz_sig;
            ex_mem_alu_bne_sig <= alu_bne_sig;
        end
    end

endmodule
