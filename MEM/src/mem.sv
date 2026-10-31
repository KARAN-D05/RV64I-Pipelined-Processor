`default_nettype none

module MEM #(
    parameter MSIZE = 1024,
    parameter MWS = 8,
    parameter W = 64,
    parameter MOPS = 7
) (
    input logic [W-1:0] in,
    input logic [$clog2(MSIZE)-1:0] addr,
    input logic [$clog2(MOPS)-1:0] op_width,
    input logic clk,
    input logic write,
    output logic [W-1:0] out
);

  logic [MWS-1:0] mem [MSIZE-1:0];

  logic [MWS-1:0] mem_out1, mem_out2, mem_out3, mem_out4, mem_out5, mem_out6, mem_out7, mem_out8;
  assign mem_out1 = mem[addr];
  assign mem_out2 = mem[addr + 1];
  assign mem_out3 = mem[addr + 2];
  assign mem_out4 = mem[addr + 3];
  assign mem_out5 = mem[addr + 4];
  assign mem_out6 = mem[addr + 5];
  assign mem_out7 = mem[addr + 6];
  assign mem_out8 = mem[addr + 7];

  always @(*) begin
    if (op_width == 3'b000) begin
        out = {{(W-8){mem_out1[MWS-1]}}, mem_out1};
    end else if (op_width == 3'b001) begin
        out = {{(W-16){mem_out2[MWS-1]}}, mem_out2, mem_out1};
    end else if (op_width == 3'b010) begin
        out = {{(W-32){mem_out4[MWS-1]}}, mem_out4, mem_out3, mem_out2, mem_out1};
    end else if (op_width == 3'b011) begin
        out = {mem_out8, mem_out7, mem_out6, mem_out5, mem_out4, mem_out3, mem_out2, mem_out1};
    end else if (op_width == 3'b100) begin
        out = {(W-8)'(1'b0), mem_out1};
    end else if (op_width == 3'b101) begin
        out = {(W-16)'(1'b0), mem_out2, mem_out1};
    end else if (op_width == 3'b110) begin
        out = {(W-32)'(1'b0), mem_out4, mem_out3, mem_out2, mem_out1};
    end else begin
        out = W'(1'b0);
    end
  end

  always_ff @(posedge clk) begin
    if (write) begin
        if (op_width == 3'b000) begin
            mem[addr] <= in[MWS-1:0];
        end else if (op_width == 3'b001) begin
            mem[addr] <= in[MWS-1:0];
            mem[addr + 1] <= in[(2*MWS)-1:MWS];
        end else if (op_width == 3'b010) begin
            mem[addr] <= in[MWS-1:0];
            mem[addr + 1] <= in[(2*MWS)-1:MWS];
            mem[addr + 2] <= in[(3*MWS)-1:(2*MWS)];
            mem[addr + 3] <= in[(4*MWS)-1:(3*MWS)];
        end else if (op_width == 3'b011) begin
            mem[addr] <= in[MWS-1:0];
            mem[addr + 1] <= in[(2*MWS)-1:MWS];
            mem[addr + 2] <= in[(3*MWS)-1:(2*MWS)];
            mem[addr + 3] <= in[(4*MWS)-1:(3*MWS)];
            mem[addr + 4] <= in[(5*MWS)-1:(4*MWS)];
            mem[addr + 5] <= in[(6*MWS)-1:(5*MWS)];
            mem[addr + 6] <= in[(7*MWS)-1:(6*MWS)];
            mem[addr + 7] <= in[(8*MWS)-1:(7*MWS)];
        end
    end
  end

endmodule 
