module ROM #(
    parameter MSIZE = 1024,
    parameter IWIDTH = 32,
    parameter PCWIDTH = 64
) (
    input logic [PCWIDTH-1:0] addr,
    output logic [IWIDTH-1:0] out
);

  logic [IWIDTH-1:0] mem [MSIZE-1:0];

  integer i;

  initial begin

    for(i=0; i<MSIZE; i=i+1)
      mem[i] = {IWIDTH{1'b0}};

    $readmemh("Program.hex", mem);
  end

  assign out = mem[addr >> 2];

endmodule
