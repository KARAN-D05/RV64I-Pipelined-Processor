`timescale 1ns/1ns
`include "wif.sv"

module testbench;

  parameter W = 64;
  parameter F = 5;

  logic [W-1:0] if_id_data1;
  logic [W-1:0] if_id_data2;
  logic [F-1:0] rs1;
  logic [F-1:0] rs2;
  logic [F-1:0] mem_wb_rd;
  logic uses_rs1;
  logic uses_rs2;
  logic mem_wb_write_rf;
  logic [W-1:0] mem_wb_result;
  logic [W-1:0] out1;
  logic [W-1:0] out2;

  WIF #(
    .W(W),
    .F(F)
  ) dut (
    .if_id_data1(if_id_data1),
    .if_id_data2(if_id_data2),
    .rs1(rs1),
    .rs2(rs2),
    .mem_wb_rd(mem_wb_rd),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .mem_wb_write_rf(mem_wb_write_rf),
    .mem_wb_result(mem_wb_result),
    .out1(out1),
    .out2(out2)
  );

  initial begin

    $monitor("time=%0t | rs1=%0d rs2=%0d | mem_wb_rd=%0d | uses_rs1=%b uses_rs2=%b | mem_wb_write_rf=%b | ID data1=%h data2=%h | MEM/WB result=%h | forward1=%b forward2=%b | out1=%h out2=%h",
    $time,
    rs1, rs2,
    mem_wb_rd,
    uses_rs1, uses_rs2,
    mem_wb_write_rf,
    if_id_data1, if_id_data2,
    mem_wb_result,
    dut.forward1, dut.forward2,
    out1, out2);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    rs1 = 5'd1;
    rs2 = 5'd2;
    mem_wb_rd = 5'd1;
    if_id_data1 = 64'h1111;
    if_id_data2 = 64'h2222;
    mem_wb_result = 64'hAAAA;
    mem_wb_write_rf = 1'b1;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    #1;

    rs1 = 5'd3;
    rs2 = 5'd4;
    mem_wb_rd = 5'd4;
    if_id_data1 = 64'h3333;
    if_id_data2 = 64'h4444;
    mem_wb_result = 64'hBBBB;
    #1;

    rs1 = 5'd5;
    rs2 = 5'd6;
    mem_wb_rd = 5'd7;
    if_id_data1 = 64'h5555;
    if_id_data2 = 64'h6666;
    mem_wb_result = 64'hCCCC;
    #1;

    rs1 = 5'd8;
    rs2 = 5'd9;
    mem_wb_rd = 5'd8;
    if_id_data1 = 64'h8888;
    if_id_data2 = 64'h9999;
    mem_wb_result = 64'hDDDD;
    uses_rs1 = 1'b0;
    uses_rs2 = 1'b1;
    #1;

    rs1 = 5'd10;
    rs2 = 5'd11;
    mem_wb_rd = 5'd11;
    if_id_data1 = 64'h1010;
    if_id_data2 = 64'h1111;
    mem_wb_result = 64'hEEEE;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b0;
    #1;

    rs1 = 5'd0;
    rs2 = 5'd0;
    mem_wb_rd = 5'd0;
    if_id_data1 = 64'h5555;
    if_id_data2 = 64'h6666;
    mem_wb_result = 64'hFFFF;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    #1;

    rs1 = 5'd12;
    rs2 = 5'd13;
    mem_wb_rd = 5'd12;
    if_id_data1 = 64'h1212;
    if_id_data2 = 64'h1313;
    mem_wb_result = 64'h12345678;
    mem_wb_write_rf = 1'b0;
    #1;

    rs1 = 5'd14;
    rs2 = 5'd15;
    mem_wb_rd = 5'd15;
    if_id_data1 = 64'h1414;
    if_id_data2 = 64'h1515;
    mem_wb_result = 64'h87654321;
    mem_wb_write_rf = 1'b1;
    #1;

    rs1 = 5'd16;
    rs2 = 5'd16;
    mem_wb_rd = 5'd16;
    if_id_data1 = 64'h1616;
    if_id_data2 = 64'h1717;
    mem_wb_result = 64'hAAAAAAAA;
    #1;

    rs1 = 5'd17;
    rs2 = 5'd18;
    mem_wb_rd = 5'd19;
    if_id_data1 = 64'h1717;
    if_id_data2 = 64'h1818;
    mem_wb_result = 64'hBBBBBBBB;
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule