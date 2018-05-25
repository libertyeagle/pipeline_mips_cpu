module control(
    input [5:0] op,
    input [5:0] funct,
    output branch,
    output mem_to_reg,
    output [3:0] alu_control,
    output mem_write,
    output alu_src,
    output alu_shift_shamt,
    output reg_write,
    output jump,
    output jump_reg,
    output reg_dst,
    output [2:0] branch_type,
    output [2:0] load_type,
    output [1:0] store_type
);
    parameter BRANCH_BEQ = 3'd0;
    parameter BRANCH_BGEZ = 3'd1; 
    parameter BRANCH_BGTZ = 3'd2;
    parameter BRANCH_BLEZ = 3'd3;
    parameter BRANCH_BLTZ = 3'd4;
    parameter BRANCH_BNE = 3'd5;

    parameter LOAD_LB = 3'd0;
    parameter LOAD_LBU = 3'd1;
    parameter LOAD_LH = 3'd2;
    parameter LOAD_LHU = 3'd3;
    parameter LOAD_LW = 3'd4;

    parameter STORE_SB = 2'd0;
    parameter STORE_SH = 2'd1;
    parameter STORE_SW = 2'd2;

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

    // branch type: beq bgez bgtz blez bltz bne
    // load type: lb lbu lh lhu lw
    // store type: sb sh sw
    always @(*)
    begin
        branch = 1'b0;
        mem_to_reg = 1'b0;
        alu_control = 4'd0;
        mem_write = 1'b0;
        alu_src = 1'b0;
        alu_shift_shamt = 1'b0;
        reg_write = 1'b0;
        jump = 1'b0;
        jump_reg = 1'b0;
        reg_dst = 1'b0;
        branch_type = 3'd0;
        load_type = 3'd0;
        store_type = 2'd0;

        case(op)
            6'h0:
            begin
                reg_dst = 1'b1;
                reg_write = 1'b1;
                case(funct)
                    6'h20: // add (with overflow)
                        alu_control = A_ADD;
                    6'h21: // addu (without overflow)
                        alu_control = A_ADD;
                    6'h24: // and
                        alu_control = A_AND;
                    6'h27: // nor
                        alu_control = A_XOR;
                    6'h25: // orh
                        alu_control = A_OR;
                    6'h0: // sll
                    begin
                        alu_shift_shamt = 1'b1;
                        alu_control = A_SLL;
                    end
                    6'h4: // sllv
                        alu_control = A_SLL;
                    6'h3: // sra
                    begin
                        alu_shift_shamt = 1'b1;
                        alu_control = A_SRA;
                    end
                    6'h7: // srav
                        alu_control = A_SRA;
                    6'h2: // srl
                    begin
                        alu_shift_shamt = 1'b1;
                        alu_control = A_SRL;
                    end 
                    6'h6: // srlv
                        alu_control = A_SRL;
                    6'h22: // sub (with overflow)
                        alu_control = A_SUB;
                    6'h23: // subu (without overflow)
                        alu_control = A_SUB;
                    6'h26: // xor
                        alu_control = A_XOR;
                    6'h2a: // slt
                        alu_control = A_SLT:
                    6'h2b: // sltu
                        alu_control = A_SLTU;
                    6'h8: // jr
                        jump_reg = 1'b1;
                endcase
            end

            6'h8: // addi
            begin
                alu_src = 1'b1;
                reg_write = 1'b1;
                alu_control = A_ADD
            end
            6'h9: // addiu
            begin
                alu_src = 1'b1;
                reg_write = 1'b1;
                alu_control = A_ADD;
            end
            6'hc: // andi
            begin
                alu_src = 1'b1;
                reg_write = 1'b1;
                alu_control = A_AND;
            end
            6'hd: // ori
            begin
                alu_src = 1'b1;
                reg_write = 1'b1;
                alu_control = A_OR;
            end
            6'he: // xori
            begin
                alu_src = 1'b1;
                reg_write = 1'b1;
                alu_control = A_XOR;
            end
            6'ha: // slti
            begin
                alu_src = 1'b1;
                reg_write = 1'b1;
                alu_control = A_SLT;
            end
            6'hb: // sltiu
            begin
                alu_src = 1'b1;
                reg_write = 1'b1;
                alu_control = A_SLTU;
            end

            6'h4: // beq
            begin
                branch = 1'b1;
                branch_type = BRANCH_BEQ;
            end
            6'h1:
            begin
                if (rt == 1) // bgez
                begin
                    branch = 1'b1;
                    branch_type = BRANCH_BGEZ;
                end
                else if (rt == 0) // bltz
                begin
                    branch = 1'b1;
                    branch_type = BRANCH_BLTZ;
                end
            end
            6'h7: // bgtz
            begin
                branch = 1'b1;
                branch_type = BRANCH_BGTZ;
            end
            6'h6: // blez
            begin
                branch = 1'b1;
                branch_type = BRANCH_BLEZ;
            end
            6'h5: // bne
            begin
                branch = 1'b1;
                branch_type = BRANCH_BNE;
            end

            6'h20: // lb
            begin
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_control = A_ADD;
                load_type = LOAD_LB;
            end
            6'h24: // lbu
            begin
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_control = A_ADD;
                load_type = LOAD_LBU;
            end
            6'h21: // lh
            begin
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_control = A_ADD;
                load_type = LOAD_LH;
            end
            6'h25: // lhu
            begin
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_control = A_ADD;
                load_type = LOAD_LHU;
            end
            6'h23: // lw
            begin
                mem_to_reg = 1'b1;
                reg_write = 1'b1;
                alu_src = 1'b1;
                alu_control = A_ADD;
                load_type = LOAD_LW;
            end
            6'h28: // sb
            begin
                mem_write = 1'b1;
                alu_control = A_ADD;
                alu_src = 1'b1;
                store_type = STORE_SB;
            end
            6'h29: // sh
            begin
                mem_write = 1'b1;
                alu_control = A_ADD;
                alu_src = 1'b1;
                store_type = STORE_SH;
            end
            6'h2b: // sw
            begin
                mem_write = 1'b1;
                alu_control = A_ADD;
                alu_src = 1'b1;
                store_type = STORE_SW;
            end
            6'h2: // j
            begin
                jump = 1'b1;
            end
        endcase
    end
endmodule