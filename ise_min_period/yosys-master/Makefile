include ../common.mk
export YOSYS=/opt/yosys-master/bin/yosys

TARGETS = $(patsubst %,tab_%_xc7a_1/results.txt,$(basename $(notdir $(BENCHMARKS))))
DEVICE=xc6s
GRADE=2

all: $(TARGETS)
	../../scripts/ise_min_period_table.sh

tab_%_xc7a_1/results.txt:
	YOSYS_SYNTH="synth_xilinx -family xc6s -abc9 -top $*" bash ../../scripts/ise_min_period.sh ../../*/benchmarks_*/*/$*.{v,vhdl} $(DEVICE) $(GRADE)

clean:
	rm -r tab_*
