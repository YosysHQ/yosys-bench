#!/bin/bash

#
# Create a database directory and run all scripts in the given directories
# based on an evaluation script:
#
# database_make <run_script> <dir1> .. <dirN> 
#

set -e
mode=$1; shift
test -f scripts/$mode.sh

rm -rf database/$mode
mkdir -p database/$mode

add_verilog_file()
{
	f=$1; g=${f//\//_}
	echo "all:: $g.dat" >> database/$mode/Makefile
	echo "$g.dat:" >> database/$mode/Makefile
	echo "	cd ../.. && bash scripts/$mode.sh $f.v > database/$mode/$g.dat" >> database/$mode/Makefile
}

add_vhdl_file()
{
	f=$1; g=${f//\//_}
	echo "all:: $g.dat" >> database/$mode/Makefile
	echo "$g.dat:" >> database/$mode/Makefile
	echo "	cd ../.. && bash scripts/$mode.sh $f.vhdl > database/$mode/$g.dat" >> database/$mode/Makefile
}


echo "all::" > database/$mode/Makefile

for arg; do
	if test -f $arg/generate.py; then
		pushd . > /dev/null
		cd $arg
		python3 generate.py
		popd > /dev/null
	fi
	if test -d $arg; then
		for f in ${arg%/}/*.v; do add_verilog_file ${f%.v}; done
		for f in ${arg%/}/*.vhdl; do add_vhdl_file ${f%.vhdl}; done
	elif test -e ${arg%.v}; then
        add_verilog_file ${arg%.v};
    elif test -e ${arg%.vhdl}; then
        add_vhdl_file ${arg%.vhdl};
	fi
done

echo "Generated database/$mode/Makefile."
make -C database/$mode -j$(nproc)

