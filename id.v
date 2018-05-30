`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  
// 
// Create Date:    17:05:51 05/28/2018 
// Design Name: 
// Module Name:    id 
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
module id_stage(
    input clk,
    input rst_n,
    input [31:0] if_id_instruction,
    input [31:0] if_id_pc_next,
	 input flush_id,
    input continue_sig,
    output reg [4:0] id_ex_rs,
    output reg [4:0] id_ex_rt,
    output reg [4:0] id_ex_rd,
    output reg [31:0] id_ex_imm_sign_extended,
    output reg [4:0] id_ex_shamt,
    output reg [31:0] id_ex_pc_next,
    output reg [3:0] id_ex_ctrl_alu_control,
    output reg id_ex_ctrl_alu_src,
    output reg id_ex_ctrl_alu_shift_shamt,
    output reg id_ex_ctrl_branch,
    output reg id_ex_ctrl_jump,
    output reg id_ex_ctrl_jump_reg,
    output reg [2:0] id_ex_ctrl_load_type,
    output reg [1:0] id_ex_ctrl_store_type,
    output reg [2:0] id_ex_ctrl_branch_type,
    output reg id_ex_ctrl_mem_to_reg,
    output reg id_ex_ctrl_mem_write,
    output reg id_ex_ctrl_reg_dst,
    output reg id_ex_ctrl_reg_write,
    output stall,
    output stall_breakpoint,
    output reg continue_en
);

    parameter BREAKPOINT_EN = 1'b1;
    parameter BREAKPOINT_ADDR = 32'd48; // for fibonacci program, breakpoint at `add $t2, $t3, $t4` 

    assign stall_breakpoint = (BREAKPOINT_EN && (if_id_pc_next - 32'd4 == BREAKPOINT_ADDR)) ? 1'b1 : 1'b0;

    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;

    wire [5:0] op;
    wire [5:0] funct;
    wire [4:0] shamt;

    // control singals
    wire branch;
    wire mem_to_reg;
    wire [3:0] alu_control;
    wire mem_write;
    wire alu_src;
    wire alu_shift_shamt;
    wire reg_write;
    wire jump;
    wire jump_reg;
    wire reg_dst;
    wire [2:0] branch_type;
    wire [2:0] load_type;
    wire [1:0] store_type;
    reg [31:0] imm_sign_extended;

    assign rs = if_id_instruction[25:21];
    assign rt = if_id_instruction[20:16];
    assign rd = if_id_instruction[15:11];

    assign op = if_id_instruction[31:26];
    assign funct = if_id_instruction[5:0];
    assign shamt = if_id_instruction[10:6];

    control CPU_CONTROL(
        op,
        funct,
        rt,
        branch,
        mem_to_reg,
        alu_control,
        mem_write,
        alu_src,
        alu_shift_shamt,
        reg_write,
        jump,
        jump_reg,
        reg_dst,
        branch_type,
        load_type,
        store_type
    );

    // sign extension
    always @(*)
        if (if_id_instruction[15] == 1'b1) imm_sign_extended = 32'hffff0000 + if_id_instruction[15:0];
        else imm_sign_extended = 32'h00000000 + if_id_instruction[15:0];

    // stall one cycle for lw hazard
    // if last insturction is LW and the register re
    assign stall = (id_ex_ctrl_mem_to_reg) && (id_ex_rt == rs || id_ex_rt == rt);

    initial 
        continue_en <= 1'b0;

    always @(posedge clk or posedge continue_sig or negedge rst_n)
    begin
        if (~rst_n) continue_en <= 1'b0;
        else if (continue_sig) continue_en <= 1'b1;
		  else continue_en <= 1'b0;
    end

    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
        begin
            id_ex_ctrl_alu_control <= 3'b0;
            id_ex_ctrl_reg_dst <= 1'b0;
            id_ex_ctrl_alu_src <= 1'b0;
            id_ex_ctrl_reg_write <= 1'b0;
            id_ex_ctrl_mem_to_reg <= 1'b0;
            id_ex_ctrl_mem_write <= 1'b0;
            id_ex_ctrl_jump <= 1'b0;
            id_ex_ctrl_branch <= 1'b0;
            id_ex_ctrl_jump_reg <= 1'b0;
            id_ex_ctrl_alu_shift_shamt <= 1'b0;
            id_ex_ctrl_store_type <= 2'b0;
            id_ex_ctrl_load_type <= 2'b0;
            id_ex_ctrl_branch_type <= 2'b0;
            
            id_ex_imm_sign_extended <= 32'b0;
            id_ex_pc_next <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_rt <= 5'b0;
            id_ex_rs <= 5'b0;
            id_ex_shamt <= 5'b0;
        end
        else if (flush_id)
        begin
            id_ex_ctrl_alu_control <= 3'b0;
            id_ex_ctrl_reg_dst <= 1'b0;
            id_ex_ctrl_alu_src <= 1'b0;
            id_ex_ctrl_reg_write <= 1'b0;
            id_ex_ctrl_mem_to_reg <= 1'b0;
            id_ex_ctrl_mem_write <= 1'b0;
            id_ex_ctrl_jump <= 1'b0;
            id_ex_ctrl_branch <= 1'b0;
            id_ex_ctrl_jump_reg <= 1'b0;
            id_ex_ctrl_alu_shift_shamt <= 1'b0;
            id_ex_ctrl_store_type <= 2'b0;
            id_ex_ctrl_load_type <= 2'b0;
            id_ex_ctrl_branch_type <= 2'b0;

            id_ex_imm_sign_extended <= 32'b0;
            id_ex_pc_next <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_rt <= 5'b0;
            id_ex_rs <= 5'b0;
            id_ex_shamt <= 5'b0;
        end
        else if (stall)
        begin
            // insert a bubble to the pipeline
            id_ex_ctrl_alu_control <= 3'b0;
            id_ex_ctrl_reg_dst <= 1'b0;
            id_ex_ctrl_alu_src <= 1'b0;
            id_ex_ctrl_reg_write <= 1'b0;
            id_ex_ctrl_mem_to_reg <= 1'b0;
            id_ex_ctrl_mem_write <= 1'b0;
            id_ex_ctrl_jump <= 1'b0;
            id_ex_ctrl_branch <= 1'b0;
            id_ex_ctrl_jump_reg <= 1'b0;
            id_ex_ctrl_alu_shift_shamt <= 1'b0;
            id_ex_ctrl_store_type <= 2'b0;
            id_ex_ctrl_load_type <= 2'b0;
            id_ex_ctrl_branch_type <= 2'b0;

            id_ex_imm_sign_extended <= 32'b0;
            id_ex_pc_next <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_rt <= 5'b0;
            id_ex_rs <= 5'b0;
            id_ex_shamt <= 5'b0;
        end
        else if (stall_breakpoint & ~continue_en)
        begin
            id_ex_ctrl_alu_control <= 3'b0;
            id_ex_ctrl_reg_dst <= 1'b0;
            id_ex_ctrl_alu_src <= 1'b0;
            id_ex_ctrl_reg_write <= 1'b0;
            id_ex_ctrl_mem_to_reg <= 1'b0;
            id_ex_ctrl_mem_write <= 1'b0;
            id_ex_ctrl_jump <= 1'b0;
            id_ex_ctrl_branch <= 1'b0;
            id_ex_ctrl_jump_reg <= 1'b0;
            id_ex_ctrl_alu_shift_shamt <= 1'b0;
            id_ex_ctrl_store_type <= 2'b0;
            id_ex_ctrl_load_type <= 2'b0;
            id_ex_ctrl_branch_type <= 2'b0;

            id_ex_imm_sign_extended <= 32'b0;
            id_ex_pc_next <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_rt <= 5'b0;
            id_ex_rs <= 5'b0;
            id_ex_shamt <= 5'b0;
        end
        else 
        begin
            id_ex_ctrl_alu_control <= alu_control;
            id_ex_ctrl_reg_dst <= reg_dst;
            id_ex_ctrl_alu_src <= alu_src;
            id_ex_ctrl_reg_write <= reg_write;
            id_ex_ctrl_mem_to_reg <= mem_to_reg;
            id_ex_ctrl_mem_write <= mem_write;
            id_ex_ctrl_jump <= jump;
            id_ex_ctrl_branch <= branch;
            id_ex_ctrl_jump_reg <= jump_reg;
            id_ex_ctrl_alu_shift_shamt <= alu_shift_shamt;
            id_ex_ctrl_store_type <= store_type;
            id_ex_ctrl_load_type <= load_type;
            id_ex_ctrl_branch_type <= branch_type;

            id_ex_imm_sign_extended <= imm_sign_extended;
            id_ex_pc_next <= if_id_pc_next;
            id_ex_rd <= rd;
            id_ex_rt <= rt;
            id_ex_rs <= rs;
            id_ex_shamt <= shamt;
        end
    end

endmodule