`default_nettype none 

module IFID #(
    parameter IWIDTH = 32,
    parameter PCWIDTH = 64
) (
    input logic [IWIDTH-1:0] instr_in,
    input logic [PCWIDTH-1:0] pc_in,
    input logic clk,
    input logic rst,
    input logic stall,
    output logic [IWIDTH-1:0] instr_out,
    output logic [PCWIDTH-1:0] pc_out
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        instr_out <= IWIDTH'(1'b0);
        pc_out <= PCWIDTH'(1'b0);
    end else if (stall) begin
        instr_out <= instr_out;
        pc_out <= pc_out;
    end else begin
        instr_out <= instr_in;
        pc_out <= pc_in;
    end
  end

endmodule
