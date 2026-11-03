`default_nettype none
`include "rf.sv"
`include "cu.sv"
`include "se.sv"

module ID #(
    W = 64,
    IW = 32,
    MOPS = 16,
    MMOPS = 7,
    WBS = 4
) (
    input logic [$clog2(IW)-1:0] Raddr1,
    input logic [$clog2(IW)-1:0] Raddr2,
    input logic [$clog2(IW)-1:0] Waddr,
    input logic [W-1:0] data_in,
    input logic write,
    input logic clk,
    input logic [IW-1:0] instr,
    input logic beq,
    input logic bne,
    input logic blt,
    input logic bge,
    input logic bltu,
    input logic bgeu,
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
    output logic [W-1:0] data_out2
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
    .WBS(WBS)
  ) dut2 (
    .instr(instr),
    .beq(beq),
    .bne(bne),
    .bge(bge),
    .blt(blt),
    .bltu(bltu),
    .bgeu(bgeu),
    .branch(branch),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .is_jalr(is_jalr),
    .res(res),
    .op_width(op_width),
    .write_rf(write_rf),
    .write_ram(write_ram)
  );

  se #(
    .IW(IW),
    .OW(W)
  ) dut3 (
    .instr(instr),
    .imm(imm)
  );

endmodule
 
