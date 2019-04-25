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
echo "hierarchy -check -top $topmodule" >> script.yos

yosys -ql $logfile -p "script $scriptpath/script.yos" >/dev/null
echo $?
rm -f $logfile
rm -f script.yos
