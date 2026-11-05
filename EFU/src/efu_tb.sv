`timescale 1ns/1ns
`include "efu.sv"

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
  logic [F-1:0] mem_wb_rd;
  logic mem_wb_write_rf;
  logic [W-1:0] mem_wb_result;
  logic [W-1:0] alu_operand_a;
  logic [W-1:0] alu_operand_b;

  EFU #(
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
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_write_rf(mem_wb_write_rf),
    .mem_wb_result(mem_wb_result),
    .alu_operand_a(alu_operand_a),
    .alu_operand_b(alu_operand_b)
  );

  initial begin

    $monitor("time=%0t | rs1=%0d rs2=%0d | uses_rs1=%b uses_rs2=%b | ID/EX data1=%h data2=%h | EX/MEM rd=%0d write=%b result=%h | MEM/WB rd=%0d write=%b result=%h | EEF A=%h B=%h | MEF A=%h B=%h | selected A=%h B=%h",
    $time,
    id_ex_rs1, id_ex_rs2,
    uses_rs1, uses_rs2,
    id_ex_data1, id_ex_data2,
    ex_mem_rd, ex_mem_write_rf, ex_mem_result,
    mem_wb_rd, mem_wb_write_rf, mem_wb_result,
    dut.id_a, dut.id_b,
    dut.mem_a, dut.mem_b,
    alu_operand_a, alu_operand_b);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    id_ex_rs1 = 5'd1;
    id_ex_rs2 = 5'd2;
    id_ex_data1 = 64'h1111;
    id_ex_data2 = 64'h2222;
    ex_mem_rd = 5'd1;
    ex_mem_result = 64'hAAAA;
    ex_mem_write_rf = 1'b1;
    mem_wb_rd = 5'd2;
    mem_wb_result = 64'hBBBB;
    mem_wb_write_rf = 1'b1;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    #1;

    id_ex_rs1 = 5'd3;
    id_ex_rs2 = 5'd4;
    ex_mem_rd = 5'd3;
    mem_wb_rd = 5'd4;
    ex_mem_result = 64'hCCCC;
    mem_wb_result = 64'hDDDD;
    id_ex_data1 = 64'h3333;
    id_ex_data2 = 64'h4444;
    #1;

    id_ex_rs1 = 5'd5;
    id_ex_rs2 = 5'd6;
    ex_mem_rd = 5'd7;
    mem_wb_rd = 5'd5;
    ex_mem_result = 64'hEEEE;
    mem_wb_result = 64'hFFFF;
    id_ex_data1 = 64'h5555;
    id_ex_data2 = 64'h6666;
    #1;

    id_ex_rs1 = 5'd8;
    id_ex_rs2 = 5'd9;
    ex_mem_rd = 5'd9;
    mem_wb_rd = 5'd8;
    ex_mem_result = 64'hAAAA1111;
    mem_wb_result = 64'hBBBB2222;
    id_ex_data1 = 64'h8888;
    id_ex_data2 = 64'h9999;
    #1;

    id_ex_rs1 = 5'd10;
    id_ex_rs2 = 5'd11;
    ex_mem_rd = 5'd12;
    mem_wb_rd = 5'd13;
    ex_mem_result = 64'hCCCC3333;
    mem_wb_result = 64'hDDDD4444;
    id_ex_data1 = 64'h1010;
    id_ex_data2 = 64'h1111;
    #1;

    id_ex_rs1 = 5'd14;
    id_ex_rs2 = 5'd15;
    ex_mem_rd = 5'd14;
    mem_wb_rd = 5'd15;
    ex_mem_result = 64'hEEEE5555;
    mem_wb_result = 64'hFFFF6666;
    uses_rs1 = 1'b0;
    uses_rs2 = 1'b1;
    #1;

    id_ex_rs1 = 5'd16;
    id_ex_rs2 = 5'd17;
    ex_mem_rd = 5'd16;
    mem_wb_rd = 5'd17;
    ex_mem_write_rf = 1'b1;
    mem_wb_write_rf = 1'b1;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b0;
    ex_mem_result = 64'h12345678;
    mem_wb_result = 64'h87654321;
    #1;

    id_ex_rs1 = 5'd0;
    id_ex_rs2 = 5'd0;
    ex_mem_rd = 5'd0;
    mem_wb_rd = 5'd0;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    ex_mem_result = 64'hAAAA;
    mem_wb_result = 64'hBBBB;
    #1;

    id_ex_rs1 = 5'd18;
    id_ex_rs2 = 5'd19;
    ex_mem_rd = 5'd18;
    mem_wb_rd = 5'd19;
    ex_mem_write_rf = 1'b0;
    mem_wb_write_rf = 1'b1;
    ex_mem_result = 64'hCCCC;
    mem_wb_result = 64'hDDDD;
    #1;

    id_ex_rs1 = 5'd20;
    id_ex_rs2 = 5'd21;
    ex_mem_rd = 5'd20;
    mem_wb_rd = 5'd21;
    ex_mem_write_rf = 1'b1;
    mem_wb_write_rf = 1'b0;
    ex_mem_result = 64'hEEEE;
    mem_wb_result = 64'hFFFF;
    #1;

    id_ex_rs1 = 5'd22;
    id_ex_rs2 = 5'd22;
    ex_mem_rd = 5'd22;
    mem_wb_rd = 5'd22;
    ex_mem_write_rf = 1'b1;
    mem_wb_write_rf = 1'b1;
    ex_mem_result = 64'hAAAA1111;
    mem_wb_result = 64'hBBBB2222;
    id_ex_data1 = 64'h22223333;
    id_ex_data2 = 64'h44445555;
    #1;

    id_ex_rs1 = 5'd23;
    id_ex_rs2 = 5'd24;
    ex_mem_rd = 5'd23;
    mem_wb_rd = 5'd24;
    ex_mem_result = 64'hCCCC1111;
    mem_wb_result = 64'hDDDD2222;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    id_ex_data1 = 64'h11112222;
    id_ex_data2 = 64'h33334444;
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule
