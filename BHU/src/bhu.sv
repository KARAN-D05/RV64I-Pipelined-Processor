`default_nettype none 

module BHU #(
    parameter IW = 32,
    parameter MOPS = 16,
    parameter MMOPS = 7,
    parameter WBS = 4,
    parameter NCS = 20,
    parameter FW = 3
) (
    input logic branch,
    input logic write_rf,
    input logic [$clog2(MOPS)-1:0] alu_op,
    input logic alu_src,
    input logic is_jalr,
    input logic [$clog2(MMOPS)-1:0] op_width,
    input logic write_ram,
    input logic [$clog2(WBS)-1:0] res,
    input logic uses_rs1,
    input logic uses_rs2,
    input logic is_load,
    input logic branch_taken,
    input logic [FW-1:0] funct3,
    input logic [IW-1:0] instr,
    output logic [NCS-1:0] id_ex_c_word,
    output logic [IW-1:0] if_id_out
);

  assign id_ex_c_word = branch_taken ? NCS'(1'b0) : {uses_rs1, uses_rs2, branch, write_rf, alu_op, alu_src, is_jalr, op_width, write_ram, is_load, res, funct3};
  assign if_id_out = branch_taken ? IW'(32'h00000013) : instr;

endmodule
