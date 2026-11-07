`default_nettype none
`include "hdu.sv"
`include "bhu.sv"

module HHU #(
    parameter MOPS = 16,
    parameter MMOPS = 7,
    parameter WBS = 4,
    parameter NCS = 20,
    parameter F = 5,
    parameter FW = 3,
    parameter IW = 32
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
    input logic id_ex_is_load,
    input logic [F-1:0] if_id_rs1,
    input logic [F-1:0] if_id_rs2,
    input logic [F-1:0] id_ex_rd,
    input logic [FW-1:0] funct3,
    input logic branch_taken,
    input logic [IW-1:0] instr,
    output logic stall,
    output logic [NCS-1:0] id_ex_c_word,
    output logic [IW-1:0] if_id_out
);

  logic [NCS-1:0] c_word_hdu, c_word_bhu;

  HDU #(
    .MOPS(MOPS),
    .MMOPS(MMOPS),
    .WBS(WBS),
    .NCS(NCS),
    .F(F),
    .FW(FW)
  ) dut1 (
    .branch(branch),
    .write_rf(write_rf),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .is_jalr(is_jalr),
    .op_width(op_width),
    .write_ram(write_ram),
    .res(res),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .is_load(is_load),
    .id_ex_is_load(id_ex_is_load),
    .if_id_rs1(if_id_rs1),
    .if_id_rs2(if_id_rs2),
    .id_ex_rd(id_ex_rd),
    .funct3(funct3),
    .stall(stall),
    .c_word(c_word_hdu)
  );

  BHU #(
    .MOPS(MOPS),
    .MMOPS(MMOPS),
    .WBS(WBS),
    .NCS(NCS),
    .IW(IW),
    .FW(FW)
  ) dut2 (
    .branch(branch),
    .write_rf(write_rf),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .is_jalr(is_jalr),
    .op_width(op_width),
    .write_ram(write_ram),
    .res(res),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .is_load(is_load),
    .funct3(funct3),
    .branch_taken(branch_taken),
    .instr(instr),
    .id_ex_c_word(c_word_bhu),
    .if_id_out(if_id_out)
  );

  assign id_ex_c_word = branch_taken ? c_word_bhu : c_word_hdu;

endmodule
