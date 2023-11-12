PROJ = pmod_7seg9_2
ADD_SRC = ctl_7seg9.v tm1640.v hexdigit.v

PIN_DEF = icebreaker.pcf
DEVICE = up5k
PACKAGE = sg48

all: $(PROJ).rpt $(PROJ).bin

%.json: %.v
	/usr/bin/yosys -p 'synth_ice40 -top $(PROJ) -json $@' $(PROJ).v $(ADD_SRC)

%.asc: %.json
	/usr/bin/nextpnr-ice40 --package $(PACKAGE) --$(DEVICE) --asc $@ --pcf $(PIN_DEF) --json $^

%.bin: %.asc
	/usr/bin/icepack $< $@

%.rpt: %.asc
	/usr/bin/icetime -d $(DEVICE) -mtr $@ $<

prog: $(PROJ).bin
	@echo 'Programming FPGA:'
	/usr/bin/iceprog $<

clean:
	rm -f $(PROJ).json $(PROJ).asc $(PROJ).rpt $(PROJ).bin

.SECONDARY:
.PHONY: all prog clean
