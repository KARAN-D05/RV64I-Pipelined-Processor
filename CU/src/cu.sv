`default_nettype none

module cu #(
    parameter IWIDTH = 32,
    parameter MOPS = 16,
    parameter MMOPS = 7,
    parameter WBS = 4
) (
    input logic [IWIDTH-1:0] instr,
    input logic beq,
    input logic bne,
    input logic blt,
    input logic bge,
    input logic bltu,
    input logic bgeu,
    output logic branch,
    output logic write_rf,
    output logic [$clog2(MOPS)-1:0] alu_op,
    output logic alu_src,
    output logic is_jalr,
    output logic [$clog2(MMOPS)-1:0] op_width,
    output logic write_ram,
    output logic [$clog2(WBS)-1:0] res,
    output logic uses_rs1,
    output logic uses_rs2,
    output logic is_load
);

  localparam OP = 7'b0110011;
  localparam OPIMM = 7'b0010011;
  localparam OP32 = 7'b0111011;
  localparam OP32IMM = 7'b0011011;
  localparam LOAD = 7'b0000011;
  localparam STORE = 7'b0100011;
  localparam BRANCH = 7'b1100011;
  localparam AUIPC = 7'b0010111;
  localparam LUI = 7'b0110111;
  localparam JALR = 7'b1100111;
  localparam JAL = 7'b1101111;

  always @(*) begin
    
    branch = 1'b0;
    write_rf = 1'b0;
    alu_op = 4'b0;
    alu_src = 1'b0;
    is_jalr = 1'b0;
    op_width = 3'b0;
    write_ram = 1'b0;
    res = 2'b0;
    uses_rs1 = 1'b0;
    uses_rs2 = 1'b0;
    is_load = 1'b0;

    case(instr[6:0])

    OP: begin
        if (instr[14:12] == 3'b000) begin
            if (instr[31:25] == 7'b0000000) begin
                write_rf = 1'b1;
                alu_op = 4'b0000;
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end else if (instr[31:25] == 7'b0100000) begin
                write_rf = 1'b1;
                alu_op = 4'b0001;
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end
        end else if (instr[14:12] == 3'b001 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b0010;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b010 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b1000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b011 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b1001;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b100 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b0111;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b101) begin
            if (instr[31:25] == 7'b0000000) begin
                write_rf = 1'b1;
                alu_op = 4'b0011;
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end else if (instr[31:25] == 7'b0100000) begin
                write_rf = 1'b1;
                alu_op = 4'b0100;
                uses_rs1 = 1'b1;
                uses_rs2 = 1'b1;
            end
        end else if (instr[14:12] == 3'b110 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b0110;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b111 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b0101;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end 
    end

    OPIMM: begin
        if (instr[14:12] == 3'b000) begin
            alu_op = 4'b0000;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b010) begin
            alu_op = 4'b1000;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b011) begin
            alu_op = 4'b1001;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b100) begin
            alu_op = 4'b0111;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b110) begin
            alu_op = 4'b0110;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b111) begin
            alu_op = 4'b0101;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b001 && instr[31:26] == 6'b000000) begin
            alu_op = 4'b0010;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b101 && instr[31:26] == 6'b000000) begin
            alu_op = 4'b0011;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b101 && instr[31:26] == 6'b010000) begin
            alu_op = 4'b0100;
            alu_src = 1'b1;
            write_rf = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end
    end

    OP32: begin
        if (instr[14:12] == 3'b000 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b1010;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b000 && instr[31:25] == 7'b0100000) begin
            write_rf = 1'b1;
            alu_op = 4'b1011;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b001 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b1100;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b101 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b1101;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b101 && instr[31:25] == 7'b0100000) begin
            write_rf = 1'b1;
            alu_op = 4'b1110;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end
    end

    OP32IMM: begin
        if (instr[14:12] == 3'b000) begin
            write_rf = 1'b1;
            alu_src = 1'b1;
            alu_op = 4'b1010;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b001 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b1100;
            alu_src = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b101 && instr[31:25] == 7'b0000000) begin
            write_rf = 1'b1;
            alu_op = 4'b1101;
            alu_src = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end else if (instr[14:12] == 3'b101 && instr[31:25] == 7'b0100000) begin
            write_rf = 1'b1;
            alu_op = 4'b1110;
            alu_src = 1'b1;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end
    end

    LOAD: begin
        if (instr[14:12] == 3'b000) begin
            write_rf = 1'b1;
            alu_src = 1'b1;
            res = 2'b01;
            op_width = 3'b000;
            alu_op = 4'b0000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
            is_load = 1'b1;
        end else if (instr[14:12] == 3'b001) begin
            write_rf = 1'b1;
            alu_src = 1'b1;
            res = 2'b01;
            op_width = 3'b001;
            alu_op = 4'b0000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
            is_load = 1'b1;
        end else if (instr[14:12] == 3'b010) begin
            write_rf = 1'b1;
            alu_src = 1'b1;
            res = 2'b01;
            op_width = 3'b010;
            alu_op = 4'b0000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
            is_load = 1'b1;
        end else if (instr[14:12] == 3'b011) begin
            write_rf = 1'b1;
            alu_src = 1'b1;
            res = 2'b01;
            op_width = 3'b011;
            alu_op = 4'b0000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
            is_load = 1'b1;
        end else if (instr[14:12] == 3'b100) begin
            write_rf = 1'b1;
            alu_src = 1'b1;
            res = 2'b01;
            op_width = 3'b100;
            alu_op = 4'b0000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
            is_load = 1'b1;
        end else if (instr[14:12] == 3'b101) begin
            write_rf = 1'b1;
            alu_src = 1'b1;
            res = 2'b01;
            op_width = 3'b101;
            alu_op = 4'b0000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
            is_load = 1'b1;
        end else if (instr[14:12] == 3'b110) begin
            write_rf = 1'b1;
            alu_src = 1'b1;
            res = 2'b01;
            op_width = 3'b110;
            alu_op = 4'b0000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
            is_load = 1'b1;
        end
    end

    STORE: begin
        if (instr[14:12] == 3'b000) begin
            alu_op = 4'b0000;
            alu_src = 1'b1;
            write_ram = 1'b1;
            op_width = 3'b000;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b001) begin
            alu_op = 4'b0000;
            alu_src = 1'b1;
            write_ram = 1'b1;
            op_width = 3'b001;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b010) begin
            alu_op = 4'b0000;
            alu_src = 1'b1;
            write_ram = 1'b1;
            op_width = 3'b010;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end else if (instr[14:12] == 3'b011) begin
            alu_op = 4'b0000;
            alu_src = 1'b1;
            write_ram = 1'b1;
            op_width = 3'b011;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
        end
    end

    BRANCH: begin
        if (instr[14:12] == 3'b000) begin
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
            if (beq == 1'b1) begin
                branch = 1'b1;
            end
        end else if (instr[14:12] == 3'b001) begin
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
            if (bne == 1'b1) begin
                branch = 1'b1;
            end
        end else if (instr[14:12] == 3'b100) begin
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
            if (blt == 1'b1) begin
                branch = 1'b1;
            end
        end else if (instr[14:12] == 3'b101) begin
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
            if (bge == 1'b1) begin
                branch = 1'b1;
            end
        end else if (instr[14:12] == 3'b110) begin
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
            if (bltu == 1'b1) begin
                branch = 1'b1;
            end
        end else if (instr[14:12] == 3'b111) begin
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b1;
            if (bgeu == 1'b1) begin
                branch = 1'b1;
            end
        end
    end

    AUIPC: begin
        write_rf = 1'b1;
        res = 2'b11;
        uses_rs1 = 1'b0;
        uses_rs2 = 1'b0;
    end

    LUI: begin
        write_rf = 1'b1;
        alu_op = 4'b1111;
        alu_src = 1'b1;
        uses_rs1 = 1'b0;
        uses_rs2 = 1'b0;
    end

    JALR: begin
        if (instr[14:12] == 3'b000) begin
            branch = 1'b1;
            is_jalr = 1'b1;
            write_rf = 1'b1;
            res = 2'b10;
            uses_rs1 = 1'b1;
            uses_rs2 = 1'b0;
        end
    end

    JAL: begin
        branch = 1'b1;
        write_rf = 1'b1;
        res = 2'b10;
        uses_rs1 = 1'b0;
        uses_rs2 = 1'b0;
    end

   endcase

  end

endmodule
