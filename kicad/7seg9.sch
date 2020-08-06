EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "7SEG9 PMOD"
Date "2020-05-20"
Rev "V1.2"
Comp "FM4DD"
Comment1 "2020 (C) FM4DD"
Comment2 "SGM6603-5.0 Step-Up IC"
Comment3 "License: CC-BY-SA 4.0"
Comment4 ""
$EndDescr
NoConn ~ 2250 2850
NoConn ~ 2250 2950
$Comp
L Connector_Generic:Conn_01x06 J1
U 1 1 5E55FA71
P 2050 3150
F 0 "J1" H 2050 2750 50  0000 C CNN
F 1 "PMOD_01x06" V 2150 3100 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Horizontal" H 2050 3150 50  0001 C CNN
F 3 "~" H 2050 3150 50  0001 C CNN
	1    2050 3150
	-1   0    0    1   
$EndComp
Text Label 2250 3050 0    50   ~ 0
DIO
Text Label 2250 3150 0    50   ~ 0
CLK
$Comp
L power:+3V3 #PWR0101
U 1 1 5AED6787
P 2450 2000
F 0 "#PWR0101" H 2450 1850 50  0001 C CNN
F 1 "+3V3" H 2465 2176 50  0000 C CNN
F 2 "" H 2450 2000 50  0001 C CNN
F 3 "" H 2450 2000 50  0001 C CNN
	1    2450 2000
	1    0    0    -1  
$EndComp
$Comp
L 01_FM4DD:7SEG_C533SR-A DP1
U 1 1 5E562BA6
P 6000 3150
F 0 "DP1" H 6500 2600 50  0000 L CNN
F 1 "7SEG_C533SR-A" H 5500 2800 50  0000 L CNN
F 2 "01_FM4DD:7SEG_CS533SR-A" H 5750 2800 50  0001 C CNN
F 3 "http://www.kyohritsu.jp/eclib/OTHER/DATASHEET/LED/osl40391xx.pdf" H 5670 3180 50  0001 C CNN
	1    6000 3150
	1    0    0    -1  
$EndComp
$Comp
L 01_FM4DD:7SEG_C533SR-A DP2
U 1 1 5E5655C1
P 7600 3150
F 0 "DP2" H 8100 2600 50  0000 L CNN
F 1 "7SEG_C533SR-A" H 7100 2800 50  0000 L CNN
F 2 "01_FM4DD:7SEG_CS533SR-A" H 7350 2800 50  0001 C CNN
F 3 "http://www.kyohritsu.jp/eclib/OTHER/DATASHEET/LED/osl40391xx.pdf" H 7270 3180 50  0001 C CNN
	1    7600 3150
	1    0    0    -1  
$EndComp
Text Label 7750 2550 1    50   ~ 0
GRID6
Text Label 7550 2550 1    50   ~ 0
GRID5
Text Label 6350 2550 1    50   ~ 0
SEG2
$Comp
L Device:R R1
U 1 1 5E5E59B2
P 2650 2750
F 0 "R1" H 2720 2796 50  0000 L CNN
F 1 "10K" V 2650 2700 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2580 2750 50  0001 C CNN
F 3 "~" H 2650 2750 50  0001 C CNN
	1    2650 2750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5E5E607C
P 2900 2750
F 0 "R2" H 2970 2796 50  0000 L CNN
F 1 "10K" V 2900 2700 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 2830 2750 50  0001 C CNN
F 3 "~" H 2900 2750 50  0001 C CNN
	1    2900 2750
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 2900 2650 3150
Wire Wire Line
	2900 2900 2900 3050
Wire Wire Line
	2650 2600 2650 2550
Wire Wire Line
	2900 2550 2650 2550
Wire Wire Line
	2450 2550 2450 3350
Wire Wire Line
	2900 2600 2900 2550
Entry Wire Line
	5350 2300 5250 2200
Entry Wire Line
	5750 2150 5650 2050
Entry Wire Line
	5550 2150 5450 2050
Entry Wire Line
	5950 2300 5850 2200
Entry Wire Line
	6150 2300 6050 2200
Entry Wire Line
	6350 2150 6250 2050
Entry Wire Line
	6950 2300 6850 2200
