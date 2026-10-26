`timescale 1ns/1ns
`include "pc.sv"

module testbench;

  parameter W = 64;

  logic [W-1:0] target;
  logic stall;
  logic branch;
  logic rst;
  logic clk;
  logic [W-1:0] out;
  logic [W-1:0] expected_pc = '0;

  pc #(
    .W(W)
  ) dut (
    .target(target),
    .stall(stall),
    .branch(branch),
    .rst(rst),
    .clk(clk),
    .out(out)
  );

  function automatic logic [W-1:0] refr(
    input logic [W-1:0] current_pc
  );
    if (rst)
        return '0;
    else if (stall)
        return current_pc;
    else if (branch)
        return target;
    else
        return current_pc + W'(4);
        
  endfunction

  int pass = 0;
  int fail = 0;

  function automatic void disp(
    input logic [W-1:0] result,
    input logic [W-1:0] expected
  );

    if (result !== expected) begin
        $display("expected = %0h | y = %0h | Fail", expected, result);
        fail ++;
    end else begin
        pass ++;
    end

  endfunction

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor("time = %0t | target = %0h | stall = %b | branch = %b | rst = %b | out = %0h", $time, target, stall, branch, rst, out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

`ifdef manual

    $display("Manual Testing");

    rst = 1'b1;
    stall = 1'b0;
    branch = 1'b0;
    target = 64'h1234_5678_9ABC_DEF0;

    @(negedge clk);
    #1;
    rst = 1'b0;

    @(negedge clk);
    #1;
    rst = 1'b0;

    @(negedge clk);
    #1;
    stall  = 1'b0;
    branch = 1'b0;
    rst    = 1'b0;

    @(posedge clk);
    #1; 

    @(posedge clk);
    #1; 

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    stall  = 1'b0;
    branch = 1'b1;
    target = 64'h0000000000000100;

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    target = 64'h0000000000002040;

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    stall  = 1'b1;
    branch = 1'b0;
    target = 64'h0000000000005000;

    @(posedge clk);
    #1; 

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    stall  = 1'b1;
    branch = 1'b1;
    target = 64'h0000000000008000;

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    stall  = 1'b0;
    branch = 1'b0;

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    stall = 1'b1;
    rst   = 1'b1;
    #1; 

    @(negedge clk);
    #1;
    rst = 1'b0;

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    stall  = 1'b0;
    branch = 1'b1;
    target = 64'h000000000000ABCD;
    rst    = 1'b1;
    #1; 

    @(negedge clk);
    #1;
    rst = 1'b0;

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    stall  = 1'b0;
    branch = 1'b1;
    target = 64'h0000000000000000;

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    target = 64'h8000000000001000;

    @(posedge clk);
    #1; 

    @(negedge clk);
    #1;
    branch = 1'b0;
    stall  = 1'b0;

    @(posedge clk);
    #1; 

`elsif random

    $display("Random Testing");

    repeat (10000) begin

    rst = $urandom_range(0, 1);
    stall = $urandom_range(0, 1);
    branch = $urandom_range(0, 1);
    target = {$urandom, $urandom};

    @(negedge clk);
    #1;
    expected_pc = refr(out);
    @(negedge clk);
    #1;

    disp(out, expected_pc);

    end

    $display("Pass = %0d | Fail = %0d", pass, fail);

`endif

    $display("Simulation Complete");
    $finish;

  end

endmodule
