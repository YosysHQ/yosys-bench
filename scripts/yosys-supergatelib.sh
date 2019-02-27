#!/bin/bash

#
# mode script for simple ASIC cell library
#
# Using custom ABC script so we can get the area of the circuit:
#  strash; ifraig; scorr; dc2; dretime; strash; &get -n; &dch -f; &nf {D}; &put
#

tmpdir=$( mktemp -d )
logfile=$tmpdir/log.out

# create synthesis script
myfile="$1"
celllibpath="$2"

#mkdir -p netlists

if [ ${myfile: -5} == ".vhdl" ]
then
    topmodule=$( basename -s .vhdl "$1" )
    echo "read -vhdl $1" > $tmpdir/script.ys
else
    topmodule=$( basename -s .v "$1")
    echo "read -vlog2k $1" > $tmpdir/script.ys
fi
#echo "read_liberty $celllibpath/supergate/supergate.lib" >> $tmpdir/script.ys
echo "hierarchy; proc; fsm; opt; memory; opt" >> $tmpdir/script.ys
echo "techmap; opt" >> $tmpdir/script.ys
echo "dfflibmap -liberty $celllibpath/supergate/supergate.lib" >> $tmpdir/script.ys
echo "abc -liberty $celllibpath/supergate/supergate.lib" >> $tmpdir/script.ys
echo "write_verilog /$1_netlist.v" >> $tmpdir/script.ys
echo "stat -liberty $celllibpath/supergate/supergate.lib" >> $tmpdir/script.ys
#echo "strash; ifraig; scorr; dc2; dretime; strash; &get -n; &dch -f; &nf {D}; &put" > $tmpdir/abc.script

# run tools
#yosys -ql $logfile -p "script $tmpdir/script.ys" >/dev/null
yosys -l $logfile -p "script $tmpdir/script.ys" >/dev/null
sed -r '/^[0-9\.]+ Printing statistics./,/^[0-9\.]+ / { /SB_LUT4/ { s/.* //; p; }; }; d;' $logfile
cp $logfile $celllibpath/../log.txt
rm -r $tmpdir
