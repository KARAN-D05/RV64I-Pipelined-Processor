`default_nettype none

module se #(
    parameter IW = 32,
    parameter OW = 64
) (
    input logic [IW-1:0] instr,
    output logic [OW-1:0] imm
);
   
  logic [6:0] i_type1, i_type2, i_type3, s_type, b_type, u_type1, u_type2, j_type;
  assign i_type1 = 7'b0010011;
  assign i_type2 = 7'b0000011;
  assign i_type3 = 7'b1100111;
  assign s_type = 7'b0100011;
  assign b_type = 7'b1100011;
  assign u_type1 = 7'b0110111;
  assign u_type2 = 7'b0010111;
  assign j_type = 7'b1101111;

  always @(*) begin
    if ((instr[6:0] == i_type1) || (instr[6:0] == i_type2) || (instr[6:0] == i_type3)) begin
        if ((instr[14:12] == 3'b001) || (instr[14:12] == 3'b101)) begin
            imm = {{OW-6{1'b0}}, instr[25:20]};
        end else begin
            imm = {{OW-12{instr[31]}}, instr[31:20]};
        end
    end else if (instr[6:0] == s_type) begin
        imm = {{OW-12{instr[31]}}, instr[31:25], instr[11:7]};
    end else if (instr[6:0] == b_type) begin
        imm = {{OW-13{instr[31]}}, instr[31] ,instr[7], instr[30:25], instr[11:8], 1'b0};
    end else if ((instr[6:0] == u_type1) || (instr[6:0] == u_type2)) begin
        imm = {{OW-32{instr[31]}} ,instr[31:12], 12'b0};
    end else if (instr[6:0] == j_type) begin
        imm = {{OW-21{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
    end else begin
        imm = OW'b0;
    end
  end

endmodule
