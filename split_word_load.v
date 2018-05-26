module split_word_load(
    input [31:0] original_data,
    input [2:0] load_type,
    input [1:0] addr_low_two_bits,
    output [31:0] split_data
);
    parameter LOAD_LB = 3'd0;
    parameter LOAD_LBU = 3'd1;
    parameter LOAD_LH = 3'd2;
    parameter LOAD_LHU = 3'd3;
    parameter LOAD_LW = 3'd4;

    always @(*)
    begin
        case(load_type):
            LOAD_LB:
            LOAD_LBU:
            LOAD_LH:
            LOAD_LHU:
            LOAD_LW:
            default:
    end

endmodule