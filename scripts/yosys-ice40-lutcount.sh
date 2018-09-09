#!/bin/bash

#
# mode script for ICE40 FPGA LUT count
#

logfile=$( mktemp )
topmodule=$( basename -s .v "$1" )
scriptpath=$( pwd )

# create synthesis script
echo "read_verilog $1" > script.yos
echo "synth_ice40 -top $topmodule" >> script.yos

# run tools
yosys -ql $logfile -p "script $scriptpath/script.yos" >/dev/null
sed -r '/^[0-9\.]+ Printing statistics./,/^[0-9\.]+ / { /SB_LUT4/ { s/.* //; p; }; }; d;' $logfile
rm -f $logfile
rm -f script.yos
