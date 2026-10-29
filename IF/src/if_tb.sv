`timescale 1ns/1ns
`include "if.sv"

module testbench;

  parameter MSIZE = 1024;
  parameter IWIDTH = 32;
  parameter PCWIDTH = 64;

  logic [PCWIDTH-1:0] target;
  logic stall;
  logic branch;
  logic rst;
  logic clk;
  logic [PCWIDTH-1:0] pc_out;
  logic [IWIDTH-1:0] instr_out;

  IF #(
    .MSIZE(MSIZE),
    .IWIDTH(IWIDTH),
    .PCWIDTH(PCWIDTH)
  )  dut (
    .target(target),
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .pc_out(pc_out),
    .instr_out(instr_out),
    .branch(branch)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor("time = %0t | pc_out = %016h | instr_out = %08h | target = %016h | stall = %b | branch = %b | rst = %b", $time, pc_out, instr_out, target, stall, branch, rst);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    rst = 1'b1;
    stall = 1'b0;
    branch = 1'b0;
    target = '0;

    @(negedge clk);
    #1;
    rst = 1'b0;

    @(negedge clk);
    #1;

    @(negedge clk);
    #1;

    @(negedge clk);
    #1;
    stall = 1'b1;

    @(negedge clk);
    #1;

    @(negedge clk);
    #1;
    stall = 1'b0;
    branch = 1'b1;
    target = 64'h0000_0000_0000_0100;

    @(negedge clk);
    #1;
    target = 64'h0000_0000_0000_0200;

    @(negedge clk);
    #1;
    stall = 1'b1;
    branch = 1'b1;
    target = 64'h0000_0000_0000_0300;

    @(negedge clk);
    #1;
    stall = 1'b0;
    branch = 1'b0;

    @(negedge clk);
    #1;
    stall = 1'b1;
    rst = 1'b1;

    @(negedge clk);
    #1;
    rst = 1'b0;
    stall = 1'b0;
    branch = 1'b1;
    target = 64'h0000_0000_0000_0300;

    @(negedge clk);
    #1;
    target = 64'h0;

    @(negedge clk);
    #1;
    target = 64'h0000_0000_0000_0FFC;

    @(negedge clk);
    #1;
    branch = 1'b0;

    @(negedge clk);
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule
