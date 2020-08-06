PROJ = pmod_7seg9_1
ADD_SRC = tm1640.v

PIN_DEF = icebreaker.pcf
DEVICE = up5k
PACKAGE = sg48

all: $(PROJ).rpt $(PROJ).bin

%.json: %.v
	/usr/local/bin/yosys -p 'synth_ice40 -json $@' $< $(ADD_SRC)

%.asc: %.json
	/usr/local/bin/nextpnr-ice40 --package $(PACKAGE) --$(DEVICE) --asc $@ --pcf $(PIN_DEF) --json $^

%.bin: %.asc
	/usr/local/bin/icepack $< $@

%.rpt: %.asc
	/usr/local/bin/icetime -d $(DEVICE) -mtr $@ $<

prog: $(PROJ).bin
	@echo 'Executing prog as root!!!'
	sudo /usr/local/bin/iceprog $<

clean:
	rm -f $(PROJ).json $(PROJ).asc $(PROJ).rpt $(PROJ).bin

.SECONDARY:
.PHONY: all prog clean
