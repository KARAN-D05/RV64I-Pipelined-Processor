`timescale 1ns/1ns
`include "mmf.sv"

module testbench;

  parameter W = 64;
  parameter F = 5;

  logic [W-1:0] ex_mem_data_in;
  logic [F-1:0] mem_wb_rd;
  logic [F-1:0] ex_mem_rs2;
  logic [W-1:0] mem_wb_result;
  logic mem_wb_write_rf;
  logic uses_rs2;
  logic [W-1:0] data_out;

  MMF #(
    .W(W),
    .F(F)
  ) dut (
    .ex_mem_data_in(ex_mem_data_in),
    .mem_wb_rd(mem_wb_rd),
    .ex_mem_rs2(ex_mem_rs2),
    .mem_wb_result(mem_wb_result),
    .mem_wb_write_rf(mem_wb_write_rf),
    .uses_rs2(uses_rs2),
    .data_out(data_out)
  );

  initial begin

    $monitor("time=%0t | ex_mem_rs2=%0d | mem_wb_rd=%0d | uses_rs2=%b | mem_wb_write_rf=%b | original_store_data=%h | mem_wb_result=%h | forward=%b | data_out=%h",
    $time,
    ex_mem_rs2,
    mem_wb_rd,
    uses_rs2,
    mem_wb_write_rf,
    ex_mem_data_in,
    mem_wb_result,
    dut.forward,
    data_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    ex_mem_rs2 = 5'd3;
    mem_wb_rd = 5'd3;
    ex_mem_data_in = 64'h1111;
    mem_wb_result = 64'hAAAA;
    mem_wb_write_rf = 1'b1;
    uses_rs2 = 1'b1;
    #1;

    ex_mem_rs2 = 5'd4;
    mem_wb_rd = 5'd5;
    ex_mem_data_in = 64'h2222;
    mem_wb_result = 64'hBBBB;
    #1;

    ex_mem_rs2 = 5'd6;
    mem_wb_rd = 5'd6;
    ex_mem_data_in = 64'h3333;
    mem_wb_result = 64'hCCCC;
    uses_rs2 = 1'b0;
    #1;

    ex_mem_rs2 = 5'd7;
    mem_wb_rd = 5'd7;
    ex_mem_data_in = 64'h4444;
    mem_wb_result = 64'hDDDD;
    uses_rs2 = 1'b1;
    mem_wb_write_rf = 1'b0;
    #1;

    ex_mem_rs2 = 5'd0;
    mem_wb_rd = 5'd0;
    ex_mem_data_in = 64'h5555;
    mem_wb_result = 64'hEEEE;
    mem_wb_write_rf = 1'b1;
    #1;

    ex_mem_rs2 = 5'd8;
    mem_wb_rd = 5'd8;
    ex_mem_data_in = 64'h6666;
    mem_wb_result = 64'hFFFF;
    mem_wb_write_rf = 1'b1;
    uses_rs2 = 1'b1;
    #1;

    ex_mem_rs2 = 5'd9;
    mem_wb_rd = 5'd9;
    ex_mem_data_in = 64'h7777;
    mem_wb_result = 64'h1234;
    #1;

    ex_mem_rs2 = 5'd10;
    mem_wb_rd = 5'd11;
    ex_mem_data_in = 64'h8888;
    mem_wb_result = 64'h5678;
    #1;

    ex_mem_rs2 = 5'd12;
    mem_wb_rd = 5'd12;
    ex_mem_data_in = 64'h9999;
    mem_wb_result = 64'hABCD;
    #1;

    ex_mem_rs2 = 5'd13;
    mem_wb_rd = 5'd13;
    ex_mem_data_in = 64'hAAAA1111;
    mem_wb_result = 64'hBBBB2222;
    mem_wb_write_rf = 1'b1;
    uses_rs2 = 1'b1;
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule