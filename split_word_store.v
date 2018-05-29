`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:23 05/28/2018 
// Design Name: 
// Module Name:    split_word_store 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module split_word_store(
    input [31:0] original_data,
    input [31:0] whole_piece_read,  // whole 32 bits data read from memory
    input [1:0] store_type,
    input [1:0] addr_low_two_bits,
    output reg [31:0] split_data
);
    
    parameter STORE_SB = 2'd0;
    parameter STORE_SH = 2'd1;
    parameter STORE_SW = 2'd2;
    
    // little endian
    // `whole_piece_read` is used to preserve other bytes / half word in the word we written to
    always @(*)
    begin
        case(store_type)
            STORE_SB:
            begin
                if (addr_low_two_bits == 2'b00)
                    split_data = {whole_piece_read[31:8], original_data[7:0]};
                else if (addr_low_two_bits == 2'b01)
                    split_data = {whole_piece_read[31:16], original_data[7:0], whole_piece_read[7:0]};
                else if (addr_low_two_bits == 2'b10)
                    split_data = {whole_piece_read[31:24], original_data[7:0], whole_piece_read[15:0]};
                else    // low_two_bits = 2'b11
                    split_data = {original_data[7:0], whole_piece_read[23:0]};
            end
            STORE_SH:
            begin
                if (addr_low_two_bits == 2'b00)
                    split_data = {whole_piece_read[31:16], original_data[15:0]};
                else // low_bits = 2'b10
                    // address must be aligned, as the case for word
                    split_data = {original_data[15:0], whole_piece_read[15:0]};
            end
            STORE_SW:
                split_data = original_data;
            default:
                split_data = original_data;
        endcase
    end
endmodule