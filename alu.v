module alu(
    input signed [31:0] alu_a,
    input signed [31:0] alu_b,
    input [2:0] alu_op,
    output reg [31:0] alu_out,
    output beq_sig,
    output bgez_sig,
    output bgtz_sig,
    output blez_sig,
    output bltz_sig,
    output bne_sig
);

    parameter A_NOP = 4'd00;
    parameter A_ADD = 4'd01;
    parameter A_SUB = 4'd02;
    parameter A_AND = 4'd03;
    parameter A_OR = 4'd04;
    parameter A_XOR = 4'd05;
    parameter A_NOR = 4'd06;
    parameter A_SLT = 4'd07;
    parameter A_SLTU = 4'd08;
    parameter A_SLL = 4'd09;
    parameter A_SRA = 4'd10;
    parameter A_SRL = 4'd11;
    parameter A_LUI = 4'd12;

    always @(*)
    begin
        case (alu_op)
            A_ADD : alu_out = alu_a + alu_b;
            A_SUB : alu_out = alu_a - alu_b;
            A_AND : alu_out = alu_a & alu_b;
            A_OR : alu_out = alu_a | alu_b;
            A_XOR : alu_out = alu_a ^ alu_b;
            A_NOR: alu_out = ~(alu_a | alu_b);
            A_SLT: ($signed(alu_a) < $signed(alu_b)) ? 32'd1 : 32'd0;
            A_SLTU: (alu_a < alu_b) ? 32'd1 : 32'd0;
            A_SLL: alu_b << alu_a[4:0];
            A_SRA: $signed(alu_b) >>> alu_a[4:0];
            A_SRL: alu_b >> alu_a[4:0];
            A_LUI: {alu_b[15:0], 16'b0};
            default: alu_out = 32'h0;
        endcase
    end

    assign beq_sig = alu_a == alu_b;
    assign bgez_sig = $signed(alu_a) >= 0;
    assign bgtz_sig = $signed(alu_a) > 0;
    assign blez_sig = $signed(alu_a) <= 0;
    assign bltz_sig = $signed(alu_a) < 0;
    assign bne_sig = alu_a != alu_b;
endmodule