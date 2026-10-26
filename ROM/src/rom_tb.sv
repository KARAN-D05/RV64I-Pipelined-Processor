`timescale 1ns/1ns
`include "rom.sv"

module testbench;

 parameter MSIZE = 1024;
 parameter IWIDTH = 32;
 parameter PCWIDTH = 64;

 logic  [PCWIDTH-1:0] addr;
 logic [IWIDTH-1:0] out;

 ROM #(
     .IWIDTH(IWIDTH),
     .MSIZE(MSIZE),
     .PCWIDTH(PCWIDTH)
 ) dut (
     .addr(addr),
     .out(out)
 );

  initial begin

    $monitor("t = %0t | addr=%0d | out=%h", $time, addr, out);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    addr = 0;
    #10;

    addr = 4;
    #10;

    addr = 8;
    #10;

    addr = 12;
    #10;

    addr = 16;
    #10;

    addr = 20;
    #10;

    addr = 24;
    #10;

    $display("Simulation Complete!");
    $finish;

 end

endmodule