Entry Wire Line
	7550 2300 7450 2200
Entry Wire Line
	7750 2300 7650 2200
Entry Wire Line
	7950 2150 7850 2050
Text Label 6950 2550 1    50   ~ 0
GRID4
Text Label 6150 2550 1    50   ~ 0
GRID3
Text Label 5950 2550 1    50   ~ 0
GRID2
Entry Wire Line
	5350 3950 5250 4050
Entry Wire Line
	5550 3950 5450 4050
Entry Wire Line
	5750 3950 5650 4050
Entry Wire Line
	5950 3950 5850 4050
Entry Wire Line
	6150 3950 6050 4050
Entry Wire Line
	6950 3950 6850 4050
Entry Wire Line
	7150 3950 7050 4050
Entry Wire Line
	7350 3950 7250 4050
Entry Wire Line
	7550 3950 7450 4050
Entry Wire Line
	7750 3950 7650 4050
Wire Wire Line
	3450 3250 3300 3250
Wire Wire Line
	3450 3350 3300 3350
Wire Wire Line
	3450 3450 3300 3450
Wire Wire Line
	3450 3550 3300 3550
Wire Wire Line
	3450 3650 3300 3650
Wire Wire Line
	3450 3750 3300 3750
Entry Wire Line
	4750 3450 4850 3350
Entry Wire Line
	4750 3350 4850 3250
Entry Wire Line
	4750 3250 4850 3150
Entry Wire Line
	4750 3150 4850 3050
Entry Wire Line
	4750 3050 4850 2950
Entry Wire Line
	4750 2950 4850 2850
Text Label 5550 2550 1    50   ~ 0
SEG1
Text Label 5950 3950 1    50   ~ 0
SEG3
Text Label 5550 3950 1    50   ~ 0
SEG4
Text Label 5350 3950 1    50   ~ 0
SEG5
Text Label 5750 2550 1    50   ~ 0
SEG6
Text Label 6150 3950 1    50   ~ 0
SEG7
Text Label 5750 3950 1    50   ~ 0
SEG8
Text Label 5350 2550 1    50   ~ 0
GRID1
Text Label 7150 2550 1    50   ~ 0
SEG1
Text Label 7950 2550 1    50   ~ 0
SEG2
Text Label 7550 3950 1    50   ~ 0
SEG3
Text Label 7150 3950 1    50   ~ 0
SEG4
Text Label 6950 3950 1    50   ~ 0
SEG5
Text Label 7350 2550 1    50   ~ 0
SEG6
Text Label 7750 3950 1    50   ~ 0
SEG7
Text Label 7350 3950 1    50   ~ 0
SEG8
NoConn ~ 3450 2850
NoConn ~ 3450 2750
NoConn ~ 3450 2650
NoConn ~ 3450 2550
NoConn ~ 3450 2450
NoConn ~ 4550 2450
NoConn ~ 4550 2550
Wire Wire Line
	2250 3050 2900 3050
Wire Wire Line
	2250 3150 2650 3150
Wire Wire Line
	2250 3350 2450 3350
Text Label 2250 3250 0    50   ~ 0
GND
Text Label 2250 3350 0    50   ~ 0
3V3
$Comp
L power:+5V #PWR0102
U 1 1 5EB78AEB
P 5000 2000
F 0 "#PWR0102" H 5000 1850 50  0001 C CNN
F 1 "+5V" H 5015 2173 50  0000 C CNN
F 2 "" H 5000 2000 50  0001 C CNN
F 3 "" H 5000 2000 50  0001 C CNN
	1    5000 2000
	1    0    0    -1  
$EndComp
$Comp
L Device:CP_Small C3
U 1 1 5EB7ACBB
P 5000 4950
F 0 "C3" H 4850 5000 50  0000 R CNN
F 1 "100uF" H 4900 4900 50  0000 R CNN
F 2 "Capacitor_SMD:CP_Elec_6.3x5.4" H 5000 4950 50  0001 C CNN
F 3 "~" H 5000 4950 50  0001 C CNN
	1    5000 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2450 2000 2450 2550
Connection ~ 2450 2550
Connection ~ 2450 3350
$Comp
L Device:C_Small C1
U 1 1 5EB2BF1C
P 2450 5000
F 0 "C1" H 2550 5050 50  0000 L CNN
F 1 "10uF" H 2550 4950 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2450 5000 50  0001 C CNN
F 3 "~" H 2450 5000 50  0001 C CNN
	1    2450 5000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 5EB58604
P 5000 5200
F 0 "#PWR0104" H 5000 4950 50  0001 C CNN
F 1 "GND" H 5005 5024 50  0000 C CNN
F 2 "" H 5000 5200 50  0001 C CNN
F 3 "" H 5000 5200 50  0001 C CNN
	1    5000 5200
	1    0    0    -1  
$EndComp
$Comp
L Device:L_Small L1
U 1 1 5EB5A0F9
P 2850 4650
F 0 "L1" V 2950 4650 50  0000 C CNN
F 1 "4.7uH" V 2800 4650 50  0000 C CNN
F 2 "Inductor_SMD:L_0603_1608Metric" H 2850 4650 50  0001 C CNN
F 3 "~" H 2850 4650 50  0001 C CNN
	1    2850 4650
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 5EB63741
P 3000 3850
F 0 "#PWR0105" H 3000 3600 50  0001 C CNN
F 1 "GND" H 3005 3674 50  0000 C CNN
F 2 "" H 3000 3850 50  0001 C CNN
F 3 "" H 3000 3850 50  0001 C CNN
	1    3000 3850
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C2
U 1 1 5EB71AA8
P 4500 4950
F 0 "C2" H 4600 4900 50  0000 L CNN
F 1 "10uF" H 4600 5000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 4500 4950 50  0001 C CNN
F 3 "~" H 4500 4950 50  0001 C CNN
	1    4500 4950
	-1   0    0    1   
$EndComp
Text Notes 3150 5450 0    50   ~ 0
3.3V to 5V Power Boost
$Comp
L 01_FM4DD:7SEG_C533SR-A DP3
U 1 1 5EC0D241
P 9200 3150
F 0 "DP3" H 9700 2600 50  0000 L CNN
F 1 "7SEG_C533SR-A" H 8700 2800 50  0000 L CNN
F 2 "01_FM4DD:7SEG_CS533SR-A" H 8950 2800 50  0001 C CNN
F 3 "http://www.kyohritsu.jp/eclib/OTHER/DATASHEET/LED/osl40391xx.pdf" H 8870 3180 50  0001 C CNN
	1    9200 3150
	1    0    0    -1  
$EndComp
Text Label 9350 2550 1    50   ~ 0
GRID9
Text Label 9150 2550 1    50   ~ 0
GRID8
Entry Wire Line
	8950 2150 8850 2050
Entry Wire Line
	8750 2150 8650 2050
Entry Wire Line
	9550 2150 9450 2050
Text Label 8550 2550 1    50   ~ 0
GRID7
Entry Wire Line
	8550 3950 8450 4050
Entry Wire Line
	8750 3950 8650 4050
Entry Wire Line
	8950 3950 8850 4050
Entry Wire Line
	9150 3950 9050 4050
Entry Wire Line
	9350 3950 9250 4050
Text Label 8750 2550 1    50   ~ 0
SEG1
Text Label 9550 2550 1    50   ~ 0
SEG2
Text Label 9150 3950 1    50   ~ 0
SEG3
Text Label 8750 3950 1    50   ~ 0
SEG4
Text Label 8550 3950 1    50   ~ 0
SEG5
Text Label 8950 2550 1    50   ~ 0
SEG6
Text Label 9350 3950 1    50   ~ 0
SEG7
Text Label 8950 3950 1    50   ~ 0
SEG8
Entry Wire Line
	8550 2300 8450 2200
Entry Wire Line
	9150 2300 9050 2200
Entry Wire Line
	9350 2300 9250 2200
Wire Notes Line
	2150 4200 2150 5500
Text Label 6300 4050 0    50   ~ 0
SEG1..SEG8
Text Label 6900 2200 2    50   ~ 0
GRID1..GRID9
Entry Wire Line
	4750 2850 4850 2750
Entry Wire Line
	4750 2750 4850 2650
Entry Wire Line
	4750 2650 4850 2550
