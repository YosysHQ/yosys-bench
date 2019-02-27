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
    echo "read -vhdl $1" > $tmpdir/script.ys
else
    topmodule=$( basename -s .v "$1")
    echo "read -vlog2k $1" > $tmpdir/script.ys
fi
echo "synth_xilinx -top $topmodule -edif $tmpdir/$topmodule.edif" >> $tmpdir/script.ys

echo "read_edif $tmpdir/$topmodule.edif" > $tmpdir/script.tcl
echo "link_design -part XC7A100TCSG324-1 -name $topmodule" >> $tmpdir/script.tcl
echo "report_design_analysis -timing -file $logfile" >> $tmpdir/script.tcl

# run tools
yosys -ql $logfile -p "script $tmpdir/script.ys" > /dev/null
vivado -mode batch -nolog -nojournal -source $tmpdir/script.tcl > /dev/null
sed -rn 's/^\|\s+Path Delay\s+\|\s+([0-9\.]+).+/\1/p' $logfile
rm -r $tmpdir
