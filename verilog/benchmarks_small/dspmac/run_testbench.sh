#!/bin/sh

iverilog -m va_math -o dspmac_16_40_tb.vvp dspmac_16_40_tb.v dspmac_16_40.v
vvp dspmac_16_40_tb.vvp