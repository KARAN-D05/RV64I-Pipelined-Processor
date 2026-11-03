`timescale 1ns/1ps
`include "wb.sv"

module testbench;

    logic [63:0] alu_out;
    logic [63:0] mem_out;
    logic [63:0] r_out;
    logic [63:0] t_out;
    logic [1:0] res;
    logic [63:0] out;

    integer passed = 0;
    integer failed = 0;

    WB #(
        .W(64),
        .IN(4)
    ) dut (
        .alu_out(alu_out),
        .mem_out(mem_out),
        .r_out(r_out),
        .t_out(t_out),
        .res(res),
        .out(out)
    );

    task automatic check(
        input logic [63:0] expected,
        input string test_name
    );
        begin
            #1;

            if (out === expected) begin
                $display("PASS: %s", test_name);
                passed++;
            end
            else begin
                $display("FAIL: %s", test_name);
                $display("Expected: %h", expected);
                $display("Actual  : %h", out);
                failed++;
            end
        end
    endtask

    initial begin

        $dumpfile("sim.vcd");
        $dumpvars(0, testbench);

        alu_out = 64'hAAAAAAAAAAAAAAAA;
        mem_out = 64'hBBBBBBBBBBBBBBBB;
        r_out   = 64'hCCCCCCCCCCCCCCCC;
        t_out   = 64'hDDDDDDDDDDDDDDDD;
        res = 2'b00;
        check(64'hAAAAAAAAAAAAAAAA, "ALU result");

        res = 2'b01;
        check(64'hBBBBBBBBBBBBBBBB, "Memory result");

        res = 2'b10;
        check(64'hCCCCCCCCCCCCCCCC, "TAG return address");

        res = 2'b11;
        check(64'hDDDDDDDDDDDDDDDD, "TAG target address");

        $display("Passed: %0d", passed);
        $display("Failed: %0d", failed);

        $finish;

    end

endmodule