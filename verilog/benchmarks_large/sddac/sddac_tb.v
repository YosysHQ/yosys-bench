// Testbench for sddac.v
// Author: Niels A. Moseley

module tb;

reg clk   = 0;
reg rst_n = 0;
reg signed [15:0] sig = 0;
wire dac_out;
integer fhandle;

// clock generation
always #1 clk=~clk;

// devices under test
sddac dut(clk, rst_n, sig, dac_out);

initial
begin
    $dumpfile("sddac_tb.vcd");
    $dumpvars;

    fhandle = $fopen("sddac_out.txt","w");

    #4 rst_n = 1'b1;

    #10000 $finish;
end

always @(posedge clk)
begin
    if (rst_n == 1'b1)
    begin
        $fwrite(fhandle, "%d\n", dac_out);
    end
end

endmodule