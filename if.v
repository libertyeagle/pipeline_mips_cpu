module if_stage(
    input clk,
    input rst_n,
    input jump_taken,
    input branch_taken,
    input [31:0] pc_jump,
    input [31:0] pc_branch,
    output reg [31:0] if_id_instruction,
    output reg [31:0] if_id_pc_next,
);

    reg [31:0] pc;
    wire [31:0] instruction;
    
    initial
        pc <= 32'b0;

    always @(posedge clk)
        if (~rst_n) pc <= 32'b0;
        else
        begin
            if (stall) pc <= pc;
            else if (jump_taken) pc <= pc_jump;
            else if (branch_taken) pc <= pc_branch;
            else pc <= pc + 32'h4;
        end

    instr_mem instruction_memory(
        .a(pc),
        .spo(instruction)
    );

    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
        begin
            if_id_pc_next <= 32'b0;
            if_id_instruction <= 32'b0;
        end
        else if (flush_if)
            if_id_pc_next <= 32'b0;
            if_id_instruction <= 32'b0;
        else if (stall)
        begin
            if_id_pc_next <= if_id_pc_next;
            if_id_instruction <= if_id_instruction;
        end
        else
        begin
            if_id_pc_next <= pc + 32'h4;
            if_id_instruction <= instruction;
        end
    end
endmodule