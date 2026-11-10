`default_nettype none
`include "if.sv"
`include "hhu.sv"
`include "ifid.sv"
`include "id.sv"
`include "wif.sv"
`include "idex.sv"
`include "ex.sv"
`include "bcu.sv"
`include "efu.sv"
`include "exmem.sv"
`include "mem.sv"
`include "mmf.sv"
`include "memwb.sv"
`include "wb.sv"

module CORE (
    input logic rst,
    input logic clk
);

  logic [63:0] if_pc_out;
  logic [31:0] if_instr_out;
  logic [31:0] hhu_if_id_out;
  logic hhu_stall;
  logic [31:0] ifid_instr_out;
  logic [63:0] ifid_pc_out;
  logic id_branch_out;
  logic id_write_rf_out;
  logic [3:0] id_alu_op_out;
  logic id_alu_src_out;
  logic id_is_jalr_out;
  logic [2:0] id_op_width_out;
  logic id_write_ram_out;
  logic [1:0] id_res_out;
  logic [63:0] id_imm_out;
  logic [63:0] id_data_out1;
  logic [63:0] id_data_out2;
  logic id_uses_rs1_out;
  logic id_uses_rs2_out;
  logic [2:0] id_funct3_out;
  logic id_is_load_out;
  logic [19:0] hhu_id_ex_c_word_out;
  logic wif_uses_rs1;
  logic wif_uses_rs2;
  assign wif_uses_rs1 = hhu_id_ex_c_word_out[19];
  assign wif_uses_rs2 = hhu_id_ex_c_word_out[18];
  logic [4:0] rs1, rs2, rd;
  assign rs1 = ifid_instr_out[19:15];
  assign rs2 = ifid_instr_out[24:20];
  assign rd = ifid_instr_out[11:7];
  logic [63:0] wif_data_out1;
  logic [63:0] wif_data_out2;
  logic [63:0] idex_data_out1;
  logic [63:0] idex_data_out2;
  logic [63:0] idex_pc_out;
  logic [63:0] idex_imm_out;
  logic [4:0] idex_rs1_out;
  logic [4:0] idex_rs2_out;
  logic [4:0] idex_rd_out;
  logic [19:0] idex_c_word_out;
  logic ex_beq_out;
  logic ex_bne_out;
  logic ex_blt_out;
  logic ex_bltu_out;
  logic ex_bgeu_out;
  logic ex_bge_out;
  logic [63:0] ex_alu_out;
  logic [63:0] ex_t_out;
  logic [63:0] ex_r_out;
  logic bcu_branch_taken_out;
  logic [63:0] efu_data_out1;
  logic [63:0] efu_data_out2;
  logic [63:0] exmem_alu_out;
  logic [63:0] exmem_data_out2;
  logic [63:0] exmem_r_out;
  logic [63:0] exmem_t_out;
  logic [7:0] exmem_c_word_out;
  logic [4:0] exmem_rs2_out;
  logic [4:0] exmem_rd_out;
  logic [63:0] mmf_out;
  logic [63:0] mem_out;
  logic [63:0] memwb_mem_out;
  logic [63:0] memwb_alu_out;
  logic [63:0] memwb_r_out;
  logic [63:0] memwb_t_out;
  logic [2:0] memwb_c_word_out;
  logic [4:0] memwb_rd_out;
  logic [63:0] wb_out;

  IF # (
    .MSIZE(1024),
    .IWIDTH(32),
    .PCWIDTH(64)
  ) if_inst (
    .target(ex_t_out),
    .branch(bcu_branch_taken_out),
    .stall(hhu_stall),
    .rst(rst),
    .clk(clk),
    .pc_out(if_pc_out),
    .instr_out(if_instr_out)
  );

  HHU #(
    .MOPS(16),
    .MMOPS(7),
    .WBS(4),
    .NCS(20),
    .F(5),
    .FW(3),
    .IW(32)
  ) hhu_inst (
    .branch(id_branch_out),
    .write_rf(id_write_rf_out),
    .alu_op(id_alu_op_out),
    .alu_src(id_alu_src_out),
    .is_jalr(id_is_jalr_out),
    .op_width(id_op_width_out),
    .write_ram(id_write_ram_out),
    .res(id_res_out),
    .uses_rs1(id_uses_rs1_out),
    .uses_rs2(id_uses_rs2_out),
    .is_load(id_is_load_out),
    .id_ex_is_load(idex_c_word_out[5]),
    .if_id_rs1(rs1),
    .if_id_rs2(rs2),
    .id_ex_rd(idex_rd_out),
    .funct3(id_funct3_out),
    .branch_taken(bcu_branch_taken_out),
    .instr(if_instr_out),
    .stall(hhu_stall),
    .id_ex_c_word(hhu_id_ex_c_word_out),
    .if_id_out(hhu_if_id_out)
  );

  IFID #(
    .IWIDTH(32),
    .PCWIDTH(64)
  ) ifid_inst (
    .instr_in(hhu_if_id_out),
    .pc_in(if_pc_out),
    .clk(clk),
    .rst(rst),
    .stall(hhu_stall),
    .instr_out(ifid_instr_out),
    .pc_out(ifid_pc_out)
  );

  ID #(
    .W(64),
    .IW(32),
    .MOPS(16),
    .MMOPS(7),
    .WBS(4),
    .FB(3)
  ) id_inst (
    .Raddr1(rs1),
    .Raddr2(rs2),
    .Waddr(memwb_rd_out),
    .data_in(wb_out),
    .write(memwb_c_word_out[2]),
    .clk(clk),
    .instr(ifid_instr_out),
    .branch(id_branch_out),
    .write_rf(id_write_rf_out),
    .alu_op(id_alu_op_out),
    .alu_src(id_alu_src_out),
    .is_jalr(id_is_jalr_out),
    .op_width(id_op_width_out),
    .write_ram(id_write_ram_out),
    .res(id_res_out),
    .imm(id_imm_out),
    .data_out1(id_data_out1),
    .data_out2(id_data_out2),
    .uses_rs1(id_uses_rs1_out),
    .uses_rs2(id_uses_rs2_out),
    .funct3(id_funct3_out),
    .is_load(id_is_load_out)
  );

  IDEX #(
    .NCS(20),
    .F(5),
    .W(64)
  ) idex_inst (
    .data_in1(wif_data_out1),
    .data_in2(wif_data_out2),
    .pc_in(ifid_pc_out),
    .imm_in(id_imm_out),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .c_word_in(hhu_id_ex_c_word_out),
    .clk(clk),
    .rst(rst),
    .data_out1(idex_data_out1),
    .data_out2(idex_data_out2),
    .pc_out(idex_pc_out),
    .imm_out(idex_imm_out),
    .rs1_out(idex_rs1_out),
    .rs2_out(idex_rs2_out),
    .rd_out(idex_rd_out),
    .c_word_out(idex_c_word_out)
  );

  WIF #(
    .W(64),
    .F(5)
  ) wif_inst (
    .if_id_data1(id_data_out1),
    .if_id_data2(id_data_out2),
    .rs1(rs1),
    .rs2(rs2),
    .mem_wb_rd(memwb_rd_out),
    .uses_rs1(wif_uses_rs1),
    .uses_rs2(wif_uses_rs2),
    .mem_wb_write_rf(memwb_c_word_out[2]),
    .mem_wb_result(wb_out),
    .out1(wif_data_out1),
    .out2(wif_data_out2)
  );

  EX #(
    .W(64),
    .MOPS(16)
  ) ex_inst (
    .pc(idex_pc_out),
    .rs1(efu_data_out1),
    .rs2(efu_data_out2),
    .imm(idex_imm_out),
    .is_jalr(idex_c_word_out[10]),
    .alu_op(idex_c_word_out[15:12]),
    .alu_src(idex_c_word_out[11]),
    .beq(ex_beq_out),
    .bne(ex_bne_out),
    .blt(ex_blt_out),
    .bge(ex_bge_out),
    .bltu(ex_bltu_out),
    .bgeu(ex_bgeu_out),
    .out(ex_alu_out),
    .t_out(ex_t_out),
    .r_out(ex_r_out)
  );

  BCU #(
    .FB(3)
  ) bcu_inst (
    .branch(idex_c_word_out[17]),
    .uses_rs1(idex_c_word_out[19]),
    .uses_rs2(idex_c_word_out[18]),
    .is_jalr(idex_c_word_out[10]),
    .beq(ex_beq_out),
    .bne(ex_bne_out),
    .bge(ex_bge_out),
    .blt(ex_blt_out),
    .bgeu(ex_bgeu_out),
    .bltu(ex_bltu_out),
    .funct3(idex_c_word_out[2:0]),
    .branch_taken(bcu_branch_taken_out)
  );

  EFU #(
    .W(64),
    .F(5)
  ) efu_inst (
    .id_ex_rs1(idex_rs1_out),
    .id_ex_rs2(idex_rs2_out),
    .id_ex_data1(idex_data_out1),
    .id_ex_data2(idex_data_out2),
    .ex_mem_result(exmem_alu_out),
    .ex_mem_write_rf(exmem_c_word_out[6]),
    .ex_mem_rd(exmem_rd_out),
    .uses_rs1(idex_c_word_out[19]),
    .uses_rs2(idex_c_word_out[18]),
    .mem_wb_rd(memwb_rd_out),
    .mem_wb_write_rf(memwb_c_word_out[2]),
    .mem_wb_result(wb_out),
    .alu_operand_a(efu_data_out1),
    .alu_operand_b(efu_data_out2)
  );

  EXMEM #(
    .W(64),
    .F(5),
    .NCS(8)
  ) exmem_inst (
    .alu_in(ex_alu_out),
    .data_in2(efu_data_out2),
    .r_in(ex_r_out),
    .t_in(ex_t_out),
    .c_word_in({idex_c_word_out[18], idex_c_word_out[16], idex_c_word_out[9:7], idex_c_word_out[6], idex_c_word_out[4:3]}),
    .rs2(idex_rs2_out),
    .rd(idex_rd_out),
    .rst(rst),
    .clk(clk),
    .alu_out(exmem_alu_out),
    .data_out2(exmem_data_out2),
    .r_out(exmem_r_out),
    .t_out(exmem_t_out),
    .c_word_out(exmem_c_word_out),
    .rs2_out(exmem_rs2_out),
    .rd_out(exmem_rd_out)
  );

  MEM #(
    .MSIZE(1024),
    .MWS(8),
    .W(64),
    .MOPS(7)
  ) mem_inst (
    .in(mmf_out),
    .addr(exmem_alu_out[9:0]),
    .op_width(exmem_c_word_out[5:3]),
    .clk(clk),
    .write(exmem_c_word_out[2]),
    .out(mem_out)
  );

  MMF #(
    .W(64),
    .F(5)
  ) mmf_inst (
    .ex_mem_data_in(exmem_data_out2),
    .mem_wb_rd(memwb_rd_out),
    .ex_mem_rs2(exmem_rs2_out),
    .mem_wb_result(wb_out),
    .mem_wb_write_rf(memwb_c_word_out[2]),
    .uses_rs2(exmem_c_word_out[7]),
    .data_out(mmf_out)
  );

  MEMWB #(
    .W(64),
    .NCS(3),
    .F(5)
  ) memwb_inst (
    .mem_in(mem_out),
    .alu_in(exmem_alu_out),
    .r_in(exmem_r_out),
    .t_in(exmem_t_out),
    .c_word_in({exmem_c_word_out[6], exmem_c_word_out[1:0]}),
    .rd(exmem_rd_out),
    .rst(rst),
    .clk(clk),
    .mem_out(memwb_mem_out),
    .alu_out(memwb_alu_out),
    .r_out(memwb_r_out),
    .t_out(memwb_t_out),
    .c_word_out(memwb_c_word_out),
    .rd_out(memwb_rd_out)
  );

  WB #(
    .W(64),
    .IN(4)
  ) wb_inst (
    .alu_out(memwb_alu_out),
    .mem_out(memwb_mem_out),
    .r_out(memwb_r_out),
    .t_out(memwb_t_out),
    .res(memwb_c_word_out[1:0]),
    .out(wb_out)
  );

endmodule
