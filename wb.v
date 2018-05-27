module wb_stage(
    input [2:0] mem_wb_ctrl_load_type
    input mem_wb_reg_write,
    input [4:0] mem_wb_rd,
    input [31:0] mem_wb_data,
    input [1:0] mem_wb_low_two_bits;
    output final_reg_write,
    output [31:0] final_data_reg_write,
    output [4:0] final_dst_reg_write
);

    split_word_load(
        mem_wb_data,
        mem_wb_ctrl_load_type,
        mem_wb_low_two_bits,
        final_data_reg_write
    );

    assign final_reg_write = mem_wb_reg_write;
    assign final_dst_reg_write = mem_wb_rd;
endmodule