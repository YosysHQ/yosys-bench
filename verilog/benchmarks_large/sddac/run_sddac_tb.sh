#!/bin/sh

iverilog -m va_math -o sddac_tb.vvp sddac_tb.v sddac.v
vvp sddac_tb.vvp
