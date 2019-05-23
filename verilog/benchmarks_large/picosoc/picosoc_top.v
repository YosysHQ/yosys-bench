module picosoc_top (
	input clk,
	input resetn,

	output        iomem_valid,
	input         iomem_ready,
	output [ 3:0] iomem_wstrb,
	output [31:0] iomem_addr,
	output [31:0] iomem_wdata,
	input  [31:0] iomem_rdata,

	input  irq_5,
	input  irq_6,
	input  irq_7,

	output ser_tx,
	input  ser_rx,

	output flash_csb,
	output flash_clk,

	output flash_io0_oe,
	output flash_io1_oe,
	output flash_io2_oe,
	output flash_io3_oe,

	output flash_io0_do,
	output flash_io1_do,
	output flash_io2_do,
	output flash_io3_do,

	input  flash_io0_di,
	input  flash_io1_di,
	input  flash_io2_di,
	input  flash_io3_di
);

picosoc top (
	.clk(clk),
	.resetn(resetn),

	.iomem_valid(iomem_valid),
	.iomem_ready(iomem_ready),
	.iomem_wstrb(iomem_wstrb),
	.iomem_addr(iomem_addr),
	.iomem_wdata(iomem_wdata),
	.iomem_rdata(iomem_rdata),

	.irq_5(irq_5),
	.irq_6(irq_6),
	.irq_7(irq_7),

	.ser_tx(ser_tx),
	.ser_rx(ser_rx),

	.flash_csb(flash_csb),
	.flash_clk(flash_clk),

	.flash_io0_oe(flash_io0_oe),
	.flash_io1_oe(flash_io1_oe),
	.flash_io2_oe(flash_io2_oe),
	.flash_io3_oe(flash_io3_oe),

	.flash_io0_do(flash_io0_do),
	.flash_io1_do(flash_io1_do),
	.flash_io2_do(flash_io2_do),
	.flash_io3_do(flash_io3_do),

	.flash_io0_di(flash_io0_di),
	.flash_io1_di(flash_io1_di),
	.flash_io2_di(flash_io2_di),
	.flash_io3_di(flash_io3_di)
);

endmodule

`include "picosoc.vh"
`include "simpleuart.vh"
`include "spimemio.vh"
`include "picorv32.vh"
