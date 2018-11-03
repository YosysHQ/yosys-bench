#!/bin/bash

#
# mode script for simple ASIC cell library
#
# Using custom ABC script so we can get the area of the circuit:
#  strash; ifraig; scorr; dc2; dretime; strash; &get -n; &dch -f; &nf {D}; &put
#

logfile=$( mktemp )
scriptpath=$( pwd )

# create synthesis script
myfile="$1"
celllibpath="$2"

#mkdir -p netlists

if [ ${myfile: -5} == ".vhdl" ]
then
    topmodule=$( basename -s .vhdl "$1" )
    echo "read -vhdl $1" > script.yos
else
    topmodule=$( basename -s .v "$1")
    echo "read -vlog2k $1" > script.yos
fi
echo "hierarchy; proc; fsm; opt; memory; opt" >> script.yos
echo "techmap; opt" >> script.yos
echo "dfflibmap -liberty $celllibpath/simple/simple.lib" >> script.yos
echo "abc -liberty $celllibpath/simple/simple.lib" >> script.yos
echo "write_verilog /$1_netlist.v" >> script.yos
echo "stat -liberty $celllibpath/simple/simple.lib" >> script.yos
#echo "strash; ifraig; scorr; dc2; dretime; strash; &get -n; &dch -f; &nf {D}; &put" > abc.script

# run tools
#yosys -ql $logfile -p "script $scriptpath/script.yos" >/dev/null
yosys -l $logfile -p "script $scriptpath/script.yos" >/dev/null
sed -r '/^[0-9\.]+ Printing statistics./,/^[0-9\.]+ / { /SB_LUT4/ { s/.* //; p; }; }; d;' $logfile
cp $logfile $celllibpath/../log.txt
rm -f $logfile
rm -f script.yos
#rm -f abc.script
