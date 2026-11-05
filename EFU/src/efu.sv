`default_nettype none
`include "eef.sv"
`include "mef.sv"
 
module EFU #(
    parameter W = 64,
    parameter F = 5
) (
    input logic [F-1:0] id_ex_rs1,
    input logic [F-1:0] id_ex_rs2,
    input logic [W-1:0] id_ex_data1,
    input logic [W-1:0] id_ex_data2,
    input logic [W-1:0] ex_mem_result,
    input logic ex_mem_write_rf,
    input logic [F-1:0] ex_mem_rd,
    input logic uses_rs1,
    input logic uses_rs2,
    input logic [F-1:0] mem_wb_rd,
    input logic mem_wb_write_rf,
    input logic [W-1:0] mem_wb_result,
    output logic [W-1:0] alu_operand_a,
    output logic [W-1:0] alu_operand_b
);

  logic [W-1:0] id_a, id_b, mem_a, mem_b;

  EEF #(
    .W(W),
    .F(F)
  ) dut1 (
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .id_ex_data1(id_ex_data1),
    .id_ex_data2(id_ex_data2),
    .ex_mem_result(ex_mem_result),
    .ex_mem_write_rf(ex_mem_write_rf),
    .ex_mem_rd(ex_mem_rd),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .alu_operand_a(id_a),
    .alu_operand_b(id_b)
  );

  MEF #(
    .F(F),
    .W(W)
  ) dut2 (
    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),
    .mem_wb_rd(mem_wb_rd),
    .mem_wb_write_rf(mem_wb_write_rf),
    .mem_wb_result(mem_wb_result),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .id_ex_data1(id_ex_data1),
    .id_ex_data2(id_ex_data2),
    .alu_operand_a(mem_a),
    .alu_operand_b(mem_b)
  );

  logic priority_ex1, priority_ex2;

  assign priority_ex1 = (ex_mem_rd != F'(1'b0) && id_ex_rs1 == ex_mem_rd && uses_rs1 && ex_mem_write_rf);
  assign priority_ex2 = (ex_mem_rd != F'(1'b0) && id_ex_rs2 == ex_mem_rd && uses_rs2 && ex_mem_write_rf);

  assign alu_operand_a = priority_ex1 ? id_a : mem_a;
  assign alu_operand_b = priority_ex2 ? id_b : mem_b;

endmodule
