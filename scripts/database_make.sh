#!/bin/bash

set -e
mode=$1; shift
test -f scripts/$mode.sh

rm -rf database/$mode
mkdir -p database/$mode

add_file()
{
	f=$1; g=${f//\//_}
	echo "all:: $g.dat" >> database/$mode/Makefile
	echo "$g.dat:" >> database/$mode/Makefile
	echo "	cd ../.. && bash scripts/$mode.sh $f.v > database/$mode/$g.dat" >> database/$mode/Makefile
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
		for f in ${arg%/}/*.v; do add_file ${f%.v}; done
	else
		add_file ${arg%.v}
	fi
done

echo "Generated database/$mode/Makefile."
make -C database/$mode -j$(nproc)

