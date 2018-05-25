module id_stage(
  
);
    wire [2:0] alu_control;
    wire [1:0] alu_op;

    assign rs = if_id_instruction[25:21];
    assign rt = if_id_instruction[20:16];
    assign rd = if_id_instruction[15:11];

    assign op = if_id_instruction[31:26];
    assign funct = if_id_instruction[];
    assign shamt = if_id_instruction[];

    control CPU_CONTROL(op, branch, mem_to_reg, alu_control, mem_write, alu_src, reg_write, jump, reg_dst);

    always @(*)
        if (if_id_instruction[15] == 1'b1) imm_sign_extended = 32'hffff0000 + if_id_instruction[15:0];
        else imm_sign_extended = 32'h00000000 + if_id_instruction[15:0];

    // stall one cycle for lw hazard
    // if last insturction is LW and the register re
    assign stall = (id_ex_ctrl_mem_read) && (id_ex_rt == rs || id_ex_rt == rt) 

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

            id_ex_imm_sign_extended <= 32'b0;
            id_ex_pc_next <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_rt <= 5'b0;
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

            id_ex_imm_sign_extended <= 32'b0;
            id_ex_pc_next <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_rt <= 5'b0;       
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

            id_ex_imm_sign_extended <= 32'b0;
            id_ex_pc_next <= 32'b0;
            id_ex_rd <= 5'b0;
            id_ex_rt <= 5'b0;
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

            id_ex_imm_sign_extended <= imm_sign_extended;
            id_ex_pc_next <= if_id_pc_next;
            id_ex_rd <= rd;
            id_ex_rt <= rt;
        end
    end

    // signal `id_ex_reg_a_data` and `id_ex_reg_b_data` comes from register file module
endmodule