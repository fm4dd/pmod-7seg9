## Example code Pmod 7SEG9

This Verilog example program validates the function of the PMOD 7SEG9 module on the Gatemate E1 board from Cologne Chip.
It creates a timer '0-00-00-0' on the nine seven-segment digits. The onboard SW3 button acts as the 'start' and 'stop' command for the timer.

The constraints have the PMOD 7SEG9 module connected to PMODB lower pinrow.

### Usage

Synthesis
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_1$ make
/home/fm/oss-cad-suite/bin/yosys -ql log/synth.log -p 'read -sv ./src/ctl_7seg9.v ./src/hexdigit.v ./src/pmod_7seg9_2.v ./src/tm1640.v; synth_gatemate -top pmod_7seg9_2 -luttree -nomx8; write_json net/pmod_7seg9_2_synth.json'

=== pmod_7seg9_2 ===

        +----------Local Count, excluding submodules.
        | 
      510 wires
     1323 wire bits
       97 public wires
      564 public wire bits
        5 ports
        5 port bits
      646 cells 
       12   $scopeinfo
      127   CC_ADDF
        1   CC_BUFG
      124   CC_DFF
        2   CC_IBUF
      171   CC_L2T4
      118   CC_L2T5
       15   CC_LUT1
       55   CC_LUT2
       16   CC_MX2
        2   CC_MX4
        3   CC_OBUF
...
```

Place and route:
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_2$ make impl
test -e src/gm.ccf || exit
/home/fm/oss-cad-suite/bin/nextpnr-himbaechel --device=CCGM1A1 --json net/pmod_7seg9_2_synth.json -o out=pmod_7seg9_2_impl.txt -o ccf=src/gm.ccf --router router2 > log/impl.log
Info: Using uarch 'gatemate' for device 'CCGM1A1'
...
Info: Device utilisation:
Info: 	            USR_RSTN:       0/      1     0%
Info: 	            CPE_COMP:       0/  20480     0%
Info: 	         CPE_CPLINES:      14/  20480     0%
Info: 	               IOSEL:       5/    162     3%
Info: 	                GPIO:       5/    162     3%
Info: 	               CLKIN:       1/      1   100%
Info: 	              GLBOUT:       1/      1   100%
Info: 	                 PLL:       0/      4     0%
Info: 	            CFG_CTRL:       0/      1     0%
Info: 	              SERDES:       0/      1     0%
Info: 	              CPE_LT:     657/  40960     1%
Info: 	              CPE_FF:     124/  40960     0%
Info: 	           CPE_RAMIO:       3/  40960     0%
Info: 	            RAM_HALF:       0/     64     0%
...
Info: Program finished normally.
/home/fm/oss-cad-suite/bin/gmpack --input pmod_7seg9_2_impl.txt --bit pmod_7seg9_2.bit
```

Programming the FPGA:
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_2$ make spi-flash
/home/fm/oss-cad-suite/bin/openFPGALoader  -b gatemate_evb_spi -f --verify pmod_7seg9_2.bit
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
