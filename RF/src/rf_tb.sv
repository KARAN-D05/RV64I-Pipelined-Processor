`timescale 1ns/1ns
`include "rf.sv"

module testbench;

  parameter WIDTH = 64;
  parameter NUM = 32;

  logic [$clog2(NUM)-1:0] Raddr1;
  logic [$clog2(NUM)-1:0] Raddr2;
  logic [$clog2(NUM)-1:0] Waddr;
  logic [WIDTH-1:0] data_in;
  logic write;
  logic clk;
  logic [WIDTH-1:0] data_out1;
  logic [WIDTH-1:0] data_out2;

  RF #(
    .WIDTH(WIDTH),
    .NUM(NUM)
  ) dut (
    .Raddr1(Raddr1),
    .Raddr2(Raddr2),
    .Waddr(Waddr),
    .data_in(data_in),
    .write(write),
    .clk(clk),
    .data_out1(data_out1),
    .data_out2(data_out2)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin

    $monitor("t = %0t | Raddr1 = %0h | Raddr2 = %0h | Waddr = %0h | write = %0h | data_in = %016h | data_out1 = %016h | data_out = %016h", $time, Raddr1, Raddr2, Waddr, write, data_in, data_out1, data_out2);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    Raddr1  = 5'd0;
    Raddr2  = 5'd0;
    Waddr   = 5'd0;
    data_in = 64'd0;
    write   = 1'b0;

    @(negedge clk);
    #1;
    data_in = 64'h9AE2_9AE2_9AE2_9AE2;
    Waddr   = 5'd10;
    write   = 1'b1;

    @(negedge clk);
    #1;
    data_in = 64'hFFFF_FFFF_FFFF_FFFF;
    Waddr   = 5'd6;

    @(negedge clk);
    #1;
    write  = 1'b0;
    Raddr1 = 5'd10;
    Raddr2 = 5'd6;

    @(negedge clk);
    #1;
    Raddr1 = 5'd0;
    Raddr2 = 5'd0;

    @(negedge clk);
    #1;
    data_in = 64'hAAAA_AAAA_AAAA_AAAA;
    Waddr   = 5'd0;
    write   = 1'b1;

    @(negedge clk);
    #1;
    write  = 1'b0;
    Raddr1 = 5'd0;
    Raddr2 = 5'd10;

    @(negedge clk);
    #1;
    Waddr   = 5'd10;
    Raddr1  = 5'd10;
    data_in = 64'h1234_5678_9ABC_DEF0;
    write   = 1'b1;

    @(negedge clk);
    #1;
    write = 1'b0;

    @(negedge clk);
    #1;
    Raddr1 = 5'd10;
    Raddr2 = 5'd6;
    write  = 1'b0;

    @(negedge clk);
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule