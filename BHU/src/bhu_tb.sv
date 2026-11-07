`timescale 1ns/1ns
`include "bhu.sv"

module testbench;

  parameter IW = 32;
  parameter MOPS = 16;
  parameter MMOPS = 7;
  parameter WBS = 4;
  parameter NCS = 20;
  parameter FW = 3;

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
  logic branch_taken;
  logic [FW-1:0] funct3;
  logic [NCS-1:0] id_ex_c_word;
  logic [IW-1:0] instr;
  logic [IW-1:0] if_id_out;

  BHU #(
    .IW(IW),
    .MOPS(MOPS),
    .MMOPS(MMOPS),
    .WBS(WBS),
    .NCS(NCS),
    .FW(FW)
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
    .branch_taken(branch_taken),
    .funct3(funct3),
    .id_ex_c_word(id_ex_c_word),
    .instr(instr),
    .if_id_out(if_id_out)
  );

  initial begin

    $monitor("time=%0t | branch=%b branch_taken=%b | uses_rs1=%b uses_rs2=%b | write_rf=%b alu_op=%b alu_src=%b is_jalr=%b op_width=%b write_ram=%b is_load=%b res=%b funct3=%b | instr=%h | id_ex_c_word=%h | if_id_out=%h",
    $time,
    branch, branch_taken,
    uses_rs1, uses_rs2,
    write_rf, alu_op, alu_src, is_jalr,
    op_width, write_ram, is_load, res, funct3,
    instr, id_ex_c_word, if_id_out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    branch = 1'b0;
    branch_taken = 1'b0;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    write_rf = 1'b1;
    alu_op = 4'b0000;
    alu_src = 1'b1;
    is_jalr = 1'b0;
    op_width = 3'b000;
    write_ram = 1'b0;
    is_load = 1'b0;
    res = 2'b00;
    funct3 = 3'b000;
    instr = 32'h00510093;
    #1;

    branch = 1'b1;
    branch_taken = 1'b1;
    instr = 32'h00208463;
    #1;

    branch = 1'b0;
    branch_taken = 1'b0;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b0;
    write_rf = 1'b1;
    alu_op = 4'b0001;
    alu_src = 1'b0;
    is_jalr = 1'b1;
    op_width = 3'b001;
    write_ram = 1'b0;
    is_load = 1'b1;
    res = 2'b01;
    funct3 = 3'b001;
    instr = 32'h00010067;
    #1;

    branch = 1'b1;
    branch_taken = 1'b1;
    instr = 32'h00000013;
    #1;

    branch = 1'b0;
    branch_taken = 1'b0;
    uses_rs1 = 1'b1;
    uses_rs2 = 1'b1;
    write_rf = 1'b0;
    alu_op = 4'b1010;
    alu_src = 1'b1;
    is_jalr = 1'b0;
    op_width = 3'b010;
    write_ram = 1'b1;
    is_load = 1'b0;
    res = 2'b00;
    funct3 = 3'b010;
    instr = 32'h00312023;
    #1;

    branch = 1'b1;
    branch_taken = 1'b1;
    instr = 32'h00000000;
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule
