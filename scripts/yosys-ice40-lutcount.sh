#!/bin/bash

#
# mode script for ICE40 FPGA LUT count
#

logfile=$( mktemp )
topmodule=$( basename -s .v "$1" )
scriptpath=$( pwd )

# create synthesis script
myfile="$1"
if [ ${myfile: -5} == ".vhdl" ]
then
    echo "read -vhdl $1" > script.yos
else
    echo "read -vlog2k $1" > script.yos
fi
echo "synth_ice40 -top $topmodule" >> script.yos

# run tools
yosys -ql $logfile -p "script $scriptpath/script.yos" >/dev/null
sed -r '/^[0-9\.]+ Printing statistics./,/^[0-9\.]+ / { /SB_LUT4/ { s/.* //; p; }; }; d;' $logfile
rm -f $logfile
rm -f script.yos
