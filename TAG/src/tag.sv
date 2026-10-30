`default_nettype none

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
  
  assign t_out = is_jalr ? ((imm + src) & ~({(W-1)'(1'b0), 1'b1})) : (imm + src);
  assign r_out = pc + {(W-3)'(1'b0), 3'b100};

endmodule
