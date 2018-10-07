// Second order sigma-delta dac
//
// For benchmarking purposes only -- don't use this for an actual design.
// There are far more performant architectures. 
// 
// Author: Niels A. Moseley, n.a.moseley@moseleyinstruments.com
//

`ifdef DEBUG_SDDAC
`include "constants.vams"
`endif

module sddac(clk, rst_n, sig_in, sd_out);

    // inputs
    input clk;                          // clock
    input rst_n;                        // synchronous reset, active low
    input signed [15:0] sig_in;         // 16 bits in Q(1,15) format

    // outputs
    output reg sd_out = 0;

    // internal signals
    reg signed [17:0] state1 = 0;       // Q(1,17)
    reg signed [19:0] state2 = 0;       // Q(1,19)
    reg signed [16:0] state1_in;        // Q(0,17)
    reg signed [18:0] state2_in;        // Q(0,19)
    reg quantizer = 0;
    reg signed [16:0] qq;

    // combination process
    always @(*)
    begin
        `ifdef DEBUG_SDDAC
        qq <= $signed(quantizer ? -17'h8000 : 17'h8000);
        `endif
        state1_in <= sig_in - $signed(quantizer ? -17'h8000 : 17'h8000);        // Q(-1,17) - Q(0,17) -> Q(0,17)
        state2_in <= state1 - $signed(quantizer ? -19'h10000 : 19'h10000);      // Q(-1,19) - Q(0,19) -> Q(0,19)
        quantizer <= state2[19];
    end

    // clocked process
    always @(posedge clk)
    begin
        if (rst_n == 1'b0)
        begin
            state1 <= 0;
            state2 <= 0;
        end
        else begin
            `ifdef DEBUG_SDDAC
            $display("feedback : %f", qq*$pow(2.0,-15));
            $display("state1_in: %f", state1_in*$pow(2.0,-17));
            $display("state2_in: %f", state2_in*$pow(2.0,-19));
            $display("");
            `endif
            state1 <= state1 + $signed({ state1_in[16], state1_in});
            state2 <= state2 + $signed({ state2_in[18], state2_in});
            sd_out <= !state2[19];
        end
    end

endmodule
