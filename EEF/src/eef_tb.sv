`timescale 1ns/1ns
`include "eef.sv"

module testbench;

  parameter W = 64;
  parameter F = 5;

  logic [F-1:0] id_ex_rs1;
  logic [F-1:0] id_ex_rs2;
  logic [W-1:0] id_ex_data1;
  logic [W-1:0] id_ex_data2;
  logic [W-1:0] ex_mem_result;
  logic ex_mem_write_rf;
  logic [F-1:0] ex_mem_rd;
  logic uses_rs1;
  logic uses_rs2;
  logic [W-1:0] alu_operand_a;
  logic [W-1:0] alu_operand_b;

  EEF #(
    .W(W),
    .F(F)
  ) dut (
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .id_ex_data1(id_ex_data1),
    .id_ex_data2(id_ex_data2),
    .ex_mem_result(ex_mem_result),
    .ex_mem_write_rf(ex_mem_write_rf),
    .ex_mem_rd(ex_mem_rd),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .alu_operand_a(alu_operand_a),
    .alu_operand_b(alu_operand_b)
  );

  initial begin

    $monitor("time = %0t | rs1 = %0d | rs2 = %0d | rd = %0d | uses_rs1 = %b | uses_rs2 = %b | write_rf = %b | data1 = %h | data2 = %h | forwarded = %h | operand_a = %h | operand_b = %h", $time, id_ex_rs1, id_ex_rs2, ex_mem_rd, uses_rs1, uses_rs2, ex_mem_write_rf, id_ex_data1, id_ex_data2, ex_mem_result, alu_operand_a, alu_operand_b);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    id_ex_rs1 = 5'd1;
    id_ex_rs2 = 5'd2;
    id_ex_data1 = 64'h1111;
    id_ex_data2 = 64'h2222;
    ex_mem_rd = 5'd2;
    ex_mem_result = 64'hAAAA;
    ex_mem_write_rf = 1'b1;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    #1;

    id_ex_rs1 = 5'd3;
    id_ex_rs2 = 5'd4;
    ex_mem_rd = 5'd3;
    id_ex_data1 = 64'h3333;
    id_ex_data2 = 64'h4444;
    ex_mem_result = 64'hBBBB;
    #1;

    id_ex_rs1 = 5'd5;
    id_ex_rs2 = 5'd6;
    ex_mem_rd = 5'd6;
    id_ex_data1 = 64'h5555;
    id_ex_data2 = 64'h6666;
    ex_mem_result = 64'hCCCC;
    #1;

    id_ex_rs1 = 5'd1;
    id_ex_rs2 = 5'd2;
    ex_mem_rd = 5'd7;
    ex_mem_result = 64'hDDDD;
    #1;

    id_ex_rs1 = 5'd3;
    id_ex_rs2 = 5'd4;
    ex_mem_rd = 5'd3;
    uses_rs1 = 1'b0;
    uses_rs2 = 1'b1;
    ex_mem_result = 64'hEEEE;
    #1;

    id_ex_rs1 = 5'd5;
    id_ex_rs2 = 5'd6;
    ex_mem_rd = 5'd6;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b0;
    ex_mem_result = 64'hFFFF;
    #1;

    id_ex_rs1 = 5'd0;
    id_ex_rs2 = 5'd0;
    ex_mem_rd = 5'd0;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    ex_mem_result = 64'h1234;
    #1;

    id_ex_rs1 = 5'd8;
    id_ex_rs2 = 5'd9;
    ex_mem_rd = 5'd8;
    ex_mem_write_rf = 1'b0;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    ex_mem_result = 64'h5678;
    #1;

    id_ex_rs1 = 5'd10;
    id_ex_rs2 = 5'd10;
    ex_mem_rd = 5'd10;
    ex_mem_write_rf = 1'b1;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    ex_mem_result = 64'hABCD;
    #1;

    id_ex_rs1 = 5'd11;
    id_ex_rs2 = 5'd12;
    ex_mem_rd = 5'd13;
    id_ex_data1 = 64'hAAAA1111;
    id_ex_data2 = 64'hBBBB2222;
    ex_mem_result = 64'hCCCC3333;
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule
