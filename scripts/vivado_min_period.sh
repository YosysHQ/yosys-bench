#!/bin/bash

# Adapted from https://github.com/cliffordwolf/picorv32/blob/d046cbfa4986acb50ef6b6e5ff58e9cab543980b/scripts/vivado/tabtest.sh

# - If YOSYS environment variable is set, Yosys will be used for synthesis
#   (otherwise Vivado will be used)
# - When using Yosys for synthesis, environment variable YOSYS_SYNTH should be set
#   to the desired synthesis command (e.g. 'synth_xilinx')
# - Vivado executable can be set using environment variable VIVADO (defaults to 'vivado')
# - Any top-level port matching regex '.*cl(oc)?k.*' is interpreted to be a clock
# - Vivado executed in single threaded mode for deterministic behaviour
# - Vivado executed in 'out of context' mode to eliminate effect of I/O
# - Binary search to find minimum clock period (within 100ps) with positive slack

set -e
path=`readlink -f "$1"`
dev="$2"
grade="$3"
ip="$(basename -- ${path%.*})"

VIVADO=${VIVADO:-vivado}

# rm -rf tab_${ip}_${dev}_${grade}
mkdir -p tab_${ip}_${dev}_${grade}
cd tab_${ip}_${dev}_${grade}
rm -f ${ip}.edif

best_speed=10000
speed=50
step=16

synth_case() {
	if [ -f test_${1}.txt ]; then
		echo "Reusing cached tab_${ip}_${dev}_${grade}/test_${1}."
		return
	fi

	case "${dev}" in
		xc7a) xl_device="xc7a100t-csg324-${grade}" ;;
		xc7k) xl_device="xc7k70t-fbg676-${grade}" ;;
		xc7v) xl_device="xc7v585t-ffg1761-${grade}" ;;
		xcku) xl_device="xcku035-fbva676-${grade}-e" ;;
		xcvu) xl_device="xcvu065-ffvc1517-${grade}-e" ;;
		xckup) xl_device="xcku3p-ffva676-${grade}-e" ;;
		xcvup) xl_device="xcvu3p-ffvc1517-${grade}-e" ;;
	esac

	cat > test_${1}.tcl <<- EOT
		set_param general.maxThreads 1
		set_property IS_ENABLED 0 [get_drc_checks {PDRC-43}]
	EOT

	pwd=$PWD
	if [ -z "$YOSYS" ]; then
		cat > test_${1}.tcl <<- EOT
			cd $(dirname ${path})
		EOT
		if [ -f $(dirname ${path})/${ip}_vivado.tcl ]; then
			cat >> test_${1}.tcl <<- EOT
				source ${ip}_vivado.tcl
				if {[get_property TOP [current_fileset]] eq ""} {
					set_property TOP [lindex [find_top] 0] [current_fileset]
				}
			EOT
		else
			cat >> test_${1}.tcl <<- EOT
				read_verilog $(basename ${path})
				set_property TOP [lindex [find_top] 0] [current_fileset]
			EOT
		fi
		cat >> test_${1}.tcl <<- EOT
			cd ${PWD}
			read_xdc test_${1}.xdc
			synth_design -part ${xl_device} -mode out_of_context
			opt_design -directive Explore
		EOT

	else
		if [ -f ${ip}.edif ]; then
			echo "Reusing cached tab_${ip}_${dev}_${grade}/${ip}.edif."
		else
			if [ -f "$(dirname ${path})/${ip}.ys" ]; then
				echo "script ${ip}.ys" > ${ip}.ys
			else
				if [ ${path:-5} == ".vhdl" ]
				then
				    echo "read -vhdl $(basename ${path})" > ${ip}.ys
				else
				    echo "read -vlog2k $(basename ${path})" > ${ip}.ys
				fi
			fi

			cat >> ${ip}.ys <<- EOT
				${YOSYS_SYNTH}
				write_verilog -noexpr -norename ${pwd}/${ip}_syn.v
			EOT

			echo "Running tab_${ip}_${dev}_${grade}/${ip}.ys.."
			pushd $(dirname ${path}) > /dev/null
			if ! ${YOSYS} -l ${pwd}/yosys.log ${pwd}/${ip}.ys > /dev/null 2>&1; then
				cat ${pwd}/yosys.log
				exit 1
			fi
			popd > /dev/null
			mv yosys.log yosys.txt
		fi

		cat >> test_${1}.tcl <<- EOT
			read_edif ${ip}.edif
			read_xdc test_${1}.xdc
			link_design -part ${xl_device} -mode out_of_context -top ${ip}
		EOT
	fi

	cat > test_${1}.xdc <<- EOT
		create_clock -period ${speed:0: -1}.${speed: -1} [get_ports -nocase -regexp .*cl(oc)?k.*]
	EOT
	cat >> test_${1}.tcl <<- EOT
		report_design_analysis
		place_design -directive Explore
		route_design -directive Explore
		report_utilization
		report_timing -no_report_unconstrained
		report_design_analysis
	EOT

	echo "Running tab_${ip}_${dev}_${grade}/test_${1}.."
	if ! $VIVADO -nojournal -log test_${1}.log -mode batch -source test_${1}.tcl > /dev/null 2>&1; then
		cat test_${1}.log
		exit 1
	fi
	mv test_${1}.log test_${1}.txt
}

got_violated=false
got_met=false

countdown=2
while [ $countdown -gt 0 ]; do
	synth_case $speed

	if grep -q '^Slack.*(VIOLATED)' test_${speed}.txt; then
		echo "        tab_${ip}_${dev}_${grade}/test_${speed} VIOLATED"
		[ $got_met = true ] && step=$((step / 2))
		speed=$((speed + step))
		got_violated=true
	elif grep -q '^Slack.*(MET)' test_${speed}.txt; then
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

