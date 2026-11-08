`timescale 1ns/1ps
`include "id.sv"

module testbench;

    parameter W = 64;
    parameter IW = 32;

    logic [$clog2(IW)-1:0] Raddr1, Raddr2, Waddr;
    logic [W-1:0] data_in;
    logic write, clk;
    logic [IW-1:0] instr;
    logic branch, write_rf;
    logic [3:0] alu_op;
    logic alu_src, is_jalr;
    logic [2:0] op_width;
    logic write_ram;
    logic [1:0] res;
    logic uses_rs1, uses_rs2;
    logic [2:0] funct3;
    logic is_load;
    logic [W-1:0] imm;
    logic [W-1:0] data_out1, data_out2;

    integer passed = 0;
    integer failed = 0;

    initial clk = 0;
    always #5 clk = ~clk;

    ID #(
        .W(64),
        .IW(32),
        .MOPS(16),
        .MMOPS(7),
        .WBS(4),
        .FB(3)
    ) dut (
        .Raddr1(Raddr1),
        .Raddr2(Raddr2),
        .Waddr(Waddr),
        .data_in(data_in),
        .write(write),
        .clk(clk),
        .instr(instr),

        .branch(branch),
        .write_rf(write_rf),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .is_jalr(is_jalr),
        .op_width(op_width),
        .write_ram(write_ram),
        .res(res),

        .uses_rs1(uses_rs1),
        .uses_rs2(uses_rs2),
        .funct3(funct3),
        .is_load(is_load),

        .imm(imm),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    task automatic write_reg(
        input logic [4:0] addr,
        input logic [63:0] value
    );
        begin
            @(negedge clk);

            Waddr = addr;
            data_in = value;
            write = 1'b1;

            @(posedge clk);
            #1;

            write = 1'b0;
        end
    endtask

    task automatic check(
        input logic condition,
        input string test_name
    );
        begin
            if (condition === 1'b1) begin
                $display("PASS: %s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %s", test_name);
                failed = failed + 1;
            end
        end
    endtask

    initial begin

        $dumpfile("sim.vcd");
        $dumpvars(0, testbench);

        Raddr1 = 0;
        Raddr2 = 0;
        Waddr = 0;
        data_in = 0;
        write = 0;
        instr = 0;

        #2;

        write_reg(5'd1, 64'd10);
        write_reg(5'd2, 64'd20);

        Raddr1 = 5'd1;
        Raddr2 = 5'd2;

        #2;

        check(data_out1 == 64'd10, "RF read port 1");
        check(data_out2 == 64'd20, "RF read port 2");

        instr = 32'h002081B3;
        Raddr1 = 5'd1;
        Raddr2 = 5'd2;

        #2;

        check(data_out1 == 64'd10, "ADD rs1 data");
        check(data_out2 == 64'd20, "ADD rs2 data");
        check(write_rf == 1'b1, "ADD write_rf");
        check(alu_op == 4'b0000, "ADD alu_op");
        check(alu_src == 1'b0, "ADD alu_src");
        check(uses_rs1 == 1'b1, "ADD uses_rs1");
        check(uses_rs2 == 1'b1, "ADD uses_rs2");
        check(is_load == 1'b0, "ADD is_load");

        instr = 32'h00508213;
        Raddr1 = 5'd1;
        Raddr2 = 5'd0;

        #2;

        check(imm == 64'd5, "ADDI immediate");
        check(data_out1 == 64'd10, "ADDI rs1 data");
        check(write_rf == 1'b1, "ADDI write_rf");
        check(alu_src == 1'b1, "ADDI alu_src");
        check(alu_op == 4'b0000, "ADDI alu_op");
        check(uses_rs1 == 1'b1, "ADDI uses_rs1");
        check(uses_rs2 == 1'b0, "ADDI uses_rs2");

        instr = 32'h0080A283;
        Raddr1 = 5'd1;

        #2;

        check(imm == 64'd8, "LW immediate");
        check(alu_src == 1'b1, "LW alu_src");
        check(write_rf == 1'b1, "LW write_rf");
        check(op_width == 3'b010, "LW op_width");
        check(res == 2'b01, "LW result selection");
        check(uses_rs1 == 1'b1, "LW uses_rs1");
        check(uses_rs2 == 1'b0, "LW uses_rs2");
        check(is_load == 1'b1, "LW is_load");

        instr = 32'h0020A623;
        Raddr1 = 5'd1;
        Raddr2 = 5'd2;

        #2;

        check(imm == 64'd12, "SW immediate");
        check(data_out1 == 64'd10, "SW address operand");
        check(data_out2 == 64'd20, "SW store data");
        check(write_ram == 1'b1, "SW write_ram");
        check(write_rf == 1'b0, "SW write_rf");
        check(alu_src == 1'b1, "SW alu_src");
        check(op_width == 3'b010, "SW op_width");
        check(uses_rs1 == 1'b1, "SW uses_rs1");
        check(uses_rs2 == 1'b1, "SW uses_rs2");
        check(is_load == 1'b0, "SW is_load");

        instr = 32'h00208463;
        Raddr1 = 5'd1;
        Raddr2 = 5'd2;

        #2;

        check(branch == 1'b1, "BEQ branch");
        check(funct3 == 3'b000, "BEQ funct3");
        check(write_rf == 1'b0, "BEQ write_rf");
        check(uses_rs1 == 1'b1, "BEQ uses_rs1");
        check(uses_rs2 == 1'b1, "BEQ uses_rs2");

        instr = 32'h00209463;

        #2;

        check(branch == 1'b1, "BNE branch");
        check(funct3 == 3'b001, "BNE funct3");

        instr = 32'h123451B7;

        #2;

        check(write_rf == 1'b1, "LUI write_rf");
        check(alu_op == 4'b1111, "LUI alu_op");
        check(alu_src == 1'b1, "LUI alu_src");
        check(uses_rs1 == 1'b0, "LUI uses_rs1");
        check(uses_rs2 == 1'b0, "LUI uses_rs2");

        instr = {12'd5, 5'd1, 3'b000, 5'd4, 7'b0011011};
        Raddr1 = 5'd1;
        Raddr2 = 5'd0;

        #2;

        check(imm == 64'd5, "ADDIW immediate");
        check(alu_op == 4'b1010, "ADDIW alu_op");
        check(alu_src == 1'b1, "ADDIW alu_src");
        check(write_rf == 1'b1, "ADDIW write_rf");
        check(uses_rs1 == 1'b1, "ADDIW uses_rs1");
        check(uses_rs2 == 1'b0, "ADDIW uses_rs2");
        
        instr = {7'b0000000, 5'd5, 5'd1, 3'b001, 5'd4, 7'b0011011};

        #2;

        check(imm == 64'd5, "SLLIW shift immediate");
        check(alu_op == 4'b1100, "SLLIW alu_op");
        check(alu_src == 1'b1, "SLLIW alu_src");
        check(write_rf == 1'b1, "SLLIW write_rf");
        
        instr = {7'b0000000, 5'd17, 5'd1, 3'b101, 5'd4, 7'b0011011};

        #2;

        check(imm == 64'd17, "SRLIW shift immediate");
        check(alu_op == 4'b1101, "SRLIW alu_op");
        check(alu_src == 1'b1, "SRLIW alu_src");
        check(write_rf == 1'b1, "SRLIW write_rf");

        instr = {7'b0100000, 5'd9, 5'd1, 3'b101, 5'd4, 7'b0011011};

        #2;

        check(imm == 64'd9, "SRAIW shift immediate");
        check(alu_op == 4'b1110, "SRAIW alu_op");
        check(alu_src == 1'b1, "SRAIW alu_src");
        check(write_rf == 1'b1, "SRAIW write_rf");

        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);

        if (failed == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED");

        $finish;

    end

endmodule
