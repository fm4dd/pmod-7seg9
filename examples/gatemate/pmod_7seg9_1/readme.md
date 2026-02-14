## Example code Pmod 7SEG9

This Verilog example program validates the function of the PMOD 7SEG9 module on the Gatemate E1 board from Cologne Chip. It writes the numbers '123456789' to be displayed on the nine seven-segment digits. 

The constraints have the PMOD 7SEG9 module connected to PMODB lower pinrow.

### Usage

Synthesis
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_1$ make
/home/fm/oss-cad-suite/bin/yosys -ql log/synth.log -p 'read -sv ./src/pmod_7seg9_1.v ./src/tm1640.v; synth_gatemate -top pmod_7seg9_1 -luttree -nomx8 -vlog net/pmod_7seg9_1_synth.v; write_json net/pmod_7seg9_1_synth.json'

=== pmod_7seg9_1 ===

        +----------Local Count, excluding submodules.
        |
      185 wires
      329 wire bits
       23 public wires
       74 public wire bits
        3 ports
        3 port bits
      247 cells
        1   $scopeinfo
       35   CC_ADDF
        1   CC_BUFG
       58   CC_DFF
        1   CC_IBUF
       65   CC_L2T4
       42   CC_L2T5
       25   CC_LUT2
       15   CC_MX2
        2   CC_MX4
        2   CC_OBUF
...
```

Place and route:
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_1$ make impl
test -e src/gm-proto.ccf || exit
/home/fm/oss-cad-suite/bin/nextpnr-himbaechel --device=CCGM1A1 --json net/pmod_7seg9_1_synth.json --write net/pmod_7seg9_1_impl.v -o out=net/pmod_7seg9_1_impl.txt -o ccf=src/gm-proto.ccf --router router2 > log/impl.log
Info: Using uarch 'gatemate' for device 'CCGM1A1'
...
Info: Device utilisation:
Info: 	            USR_RSTN:       0/      1     0%
Info: 	            CPE_COMP:       0/  20480     0%
Info: 	         CPE_CPLINES:       4/  20480     0%
Info: 	               IOSEL:       3/    162     1%
Info: 	                GPIO:       3/    162     1%
Info: 	               CLKIN:       1/      1   100%
Info: 	              GLBOUT:       1/      1   100%
Info: 	                 PLL:       0/      4     0%
Info: 	            CFG_CTRL:       0/      1     0%
Info: 	              SERDES:       0/      1     0%
Info: 	              CPE_LT:     245/  40960     0%
Info: 	              CPE_FF:      58/  40960     0%
Info: 	           CPE_RAMIO:       2/  40960     0%
Info: 	            RAM_HALF:       0/     64     0%
...
Info: Program finished normally.
/home/fm/oss-cad-suite/bin/gmpack --input pmod_7seg9_1_impl.txt --bit pmod_7seg9_1.bit
```

Programming the FPGA:
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_1$ make spi-flash 
/home/fm/oss-cad-suite/bin/openFPGALoader  -b gatemate_evb_spi -f --verify pmod_7seg9_1.bit
empty
write to flash
Jtag frequency : requested 6.00MHz    -> real 6.00MHz   
JEDEC ID: 0xc22817
Detected: Macronix MX25R6435F 128 sectors size: 64Mb
00000000 00000000 00000000 00
start addr: 00000000, end_addr: 00010000
Erasing: [==================================================] 100.00%
Done
Writing: [==================================================] 100.00%
Done
Verifying write (May take time)
Reading: [==================================================] 100.00%
Done
Wait for CFG_DONE DONE
```
