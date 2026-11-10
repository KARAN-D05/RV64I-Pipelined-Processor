`timescale 1ns/1ns
`include "core.sv"

module testbench;

  logic rst;
  logic clk;

  CORE dut (
    .rst(rst),
    .clk(clk)
  );

  always #5 clk = ~clk;

  initial begin

    $monitor("t = %03t | PC = %02h | Rd = %0h | INSTR = %04h | r1 = %04h | r2 = %04h | r3 = %04h | r4 = %04h | r5 = %04h ", $time, dut.if_pc_out, dut.memwb_rd_out, dut.if_instr_out, dut.id_inst.dut1.Regs[1], dut.id_inst.dut1.Regs[2], dut.id_inst.dut1.Regs[3], dut.id_inst.dut1.Regs[4], dut.id_inst.dut1.Regs[5]);

    $dumpfile("Sim.vcd");
    $dumpvars(0, testbench);

    clk = 0;
    rst = 1;

    #10;
    rst = 0;#500;

    $display("Simulation Complete!");
    $finish;
    
  end

endmodule