`timescale 1ns/1ns
`include "ex.sv"

module testbench;

  parameter W = 64;
  parameter MOPS = 15;

  logic [W-1:0] pc;
  logic [W-1:0] rs1;
  logic [W-1:0] rs2;
  logic [W-1:0] imm;
  logic is_jalr;
  logic [$clog2(MOPS)-1:0] alu_op;
  logic alu_src;
  logic beq;
  logic bne;
  logic blt;
  logic bge;
  logic bltu;
  logic bgeu;
  logic [W-1:0] out;
  logic [W-1:0] t_out;
  logic [W-1:0] r_out;

  EX #(
    .W(W),
    .MOPS(MOPS)
  ) dut (
    .pc(pc),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .is_jalr(is_jalr),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .beq(beq),
    .bne(bne),
    .blt(blt),
    .bge(bge),
    .bltu(bltu),
    .bgeu(bgeu),
    .out(out),
    .t_out(t_out),
    .r_out(r_out)
  );

  initial begin

    $monitor("time = %0t | pc = %016h | rs1 = %016h | rs2 = %016h | imm = %016h | alu_op = %b | alu_src = %b | is_jalr = %b | out = %016h | beq = %b | bne = %b | blt = %b | bge = %b | bltu = %b | bgeu = %b | t_out = %016h | r_out = %016h", $time, pc, rs1, rs2, imm, alu_op, alu_src, is_jalr, out, beq, bne, blt, bge, bltu, bgeu, t_out, r_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    pc = 64'h1000;
    rs1 = 64'h50;
    rs2 = 64'h10;
    imm = 64'h20;
    alu_op = 4'd0;
    alu_src = 0;
    is_jalr = 0;
    #1;

    rs1 = 64'h50;
    rs2 = 64'h10;
    alu_op = 4'd1;
    #1;

    rs1 = 64'h1;
    rs2 = 64'd4;
    alu_op = 4'd2;
    #1;

    rs1 = 64'h100;
    rs2 = 64'd4;
    alu_op = 4'd3;
    #1;

    rs1 = 64'h8000000000000000;
    rs2 = 64'd4;
    alu_op = 4'd4;
    #1;

    rs1 = 64'hFF00;
    rs2 = 64'h0FF0;
    alu_op = 4'd5;
    #1;

    alu_op = 4'd6;
    #1;

    alu_op = 4'd7;
    #1;

    rs1 = -64'd10;
    rs2 = 64'd5;
    alu_op = 4'd8;
    #1;

    rs1 = 64'hFFFFFFFFFFFFFFF0;
    rs2 = 64'h10;
    alu_op = 4'd9;
    #1;

    rs1 = 64'h000000007FFFFFFF;
    rs2 = 64'h1;
    alu_op = 4'd10;
    #1;

    rs1 = 64'h0000000000000005;
    rs2 = 64'h000000000000000A;
    alu_op = 4'd11;
    #1;

    rs1 = 64'h0000000000000001;
    rs2 = 64'd31;
    alu_op = 4'd12;
    #1;

    rs1 = 64'h0000000080000000;
    rs2 = 64'd1;
    alu_op = 4'd13;
    #1;

    rs1 = 64'h0000000080000000;
    rs2 = 64'd1;
    alu_op = 4'd14;
    #1;

    rs1 = 64'h50;
    imm = 64'h10;
    alu_op = 4'd0;
    alu_src = 1;
    #1;

    rs1 = 64'h7FFFFFFF;
    imm = 64'h1;
    alu_op = 4'd10;
    #1;

    rs1 = 64'h100;
    rs2 = 64'h100;
    alu_src = 0;
    alu_op = 4'd0;
    #1;

    rs1 = 64'h100;
    rs2 = 64'h200;
    #1;

    rs1 = -64'd5;
    rs2 = 64'd5;
    #1;

    rs1 = 64'hFFFFFFFFFFFFFFF0;
    rs2 = 64'h10;
    #1;

    pc = 64'h1000;
    imm = 64'h20;
    is_jalr = 0;
    #1;

    rs1 = 64'h1003;
    imm = 64'h10;
    is_jalr = 1;
    #1;

    pc = 64'h2000;
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule
