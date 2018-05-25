module wb_stage(
    input mem_wb_reg_write,
    input [31:0] mem_wb_data,
    output final_reg_write,
    output [31:0] final_data_reg_write
);

    assign final_reg_write = mem_wb_reg_write;
    assign final_data_reg_write = mem_wb_data;

endmodule