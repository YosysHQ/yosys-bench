module picorv32_small (
    input clk, resetn,

    output        mem_valid,
    output        mem_instr,
    input         mem_ready,

    output [31:0] mem_addr,
    output [31:0] mem_wdata,
    output [ 3:0] mem_wstrb,
    input  [31:0] mem_rdata
);
    top_small picorv32(
        .clk      (clk      ),
        .resetn   (resetn   ),
        .mem_valid(mem_valid),
        .mem_instr(mem_instr),
        .mem_ready(mem_ready),
        .mem_addr (mem_addr ),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata)
    );
endmodule

`include "synth_area_top.vh"
`include "picorv32.vh"
