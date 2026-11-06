`default_nettype none

module HDU #(
    parameter MOPS = 16,
    parameter MMOPS = 7,
    parameter WBS = 4,
    parameter NCS = 17,
    parameter F = 5
    ) (
    input logic branch,
    input logic write_rf,
    input logic [$clog2(MOPS)-1:0] alu_op,
    input logic alu_src,
    input logic is_jalr,
    input logic [$clog2(MMOPS)-1:0] op_width,
    input logic write_ram,
    input logic [$clog2(WBS)-1:0] res,
    input logic uses_rs1,
    input logic uses_rs2,
    input logic is_load,
    input logic id_ex_is_load,
    input logic [F-1:0] if_id_rs1,
    input logic [F-1:0] if_id_rs2,
    input logic [F-1:0] id_ex_rd,
    output logic stall,
    output logic [NCS-1:0] c_word
);

  assign stall = (id_ex_rd != F'(1'b0) && if_id_rs1 == id_ex_rd && uses_rs1 && id_ex_is_load && !write_ram) || (id_ex_rd != F'(1'b0) && if_id_rs2 == id_ex_rd && uses_rs2 && id_ex_is_load && !write_ram) || (id_ex_rd != F'(1'b0) && if_id_rs1 == id_ex_rd && uses_rs1 && id_ex_is_load && write_ram);

  assign c_word = stall ? NCS'(1'b0) : {uses_rs1, uses_rs2, branch, write_rf, alu_op[$clog2(MOPS)-1:0], alu_src, is_jalr, op_width[$clog2(MMOPS)-1:0], write_ram, is_load, res[$clog2(WBS)-1:0]};

endmodule 