Text Label 3300 3250 0    50   ~ 0
SEG1
Text Label 3300 3350 0    50   ~ 0
SEG2
Text Label 3300 3450 0    50   ~ 0
SEG3
Text Label 3300 3550 0    50   ~ 0
SEG4
Text Label 3300 3650 0    50   ~ 0
SEG5
Text Label 3300 3750 0    50   ~ 0
SEG6
Text Label 4550 3750 0    50   ~ 0
SEG7
Text Label 4550 3650 0    50   ~ 0
SEG8
Text Label 4550 3450 0    50   ~ 0
GRID1
Text Label 4550 3350 0    50   ~ 0
GRID2
Text Label 4550 3250 0    50   ~ 0
GRID3
Text Label 4550 3150 0    50   ~ 0
GRID4
Text Label 4550 3050 0    50   ~ 0
GRID5
Text Label 4550 2950 0    50   ~ 0
GRID6
Text Label 4550 2850 0    50   ~ 0
GRID7
Text Label 4550 2750 0    50   ~ 0
GRID8
Text Label 4550 2650 0    50   ~ 0
GRID9
Wire Wire Line
	4550 2650 4750 2650
Wire Wire Line
	4550 2750 4750 2750
Wire Wire Line
	4550 2950 4750 2950
Wire Wire Line
	4550 3050 4750 3050
Wire Wire Line
	4550 3150 4750 3150
Wire Wire Line
	4550 3250 4750 3250
Wire Wire Line
	4550 3350 4750 3350
Wire Wire Line
	4550 3450 4750 3450
Wire Wire Line
	4550 3650 4750 3650
Wire Wire Line
	4550 3750 4750 3750
Wire Wire Line
	4550 2850 4750 2850
$Comp
L 01_FM4DD:TM1640 U2
U 1 1 5EB71A62
P 4000 2850
F 0 "U2" H 4000 3400 60  0000 C CNN
F 1 "TM1640" H 4000 1800 60  0000 C CNN
F 2 "01_FM4DD:SOP-28_7.5x17.9mm_P1.27mm" H 4000 1750 60  0001 C CNN
F 3 "" H 4000 2850 60  0001 C CNN
F 4 "Akizuki Denshi" H 4100 1550 60  0001 C CNN "Vendor"
F 5 "I-13224" H 4000 1650 60  0001 C CNN "Vendor Part Number"
	1    4000 2850
	1    0    0    -1  
$EndComp
Wire Notes Line
	5350 5500 5350 4200
Wire Notes Line
	2150 5500 5350 5500
Wire Notes Line
	5350 4200 2150 4200
Wire Bus Line
	3200 4050 4850 4050
Wire Wire Line
	3050 4650 2950 4650
Connection ~ 2650 2550
Wire Wire Line
	2650 2550 2450 2550
Wire Wire Line
	2250 3250 3000 3250
Wire Wire Line
	3000 2950 3450 2950
Connection ~ 3000 3250
Wire Wire Line
	3000 3250 3000 3850
Wire Wire Line
	3000 2950 3000 3250
Connection ~ 2650 3150
Wire Wire Line
	2900 3050 3450 3050
Connection ~ 2900 3050
Wire Bus Line
	9950 2050 9950 4050
Wire Wire Line
	5000 2000 5000 3550
Entry Wire Line
	4750 3750 4850 3850
Entry Wire Line
	4750 3650 4850 3750
Wire Wire Line
	4550 3550 5000 3550
Entry Wire Line
	7150 2150 7050 2050
Entry Wire Line
	7350 2150 7250 2050
Wire Wire Line
	5350 2300 5350 2550
Wire Wire Line
	5550 2150 5550 2550
Wire Wire Line
	5750 2150 5750 2550
Wire Wire Line
	5950 2300 5950 2550
Wire Wire Line
	6150 2300 6150 2550
Wire Wire Line
	6350 2150 6350 2550
Wire Wire Line
	6950 2300 6950 2550
Wire Wire Line
	7150 2150 7150 2550
Wire Wire Line
	7350 2150 7350 2550
Wire Wire Line
	7550 2300 7550 2550
Wire Wire Line
	7750 2300 7750 2550
