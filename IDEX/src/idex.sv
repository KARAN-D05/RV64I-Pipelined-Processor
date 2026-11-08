`default_nettype none

module IDEX #(
    parameter NCS = 20,
    parameter F = 5,
    parameter W = 64
) (
    input logic [W-1:0] data_in1,
    input logic [W-1:0] data_in2,
    input logic [W-1:0] pc_in,
    input logic [W-1:0] imm_in,
    input logic [F-1:0] rs1,
    input logic [F-1:0] rs2,
    input logic [F-1:0] rd,
    input logic [NCS-1:0] c_word_in,
    input logic clk,
    input logic rst,
    output logic [W-1:0] data_out1,
    output logic [W-1:0] data_out2,
    output logic [W-1:0] pc_out,
    output logic [W-1:0] imm_out,
    output logic [F-1:0] rs1_out,
    output logic [F-1:0] rs2_out,
    output logic [F-1:0] rd_out,
    output logic [NCS-1:0] c_word_out
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out1 <= W'(1'b0);
        data_out2 <= W'(1'b0);
        pc_out <= W'(1'b0);
        imm_out <= W'(1'b0);
        rs1_out <= F'(1'b0);
        rs2_out <= F'(1'b0);
        rd_out <= F'(1'b0);
        c_word_out <= NCS'(1'b0);
    end else begin
        data_out1 <= data_in1;
        data_out2 <= data_in2;
        pc_out <= pc_in;
        imm_out <= imm_in;
        rs1_out <= rs1;
        rs2_out <= rs2;
        rd_out <= rd;
        c_word_out <= c_word_in;
    end
  end

endmodule 
