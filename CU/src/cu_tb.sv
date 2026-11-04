`timescale 1ns/1ps
`include "cu.sv"

module testbench;

    logic [31:0] instr;
    logic beq, bne, blt, bge, bltu, bgeu;
    logic branch;
    logic write_rf;
    logic [3:0] alu_op;
    logic alu_src;
    logic is_jalr;
    logic [2:0] op_width;
    logic write_ram;
    logic [1:0] res;
    logic uses_rs1, uses_rs2;
    integer passed = 0;
    integer failed = 0;

    cu #(
        .IWIDTH(32),
        .MOPS(16),
        .MMOPS(7),
        .WBS(4)
    ) dut (
        .instr(instr),
        .beq(beq),
        .bne(bne),
        .blt(blt),
        .bge(bge),
        .bltu(bltu),
        .bgeu(bgeu),
        .branch(branch),
        .write_rf(write_rf),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .is_jalr(is_jalr),
        .op_width(op_width),
        .write_ram(write_ram),
        .res(res),
        .uses_rs1(uses_rs1),
        .uses_rs2(uses_rs2)
    );

    function automatic [31:0] enc_r(
        input [6:0] opcode,
        input [6:0] funct7,
        input [2:0] funct3
    );
        enc_r = { funct7, 5'd2, 5'd1, funct3, 5'd3, opcode};
    endfunction


    function automatic [31:0] enc_i(
        input [6:0] opcode,
        input [11:0] imm,
        input [2:0] funct3
    );
        enc_i = {imm, 5'd1, funct3, 5'd3, opcode};
    endfunction

    function automatic [31:0] enc_s(
        input [6:0] opcode,
        input [2:0] funct3
    );
        enc_s = {7'h00, 5'd2, 5'd1, funct3, 5'h02, opcode};
    endfunction


    function automatic [31:0] enc_b(
        input [6:0] opcode,
        input [2:0] funct3
    );
        enc_b = {7'h00, 5'd2, 5'd1, funct3, 5'h00, opcode};
    endfunction

    task automatic check(
        input [31:0] test_instr,
        input [5:0] flags,
        input e_branch,
        input e_write_rf,
        input [3:0] e_alu_op,
        input e_alu_src,
        input e_is_jalr,
        input [2:0] e_op_width,
        input e_write_ram,
        input [1:0] e_res,
        input e_uses_rs1,
        input e_uses_rs2,
        input string test_name
    );

        logic mismatch;

        begin
            instr = test_instr;
            {beq,bne,blt,bge,bltu,bgeu} = flags;

            #1;

            mismatch = 1'b0;

            if (branch !== e_branch)
                mismatch = 1'b1;

            if (write_rf !== e_write_rf)
                mismatch = 1'b1;

            if (alu_op !== e_alu_op)
                mismatch = 1'b1;

            if (alu_src !== e_alu_src)
                mismatch = 1'b1;

            if (is_jalr !== e_is_jalr)
                mismatch = 1'b1;

            if (op_width !== e_op_width)
                mismatch = 1'b1;

            if (write_ram !== e_write_ram)
                mismatch = 1'b1;

            if (res !== e_res)
                mismatch = 1'b1;

            if (uses_rs1 !== e_uses_rs1)
                mismatch = 1'b1;

            if (uses_rs2 !== e_uses_rs2)
                mismatch = 1'b1;

            if (mismatch) begin
                $display("");
                $display("FAIL: %s", test_name);
                $display("Instruction: %h", instr);
                $display("Signal       Expected    Actual");
                $display("branch       %b           %b", e_branch, branch);
                $display("write_rf     %b           %b",e_write_rf, write_rf);
                $display("alu_op       %b           %b", e_alu_op, alu_op);
                $display("alu_src      %b           %b", e_alu_src, alu_src);
                $display("is_jalr      %b           %b", e_is_jalr, is_jalr);
                $display("op_width     %b           %b", e_op_width, op_width);
                $display("write_ram    %b           %b", e_write_ram, write_ram);
                $display("res          %b           %b", e_res, res);
                $display("uses_rs1     %b           %b", e_uses_rs1, uses_rs1);
                $display("uses_rs2     %b           %b", e_uses_rs2, uses_rs2);
                failed = failed + 1;
            end
            else begin
                $display("PASS: %s", test_name);
                passed = passed + 1;
            end
        end

    endtask

    initial begin

        $dumpfile("sim.vcd");
        $dumpvars(0, testbench);

        instr = 0;
        beq = 0;
        bne = 0;
        blt = 0;
        bge = 0;
        bltu = 0;
        bgeu = 0;

        #5;

        check(enc_r(7'h33,7'h00,3'b000),0,0,1,4'b0000,0,0,0,0,0,1,1,"ADD");
        check(enc_r(7'h33,7'h20,3'b000),0,0,1,4'b0001,0,0,0,0,0,1,1,"SUB");
        check(enc_r(7'h33,7'h00,3'b001),0,0,1,4'b0010,0,0,0,0,0,1,1,"SLL");
        check(enc_r(7'h33,7'h00,3'b010),0,0,1,4'b1000,0,0,0,0,0,1,1,"SLT");
        check(enc_r(7'h33,7'h00,3'b011),0,0,1,4'b1001,0,0,0,0,0,1,1,"SLTU");
        check(enc_r(7'h33,7'h00,3'b100),0,0,1,4'b0111,0,0,0,0,0,1,1,"XOR");
        check(enc_r(7'h33,7'h00,3'b101),0,0,1,4'b0011,0,0,0,0,0,1,1,"SRL");
        check(enc_r(7'h33,7'h20,3'b101),0,0,1,4'b0100,0,0,0,0,0,1,1,"SRA");
        check(enc_r(7'h33,7'h00,3'b110),0,0,1,4'b0110,0,0,0,0,0,1,1,"OR");
        check(enc_r(7'h33,7'h00,3'b111),0,0,1,4'b0101,0,0,0,0,0,1,1,"AND");
        check(enc_i(7'h13,12'h123,3'b000),0,0,1,4'b0000,1,0,0,0,0,1,0,"ADDI");
        check(enc_i(7'h13,12'h123,3'b010),0,0,1,4'b1000,1,0,0,0,0,1,0,"SLTI");
        check(enc_i(7'h13,12'h123,3'b011),0,0,1,4'b1001,1,0,0,0,0,1,0,"SLTIU");
        check(enc_i(7'h13,12'h123,3'b100),0,0,1,4'b0111,1,0,0,0,0,1,0,"XORI");
        check(enc_i(7'h13,12'h123,3'b110),0,0,1,4'b0110,1,0,0,0,0,1,0,"ORI");
        check(enc_i(7'h13,12'h123,3'b111),0,0,1,4'b0101,1,0,0,0,0,1,0,"ANDI");
        check(enc_i(7'h13,12'h001,3'b001),0,0,1,4'b0010,1,0,0,0,0,1,0,"SLLI");
        check(enc_i(7'h13,12'h001,3'b101),0,0,1,4'b0011,1,0,0,0,0,1,0,"SRLI");
        check(enc_i(7'h13,12'h401,3'b101),0,0,1,4'b0100,1,0,0,0,0,1,0,"SRAI");
        check(enc_r(7'h3B,7'h00,3'b000),0,0,1,4'b1010,0,0,0,0,0,1,1,"ADDW");
        check(enc_r(7'h3B,7'h20,3'b000),0,0,1,4'b1011,0,0,0,0,0,1,1,"SUBW");
        check(enc_r(7'h3B,7'h00,3'b001),0,0,1,4'b1100,0,0,0,0,0,1,1,"SLLW");
        check(enc_r(7'h3B,7'h00,3'b101),0,0,1,4'b1101,0,0,0,0,0,1,1,"SRLW");
        check(enc_r(7'h3B,7'h20,3'b101),0,0,1,4'b1110,0,0,0,0,0,1,1,"SRAW");
        check(enc_i(7'h1B,12'h123,3'b000),0,0,1,4'b1010,1,0,0,0,0,1,0,"ADDIW");
        check(enc_i(7'h1B,12'h001,3'b001),0,0,1,4'b1100,1,0,0,0,0,1,0,"SLLIW");
        check(enc_i(7'h1B,12'h001,3'b101),0,0,1,4'b1101,1,0,0,0,0,1,0,"SRLIW");
        check(enc_i(7'h1B,12'h401,3'b101),0,0,1,4'b1110,1,0,0,0,0,1,0,"SRAIW");
        check(enc_i(7'h03,12'h100,3'b000),0,0,1,4'b0000,1,0,3'b000,0,2'b01,1,0,"LB");
        check(enc_i(7'h03,12'h100,3'b001),0,0,1,4'b0000,1,0,3'b001,0,2'b01,1,0,"LH");
        check(enc_i(7'h03,12'h100,3'b010),0,0,1,4'b0000,1,0,3'b010,0,2'b01,1,0,"LW");
        check(enc_i(7'h03,12'h100,3'b011),0,0,1,4'b0000,1,0,3'b011,0,2'b01,1,0,"LD");
        check(enc_i(7'h03,12'h100,3'b100),0,0,1,4'b0000,1,0,3'b100,0,2'b01,1,0,"LBU");
        check(enc_i(7'h03,12'h100,3'b101),0,0,1,4'b0000,1,0,3'b101,0,2'b01,1,0,"LHU");
        check(enc_i(7'h03,12'h100,3'b110),0,0,1,4'b0000,1,0,3'b110,0,2'b01,1,0,"LWU");
        check(enc_s(7'h23,3'b000),0,0,0,4'b0000,1,0,3'b000,1,0,1,1,"SB");
        check(enc_s(7'h23,3'b001),0,0,0,4'b0000,1,0,3'b001,1,0,1,1,"SH");
        check(enc_s(7'h23,3'b010),0,0,0,4'b0000,1,0,3'b010,1,0,1,1,"SW");
        check(enc_s(7'h23,3'b011),0,0,0,4'b0000,1,0,3'b011,1,0,1,1,"SD");
        check(enc_b(7'h63,3'b000),6'b100000,1,0,0,0,0,0,0,0,1,1,"BEQ taken");
        check(enc_b(7'h63,3'b001),6'b010000,1,0,0,0,0,0,0,0,1,1,"BNE taken");
        check(enc_b(7'h63,3'b100),6'b001000,1,0,0,0,0,0,0,0,1,1,"BLT taken");
        check(enc_b(7'h63,3'b101),6'b000100,1,0,0,0,0,0,0,0,1,1,"BGE taken");
        check(enc_b(7'h63,3'b110),6'b000010,1,0,0,0,0,0,0,0,1,1,"BLTU taken");
        check(enc_b(7'h63,3'b111),6'b000001,1,0,0,0,0,0,0,0,1,1,"BGEU taken");
        check(enc_b(7'h63,3'b000),0,0,0,0,0,0,0,0,0,1,1,"BEQ not taken");
        check(enc_b(7'h63,3'b001),0,0,0,0,0,0,0,0,0,1,1,"BNE not taken");
        check(enc_b(7'h63,3'b100),0,0,0,0,0,0,0,0,0,1,1,"BLT not taken");
        check(enc_b(7'h63,3'b101),0,0,0,0,0,0,0,0,0,1,1,"BGE not taken");
        check(enc_b(7'h63,3'b110),0,0,0,0,0,0,0,0,0,1,1,"BLTU not taken");
        check(enc_b(7'h63,3'b111),0,0,0,0,0,0,0,0,0,1,1,"BGEU not taken");
        check({20'h12345,5'd3,7'h17},0,0,1,0,0,0,0,0,2'b11,0,0,"AUIPC");
        check({20'h12345,5'd3,7'h37},0,0,1,4'b1111,1,0,0,0,0,0,0,"LUI");
        check({20'h12345,5'd3,7'h6F},0,1,1,0,0,0,0,0,2'b10,0,0,"JAL");
        check(enc_i(7'h67,12'h100,3'b000),0,1,1,0,0,1,0,0,2'b10,1,0,"JALR");
        check(32'h00000000,0,0,0,0,0,0,0,0,0,0,0,"Invalid opcode 0");
        check(32'hFFFFFFFF,0,0,0,0,0,0,0,0,0,0,0,"Invalid opcode FFFFFFFF");
        check(32'h0000007F,0,0,0,0,0,0,0,0,0,0,0,"Invalid opcode 7F");
        check(enc_r(7'h33,7'h7F,3'b000),0,0,0,0,0,0,0,0,0,0,0,"Invalid ADD funct7");
        check(enc_r(7'h33,7'h01,3'b101),0,0,0,0,0,0,0,0,0,0,0,"Invalid SRL funct7");
        check(enc_r(7'h33,7'h20,3'b001),0,0,0,0,0,0,0,0,0,0,0,"Invalid SLL funct7");
        check(enc_i(7'h13,12'h401,3'b001),0,0,0,0,0,0,0,0,0,0,0,"Invalid SLLI");
        check(enc_i(7'h13,12'h801,3'b101),0,0,0,0,0,0,0,0,0,0,0,"Invalid SRLI/SRAI");
        check(enc_r(7'h3B,7'h01,3'b000),0,0,0,0,0,0,0,0,0,0,0,"Invalid ADDW funct7");
        check(enc_r(7'h3B,7'h20,3'b001),0,0,0,0,0,0,0,0,0,0,0,"Invalid SLLW funct7");
        check(enc_i(7'h1B,12'h401,3'b001),0,0,0,0,0,0,0,0,0,0,0,"Invalid SLLIW");
        check(enc_i(7'h03,12'h100,3'b111),0,0,0,0,0,0,0,0,0,0,0,"Invalid LOAD funct3");
        check(enc_s(7'h23,3'b100),0,0,0,0,0,0,0,0,0,0,0,"Invalid STORE funct3");
        check(enc_b(7'h63,3'b010),0,0,0,0,0,0,0,0,0,0,0,"Invalid BRANCH funct3 010");
        check(enc_b(7'h63,3'b011),0,0,0,0,0,0,0,0,0,0,0,"Invalid BRANCH funct3 011");
        check(enc_i(7'h67,12'h100,3'b001),0,0,0,0,0,0,0,0,0,0,0,"Invalid JALR funct3");

        $display("Passed : %0d",passed);
        $display("Failed : %0d",failed);

        if (failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED");

        $finish;

    end

endmodule
