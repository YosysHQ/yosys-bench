#!/bin/bash

#
# mode script for Xilinx FPGA timing
#

tmpdir=$( mktemp -d )
logfile=$tmpdir/log.out

# create synthesis script
myfile="$1"
if [ ${myfile: -5} == ".vhdl" ]
then
    topmodule=$( basename -s .vhdl "$1" )
    echo "read_vhdl $1" > $tmpdir/script.tcl
else
    topmodule=$( basename -s .v "$1")
    echo "read_verilog $1" > $tmpdir/script.tcl
fi
echo "synth_design -top $topmodule -part XC7A100TCSG324-1" >> $tmpdir/script.tcl
echo "report_design_analysis -timing -file $logfile" >> $tmpdir/script.tcl

# run tools
vivado -mode batch -nolog -nojournal -source $tmpdir/script.tcl > /dev/null
sed -rn 's/^\|\s+Path Delay\s+\|\s+([0-9\.]+).+/\1/p' $logfile
rm -rf $tmpdir
