#!/bin/sh

iverilog -m va_math -o sddac_tb.vvp sddac_tb.v sddac.v
#iverilog -m va_math -o sddac_tb.vvp sddac_tb.v sddac.v_netlist.v ../../../celllibs/supergate/supergate.v
vvp sddac_tb.vvp
python3 genspectrumplot.py
