#!/bin/sh

ghdl -a cic5.m.vhdl
ghdl -a cic5_tb.m.vhdl
ghdl -e cic5_tb
ghdl -r cic5_tb --wave=cic5_tb.ghw