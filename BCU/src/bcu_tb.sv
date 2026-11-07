`timescale 1ns/1ns
`include "bcu.sv"

module testbench;

  parameter FB = 3;

  logic branch;
  logic uses_rs1;
  logic uses_rs2;
  logic is_jalr;
  logic beq;
  logic bne;
  logic bge;
  logic blt;
  logic bgeu;
  logic bltu;
  logic [FB-1:0] funct3;
  logic branch_taken;

  BCU #(
    .FB(FB)
  ) dut (
    .branch(branch),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .is_jalr(is_jalr),
    .beq(beq),
    .bne(bne),
    .bge(bge),
    .blt(blt),
    .bgeu(bgeu),
    .bltu(bltu),
    .funct3(funct3),
    .branch_taken(branch_taken)
  );

  initial begin

    $monitor("time=%0t | branch=%b | uses_rs1=%b uses_rs2=%b | is_jalr=%b | funct3=%b | beq=%b bne=%b blt=%b bge=%b bltu=%b bgeu=%b | branch_taken=%b",
    $time,
    branch,
    uses_rs1, uses_rs2,
    is_jalr,
    funct3,
    beq, bne, blt, bge, bltu, bgeu,
    branch_taken);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    // JAL
    branch = 1'b1;
    uses_rs1 = 1'b0;
    uses_rs2 = 1'b0;
    is_jalr = 1'b0;
    funct3 = 3'b000;
    beq = 1'b0;
    bne = 1'b0;
    blt = 1'b0;
    bge = 1'b0;
    bltu = 1'b0;
    bgeu = 1'b0;
    #1;

    // JALR
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b0;
    is_jalr = 1'b1;
    #1;

    // BEQ - condition true
    is_jalr = 1'b0;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    funct3 = 3'b000;
    beq = 1'b1;
    #1;

    // BNE - condition true
    funct3 = 3'b001;
    beq = 1'b0;
    bne = 1'b1;
    #1;

    // BLT - condition true
    funct3 = 3'b100;
    bne = 1'b0;
    blt = 1'b1;
    #1;

    // BGE - condition true
    funct3 = 3'b101;
    blt = 1'b0;
    bge = 1'b1;
    #1;

    // BLTU - condition true
    funct3 = 3'b110;
    bge = 1'b0;
    bltu = 1'b1;
    #1;

    // BGEU - condition true
    funct3 = 3'b111;
    bltu = 1'b0;
    bgeu = 1'b1;
    #1;

    // Conditional branch - condition false
    funct3 = 3'b000;
    bgeu = 1'b0;
    beq = 1'b0;
    #1;

    // Invalid funct3
    funct3 = 3'b010;
    beq = 1'b1;
    #1;

    // branch not asserted
    branch = 1'b0;
    funct3 = 3'b000;
    beq = 1'b1;
    #1;

    // JALR with branch not asserted
    is_jalr = 1'b1;
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule