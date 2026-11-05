`default_nettype none 

module WIF #(
    parameter W = 64,
    parameter F = 5
) (
    input logic [W-1:0] if_id_data1,
    input logic [W-1:0] if_id_data2,
    input logic [F-1:0] rs1,
    input logic [F-1:0] rs2,
    input logic [F-1:0] mem_wb_rd,
    input logic uses_rs1,
    input logic uses_rs2,
    input logic mem_wb_write_rf,
    input logic [W-1:0] mem_wb_result,
    output logic [W-1:0] out1,
    output logic [W-1:0] out2
);

  logic forward1, forward2;

  assign forward1 = (rs1 == mem_wb_rd && mem_wb_write_rf && mem_wb_rd != F'(1'b0) && uses_rs1);
  assign forward2 = (rs2 == mem_wb_rd && mem_wb_write_rf && mem_wb_rd != F'(1'b0) && uses_rs2);

  assign out1 = forward1 ? mem_wb_result : if_id_data1;
  assign out2 = forward2 ? mem_wb_result : if_id_data2;

endmodule