Wire Wire Line
	7950 2150 7950 2550
Wire Wire Line
	8550 2300 8550 2550
Wire Wire Line
	8750 2150 8750 2550
Wire Wire Line
	8950 2150 8950 2550
Wire Wire Line
	9150 2300 9150 2550
Wire Wire Line
	9350 2300 9350 2550
Wire Wire Line
	9550 2150 9550 2550
Wire Wire Line
	5350 3750 5350 3950
Wire Wire Line
	5550 3750 5550 3950
Wire Wire Line
	5750 3750 5750 3950
Wire Wire Line
	5950 3750 5950 3950
Wire Wire Line
	6150 3750 6150 3950
Wire Wire Line
	6950 3750 6950 3950
Wire Wire Line
	7150 3750 7150 3950
Wire Wire Line
	7350 3750 7350 3950
Wire Wire Line
	7550 3750 7550 3950
Wire Wire Line
	7750 3750 7750 3950
Wire Wire Line
	8550 3750 8550 3950
Wire Wire Line
	8750 3750 8750 3950
Wire Wire Line
	8950 3750 8950 3950
Wire Wire Line
	9150 3750 9150 3950
Wire Wire Line
	9350 3750 9350 3950
Wire Wire Line
	2650 3150 3450 3150
Entry Wire Line
	3300 3250 3200 3350
Entry Wire Line
	3300 3350 3200 3450
Entry Wire Line
	3300 3450 3200 3550
Entry Wire Line
	3300 3550 3200 3650
Entry Wire Line
	3300 3650 3200 3750
Entry Wire Line
	3300 3750 3200 3850
$Comp
L 01_FM4DD:SGM6603-5.0 U1
U 1 1 5EC52181
P 3550 4950
F 0 "U1" H 3300 5400 60  0000 C CNN
F 1 "SGM6603-5.0" H 3550 4900 60  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-6" H 3550 4700 60  0001 C CNN
F 3 "http://www.sg-micro.com/uploads/soft/20190626/1561534022.pdf" H 3550 4950 60  0001 C CNN
F 4 "SG Micro, LCSC" H 3500 4600 60  0001 C CNN "Vendor"
F 5 "L6920DB" H 3500 4800 60  0001 C CNN "Vendor Part Number"
	1    3550 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 4650 4200 4650
Wire Wire Line
	4200 4650 4200 4400
Wire Wire Line
	2450 4650 2750 4650
Wire Wire Line
	2450 4400 4200 4400
Connection ~ 2450 4400
Wire Wire Line
	2450 4400 2450 4650
Wire Wire Line
	2450 3350 2450 4400
Connection ~ 2450 4650
Wire Wire Line
	3050 4850 2450 4850
Wire Wire Line
	2450 4650 2450 4850
Wire Wire Line
	3050 4750 2900 4750
Wire Wire Line
	5000 3550 5000 4750
Connection ~ 5000 3550
Wire Wire Line
	5000 4750 5000 4850
Connection ~ 5000 4750
Wire Wire Line
	4500 4850 4500 4750
Connection ~ 4500 4750
Wire Wire Line
	4500 4750 4050 4750
Wire Wire Line
	4500 4750 5000 4750
Wire Wire Line
	5000 5050 5000 5150
Wire Wire Line
	4500 5150 5000 5150
Wire Wire Line
	4500 5050 4500 5150
Connection ~ 5000 5150
Wire Wire Line
	5000 5150 5000 5200
Connection ~ 4500 5150
Wire Wire Line
	2900 4750 2900 5150
Connection ~ 2900 5150
Wire Wire Line
	2900 5150 4500 5150
Wire Wire Line
	2450 4850 2450 4900
Connection ~ 2450 4850
Wire Wire Line
	2450 5100 2450 5150
Wire Wire Line
	2450 5150 2900 5150
Wire Bus Line
	4850 3750 4850 4050
Wire Bus Line
	3200 2050 3200 4050
Wire Bus Line
	4850 2200 9250 2200
Wire Bus Line
	3200 2050 9950 2050
Wire Bus Line
	4850 2200 4850 3350
Wire Bus Line
	5250 4050 9950 4050
$EndSCHEMATC
