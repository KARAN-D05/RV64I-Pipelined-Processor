`default_nettype none

module MEMWB #(
    parameter W = 64,
    parameter NCS = 3,
    parameter F = 5
) (
    input logic [W-1:0] mem_in,
    input logic [W-1:0] alu_in,
    input logic [W-1:0] r_in,
    input logic [W-1:0] t_in,
    input logic [NCS-1:0] c_word_in,
    input logic [F-1:0] rd,
    input logic rst,
    input logic clk,
    output logic [W-1:0] mem_out,
    output logic [W-1:0] alu_out,
    output logic [W-1:0] r_out,
    output logic [W-1:0] t_out,
    output logic [NCS-1:0] c_word_out,
    output logic [F-1:0] rd_out
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_out <= W'(1'b0);
        alu_out <= W'(1'b0);
        r_out <= W'(1'b0);
        t_out <= W'(1'b0);
        c_word_out <= NCS'(1'b0);
        rd_out <= F'(1'b0);
    end else begin
        mem_out <= mem_in;
        alu_out <= alu_in;
        r_out <= r_in;
        t_out <= t_in;
        c_word_out <= c_word_in;
        rd_out <= rd;
    end
  end

endmodule 
