`default_nettype none
`include "rom.sv"
`include "pc.sv" 

module IF #(
    parameter MSIZE = 1024,
    parameter IWIDTH = 32,
    parameter PCWIDTH = 64
) (
    input logic [PCWIDTH-1:0] target,
    input logic stall,
    input logic branch,
    input logic rst,
    input logic clk,
    output logic [PCWIDTH-1:0] pc_out,
    output logic [IWIDTH-1:0] instr_out
);

  ROM #(
    .MSIZE(MSIZE),
    .IWIDTH(IWIDTH),
    .PCWIDTH(PCWIDTH)
  ) dut1 (
    .addr(pc_out),
    .out(instr_out)
  );

  pc #(
    .W(PCWIDTH)
  ) dut2 (
    .branch(branch),
    .stall(stall),
    .target(target),
    .out(pc_out),
    .clk(clk),
    .rst(rst)
  );

endmodule
