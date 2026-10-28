`timescale 1ns/1ns
`include "tag.sv"

module testbench;

  parameter W = 64;

  logic [W-1:0] rs1;
  logic [W-1:0] imm;
  logic [W-1:0] pc;
  logic is_jalr;
  logic [W-1:0] t_out;
  logic [W-1:0] r_out;

  tag #(
    .W(W)
  ) dut (
    .rs1(rs1),
    .imm(imm),
    .pc(pc),
    .is_jalr(is_jalr),
    .t_out(t_out),
    .r_out(r_out)
  );

  initial begin

    $monitor("time = %0t | rs1 = %h | imm = %h | pc = %h | is_jalr = %b | t_out = %h | r_out = %h", $time, rs1, imm, pc, is_jalr, t_out, r_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    rs1 = 64'h0000000000000050;
    imm = 64'h0000000000000010;
    pc = 64'h0000000000001000;
    is_jalr = 0;
    #1;

    rs1 = 64'h0000000000000050;
    imm = 64'hFFFFFFFFFFFFFFF0;
    pc = 64'h0000000000001000;
    is_jalr = 0;
    #1;

    rs1 = 64'h0000000000000100;
    imm = 64'h0000000000000000;
    pc = 64'h0000000000002000;
    is_jalr = 0;
    #1;

    rs1 = 64'h0000000000000000;
    imm = 64'h0000000000000008;
    pc = 64'hFFFFFFFFFFFFFFFC;
    is_jalr = 0;
    #1;

    rs1 = 64'h0000000000003000;
    imm = 64'h0000000000000020;
    pc = 64'h0000000000008000;
    is_jalr = 1;
    #1;

    rs1 = 64'h0000000000001003;
    imm = 64'h0000000000000010;
    pc = 64'h0000000000004000;
    is_jalr = 1;
    #1;

    rs1 = 64'h0000000000001000;
    imm = 64'h0000000000000003;
    pc = 64'h0000000000004000;
    is_jalr = 1;
    #1;

    rs1 = 64'h0000000000002000;
    imm = 64'hFFFFFFFFFFFFFFF8;
    pc = 64'h0000000000005000;
    is_jalr = 1;
    #1;

    rs1 = 64'hFFFFFFFFFFFFFFFE;
    imm = 64'h0000000000000001;
    pc = 64'h0000000000006000;
    is_jalr = 1;
    #1;

    rs1 = 64'h0000000000007000;
    imm = 64'h0000000000000000;
    pc = 64'h0000000000009000;
    is_jalr = 1;
    #1;

    rs1 = 64'h0000000000005000;
    imm = 64'h0000000000000004;
    pc = 64'h000000000000A000;
    is_jalr = 0;
    #1;

    rs1 = 64'h0000000000000000;
    imm = 64'h0000000000000000;
    pc = 64'hFFFFFFFFFFFFFFFC;
    is_jalr = 1;
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule
