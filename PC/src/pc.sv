// 64-Bit Program Counter
`default_nettype none

module pc #(
    parameter W = 64
) (
    input logic [W-1:0] target,
    input logic branch,
    input logic stall,
    input logic rst,
    input logic clk,
    output logic [W-1:0] out
);

  logic [W-1:0] next_pc;
  assign next_pc = out + 3'b100;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= W'(1'b0);
    end else if (stall) begin
        out <= out;
    end else if (branch) begin
        out <= target;
    end else begin
        out <= next_pc;
    end
  end

endmodule
