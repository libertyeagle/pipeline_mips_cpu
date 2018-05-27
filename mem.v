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
    output branch_taken,
    output jump_taken,
    output [2:0] mem_wb_ctrl_load_type,
    output mem_wb_ctrl_reg_write,
    output [31:0] mem_wb_data,
    output [4:0] mem_wb_rd,
    output [1:0] mem_wb_low_two_bits
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
        split_word_write
    );

	data_memory data_mem (
        .a(ex_mem_alu_out),
        .d(split_data_write),
        .clk(clk),
        .we(ex_mem_ctrl_mem_write),
        .spo(data_mem_read)
    );

    always @(*)
    begin
        case(ex_mem_ctrl_branch)
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
    end

    assign jump_taken = ex_mem_ctrl_jump || ex_mem_ctrl_jump_reg;

    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
        begin
            mem_wb_ctrl_reg_write <= 1'b0;
            mem_wb_ctrl_load_type <= 1'b0;
            
            mem_wb_low_two_bits <= 2'b00;
            mem_wb_data <= 32'b0
            mem_wb_rd <= 5'b0;
        end
        else
        begin
            mem_wb_ctrl_reg_write <= ex_mem_ctrl_reg_write;
            mem_wb_ctrl_load_type <= ex_mem_ctrl_load_type;

            mem_wb_low_two_bits <= ex_mem_alu_out[1:0];
            mem_wb_data <= (ex_mem_ctrl_mem_to_reg) ? data_mem_read : ex_mem_alu_out;
            mem_wb_rd <= ex_mem_rd;
        end
    end
endmodule