#!/bin/sh

iverilog -o cordic_tb.vvp cordic_10_16.v cordic_4_8.v cordic_tb.v
vvp cordic_tb.vvp
