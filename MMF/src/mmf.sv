`default_nettype none

module MMF #(
    parameter W = 64,
    parameter F = 5
) (
    input logic [W-1:0] ex_mem_data_in,
    input logic [F-1:0] mem_wb_rd,
    input logic [F-1:0] ex_mem_rs2,
    input logic [W-1:0] mem_wb_result,
    input logic mem_wb_write_rf,
    input logic uses_rs2,
    output logic [W-1:0] data_out
);

  logic forward;
  assign forward = (mem_wb_rd == ex_mem_rs2 && mem_wb_write_rf && mem_wb_rd != F'(1'b0) && uses_rs2);

  assign data_out = forward ? mem_wb_result : ex_mem_data_in;

endmodule
