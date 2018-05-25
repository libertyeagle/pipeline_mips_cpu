module if_stage(
  
);

    initial
        pc <= 32'b0;

    always @(posedge clk)
        if (~rst_n) pc <= 32'b0;
        else
        begin
            if (stall) pc <= pc;
            else if (jump_taken) pc <= pc_jump;
            else if (branch_eq_taken || branch_neq_taken) pc <= pc_branch;
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