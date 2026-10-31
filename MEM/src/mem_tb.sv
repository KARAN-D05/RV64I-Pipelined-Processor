`timescale 1ns/1ns
`include "mem.sv"

module testbench;

  parameter MSIZE = 1024;
  parameter MWS   = 8;
  parameter W     = 64;
  parameter MOPS  = 7;
  localparam B    = 3'b000;
  localparam H    = 3'b001;
  localparam W_OP = 3'b010;
  localparam D    = 3'b011;
  localparam BU   = 3'b100;
  localparam HU   = 3'b101;
  localparam WU   = 3'b110;
  logic [W-1:0] in;
  logic [$clog2(MSIZE)-1:0] addr;
  logic [$clog2(MOPS)-1:0] op_width;
  logic clk;
  logic write;
  logic [W-1:0] out;

  MEM #(
    .MSIZE(MSIZE),
    .MWS(MWS),
    .W(W),
    .MOPS(MOPS)
  ) dut (
    .in(in),
    .addr(addr),
    .op_width(op_width),
    .clk(clk),
    .write(write),
    .out(out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  task automatic store(
    input logic [9:0] a,
    input logic [2:0] op,
    input logic [63:0] data
  );
    begin
      @(negedge clk);
      addr     = a;
      op_width = op;
      in       = data;
      write    = 1'b1;

      @(posedge clk);
      #1;
      write = 1'b0;
    end
  endtask

  task automatic load_check(
    input logic [9:0] a,
    input logic [2:0] op,
    input logic [63:0] expected
  );
    begin
      @(negedge clk);
      addr     = a;
      op_width = op;
      write    = 1'b0;

      #1;

      if (out !== expected) begin
        $display(
          "FAIL | Addr = %03h | OP = %03b | Expected = %016h | Got = %016h", a, op, expected, out
        );
        $fatal;
      end else begin
        $display(
          "PASS | Addr = %03h | OP = %03b | Data = %016h", a, op, out
        );
      end
    end
  endtask

  initial begin

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    addr     = 0;
    in       = 0;
    op_width = 0;
    write    = 0;

    store(10'h100, D, 64'h0123_4567_89AB_CDEF);
    load_check(10'h100, D, 64'h0123_4567_89AB_CDEF);

    load_check(10'h100, B,  64'hFFFF_FFFF_FFFF_FFEF);
    load_check(10'h100, BU, 64'h0000_0000_0000_00EF);

    load_check(10'h100, H,  64'hFFFF_FFFF_FFFF_CDEF);
    load_check(10'h100, HU, 64'h0000_0000_0000_CDEF);

    load_check(10'h100, W_OP, 64'hFFFF_FFFF_89AB_CDEF);
    load_check(10'h100, WU,   64'h0000_0000_89AB_CDEF);

    store(10'h104, B, 64'h0000_0000_0000_0080);
    load_check(10'h104, B,  64'hFFFF_FFFF_FFFF_FF80);
    load_check(10'h104, BU, 64'h0000_0000_0000_0080);

    store(10'h110, H, 64'h0000_0000_0000_8001);
    load_check(10'h110, H,  64'hFFFF_FFFF_FFFF_8001);
    load_check(10'h110, HU, 64'h0000_0000_0000_8001);

    store(10'h120, W_OP, 64'h0000_0000_8000_0001);
    load_check(10'h120, W_OP, 64'hFFFF_FFFF_8000_0001);
    load_check(10'h120, WU,   64'h0000_0000_8000_0001);

    store(10'h131, D, 64'hFEDC_BA98_7654_3210);
    load_check(10'h131, D,  64'hFEDC_BA98_7654_3210);
    load_check(10'h132, WU, 64'h0000_0000_9876_5432);
    load_check(10'h133, HU, 64'h0000_0000_0000_7654);
    load_check(10'h134, BU, 64'h0000_0000_0000_0076);

    store(10'h150, D, 64'h1122_3344_5566_7788);
    store(10'h153, B, 64'h0000_0000_0000_00AA);
    load_check(10'h150, D, 64'h1122_3344_AA66_7788);

    store(10'h161, H, 64'h0000_0000_0000_FF80);
    load_check(10'h161, H,  64'hFFFF_FFFF_FFFF_FF80);
    load_check(10'h161, HU, 64'h0000_0000_0000_FF80);

    store(10'h171, W_OP, 64'h0000_0000_89AB_CDEF);
    load_check(10'h171, W_OP, 64'hFFFF_FFFF_89AB_CDEF);
    load_check(10'h171, WU,   64'h0000_0000_89AB_CDEF);

    store(10'h180, D, 64'h0123_4567_89AB_CDEF);
    store(10'h182, H, 64'h0000_0000_0000_AABB);
    load_check(10'h180, D, 64'h0123_4567_AABB_CDEF);

    store(10'h190, B, 64'h0000_0000_0000_0000);
    load_check(10'h190, B,  64'h0000_0000_0000_0000);
    load_check(10'h190, BU, 64'h0000_0000_0000_0000);

    store(10'h191, B, 64'h0000_0000_0000_00FF);
    load_check(10'h191, B,  64'hFFFF_FFFF_FFFF_FFFF);
    load_check(10'h191, BU, 64'h0000_0000_0000_00FF);

    store(10'h1A0, H, 64'h0000_0000_0000_0000);
    load_check(10'h1A0, H,  64'h0000_0000_0000_0000);
    load_check(10'h1A0, HU, 64'h0000_0000_0000_0000);

    store(10'h1A2, H, 64'h0000_0000_0000_FFFF);
    load_check(10'h1A2, H,  64'hFFFF_FFFF_FFFF_FFFF);
    load_check(10'h1A2, HU, 64'h0000_0000_0000_FFFF);


    $display("Simulation Complete");
    $finish;

  end

endmodule