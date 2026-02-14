## config.mk
## -------------------------------------------------------------------
## Gatemate project Makefile for oss-cad-suite toolchain (2026-02-11)
## -------------------------------------------------------------------

## toolchain
YOSYS = /home/fm/oss-cad-suite/bin/yosys
PR    = /home/fm/oss-cad-suite/bin/nextpnr-himbaechel
PACK  = /home/fm/oss-cad-suite/bin/gmpack
OFL   = /home/fm/oss-cad-suite/bin/openFPGALoader

GTKW = gtkwave
IVL = iverilog
VVP = vvp
IVLFLAGS = -Winfloop -g2012 -gspecify -Ttyp -DSIMULATION

## simulation libraries (oss-cad-suite: cpelib.v is now cells_sim.v)
CELLS_SYNTH = /home/fm/oss-cad-suite/share/yosys/gatemate/cells_sim.v

## target sources
VLOG_SRC = $(shell find ./src/ -type f \( -iname \*.v -o -iname \*.sv \))

## misc tools
RM = rm -rf

## toolchain targets
synth: synth_vlog

## --------------------------------------------------------------------------
## In synthesis we create both output formats: Verilog and JSON.
## The old Verilog output is needed because iVerlog does not understand JSON.
## --------------------------------------------------------------------------
synth_vlog: $(VLOG_SRC)
	@test -d log || mkdir log
	@test -d net || mkdir net
	$(YOSYS) -ql log/synth.log -p 'read -sv $(VLOG_SRC); synth_gatemate -top $(TOP) -luttree -nomx8 -vlog net/$(TOP)_synth.v; write_json net/$(TOP)_synth.json'

synth_vhdl: $(VHDL_SRC)
	@test -d log || mkdir log
	@test -d net || mkdir net
	$(YOSYS) -ql log/synth.log -p 'ghdl --warn-no-binding -C --ieee=synopsys $^ -e $(TOP); synth_gatemate -top $(TOP); write_json net/$(TOP)_synth.json'

## --------------------------------------------------------------------------
## In place_&_route we tell nextpnr to export a Verilog netlist of the design
## with '--write net/$(TOP)_impl.v'. This is needed for iVerilog simulations.
## --------------------------------------------------------------------------
impl:
	test -e $(PIN_DEF) || exit
	$(PR) --device=CCGM1A1 --json net/$(TOP)_synth.json --write net/$(TOP)_impl.v -o out=net/$(TOP)_impl.txt -o ccf=$(PIN_DEF) --router router2 > log/$@.log
	$(PACK) --input net/$(TOP)_impl.txt --bit $(TOP).bit

prog:
	@echo 'Programming E1 SPI Config:'
	$(OFL) $(OFLFLAGS) -b gatemate_evp_spi $(TOP).bit

jtag:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_jtag $(TOP).bit

jtag-flash:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_jtag -f --verify $(TOP).bit

spi:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_spi -m $(TOP).bit

spi-flash:
	$(OFL) $(OFLFLAGS) -b gatemate_evb_spi -f --verify $(TOP).bit

all: synth impl jtag

## --------------------------------------------------------------
## Unified Simulation Targets
## --------------------------------------------------------------

# RTL Simulation Binary (vlog_sim)
sim/$(TOP)_sim.vvp: $(VLOG_SRC) sim/$(TOP)_tb.v
	@mkdir -p sim
	$(IVL) $(IVLFLAGS) -o $@ $^

# Post-Synthesis Simulation Binary (synth_sim)
sim/$(TOP)_synth_sim.vvp: net/$(TOP)_synth.v sim/$(TOP)_tb.v
	@mkdir -p sim
	$(IVL) $(IVLFLAGS) -o $@ $^ $(CELLS_SYNTH)

# Post-Implementation Simulation Binary (impl_sim)
sim/$(TOP)_impl_sim.vvp: net/$(TOP)_impl.v sim/$(TOP)_tb.v
	@mkdir -p sim
	$(IVL) $(IVLFLAGS) -o $@ $^ $(CELLS_SYNTH)

# Phony targets to run simulations from CLI
.PHONY: vlog_sim synth_sim impl_sim
vlog_sim: sim/$(TOP)_sim.vvp
	$(VVP) -N $< -lx2

synth_sim: sim/$(TOP)_synth_sim.vvp
	$(VVP) -N $< -lx2

impl_sim: sim/$(TOP)_impl_sim.vvp
	$(VVP) -N $< -lx2

## -------------------------------------------------------------
## GTKWave Waveform Generation
## -------------------------------------------------------------

# Rule to generate VCD from the RTL simulation binary
sim/$(TOP)_tb.vcd: sim/$(TOP)_sim.vvp
	@echo "Generating fresh VCD data for $(TOP)..."
	$(VVP) -N $< -lx2

# Primary wave target: check dependencies and launch GTKWave
wave: sim/$(TOP)_tb.vcd
	$(GTKW) $< sim/config.gtkw

## -------------------------------------------------------------
## make clean deletes all compiled files and the bitstream
## -------------------------------------------------------------
clean:
	$(RM) log/*.log
	$(RM) net/*_synth.json
	$(RM) net/*_synth.v
	$(RM) net/*_impl.v
	$(RM) net/*_impl.txt
	$(RM) sim/*.vcd
	$(RM) sim/*.vvp
	$(RM) *.bit
	test ! -d log || rmdir log
	test ! -d net || rmdir net
