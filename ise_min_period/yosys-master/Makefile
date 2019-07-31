include ../common.mk
export YOSYS=/opt/yosys-master/bin/yosys

DEVICE=xc6s
GRADE=2
TARGETS = $(patsubst %,tab_%_$(DEVICE)_$(GRADE)/results.txt,$(basename $(notdir $(BENCHMARKS))))

all: $(TARGETS)
	../../scripts/ise_min_period_table.sh

tab_%_$(DEVICE)_$(GRADE)/results.txt:
	YOSYS_SYNTH="synth_xilinx -family xc6s -abc9 -top $*" bash ../../scripts/ise_min_period.sh ../../*/benchmarks_*/*/$*.{v,vhdl} $(DEVICE) $(GRADE)

clean:
	rm -r tab_*
