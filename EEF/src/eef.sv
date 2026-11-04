`default_nettype none 

module EEF #(
    W = 64,
    F = 5
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
    output logic [W-1:0] alu_operand_a,
    output logic [W-1:0] alu_operand_b
);

  logic forward1, forward2;

  assign forward1 = (ex_mem_rd != F'(1'b0) && id_ex_rs1 == ex_mem_rd && uses_rs1 && ex_mem_write_rf);
  assign forward2 = (ex_mem_rd != F'(1'b0) && id_ex_rs2 == ex_mem_rd && uses_rs2 && ex_mem_write_rf);

  assign alu_operand_a = forward1 ? ex_mem_result : id_ex_data1;
  assign alu_operand_b = forward2 ? ex_mem_result : id_ex_data2;

endmodule
