`timescale 1ns/1ns
`include "ifid.sv"

module testbench;

  parameter IWIDTH = 32;
  parameter PCWIDTH = 64;

  logic [IWIDTH-1:0] instr_in;
  logic [PCWIDTH-1:0] pc_in;
  logic clk;
  logic rst;
  logic stall;
  logic [IWIDTH-1:0] instr_out;
  logic [PCWIDTH-1:0] pc_out;

  IFID #(
    .IWIDTH(IWIDTH),
    .PCWIDTH(PCWIDTH)
  ) dut (
    .instr_in(instr_in),
    .pc_in(pc_in),
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .instr_out(instr_out),
    .pc_out(pc_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor("t = %0t | rst = %0b | stall = %0b | pc_in = %016h | instr_in = %08h | pc_out = %016h | instr_out = %08h",
             $time, rst, stall, pc_in, instr_in, pc_out, instr_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    rst = 1'b0;
    stall = 1'b0;
    pc_in = 64'd0;
    instr_in = 32'd0;

    #2;
    rst = 1'b1;

    #2;
    rst = 1'b0;

    @(negedge clk);
    #1;
    pc_in = 64'h0000_0000_0000_1000;
    instr_in = 32'h00A0_0093;

    @(negedge clk);
    #1;
    pc_in = 64'h0000_0000_0000_1004;
    instr_in = 32'h0020_8133;

    @(negedge clk);
    #1;
    pc_in = 64'h0000_0000_0000_1008;
    instr_in = 32'h0031_01B3;

    @(negedge clk);
    #1;
    stall = 1'b1;
    pc_in = 64'h0000_0000_0000_100C;
    instr_in = 32'h0000_006F;

    @(negedge clk);
    #1;
    pc_in = 64'h0000_0000_0000_1010;
    instr_in = 32'h0000_0013;

    @(negedge clk);
    #1;
    stall = 1'b0;
    pc_in = 64'h0000_0000_0000_1014;
    instr_in = 32'h0050_0193;

    @(negedge clk);
    #1;
    pc_in = 64'h0000_0000_0000_1018;
    instr_in = 32'h0000_006F;

    @(negedge clk);
    #1;
    stall = 1'b1;
    rst = 1'b1;

    #1;
    rst = 1'b0;
    stall = 1'b0;
    pc_in = 64'h0000_0000_0000_101C;
    instr_in = 32'h0000_0013;

    @(negedge clk);
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule
