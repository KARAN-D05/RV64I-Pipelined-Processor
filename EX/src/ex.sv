`default_nettype none
`include "alu.sv"
`include "tag.sv"

module EX #(
    parameter W = 64,
    parameter MOPS = 15
) (
    input logic [W-1:0] pc,
    input logic [W-1:0] rs1,
    input logic [W-1:0] rs2,
    input logic [W-1:0] imm,
    input logic is_jalr,
    input logic [$clog2(MOPS)-1:0] alu_op,
    input logic alu_src,
    output logic beq,
    output logic bne,
    output logic blt,
    output logic bge,
    output logic bltu,
    output logic bgeu,
    output logic [W-1:0] out,
    output logic [W-1:0] t_out,
    output logic [W-1:0] r_out
);

  alu #(
    .MOPS(MOPS),
    .W(W)
  ) dut1 (
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .out(out),
    .beq(beq),
    .bne(bne),
    .blt(blt),
    .bge(bge),
    .bltu(bltu),
    .bgeu(bgeu)
  );

  tag #(
    .W(W)
  ) dut2 (
    .rs1(rs1),
    .imm(imm),
    .pc(pc),
    .is_jalr(is_jalr),
    .t_out(t_out),
    .r_out(r_out)
  );

endmodule
