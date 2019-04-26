#!/bin/bash

#
# mode script for ICE40 FPGA FF count
#

logfile=$( mktemp )
scriptpath=$( pwd )

# create synthesis script
myfile="$1"
if [ ${myfile: -5} == ".vhdl" ]
then
    topmodule=$( basename -s .vhdl "$1" )
    echo "read -vhdl $1" > script.yos
else
    topmodule=$( basename -s .v "$1")
    echo "read -vlog2k $1" > script.yos
fi
echo "hierarchy -check -top $topmodule" >> script.yos
echo "proc" >> script.yos
echo "equiv_opt -map +/xilinx/cells_sim.v -assert -undef synth_xilinx" >> script.yos

# run tools
yosys -ql $logfile -p "script $scriptpath/script.yos" >/dev/null
echo $?
rm -f $logfile
rm -f script.yos
