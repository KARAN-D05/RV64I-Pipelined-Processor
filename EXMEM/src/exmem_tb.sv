`timescale 1ns/1ns
`include "exmem.sv"

module testbench;

  parameter NCS = 9;
  parameter F = 5;
  parameter W = 64;

  logic [W-1:0] alu_in;
  logic [W-1:0] data_in2;
  logic [W-1:0] r_in;
  logic [W-1:0] t_in;
  logic [NCS-1:0] c_word_in;
  logic [F-1:0] rs2;
  logic [F-1:0] rd;
  logic rst;
  logic clk;

  logic [W-1:0] alu_out;
  logic [W-1:0] data_out2;
  logic [W-1:0] r_out;
  logic [W-1:0] t_out;
  logic [NCS-1:0] c_word_out;
  logic [F-1:0] rs2_out;
  logic [F-1:0] rd_out;

  EXMEM #(
    .W(W),
    .F(F),
    .NCS(NCS)
  ) dut (
    .alu_in(alu_in),
    .data_in2(data_in2),
    .r_in(r_in),
    .t_in(t_in),
    .c_word_in(c_word_in),
    .rs2(rs2),
    .rd(rd),
    .rst(rst),
    .clk(clk),
    .alu_out(alu_out),
    .data_out2(data_out2),
    .r_out(r_out),
    .t_out(t_out),
    .c_word_out(c_word_out),
    .rs2_out(rs2_out),
    .rd_out(rd_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor("t = %0t | rst = %0b | alu_in = %016h | data_in2 = %016h | r_in = %016h | t_in = %016h | c_word_in = %03h | rs2 = %0d | rd = %0d | alu_out = %016h | data_out2 = %016h | r_out = %016h | t_out = %016h | c_word_out = %03h | rs2_out = %0d | rd_out = %0d",
             $time, rst, alu_in, data_in2, r_in, t_in, c_word_in, rs2, rd,
             alu_out, data_out2, r_out, t_out, c_word_out, rs2_out, rd_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    rst = 1'b0;
    alu_in = 0;
    data_in2 = 0;
    r_in = 0;
    t_in = 0;
    c_word_in = 0;
    rs2 = 0;
    rd = 0;

    #2;
    rst = 1'b1;

    #2;
    rst = 1'b0;

    @(negedge clk);
    #1;
    alu_in = 64'hAAAA_AAAA_AAAA_AAAA;
    data_in2 = 64'hBBBB_BBBB_BBBB_BBBB;
    r_in = 64'h0000_0000_0000_1004;
    t_in = 64'h0000_0000_0000_1020;
    c_word_in = 9'b101_101_011;
    rs2 = 5'd2;
    rd = 5'd3;

    @(negedge clk);
    #1;
    alu_in = 64'h1234_5678_9ABC_DEF0;
    data_in2 = 64'hFEDC_BA98_7654_3210;
    r_in = 64'h0000_0000_0000_2004;
    t_in = 64'h0000_0000_0000_2040;
    c_word_in = 9'b010_110_100;
    rs2 = 5'd11;
    rd = 5'd12;

    @(negedge clk);
    #1;
    alu_in = 64'h0000_0000_0000_0001;
    data_in2 = 64'h0000_0000_0000_0002;
    r_in = 64'h0000_0000_0000_3004;
    t_in = 64'h0000_0000_0000_300C;
    c_word_in = 9'b000_000_000;
    rs2 = 5'd21;
    rd = 5'd22;

    @(negedge clk);
    #1;
    rst = 1'b1;

    #1;
    rst = 1'b0;
    alu_in = 64'hFFFF_FFFF_FFFF_FFFF;
    data_in2 = 64'h1111_1111_1111_1111;
    r_in = 64'h0000_0000_0000_4004;
    t_in = 64'h0000_0000_0000_4040;
    c_word_in = 9'b111_111_111;
    rs2 = 5'd6;
    rd = 5'd7;

    @(negedge clk);
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule
