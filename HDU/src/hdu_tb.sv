`timescale 1ns/1ns
`include "hdu.sv"

module testbench;

  parameter MOPS = 16;
  parameter MMOPS = 7;
  parameter WBS = 4;
  parameter NCS = 20;
  parameter F = 5;
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
  logic id_ex_is_load;
  logic [F-1:0] if_id_rs1;
  logic [F-1:0] if_id_rs2;
  logic [F-1:0] id_ex_rd;
  logic [FW-1:0] funct3;
  logic stall;
  logic [NCS-1:0] c_word;

  HDU #(
    .MOPS(MOPS),
    .MMOPS(MMOPS),
    .WBS(WBS),
    .NCS(NCS),
    .F(F),
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
    .id_ex_is_load(id_ex_is_load),
    .if_id_rs1(if_id_rs1),
    .if_id_rs2(if_id_rs2),
    .id_ex_rd(id_ex_rd),
    .funct3(funct3),
    .stall(stall),
    .c_word(c_word)
  );

  initial begin

    $monitor("time=%0t | if_id_rs1=%0d if_id_rs2=%0d | id_ex_rd=%0d | id_ex_is_load=%b | uses_rs1=%b uses_rs2=%b | write_ram=%b | funct3=%b | stall=%b | c_word=%h",
             $time, if_id_rs1, if_id_rs2, id_ex_rd, id_ex_is_load,
             uses_rs1, uses_rs2, write_ram, funct3, stall, c_word);

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
    funct3 = 3'b000;
    if_id_rs1 = 5'd5;
    if_id_rs2 = 5'd6;
    id_ex_rd = 5'd5;
    #1;

    if_id_rs1 = 5'd3;
    if_id_rs2 = 5'd7;
    id_ex_rd = 5'd7;
    funct3 = 3'b001;
    #1;

    write_ram = 1;
    write_rf = 0;
    alu_src = 1;
    uses_rs1 = 1;
    uses_rs2 = 1;
    if_id_rs1 = 5'd8;
    if_id_rs2 = 5'd9;
    id_ex_rd = 5'd8;
    funct3 = 3'b010;
    #1;

    if_id_rs1 = 5'd10;
    if_id_rs2 = 5'd11;
    id_ex_rd = 5'd11;
    funct3 = 3'b011;
    #1;

    if_id_rs1 = 5'd12;
    if_id_rs2 = 5'd13;
    id_ex_rd = 5'd14;
    funct3 = 3'b100;
    #1;

    if_id_rs1 = 5'd15;
    if_id_rs2 = 5'd16;
    id_ex_rd = 5'd0;
    funct3 = 3'b101;
    #1;

    write_ram = 0;
    write_rf = 1;
    alu_src = 0;
    uses_rs1 = 0;
    uses_rs2 = 1;
    if_id_rs1 = 5'd17;
    if_id_rs2 = 5'd18;
    id_ex_rd = 5'd17;
    funct3 = 3'b110;
    #1;

    uses_rs1 = 1;
    uses_rs2 = 0;
    if_id_rs1 = 5'd19;
    if_id_rs2 = 5'd20;
    id_ex_rd = 5'd20;
    funct3 = 3'b111;
    #1;

    uses_rs1 = 1;
    uses_rs2 = 1;
    id_ex_is_load = 0;
    if_id_rs1 = 5'd21;
    if_id_rs2 = 5'd22;
    id_ex_rd = 5'd21;
    funct3 = 3'b000;
    #1;

    id_ex_is_load = 1;
    write_ram = 1;
    write_rf = 0;
    alu_src = 1;
    if_id_rs1 = 5'd23;
    if_id_rs2 = 5'd23;
    id_ex_rd = 5'd23;
    funct3 = 3'b111;
    #1;

    $display("Simulation Complete!");
    $finish;

  end

endmodule
