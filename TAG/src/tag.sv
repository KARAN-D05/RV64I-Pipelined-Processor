`default_nettype none
`include "ksa.sv"

module tag #(
    parameter W = 64
) (
    input logic [W-1:0] rs1,
    input logic [W-1:0] imm,
    input logic [W-1:0] pc,
    input logic is_jalr,
    output logic [W-1:0] t_out,
    output logic [W-1:0] r_out
);
  
  logic [W-1:0] src;
  logic [W-1:0] sum1, sum2;
  assign src = is_jalr ? rs1 : pc;
  
  ksa dut1 (.a(imm), .b(src), .c_in(1'b0), .sum(sum1));
  ksa dut2 (.a(pc), .b({(W-3)'(1'b0), 3'b100}), .c_in(1'b0), .sum(sum2));

  assign t_out = is_jalr ? ((sum1) & ~({(W-1)'(1'b0), 1'b1})) : (sum1);
  assign r_out = sum2;

endmodule
