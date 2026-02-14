## Example code Pmod 7SEG9

This Verilog example program validates the function of the PMOD 7SEG9 module on the Gatemate E1 board from Cologne Chip. It writes the numbers '123456789' to be displayed on the nine seven-segment digits. The default constraints have the PMOD 7SEG9 module connected to PMODB lower pinrow.

### Usage

Synthesis
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_1$ make
/home/fm/cc-toolchain-linux/bin/yosys/yosys -ql log/synth.log -p 'read -sv ./src/pmod_7seg9_1.v ./src/tm1640.v; synth_gatemate -top pmod_7seg9_1 -nomx8 -vlog net/pmod_7seg9_1_synth.v'

=== pmod_7seg9_1 ===
 
   Number of wires:                140
   Number of wire bits:            395
   Number of public wires:          23
   Number of public wire bits:      68
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                212
     CC_ADDF                        28
     CC_BUFG                         1
     CC_DFF                         52
     CC_IBUF                         1
     CC_LUT1                         7
     CC_LUT2                        28
     CC_LUT3                        19
     CC_LUT4                        72
     CC_MX4                          2
     CC_OBUF                         2
...
```

Place and route:
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_1$ make impl
test -e src/gm-proto.ccf || exit
/home/fm/cc-toolchain-linux/bin/p_r/p_r -i net/pmod_7seg9_1_synth.v -o pmod_7seg9_1 -ccf src/gm-proto.ccf > log/impl.log

Utilization Report

 CPEs                    172 /  20480  (  0.8 %)
 -----------------------------------------------
   CPE Registers          52 /  40960  (  0.1 %)
     Flip-flops           52
     Latches               0

 GPIOs                     3 /    144  (  2.1 %)
...
```

Programming the FPGA:
```
fm@nuc7fpga:~/fpga/hardware/pmod-7seg9/examples/gatemate/pmod_7seg9_1$ make spi-flash
/home/fm/cc-toolchain-linux/bin/openFPGALoader/openFPGALoader  -b gatemate_evb_spi -f --verify pmod_7seg9_1_00.cfg
write to flash
Jtag frequency : requested 6.00MHz   -> real 6.00MHz  
Detail: 
Jedec ID          : c2
memory type       : 28
memory capacity   : 17
EDID + CFD length : c2
EDID              : 1728
CFD               : 
00
Detail: 
Jedec ID          : c2
memory type       : 28
memory capacity   : 17
EDID + CFD length : c2
EDID              : 1728
CFD               : 
flash chip unknown: use basic protection detection
Erasing: [==================================================] 100.00%
Done
Writing: [==================================================] 100.00%
Done
Verifying write (May take time)
Read flash : [==================================================] 100.00%
Done
Wait for CFG_DONE DONE
```
