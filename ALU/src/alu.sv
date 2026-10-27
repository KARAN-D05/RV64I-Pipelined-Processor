`default_nettype none
`include "ksa.sv"

module alu #(
    parameter W = 64,
    parameter MOPS = 10
) (
    input logic [W-1:0] rs1,
    input logic [W-1:0] rs2,
    input logic [W-1:0] imm,
    input logic [$clog2(MOPS)-1:0] alu_op,
    input logic alu_src,
    output logic [W-1:0] out,
    output logic beq,
    output logic bne,
    output logic blt,
    output logic bge,
    output logic bltu,
    output logic bgeu
);

  logic [W-1:0] op2;
  assign op2 = alu_src ? imm : rs2;

  assign beq = rs1 == op2;
  assign bne = rs1 != op2;
  assign blt = $signed(rs1) < $signed(op2);
  assign bge = $signed(rs1) >= $signed(op2);
  assign bltu = rs1 < op2;
  assign bgeu = rs1 >= op2;

  localparam [$clog2(MOPS)-1:0] ADD = 0;
  localparam [$clog2(MOPS)-1:0] SUB = 1;
  localparam [$clog2(MOPS)-1:0] SLL = 2;
  localparam [$clog2(MOPS)-1:0] SRL = 3;
  localparam [$clog2(MOPS)-1:0] SRA = 4;
  localparam [$clog2(MOPS)-1:0] AND = 5;
  localparam [$clog2(MOPS)-1:0] OR = 6;
  localparam [$clog2(MOPS)-1:0] XOR = 7;
  localparam [$clog2(MOPS)-1:0] SLT = 8;
  localparam [$clog2(MOPS)-1:0] SLTU = 9;

  logic [5:0] shamt;
  assign shamt = op2[5:0];

  logic [W-1:0] sum;
  logic cout;;
  ksa dut (.a(rs1), .b(op2), .c_in(1'b0), .sum(sum), .c_out(cout));

  always_comb begin
    case(alu_op)
    ADD: out = sum;
    SUB: out = rs1 - op2;
    SLL: out = rs1 << shamt;
    SRL: out = rs1 >> shamt;
    SRA: out = $signed(rs1) >>> shamt;
    AND: out = rs1 & op2;
    OR: out = rs1 | op2;
    XOR: out = rs1 ^ op2;
    SLT: out = ($signed(rs1) < $signed(op2)) ? {{W-1{1'b0}}, 1'b1} : W'(1'b0);
    SLTU: out = (rs1 < op2) ? {{W-1{1'b0}}, 1'b1} : W'(1'b0);
    default: out = W'(1'b0);
    endcase
  end

endmodule
