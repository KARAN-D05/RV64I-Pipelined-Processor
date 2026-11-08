`default_nettype none
`include "rf.sv"
`include "cu.sv"
`include "se.sv"

module ID #(
    W = 64,
    IW = 32,
    MOPS = 16,
    MMOPS = 7,
    WBS = 4,
    FB = 3
) (
    input logic [$clog2(IW)-1:0] Raddr1,
    input logic [$clog2(IW)-1:0] Raddr2,
    input logic [$clog2(IW)-1:0] Waddr,
    input logic [W-1:0] data_in,
    input logic write,
    input logic clk,
    input logic [IW-1:0] instr,
    output logic branch,
    output logic write_rf,
    output logic [$clog2(MOPS)-1:0] alu_op,
    output logic alu_src,
    output logic is_jalr,
    output logic [$clog2(MMOPS)-1:0] op_width,
    output logic write_ram,
    output logic [$clog2(WBS)-1:0] res,
    output logic [W-1:0] imm,
    output logic [W-1:0] data_out1,
    output logic [W-1:0] data_out2,
    output logic uses_rs1,
    output logic uses_rs2,
    output logic [FB-1:0] funct3,
    output logic is_load
);

  RF #(
    .WIDTH(W),
    .NUM(IW)
  ) dut1 (
    .Raddr1(Raddr1),
    .Raddr2(Raddr2),
    .Waddr(Waddr),
    .data_in(data_in),
    .write(write),
    .clk(clk),
    .data_out1(data_out1),
    .data_out2(data_out2)
  );

  cu #(
    .IWIDTH(IW),
    .MOPS(MOPS),
    .MMOPS(MMOPS),
    .WBS(WBS),
    .FB(FB)
  ) dut2 (
    .instr(instr),
    .branch(branch),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .is_jalr(is_jalr),
    .res(res),
    .op_width(op_width),
    .write_rf(write_rf),
    .write_ram(write_ram),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .funct3(funct3),
    .is_load(is_load)
  );

  se #(
    .IW(IW),
    .OW(W)
  ) dut3 (
    .instr(instr),
    .imm(imm)
  );

endmodule
