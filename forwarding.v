module forwarding_alu(
    input [5:0] id_ex_rs,
    input [5:0] id_ex_rt,
    input [5:0] ex_mem_rd,
    input [5:0] mem_wb_rd,
    input ex_mem_reg_write,
    input mem_wb_reg_write,
    input [31:0] reg_a_data,
    input [31:0] reg_b_data,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_data,
    output [31:0] alu_src_a,
    output [31:0] alu_src_b_reg
);
    wire bypass_a_from_mem;
    wire bypass_a_from_wb;
    wire bypass_b_from_mem;
    wire bypass_b_from_wb;

    wire [1:0] forward_a;
    wire [1:0] forward_b;
    

    function [1:0] forward_sig;
        input ex_mem_forward_sig;
        input mem_wb_forward_sig;
        begin
            if (ex_mem_forward_sig)
                forward_sig = 2'b10;
            else if (mem_wb_forward_sig)
                forward_sig = 2'b01;
            else forward_sig = 2'b00;
        end
    endfunction

    // r-type instruction
    // op (6 bits) - rs (5 bits) - rt (5 bits) - rd (5 bits) - shamt (5 bits) - funct (6 bits)
    assign bypass_a_from_mem = (id_ex_rs == ex_mem_rd) && (id_ex_rs != 5'd0) && (ex_mem_reg_write == 1'b1);
    assign bypass_b_from_mem = (id_ex_rt == ex_mem_rd) && (id_ex_rt != 5'd0) && (ex_mem_reg_write == 1'b1);
    assign bypass_a_from_wb = (id_ex_rs == mem_wb_rd) && (id_ex_rs != 5'd0) && (mem_wb_reg_write == 1'b1);
    assign bypass_b_from_wb = (id_ex_rt == mem_wb_rd) && (id_ex_rt != 5'd0) && (mem_wb_reg_write == 1'b1);

    assign forward_a = forward_sig(bypass_a_from_mem, bypass_a_from_wb);
    assign forward_b = forward_sig(bypass_b_from_mem, bypass_b_from_wb);


    always @(*)
        case (forward_a)
            // no forwarding
            2'd00: alu_src_a = reg_a_data;
            // forwarding from MEM_WB
            2'd01: alu_src_a = mem_wb_data;
            // forwarding from EX_MEM
            2'd10: alu_src_a = ex_mem_alu_result;
            default: alu_src_a = reg_a_data;
        endcase

    always @(*)
        case (forward_b)
            2'd00: alu_src_b_reg = reg_b_data;
            2'd01: alu_src_b_reg = mem_wb_data;
            2'd10: alu_src_b_reg = ex_mem_alu_result;
            default: alu_src_b_reg = reg_b_data;
        endcase
endmodule