PROJ = pmod_7seg9_1
ADD_SRC = tm1640.v
OSSDIR = ~/oss-cad-suite/bin

PIN_DEF = ulx3s.lpf
DEVICE = 85k
PACKAGE = CABGA381
TRELLIS = /usr/share/trellis
BASECFG = $(TRELLIS)/misc/basecfgs/empty_$(PART_BASECONFIG).config

all: $(PROJ).svf $(PROJ).bit

%.json: %.v
	$(OSSDIR)/yosys -p 'synth_ecp5 -top $(PROJ) -noccu2 -nomux -nodram -json $@' $(PROJ).v $(ADD_SRC)

%.asc: %.json
	$(OSSDIR)/nextpnr-ecp5 --$(DEVICE) --package $(PACKAGE) --textcfg $@ --lpf $(PIN_DEF) --json $^

# create the compressed bitstream file for FPGA programming
%.bit: %.asc
	$(OSSDIR)/ecppack --compress --freq 38.8 $< --bit $@

# create SVF (serial vector format) file with compression
%.svf: %.asc
	$(OSSDIR)/ecppack --compress $< --svf $@

# program FPGA SRAM (using openFPGALoader over fujprog)
prog: $(PROJ).bit
	@echo 'Programming FPGA:'
	$(OSSDIR)/openFPGALoader -b ulx3s $<

# program FPGA Flash
flash: $(PROJ).bit
	@echo 'Programming FPGA:'
	$(OSSDIR)/openFPGALoader -b ulx3s -f $<

clean:
	rm -f $(PROJ).json $(PROJ).asc $(PROJ).svf $(PROJ).bit

.SECONDARY:
.PHONY: all prog clean
