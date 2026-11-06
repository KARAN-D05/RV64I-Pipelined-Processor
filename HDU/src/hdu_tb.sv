`timescale 1ns/1ns
`include "hdu.sv"

module testbench;

  parameter MOPS = 16;
  parameter MMOPS = 7;
  parameter WBS = 4;
  parameter NCS = 17;
  parameter F = 5;

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
  logic stall;
  logic [NCS-1:0] c_word;

  HDU #(
    .MOPS(MOPS),
    .MMOPS(MMOPS),
    .WBS(WBS),
    .NCS(NCS),
    .F(F)
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
    .stall(stall),
    .c_word(c_word)
  );

  initial begin

    $monitor("time = %0t | if_id_rs1 = %0d | if_id_rs2 = %0d | id_ex_rd = %0d | id_ex_is_load = %b | uses_rs1 = %b | uses_rs2 = %b | write_ram = %b | stall = %b | c_word = %h",
             $time, if_id_rs1, if_id_rs2, id_ex_rd, id_ex_is_load,
             uses_rs1, uses_rs2, write_ram, stall, c_word);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    branch = 0;
    write_rf = 1;
    alu_op = 4'b0000;
    alu_src = 0;
    is_jalr = 0;
    op_width = 3'b000;
    write_ram = 0;
    res = 2'b00;
    uses_rs1 = 1;
    uses_rs2 = 1;
    is_load = 0;
    id_ex_is_load = 1;
    if_id_rs1 = 5'd5;
    if_id_rs2 = 5'd6;
    id_ex_rd = 5'd5;
    #1;

    if_id_rs1 = 5'd3;
    if_id_rs2 = 5'd7;
    id_ex_rd = 5'd7;
    #1;

    write_ram = 1;
    write_rf = 0;
    alu_src = 1;
    uses_rs1 = 1;
    uses_rs2 = 1;
    if_id_rs1 = 5'd8;
    if_id_rs2 = 5'd9;
    id_ex_rd = 5'd8;
    #1;

    if_id_rs1 = 5'd10;
    if_id_rs2 = 5'd11;
    id_ex_rd = 5'd11;
    #1;

    if_id_rs1 = 5'd12;
    if_id_rs2 = 5'd13;
    id_ex_rd = 5'd14;
    #1;

    if_id_rs1 = 5'd15;
    if_id_rs2 = 5'd16;
    id_ex_rd = 5'd0;
    #1;

    write_ram = 0;
    write_rf = 1;
    alu_src = 0;
    uses_rs1 = 0;
    uses_rs2 = 1;
    if_id_rs1 = 5'd17;
    if_id_rs2 = 5'd18;
    id_ex_rd = 5'd17;
    #1;

    uses_rs1 = 1;
    uses_rs2 = 0;
    if_id_rs1 = 5'd19;
    if_id_rs2 = 5'd20;
    id_ex_rd = 5'd20;
    #1;

    uses_rs1 = 1;
    uses_rs2 = 1;
    id_ex_is_load = 0;
    if_id_rs1 = 5'd21;
    if_id_rs2 = 5'd22;
    id_ex_rd = 5'd21;
    #1;

    id_ex_is_load = 1;
    write_ram = 1;
    write_rf = 0;
    alu_src = 1;
    if_id_rs1 = 5'd23;
    if_id_rs2 = 5'd23;
    id_ex_rd = 5'd23;
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule