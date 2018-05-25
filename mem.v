module mem_stage(
    output branch_eq_taken,
    output branch_neq_taken,
    output jump_taken,
    output pc_jump,
    output pc_branch
);

    assign branch_eq_taken = ex_mem_ctrl_branch_eq && ex_mem_alu_zero;
    assign branch_neq_taken = ex_mem_ctrl_branch_neq && ~ex_mem_alu_zero;

    assign jump_taken = ex_mem_ctrl_jump;

    assign pc_jump = ex_mem_pc_jump;
    assign pc_branch = ex_mem_pc_branch;

    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
        begin
            mem_wb_ctrl_reg_write <= 1'b0;
            
            mem_wb_data <= 32'b0;
            
            mem_wb_write_reg_dst <= 5'b0;
        end
        else
        begin
            mem_wb_ctrl_reg_write <= ex_mem_ctrl_reg_write;
            
            if (ex_mem_ctrl_mem_to_reg) mem_wb_data <= data_mem_read;
            else mem_wb_data <= ex_mem_alu_out;

            mem_wb_write_reg_dst <= ex_mem_write_reg_dst;
        end        
    end

	 data_memory data_mem (
        .a(ex_mem_alu_out),
        .d(ex_mem_reg_b_data),
        .clk(clk),
        .we(ex_mem_ctrl_mem_write),
        .spo(data_mem_read)
    );
endmodule