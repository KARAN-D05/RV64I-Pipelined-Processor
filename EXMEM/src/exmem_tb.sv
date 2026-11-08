`default_nettype none

module EXMEM #(
    parameter W = 64,
    parameter F = 5,
    parameter NCS = 9
) (
    input logic [W-1:0] alu_in,
    input logic [W-1:0] data_in2,
    input logic [W-1:0] r_in,
    input logic [W-1:0] t_in,
    input logic [NCS-1:0] c_word_in,
    input logic [F-1:0] rs2,
    input logic [F-1:0] rd,
    input logic rst,
    input logic clk,
    output logic [W-1:0] alu_out,
    output logic [W-1:0] data_out2,
    output logic [W-1:0] r_out,
    output logic [W-1:0] t_out,
    output logic [NCS-1:0] c_word_out,
    output logic [F-1:0] rs2_out,
    output logic [F-1:0] rd_out
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        alu_out <= W'(1'b0);
        data_out2 <= W'(1'b0);
        r_out <= W'(1'b0);
        t_out <= W'(1'b0);
        c_word_out <= NCS'(1'b0);
        rs2_out <= F'(1'b0);
        rd_out <= F'(1'b0);
    end else begin
        alu_out <= alu_in;
        data_out2 <= data_in2;
        r_out <= r_in;
        t_out <= t_in;
        c_word_out <= c_word_in;
        rs2_out <= rs2;
        rd_out <= rd;
    end
  end

endmodule
