`default_nettype none

module MEF #(
    parameter F =5,
    parameter W = 64
) (
    input logic [F-1:0] id_ex_rs1,
    input logic [F-1:0] id_ex_rs2,
    input logic [F-1:0] mem_wb_rd,
    input logic mem_wb_write_rf,
    input logic [W-1:0] mem_wb_result,
    input logic uses_rs1,
    input logic uses_rs2,
    input logic [W-1:0] id_ex_data1,
    input logic [W-1:0] id_ex_data2,
    output logic [W-1:0] alu_operand_a,
    output logic [W-1:0] alu_operand_b
);

  logic forward1, forward2;

  assign forward1 = (mem_wb_rd != F'(1'b0) && id_ex_rs1 == mem_wb_rd && uses_rs1 && mem_wb_write_rf);
  assign forward2 = (mem_wb_rd != F'(1'b0) && id_ex_rs2 == mem_wb_rd && uses_rs2 && mem_wb_write_rf);

  assign alu_operand_a = forward1 ? mem_wb_result : id_ex_data1;
  assign alu_operand_b = forward2 ? mem_wb_result : id_ex_data2;


endmodule
