`default_nettype none
 
module alu #(
    parameter W = 64,
    parameter MOPS = 16
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
  localparam [$clog2(MOPS)-1:0] ADDW = 10;
  localparam [$clog2(MOPS)-1:0] SUBW = 11;
  localparam [$clog2(MOPS)-1:0] SLLW = 12;
  localparam [$clog2(MOPS)-1:0] SRLW = 13;
  localparam [$clog2(MOPS)-1:0] SRAW = 14;
  localparam [$clog2(MOPS)-1:0] LUI = 15;

  logic [5:0] shamt1;
  assign shamt1 = op2[5:0];

  logic [5:0] shamt2;
  assign shamt2 = op2[4:0];

  logic [(W/2)-1:0] sum;
  assign sum = rs1[(W/2)-1:0] + op2[(W/2)-1:0];

  logic [(W/2)-1:0] diff;
  assign diff = rs1[(W/2)-1:0] - op2[(W/2)-1:0];

  logic [(W/2)-1:0] sl;
  assign sl = rs1[(W/2)-1:0] << shamt2;

  logic [(W/2)-1:0] sr;
  assign sr = rs1[(W/2)-1:0] >> shamt2;

  logic [(W/2)-1:0] sa;
  assign sa = $signed(rs1[(W/2)-1:0]) >>> shamt2;

  always @(*) begin
    case(alu_op)
    ADD: out = rs1 + op2;
    SUB: out = rs1 - op2;
    SLL: out = rs1 << shamt1;
    SRL: out = rs1 >> shamt1;
    SRA: out = $signed(rs1) >>> shamt1;
    AND: out = rs1 & op2;
    OR: out = rs1 | op2;
    XOR: out = rs1 ^ op2;
    SLT: out = ($signed(rs1) < $signed(op2)) ? {(W-1)'(1'b0), 1'b1} : W'(1'b0);
    SLTU: out = (rs1 < op2) ? {(W-1)'(1'b0), 1'b1} : W'(1'b0);
    ADDW: out = {{W/2{sum[(W/2)-1]}}, sum};
    SUBW: out = {{W/2{diff[(W/2)-1]}}, diff};
    SLLW: out = {{W/2{sl[(W/2)-1]}}, sl};
    SRLW: out = {{W/2{sr[(W/2)-1]}}, sr};
    SRAW: out = {{W/2{sa[(W/2)-1]}}, sa};
    LUI: out = op2 + W'(1'b0);
    endcase
  end

endmodule
