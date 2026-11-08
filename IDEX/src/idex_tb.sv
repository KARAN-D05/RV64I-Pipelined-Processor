`timescale 1ns/1ns
`include "idex.sv"

module testbench;

  parameter NCS = 20;
  parameter F = 5;
  parameter W = 64;

  logic [W-1:0] data_in1;
  logic [W-1:0] data_in2;
  logic [W-1:0] pc_in;
  logic [W-1:0] imm_in;
  logic [F-1:0] rs1;
  logic [F-1:0] rs2;
  logic [F-1:0] rd;
  logic [NCS-1:0] c_word_in;
  logic clk;
  logic rst;
  logic [W-1:0] data_out1;
  logic [W-1:0] data_out2;
  logic [W-1:0] pc_out;
  logic [W-1:0] imm_out;
  logic [F-1:0] rs1_out;
  logic [F-1:0] rs2_out;
  logic [F-1:0] rd_out;
  logic [NCS-1:0] c_word_out;

  IDEX #(
    .NCS(NCS),
    .F(F),
    .W(W)
  ) dut (
    .data_in1(data_in1),
    .data_in2(data_in2),
    .pc_in(pc_in),
    .imm_in(imm_in),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .c_word_in(c_word_in),
    .clk(clk),
    .rst(rst),
    .data_out1(data_out1),
    .data_out2(data_out2),
    .pc_out(pc_out),
    .imm_out(imm_out),
    .rs1_out(rs1_out),
    .rs2_out(rs2_out),
    .rd_out(rd_out),
    .c_word_out(c_word_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor("t = %0t | rst = %0b | data_in1 = %016h | data_in2 = %016h | pc_in = %016h | imm_in = %016h | rs1 = %0d | rs2 = %0d | rd = %0d | c_word_in = %05h | data_out1 = %016h | data_out2 = %016h | pc_out = %016h | imm_out = %016h | rs1_out = %0d | rs2_out = %0d | rd_out = %0d | c_word_out = %05h",
             $time, rst, data_in1, data_in2, pc_in, imm_in, rs1, rs2, rd, c_word_in,
             data_out1, data_out2, pc_out, imm_out, rs1_out, rs2_out, rd_out, c_word_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    rst = 1'b0;
    data_in1 = 0;
    data_in2 = 0;
    pc_in = 0;
    imm_in = 0;
    rs1 = 0;
    rs2 = 0;
    rd = 0;
    c_word_in = 0;

    #2;
    rst = 1'b1;

    #2;
    rst = 1'b0;

    @(negedge clk);
    #1;
    data_in1 = 64'hAAAA_AAAA_AAAA_AAAA;
    data_in2 = 64'hBBBB_BBBB_BBBB_BBBB;
    pc_in = 64'h0000_0000_0000_1000;
    imm_in = 64'h0000_0000_0000_0020;
    rs1 = 5'd1;
    rs2 = 5'd2;
    rd = 5'd3;
    c_word_in = 20'hABCDE;

    @(negedge clk);
    #1;
    data_in1 = 64'h1234_5678_9ABC_DEF0;
    data_in2 = 64'hFEDC_BA98_7654_3210;
    pc_in = 64'h0000_0000_0000_1004;
    imm_in = 64'hFFFF_FFFF_FFFF_FFF8;
    rs1 = 5'd10;
    rs2 = 5'd11;
    rd = 5'd12;
    c_word_in = 20'h54321;

    @(negedge clk);
    #1;
    data_in1 = 64'h0000_0000_0000_0001;
    data_in2 = 64'h0000_0000_0000_0002;
    pc_in = 64'h0000_0000_0000_1008;
    imm_in = 64'h0000_0000_0000_000C;
    rs1 = 5'd20;
    rs2 = 5'd21;
    rd = 5'd22;
    c_word_in = 20'h00000;

    @(negedge clk);
    #1;
    rst = 1'b1;

    #1;
    rst = 1'b0;
    data_in1 = 64'hFFFF_FFFF_FFFF_FFFF;
    data_in2 = 64'h1111_1111_1111_1111;
    pc_in = 64'h0000_0000_0000_2000;
    imm_in = 64'h0000_0000_0000_0040;
    rs1 = 5'd5;
    rs2 = 5'd6;
    rd = 5'd7;
    c_word_in = 20'hFFFFF;

    @(negedge clk);
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule
