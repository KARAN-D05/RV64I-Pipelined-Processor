`timescale 1ns/1ns
`include "hhu.sv"

module testbench;

  parameter MOPS = 16;
  parameter MMOPS = 7;
  parameter WBS = 4;
  parameter NCS = 20;
  parameter F = 5;
  parameter FW = 3;
  parameter IW = 32;

  logic branch;
  logic write_rf;
  logic [$clog2(MOPS)-1:0] alu_op;
  logic alu_src;
  logic is_jalr;
  logic [$clog2(MMOPS)-1:0] op_width;
  logic write_ram;
  logic [$clog2(WBS)-1:0] res;
  logic uses_rs1;
  logic uses_rs2;
  logic is_load;
  logic id_ex_is_load;
  logic [F-1:0] if_id_rs1;
  logic [F-1:0] if_id_rs2;
  logic [F-1:0] id_ex_rd;
  logic [FW-1:0] funct3;
  logic branch_taken;
  logic [IW-1:0] instr;
  logic stall;
  logic [NCS-1:0] id_ex_c_word;
  logic [IW-1:0] if_id_out;

  HHU #(
    .MOPS(MOPS),
    .MMOPS(MMOPS),
    .WBS(WBS),
    .NCS(NCS),
    .F(F),
    .FW(FW),
    .IW(IW)
  ) dut (
    .branch(branch),
    .write_rf(write_rf),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .is_jalr(is_jalr),
    .op_width(op_width),
    .write_ram(write_ram),
    .res(res),
    .uses_rs1(uses_rs1),
    .uses_rs2(uses_rs2),
    .is_load(is_load),
    .id_ex_is_load(id_ex_is_load),
    .if_id_rs1(if_id_rs1),
    .if_id_rs2(if_id_rs2),
    .id_ex_rd(id_ex_rd),
    .funct3(funct3),
    .branch_taken(branch_taken),
    .instr(instr),
    .stall(stall),
    .id_ex_c_word(id_ex_c_word),
    .if_id_out(if_id_out)
  );

  initial begin

    $monitor("time=%0t | branch=%b branch_taken=%b | rs1=%0d rs2=%0d rd=%0d | id_ex_is_load=%b uses_rs1=%b uses_rs2=%b write_ram=%b | stall=%b | HDU_word=%h BHU_word=%h | id_ex_c_word=%h | instr=%h | if_id_out=%h",
    $time,
    branch, branch_taken,
    if_id_rs1, if_id_rs2, id_ex_rd,
    id_ex_is_load, uses_rs1, uses_rs2, write_ram,
    stall,
    dut.c_word_hdu, dut.c_word_bhu,
    id_ex_c_word,
    instr, if_id_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    branch = 0;
    write_rf = 1;
    alu_op = 4'b0000;
    alu_src = 1;
    is_jalr = 0;
    op_width = 3'b000;
    write_ram = 0;
    res = 2'b00;
    uses_rs1 = 1;
    uses_rs2 = 1;
    is_load = 0;
    id_ex_is_load = 0;
    if_id_rs1 = 5'd2;
    if_id_rs2 = 5'd3;
    id_ex_rd = 5'd5;
    funct3 = 3'b000;
    branch_taken = 0;
    instr = 32'h00510093;
    #1;

    id_ex_is_load = 1;
    id_ex_rd = 5'd5;
    if_id_rs1 = 5'd5;
    if_id_rs2 = 5'd6;
    funct3 = 3'b001;
    instr = 32'h005080B3;
    #1;

    write_ram = 1;
    write_rf = 0;
    alu_src = 1;
    uses_rs1 = 1;
    uses_rs2 = 1;
    if_id_rs1 = 5'd8;
    if_id_rs2 = 5'd9;
    id_ex_rd = 5'd9;
    funct3 = 3'b010;
    instr = 32'h00912023;
    #1;

    write_ram = 0;
    write_rf = 1;
    id_ex_is_load = 0;
    id_ex_rd = 5'd10;
    if_id_rs1 = 5'd11;
    if_id_rs2 = 5'd12;
    branch = 1;
    branch_taken = 1;
    funct3 = 3'b000;
    instr = 32'h00208463;
    #1;

    branch = 1;
    is_jalr = 1;
    branch_taken = 1;
    instr = 32'h00010067;
    #1;

    branch = 1;
    is_jalr = 0;
    branch_taken = 0;
    instr = 32'h00208463;
    #1;

    branch = 0;
    id_ex_is_load = 1;
    id_ex_rd = 5'd15;
    if_id_rs1 = 5'd14;
    if_id_rs2 = 5'd15;
    uses_rs1 = 1;
    uses_rs2 = 1;
    branch_taken = 0;
    instr = 32'h00F707B3;
    #1;

    write_ram = 0;
    write_rf = 1;
    id_ex_is_load = 0;
    id_ex_rd = 5'd20;
    if_id_rs1 = 5'd20;
    if_id_rs2 = 5'd21;
    instr = 32'h015A0A33;
    #1;

    $display("Simulation Complete");
    $finish;

  end

endmodule