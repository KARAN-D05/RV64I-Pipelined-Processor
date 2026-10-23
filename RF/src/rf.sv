`default_nettype none

module RF #(
    parameter WIDTH = 64,
    parameter NUM = 32
) (
    input logic [$clog2(NUM)-1:0] Raddr1,
    input logic [$clog2(NUM)-1:0] Raddr2,
    input logic [$clog2(NUM)-1:0] Waddr,
    input logic [WIDTH-1:0] data_in,
    input logic write,
    input logic clk,
    output logic [WIDTH-1:0] data_out1,
    output logic [WIDTH-1:0] data_out2
);

  logic [WIDTH-1:0] Regs [NUM-1:0];

  localparam [$clog2(NUM)-1:0] reg0 = 0;
  localparam [$clog2(NUM)-1:0] reg1 = 1;
  localparam [$clog2(NUM)-1:0] reg2 = 2;
  localparam [$clog2(NUM)-1:0] reg3 = 3;
  localparam [$clog2(NUM)-1:0] reg4 = 4;
  localparam [$clog2(NUM)-1:0] reg5 = 5;
  localparam [$clog2(NUM)-1:0] reg6 = 6;
  localparam [$clog2(NUM)-1:0] reg7 = 7;
  localparam [$clog2(NUM)-1:0] reg8 = 8;
  localparam [$clog2(NUM)-1:0] reg9 = 9;
  localparam [$clog2(NUM)-1:0] reg10 = 10;
  localparam [$clog2(NUM)-1:0] reg11 = 11;
  localparam [$clog2(NUM)-1:0] reg12 = 12;
  localparam [$clog2(NUM)-1:0] reg13 = 13;
  localparam [$clog2(NUM)-1:0] reg14 = 14;
  localparam [$clog2(NUM)-1:0] reg15 = 15;
  localparam [$clog2(NUM)-1:0] reg16 = 16;
  localparam [$clog2(NUM)-1:0] reg17 = 17;
  localparam [$clog2(NUM)-1:0] reg18 = 18;
  localparam [$clog2(NUM)-1:0] reg19 = 19;
  localparam [$clog2(NUM)-1:0] reg20 = 20;
  localparam [$clog2(NUM)-1:0] reg21 = 21;
  localparam [$clog2(NUM)-1:0] reg22 = 22;
  localparam [$clog2(NUM)-1:0] reg23 = 23;
  localparam [$clog2(NUM)-1:0] reg24 = 24;
  localparam [$clog2(NUM)-1:0] reg25 = 25;
  localparam [$clog2(NUM)-1:0] reg26 = 26;
  localparam [$clog2(NUM)-1:0] reg27 = 27;
  localparam [$clog2(NUM)-1:0] reg28 = 28;
  localparam [$clog2(NUM)-1:0] reg29 = 29;
  localparam [$clog2(NUM)-1:0] reg30 = 30;
  localparam [$clog2(NUM)-1:0] reg31 = 31;

  always_comb begin
    case(Raddr1)
    reg0: data_out1 = {WIDTH{1'b0}};
    reg1: data_out1 = Regs[reg1];
    reg2: data_out1 = Regs[reg2];
    reg3: data_out1 = Regs[reg3];
    reg4: data_out1 = Regs[reg4];
    reg5: data_out1 = Regs[reg5];
    reg6: data_out1 = Regs[reg6];
    reg7: data_out1 = Regs[reg7];
    reg8: data_out1 = Regs[reg8];
    reg9: data_out1 = Regs[reg9];
    reg10: data_out1 = Regs[reg10];
    reg11: data_out1 = Regs[reg11];
    reg12: data_out1 = Regs[reg12];
    reg13: data_out1 = Regs[reg13];
    reg14: data_out1 = Regs[reg14];
    reg15: data_out1 = Regs[reg15];
    reg16: data_out1 = Regs[reg16];
    reg17: data_out1 = Regs[reg17];
    reg18: data_out1 = Regs[reg18];
    reg19: data_out1 = Regs[reg19];
    reg20: data_out1 = Regs[reg20];
    reg21: data_out1 = Regs[reg21];
    reg22: data_out1 = Regs[reg22];
    reg23: data_out1 = Regs[reg23];
    reg24: data_out1 = Regs[reg24];
    reg25: data_out1 = Regs[reg25];
    reg26: data_out1 = Regs[reg26];
    reg27: data_out1 = Regs[reg27];
    reg28: data_out1 = Regs[reg28];
    reg29: data_out1 = Regs[reg29];
    reg30: data_out1 = Regs[reg30];
    reg31: data_out1 = Regs[reg31];
    default: data_out1 = {WIDTH{1'b0}};
    endcase
  end

  always_comb begin
    case(Raddr2)
    reg0: data_out2 = {WIDTH{1'b0}};
    reg1: data_out2 = Regs[reg1];
    reg2: data_out2 = Regs[reg2];
    reg3: data_out2 = Regs[reg3];
    reg4: data_out2 = Regs[reg4];
    reg5: data_out2 = Regs[reg5];
    reg6: data_out2 = Regs[reg6];
    reg7: data_out2 = Regs[reg7];
    reg8: data_out2 = Regs[reg8];
    reg9: data_out2 = Regs[reg9];
    reg10: data_out2 = Regs[reg10];
    reg11: data_out2 = Regs[reg11];
    reg12: data_out2 = Regs[reg12];
    reg13: data_out2 = Regs[reg13];
    reg14: data_out2 = Regs[reg14];
    reg15: data_out2 = Regs[reg15];
    reg16: data_out2 = Regs[reg16];
    reg17: data_out2 = Regs[reg17];
    reg18: data_out2 = Regs[reg18];
    reg19: data_out2 = Regs[reg19];
    reg20: data_out2 = Regs[reg20];
    reg21: data_out2 = Regs[reg21];
    reg22: data_out2 = Regs[reg22];
    reg23: data_out2 = Regs[reg23];
    reg24: data_out2 = Regs[reg24];
    reg25: data_out2 = Regs[reg25];
    reg26: data_out2 = Regs[reg26];
    reg27: data_out2 = Regs[reg27];
    reg28: data_out2 = Regs[reg28];
    reg29: data_out2 = Regs[reg29];
    reg30: data_out2 = Regs[reg30];
    reg31: data_out2 = Regs[reg31];
    default: data_out2 = {WIDTH{1'b0}};
    endcase
  end

  always_ff @(posedge clk) begin
    if (write) begin
        case(Waddr)
        reg1: Regs[reg1] <= data_in;
        reg2: Regs[reg2] <= data_in;
        reg3: Regs[reg3] <= data_in;
        reg4: Regs[reg4] <= data_in;
        reg5: Regs[reg5] <= data_in;
        reg6: Regs[reg6] <= data_in;
        reg7: Regs[reg7] <= data_in;
        reg8: Regs[reg8] <= data_in;
        reg9: Regs[reg9] <= data_in;
        reg10: Regs[reg10] <= data_in;
        reg11: Regs[reg11] <= data_in;
        reg12: Regs[reg12] <= data_in;
        reg13: Regs[reg13] <= data_in;
        reg14: Regs[reg14] <= data_in;
        reg15: Regs[reg15] <= data_in;
        reg16: Regs[reg16] <= data_in;
        reg17: Regs[reg17] <= data_in;
        reg18: Regs[reg18] <= data_in;
        reg19: Regs[reg19] <= data_in;
        reg20: Regs[reg20] <= data_in;
        reg21: Regs[reg21] <= data_in;
        reg22: Regs[reg22] <= data_in;
        reg23: Regs[reg23] <= data_in;
        reg24: Regs[reg24] <= data_in;
        reg25: Regs[reg25] <= data_in;
        reg26: Regs[reg26] <= data_in;
        reg27: Regs[reg27] <= data_in;
        reg28: Regs[reg28] <= data_in;
        reg29: Regs[reg29] <= data_in;
        reg30: Regs[reg30] <= data_in;
        reg31: Regs[reg31] <= data_in;
    endcase
    end
  end

endmodule