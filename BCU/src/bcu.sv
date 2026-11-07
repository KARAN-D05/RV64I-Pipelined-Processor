`default_nettype none

module BCU #(
    parameter FB = 3
) (
    input logic branch,
    input logic uses_rs1,
    input logic uses_rs2,
    input logic is_jalr,
    input logic beq,
    input logic bne,
    input logic bge,
    input logic blt,
    input logic bgeu,
    input logic bltu,
    input logic [FB-1:0] funct3,
    output logic branch_taken
);

  always_comb begin
    if (branch && uses_rs1 && uses_rs2) begin
        if (funct3 == 3'b000) begin
            if (beq) begin
                branch_taken = 1'b1;
            end else begin
                branch_taken = 1'b0;
            end
        end else if (funct3 == 3'b001) begin
            if (bne) begin
                branch_taken = 1'b1;
            end else begin
                branch_taken = 1'b0;
            end
        end else if (funct3 == 3'b100) begin
            if (blt) begin
                branch_taken = 1'b1;
            end else begin
                branch_taken = 1'b0;
            end
        end else if (funct3 == 3'b101) begin
            if (bge) begin
                branch_taken = 1'b1;
            end else begin
                branch_taken = 1'b0;
            end
        end else if (funct3 == 3'b110) begin
            if (bltu) begin
                branch_taken = 1'b1;
            end else begin
                branch_taken = 1'b0;
            end
        end else if (funct3 == 3'b111) begin
            if (bgeu) begin
                branch_taken = 1'b1;
            end else begin
                branch_taken = 1'b0;
            end
        end else begin
            branch_taken = 1'b0;
        end
    end else if (branch && is_jalr && uses_rs1 && !uses_rs2) begin
        branch_taken = 1'b1;
    end else if (branch && !uses_rs1 && !uses_rs2) begin
        branch_taken = 1'b1;
    end else begin
        branch_taken = 1'b0;
    end
  end

endmodule 
