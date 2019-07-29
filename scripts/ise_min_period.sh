#!/bin/bash

set -e
path=`readlink -f "$1"`
dev="$2"
grade="$3"
ip="$(basename -- ${path%.*})"

# rm -rf tab_${ip}_${dev}_${grade}
mkdir -p tab_${ip}_${dev}_${grade}
cd tab_${ip}_${dev}_${grade}

best_speed=10000
speed=50
step=16

synth_case() {
	if [ -f test_${1}.txt ]; then
		echo "Reusing cached tab_${ip}_${dev}_${grade}/test_${1}."
		return
	fi

	case "${dev}" in
		xc6s) xl_device="xc6slx100t-csg484-${grade}"
		#xc7a) xl_device="xc7a100t-csg324-${grade}" ;;
		#xc7a200) xl_device="xc7a200t-fbg676-${grade}" ;;
		#xc7k) xl_device="xc7k70t-fbg676-${grade}" ;;
		#xc7v) xl_device="xc7v585t-ffg1761-${grade}" ;;
		#xcku) xl_device="xcku035-fbva676-${grade}-e" ;;
		#xcvu) xl_device="xcvu065-ffvc1517-${grade}-e" ;;
		#xckup) xl_device="xcku3p-ffva676-${grade}-e" ;;
		#xcvup) xl_device="xcvu3p-ffvc1517-${grade}-e" ;;
	esac

	pwd=$PWD
	if [ -f "../$(dirname ${path})/${ip}.prj" ]; then
		echo "run -ifn "$(dirname ${path})/${ip}.prj" -ifmt mixed -ofn ${pwd}/test_${1}.ngc -ofmt NGC -p ${xl_device} -uc ${pwd}/test_${1}.xcf -iobuf no" > test_${1}.xst
	else
		cat > test_${1}.prj <<- EOT
			verilog work $(basename ${path})
		EOT
		echo "run -ifn ${pwd}/test_${1}.prj -ifmt mixed -top ${ip} -ofn ${pwd}/test_${1}.ngc -ofmt NGC -p ${xl_device} -uc ${pwd}/test_${1}.xcf -iobuf no" > test_${1}.xst
        fi
	cat > test_${1}.xcf <<- EOT
		NET "$(<$(dirname ${path})/${ip}.clock)" TNM_NET = clk;
		TIMESPEC TS_clk = PERIOD "clk" ${speed:0: -1}.${speed: -1} ns;
		BEGIN MODEL ${ip}
			NET "$(<$(dirname ${path})/${ip}.clock)" BUFFER_TYPE = BUFG;
		END;
	EOT
	cat > test_${1}.ucf <<- EOT
		NET "$(<$(dirname ${path})/${ip}.clock)" TNM_NET = clk;
		TIMESPEC TS_clk = PERIOD "clk" ${speed:0: -1}.${speed: -1} ns;
	EOT

	echo "Running tab_${ip}_${dev}_${grade}/test_${1}.."
	pushd $(dirname ${path}) > /dev/null
	if ! xst -ifn ${pwd}/test_${1}.xst -ofn ${pwd}/test_${1}.srp -intstyle xflow > /dev/null 2>&1; then
		cat ${pwd}/test_${1}.srp
		exit 1
	fi
	popd > /dev/null

	if ! ngdbuild test_${1}.ngc test_${1}.ngd -uc test_${1}.ucf -intstyle xflow > /dev/null 2>&1; then
		cat test_${1}.bld
		exit 1
	fi
	if ! map test_${1} -intstyle xflow -u > /dev/null 2>&1; then
		cat test_${1}.mrp
		exit 1
	fi
	if ! par test_${1} ${pwd}/test_${1}_par -intstyle xflow > /dev/null 2>&1; then
		cat test_${1}_par.par
		exit 1
	fi
	if ! trce test_${1}_par ${pwd}/test_${1}.pcf -v 1 -intstyle xflow > /dev/null 2>&1; then
		cat test_${1}_par.twr
		exit 1
	fi

	> test_${1}.txt
	cat test_${1}.srp >> test_${1}.txt
	cat test_${1}.bld >> test_${1}.txt
	cat test_${1}.mrp >> test_${1}.txt
	cat test_${1}_par.par >> test_${1}.txt
	cat test_${1}_par.twr >> test_${1}.txt
}

got_violated=false
got_met=false

countdown=2
while [ $countdown -gt 0 ]; do
	synth_case $speed

	if grep -q '^Slack:\s\+-[0-9\.]\+ns (requirement' test_${speed}.txt; then
		echo "        tab_${ip}_${dev}_${grade}/test_${speed} VIOLATED"
		[ $got_met = true ] && step=$((step / 2))
		speed=$((speed + step))
		got_violated=true
	elif grep -q '^Slack:\s\+[0-9\.]\+ns (requirement' test_${speed}.txt; then
		echo "        tab_${ip}_${dev}_${grade}/test_${speed} MET"
		[ $speed -lt $best_speed ] && best_speed=$speed
		step=$((step / 2))
		speed=$((speed - step))
		got_met=true
	else
		echo "ERROR: No slack line found in $PWD/test_${speed}.txt!"
		exit 1
	fi

	if [ $step -eq 0 ]; then
		countdown=$((countdown - 1))
		speed=$((best_speed - 2))
		step=1
	fi
done

if ! $got_violated; then
	echo "ERROR: No timing violated in $PWD!"
	exit 1
fi

if ! $got_met; then
	echo "ERROR: No timing met in $PWD!"
	exit 1
fi


echo "-----------------------"
echo "Best speed for tab_${ip}_${dev}_${grade}: $best_speed"
echo "-----------------------"
echo $best_speed > results.txt

