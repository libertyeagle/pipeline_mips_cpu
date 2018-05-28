module flush_control(
    input branch_taken,
    input jump_taken,
    output flush_if,
    output flush_id,
    output flush_ex,
);

    assign flush_if = (jump_taken || branch_taken) ? 1'b1 : 1'b0;
    assign flush_id = (jump_taken || branch_taken) ? 1'b1 : 1'b0;
    assign flush_ex = (jump_taken || branch_taken) ? 1'b1 : 1'b0;

endmodule