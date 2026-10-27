`timescale 1ns/1ns
`include "alu.sv"

module testbench;

  parameter W = 64;
  parameter MOPS = 10;

  logic [W-1:0] rs1;
  logic [W-1:0] rs2;
  logic [W-1:0] imm;
  logic [$clog2(MOPS)-1:0] alu_op;
  logic alu_src;
  logic [W-1:0] out;
  logic beq;
  logic bne;
  logic blt;
  logic bge;
  logic bltu;
  logic bgeu;

  alu #(
    .MOPS(MOPS),
    .W(W)
  ) dut (
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .out(out),
    .beq(beq),
    .bne(bne),
    .blt(blt),
    .bge(bge),
    .bltu(bltu),
    .bgeu(bgeu)
  );

  initial begin

    $monitor("t = %0t | rs1 = %016h | rs2 = %016h | imm = %016h | alu_op = %04b | alu_src = %b | out = %016h | beq = %b | bne = %b | blt = %b | bge = %b | bltu = %b | bgeu = %b", $time, rs1, rs2, imm, alu_op, alu_src, out, beq, bne, blt, bge, bltu, bgeu);

    $dumpfile("sim.vcd");
    $dumpvars(0, testbench);

    alu_src = 0; rs1 = 64'd10; rs2 = 64'd20; imm = 64'd5; alu_op = 0;
    #5; if (out !== 64'd30) $error("ADD test 1 failed");

    alu_src = 1; rs1 = 64'd10; rs2 = 64'd20; imm = 64'd5; alu_op = 0;
    #5; if (out !== 64'd15) $error("ADD immediate-source test failed");

    alu_src = 0; rs1 = 64'h7FFFFFFFFFFFFFFF; rs2 = 64'd1; alu_op = 0;
    #5; if (out !== 64'h8000000000000000) $error("ADD overflow-wrap test failed");

    alu_src = 0; rs1 = 64'hFFFFFFFFFFFFFFFF; rs2 = 64'd1; alu_op = 0;
    #5; if (out !== 64'd0) $error("ADD carry-wrap test failed");

    alu_src = 0; rs1 = 64'd20; rs2 = 64'd7; alu_op = 1;
    #5; if (out !== 64'd13) $error("SUB test 1 failed");

    rs1 = 64'd7; rs2 = 64'd20;
    #5; if (out !== 64'hFFFFFFFFFFFFFFF3) $error("SUB negative-result test failed");

    rs1 = 64'd5; rs2 = 64'd5;
    #5; if (out !== 64'd0) $error("SUB equal-operands test failed");

    alu_src = 0; rs1 = 64'd1; rs2 = 64'd4; alu_op = 2;
    #5; if (out !== 64'd16) $error("SLL test 1 failed");

    rs1 = 64'd1; rs2 = 64'd63;
    #5; if (out !== 64'h8000000000000000) $error("SLL shift-63 test failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; rs2 = 64'd0;
    #5; if (out !== 64'hFFFFFFFFFFFFFFFF) $error("SLL shift-0 test failed");

    rs1 = 64'h8000000000000000; rs2 = 64'd1; alu_op = 3;
    #5; if (out !== 64'h4000000000000000) $error("SRL logical-zero-fill test failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; rs2 = 64'd63;
    #5; if (out !== 64'd1) $error("SRL shift-63 test failed");

    rs1 = 64'h8000000000000000; rs2 = 64'd1; alu_op = 4;
    #5; if (out !== 64'hC000000000000000) $error("SRA negative-number test failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; rs2 = 64'd63;
    #5; if (out !== 64'hFFFFFFFFFFFFFFFF) $error("SRA sign-extension test failed");

    rs1 = 64'h7FFFFFFFFFFFFFFF; rs2 = 64'd1;
    #5; if (out !== 64'h3FFFFFFFFFFFFFFF) $error("SRA positive-number test failed");

    alu_src = 0; rs1 = 64'hF0F0; rs2 = 64'hFF00; alu_op = 5;
    #5; if (out !== 64'hF000) $error("AND test failed");

    rs1 = 64'hF0F0; rs2 = 64'h0F0F; alu_op = 6;
    #5; if (out !== 64'hFFFF) $error("OR test failed");

    rs1 = 64'hFFFF; rs2 = 64'h0F0F; alu_op = 7;
    #5; if (out !== 64'hF0F0) $error("XOR test failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; rs2 = 64'd1; alu_op = 8;
    #5; if (out !== 64'd1) $error("SLT -1 < 1 test failed");

    rs1 = 64'h8000000000000000; rs2 = 64'd0;
    #5; if (out !== 64'd1) $error("SLT minimum signed value test failed");

    rs1 = 64'd1; rs2 = 64'hFFFFFFFFFFFFFFFF;
    #5; if (out !== 64'd0) $error("SLT 1 < -1 test failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; rs2 = 64'd1; alu_op = 9;
    #5; if (out !== 64'd0) $error("SLTU unsigned comparison test 1 failed");

    rs1 = 64'd1; rs2 = 64'hFFFFFFFFFFFFFFFF;
    #5; if (out !== 64'd1) $error("SLTU unsigned comparison test 2 failed");

    rs1 = 64'd0; rs2 = 64'd0;
    #5; if (out !== 64'd0) $error("SLTU equality test failed");

    alu_op = 10;
    #5; if (out !== 64'd0) $error("Invalid alu_op 10 failed");

    alu_op = 11;
    #5; if (out !== 64'd0) $error("Invalid alu_op 11 failed");

    alu_op = 12;
    #5; if (out !== 64'd0) $error("Invalid alu_op 12 failed");

    alu_op = 13;
    #5; if (out !== 64'd0) $error("Invalid alu_op 13 failed");

    alu_op = 14;
    #5; if (out !== 64'd0) $error("Invalid alu_op 14 failed");

    alu_op = 15;
    #5; if (out !== 64'd0) $error("Invalid alu_op 15 failed");

    rs1 = 64'd5; rs2 = 64'd5; alu_op = 0;
    #5;
    if (beq !== 1'b1) $error("BEQ equal test failed");
    if (bne !== 1'b0) $error("BNE equal test failed");
    if (blt !== 1'b0) $error("BLT equal test failed");
    if (bge !== 1'b1) $error("BGE equal test failed");
    if (bltu !== 1'b0) $error("BLTU equal test failed");
    if (bgeu !== 1'b1) $error("BGEU equal test failed");

    rs1 = 64'd3; rs2 = 64'd8;
    #5;
    if (beq !== 1'b0) $error("BEQ unequal test failed");
    if (bne !== 1'b1) $error("BNE unequal test failed");
    if (blt !== 1'b1) $error("BLT positive test failed");
    if (bge !== 1'b0) $error("BGE positive test failed");
    if (bltu !== 1'b1) $error("BLTU positive test failed");
    if (bgeu !== 1'b0) $error("BGEU positive test failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; rs2 = 64'd1;
    #5;
    if (blt !== 1'b1) $error("BLT signed -1 < 1 failed");
    if (bge !== 1'b0) $error("BGE signed -1 >= 1 failed");
    if (bltu !== 1'b0) $error("BLTU unsigned max < 1 failed");
    if (bgeu !== 1'b1) $error("BGEU unsigned max >= 1 failed");

    rs1 = 64'h8000000000000000; rs2 = 64'h7FFFFFFFFFFFFFFF;
    #5;
    if (blt !== 1'b1) $error("BLT signed minimum test failed");
    if (bge !== 1'b0) $error("BGE signed minimum test failed");
    if (bltu !== 1'b0) $error("BLTU unsigned comparison test failed");
    if (bgeu !== 1'b1) $error("BGEU unsigned comparison test failed");

    alu_src = 1; rs1 = 64'd1; imm = 64'd4; alu_op = 2;
    #5; if (out !== 64'd16) $error("SLLI test 1 failed");

    rs1 = 64'd1; imm = 64'd63; alu_op = 2;
    #5; if (out !== 64'h8000000000000000) $error("SLLI test 2 failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; imm = 64'd0; alu_op = 2;
    #5; if (out !== 64'hFFFFFFFFFFFFFFFF) $error("SLLI shift-0 failed");

    rs1 = 64'h8000000000000000; imm = 64'd1; alu_op = 3;
    #5; if (out !== 64'h4000000000000000) $error("SRLI test 1 failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; imm = 64'd63; alu_op = 3;
    #5; if (out !== 64'd1) $error("SRLI test 2 failed");

    rs1 = 64'h8000000000000000; imm = 64'd0; alu_op = 3;
    #5; if (out !== 64'h8000000000000000) $error("SRLI shift-0 failed");

    rs1 = 64'h8000000000000000; imm = 64'd1; alu_op = 4;
    #5; if (out !== 64'hC000000000000000) $error("SRAI test 1 failed");

    rs1 = 64'hFFFFFFFFFFFFFFFF; imm = 64'd63; alu_op = 4;
    #5; if (out !== 64'hFFFFFFFFFFFFFFFF) $error("SRAI test 2 failed");

    rs1 = 64'h7FFFFFFFFFFFFFFF; imm = 64'd1; alu_op = 4;
    #5; if (out !== 64'h3FFFFFFFFFFFFFFF) $error("SRAI test 3 failed");

    rs1 = 64'h8000000000000000; imm = 64'd64; alu_op = 3;
    #5; if (out !== 64'h8000000000000000) $error("SRLI truncation test failed");

    $display("Simulation Complete!");
    $finish;

  end

endmodule