include ../common.mk
export YOSYS=/opt/yosys-master/bin/yosys

TARGETS = $(patsubst %,tab_%_xc7a_1/results.txt,$(basename $(notdir $(BENCHMARKS))))

all: $(TARGETS)

tab_%_xc7a_1/results.txt:
	YOSYS_SYNTH="synth_xilinx -abc9 -top $* -edif $(PWD)/$$(dirname $@)/$*.edif" bash ../../scripts/vivado_min_period.sh ../../*/benchmarks_*/*/$*.{v,vhdl} xc7a 1

clean:
	rm -r tab_*
