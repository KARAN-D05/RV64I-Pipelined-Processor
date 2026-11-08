`timescale 1ns/1ns
`include "memwb.sv"

module testbench;

  parameter NCS = 3;
  parameter F = 5;
  parameter W = 64;

  logic [W-1:0] mem_in;
  logic [W-1:0] alu_in;
  logic [W-1:0] r_in;
  logic [W-1:0] t_in;
  logic [NCS-1:0] c_word_in;
  logic [F-1:0] rd;
  logic rst;
  logic clk;

  logic [W-1:0] mem_out;
  logic [W-1:0] alu_out;
  logic [W-1:0] r_out;
  logic [W-1:0] t_out;
  logic [NCS-1:0] c_word_out;
  logic [F-1:0] rd_out;

  MEMWB #(
    .W(W),
    .NCS(NCS),
    .F(F)
  ) dut (
    .mem_in(mem_in),
    .alu_in(alu_in),
    .r_in(r_in),
    .t_in(t_in),
    .c_word_in(c_word_in),
    .rd(rd),
    .rst(rst),
    .clk(clk),
    .mem_out(mem_out),
    .alu_out(alu_out),
    .r_out(r_out),
    .t_out(t_out),
    .c_word_out(c_word_out),
    .rd_out(rd_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor("t = %0t | rst = %0b | mem_in = %016h | alu_in = %016h | r_in = %016h | t_in = %016h | c_word_in = %03b | rd = %0d | mem_out = %016h | alu_out = %016h | r_out = %016h | t_out = %016h | c_word_out = %03b | rd_out = %0d",
             $time, rst, mem_in, alu_in, r_in, t_in, c_word_in, rd,
             mem_out, alu_out, r_out, t_out, c_word_out, rd_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    rst = 1'b0;
    mem_in = 0;
    alu_in = 0;
    r_in = 0;
    t_in = 0;
    c_word_in = 0;
    rd = 0;

    #2;
    rst = 1'b1;

    #2;
    rst = 1'b0;

    @(negedge clk);
    #1;
    mem_in = 64'hAAAA_AAAA_AAAA_AAAA;
    alu_in = 64'hBBBB_BBBB_BBBB_BBBB;
    r_in = 64'h0000_0000_0000_1004;
    t_in = 64'h0000_0000_0000_1020;
    c_word_in = 3'b001;
    rd = 5'd3;

    @(negedge clk);
    #1;
    mem_in = 64'h1234_5678_9ABC_DEF0;
    alu_in = 64'hFEDC_BA98_7654_3210;
    r_in = 64'h0000_0000_0000_2004;
    t_in = 64'h0000_0000_0000_2040;
    c_word_in = 3'b010;
    rd = 5'd12;

    @(negedge clk);
    #1;
    mem_in = 64'h0000_0000_0000_0001;
    alu_in = 64'h0000_0000_0000_0002;
    r_in = 64'h0000_0000_0000_3004;
    t_in = 64'h0000_0000_0000_300C;
    c_word_in = 3'b000;
    rd = 5'd22;

    @(negedge clk);
    #1;
    rst = 1'b1;

    #1;
    rst = 1'b0;
    mem_in = 64'hFFFF_FFFF_FFFF_FFFF;
    alu_in = 64'h1111_1111_1111_1111;
    r_in = 64'h0000_0000_0000_4004;
    t_in = 64'h0000_0000_0000_4040;
    c_word_in = 3'b111;
    rd = 5'd7;

    @(negedge clk);
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule