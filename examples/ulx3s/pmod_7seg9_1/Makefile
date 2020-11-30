PROJ = pmod_7seg9_1
ADD_SRC = tm1640.v

PIN_DEF = ulx3s.lpf
DEVICE = 85k
PACKAGE = CABGA381
TRELLIS = /usr/share/trellis
BASECFG = $(TRELLIS)/misc/basecfgs/empty_$(PART_BASECONFIG).config

all: $(PROJ).svf $(PROJ).bit

%.json: %.v
	/usr/bin/yosys -p 'synth_ecp5 -noccu2 -nomux -nodram -json $@' $< $(ADD_SRC)

%.asc: %.json
	/usr/bin/nextpnr-ecp5 --$(DEVICE) --package $(PACKAGE) --textcfg $@ --lpf $(PIN_DEF) --json $^

%.bit: %.asc
	/usr/bin/ecppack $< --bit $@

%.svf: %.asc
	/usr/bin/ecppack $< --svf $@

prog: $(PROJ).bit
	@echo 'Programming FPGA:'
	/usr/bin/fujprog -b 115200 -j sram -T bit $<

flash: $(PROJ).bit
	@echo 'Programming FPGA:'
	/usr/bin/fujprog -b 115200 -j flash -T bit $<

wslprog: $(PROJ).bit
	@echo 'Executing ujprog under windows!!!'
	/d/fpga-local/bin/ujprog.exe $<

clean:
	rm -f $(PROJ).json $(PROJ).asc $(PROJ).svf $(PROJ).bit

.SECONDARY:
.PHONY: all prog clean
