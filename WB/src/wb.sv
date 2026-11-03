`default_nettype none
 
module WB #(
    parameter W = 64,
    parameter IN = 4
) (
    input logic [W-1:0] alu_out,
    input logic [W-1:0] mem_out,
    input logic [W-1:0] r_out,
    input logic [W-1:0] t_out,
    input logic [$clog2(IN)-1:0] res,
    output logic [W-1:0] out
);

  always_comb begin
    case (res)
    2'b00: out = alu_out;
    2'b01: out = mem_out;
    2'b10: out = r_out;
    2'b11: out = t_out;
    endcase
  end

endmodule
