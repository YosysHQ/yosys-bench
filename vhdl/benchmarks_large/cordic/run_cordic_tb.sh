#!/bin/sh

ghdl -a cordic_10_16.vhdl
ghdl -a cordic_tb.vhdl
ghdl -e cordic_tb
ghdl -r cordic_tb --wave=cordic_tb.ghw
