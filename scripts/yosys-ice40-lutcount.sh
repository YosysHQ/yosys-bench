#!/bin/bash

#
# mode script for ICE40 FPGA LUT count
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
echo "synth_ice40 -top $topmodule $EXTRA_FLAGS" >> script.yos

# run tools
yosys -ql $logfile -p "script $tmpdir/script.ys" >/dev/null
sed -r '/^[0-9\.]+ Printing statistics./,/^[0-9\.]+ / { /SB_LUT4/ { s/.* //; p; }; }; d;' $logfile
rm -rf $tmpdir
