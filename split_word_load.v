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
            begin
                if (addr_low_two_bits == 2'b00)
                    split_data = $signed(original_data[7:0]);
                else if (addr_low_two_bits == 2'b01)
                    split_data = $signed(original_data[15:8]);
                else if (addr_low_two_bits == 2'b10):
                    split_data = $signed(original_data[23:16]);
                else
                    split_data = $signed(original_data[31:24]);
            end    
            LOAD_LBU:
            begin
                if (addr_low_two_bits == 2'b00)
                    split_data = original_data[7:0];
                else if (addr_low_two_bits == 2'b01)
                    split_data = original_data[15:8];
                else if (addr_low_two_bits == 2'b10):
                    split_data = original_data[23:16];
                else
                    split_data = original_data[31:24];
            end
            LOAD_LH:
            begin
                if (addr_low_two_bits == 2'b00):
                    split_data = $signed(original_data[15:0]);
                else    // addr_low_two_bits == 2'b10 
                    split_data = $signed(original_data[31:16]);
            end
            LOAD_LHU:
            begin
                if (addr_low_two_bits == 2'b00):
                    split_data = original_data[15:0];
                else
                    split_data = original_data[31:15];
            end
            LOAD_LW:
                split_data = original_data;
            default: split_data = 32'b0;
        endcase
    end
endmodule