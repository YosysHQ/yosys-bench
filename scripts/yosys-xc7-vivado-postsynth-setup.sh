#!/bin/bash

#
# mode script for Xilinx FPGA timing
#

logfile=$( mktemp )
tmpdir=$( mktemp -d )
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
echo "synth_xilinx -top $topmodule -edif $tmpdir/$topmodule.edif" >> script.yos

echo "read_edif $tmpdir/$topmodule.edif" > script.tcl
echo "link_design -part XC7A100TCSG324-1 -name $topmodule" >> script.tcl
echo "create_clock -period 1 [get_nets -of [get_pins -filter {name =~ "*/C"} -of [all_ffs]]]" >> script.tcl
echo "report_design_analysis -timing -file $logfile" >> script.tcl

# run tools
yosys -ql $logfile -p "script $scriptpath/script.yos" > /dev/null
vivado -mode batch -nolog -nojournal -source script.tcl > /dev/null
sed -rn 's/^\|\s+Path Delay\s+\|\s+([0-9\.]+).+/\1/p' $logfile
rm -f $logfile
rm -rf $tmpdir
rm -f script.yos script.tcl
