
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 14.745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _offset=R7
	.DEF _rx_wr_index=R6
	.DEF _rx_rd_index=R9
	.DEF _rx_counter=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_seqc:
	.DB  0x1,0x0,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x0,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x06
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 3/13/2016
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 14.745600 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;#include <stdio.h>
;int i;
;bit c;
;char offset=0;
;
;flash char seqc[96][4]={{1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,1},
;{1,0,0,0},{0,1,0,0},{0,0,0,1},{0,0,1,0},
;{1,0,0,0},{0,0,1,0},{0,1,0,0},{0,0,0,1},
;{1,0,0,0},{0,0,1,0},{0,0,0,1},{0,1,0,0},
;{1,0,0,0},{0,0,0,1},{0,0,1,0},{0,1,0,0},
;{1,0,0,0},{0,0,0,1},{0,1,0,0},{0,0,1,0},
;{0,1,0,0},{1,0,0,0},{0,0,1,0},{0,0,0,1},
;{0,1,0,0},{1,0,0,0},{0,0,0,1},{0,0,1,0},
;{0,1,0,0},{0,0,1,0},{1,0,0,0},{0,0,0,1},
;{0,1,0,0},{0,0,1,0},{0,0,0,1},{1,0,0,0},
;{0,1,0,0},{0,0,0,1},{1,0,0,0},{0,0,1,0},
;{0,1,0,0},{0,0,0,1},{0,0,1,0},{1,0,0,0},
;{0,0,1,0},{1,0,0,0},{0,1,0,0},{0,0,0,1},
;{0,0,1,0},{1,0,0,0},{0,0,0,1},{0,1,0,0},
;{0,0,1,0},{0,1,0,0},{1,0,0,0},{0,0,0,1},
;{0,0,1,0},{0,1,0,0},{0,0,0,1},{1,0,0,0},
;{0,0,1,0},{0,0,0,1},{0,1,0,0},{1,0,0,0},
;{0,0,1,0},{0,0,0,1},{1,0,0,0},{0,1,0,0},
;{0,0,0,1},{1,0,0,0},{0,1,0,0},{0,0,1,0},
;{0,0,0,1},{1,0,0,0},{0,0,1,0},{0,1,0,0},
;{0,0,0,1},{0,1,0,0},{1,0,0,0},{0,0,1,0},
;{0,0,0,1},{0,1,0,0},{0,0,1,0},{1,0,0,0},
;{0,0,0,1},{0,0,1,0},{1,0,0,0},{0,1,0,0},
;{0,0,0,1},{0,0,1,0},{0,1,0,0},{1,0,0,0}};
;
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 1
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index=0,rx_rd_index=0;
;#else
;unsigned int rx_wr_index=0,rx_rd_index=0;
;#endif
;
;#if RX_BUFFER_SIZE < 256
;unsigned char rx_counter=0;
;#else
;unsigned int rx_counter=0;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0055 {

	.CSEG
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0056 char status,data;
; 0000 0057 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0058 data=UDR;
	IN   R16,12
; 0000 0059 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 005A    {
; 0000 005B    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 005C    if ((data>=0) && (data<=23)) offset=data*4;
	CPI  R16,0
	BRLO _0x5
	CPI  R16,24
	BRLO _0x6
_0x5:
	RJMP _0x4
_0x6:
	MOV  R30,R16
	LSL  R30
	LSL  R30
	MOV  R7,R30
; 0000 005D    else if (data=='s') c=1;
	RJMP _0x7
_0x4:
	CPI  R16,115
	BRNE _0x8
	SET
	BLD  R2,0
; 0000 005E      else if (data=='t') {c=0;PORTC.5=0;PORTC.4=0;PORTC.3=0;PORTC.2=0;}
	RJMP _0x9
_0x8:
	CPI  R16,116
	BRNE _0xA
	CLT
	BLD  R2,0
	RCALL SUBOPT_0x0
; 0000 005F #if RX_BUFFER_SIZE == 256
; 0000 0060    // special case for receiver buffer size=256
; 0000 0061    if (++rx_counter == 0) rx_buffer_overflow=1;
; 0000 0062 #else
; 0000 0063    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
_0xA:
_0x9:
_0x7:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x13
	CLR  R6
; 0000 0064    if (++rx_counter == RX_BUFFER_SIZE)
_0x13:
	INC  R8
	LDI  R30,LOW(1)
	CP   R30,R8
	BRNE _0x14
; 0000 0065       {
; 0000 0066       rx_counter=0;
	CLR  R8
; 0000 0067       rx_buffer_overflow=1;
	SET
	BLD  R2,1
; 0000 0068       }
; 0000 0069 #endif
; 0000 006A    }
_0x14:
; 0000 006B }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0072 {
; 0000 0073 char data;
; 0000 0074 while (rx_counter==0);
;	data -> R17
; 0000 0075 data=rx_buffer[rx_rd_index++];
; 0000 0076 #if RX_BUFFER_SIZE != 256
; 0000 0077 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0078 #endif
; 0000 0079 #asm("cli")
; 0000 007A --rx_counter;
; 0000 007B #asm("sei")
; 0000 007C return data;
; 0000 007D }
;#pragma used-
;#endif
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0086 {
_read_adc:
; .FSTART _read_adc
; 0000 0087 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0088 // Delay needed for the stabilization of the ADC input voltage
; 0000 0089 delay_us(10);
	__DELAY_USB 49
; 0000 008A // Start the AD conversion
; 0000 008B ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 008C // Wait for the AD conversion to complete
; 0000 008D while ((ADCSRA & (1<<ADIF))==0);
_0x19:
	SBIS 0x6,4
	RJMP _0x19
; 0000 008E ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 008F return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0090 }
; .FEND
;
;void main(void)
; 0000 0093 {
_main:
; .FSTART _main
; 0000 0094 // Declare your local variables here
; 0000 0095 
; 0000 0096 // Input/Output Ports initialization
; 0000 0097 // Port B initialization
; 0000 0098 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0099 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 009A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 009B PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 009C 
; 0000 009D // Port C initialization
; 0000 009E // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 009F DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(60)
	OUT  0x14,R30
; 0000 00A0 // State: Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 00A1 PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00A2 
; 0000 00A3 // Port D initialization
; 0000 00A4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00A5 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00A6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00A7 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00A8 
; 0000 00A9 // Timer/Counter 0 initialization
; 0000 00AA // Clock source: System Clock
; 0000 00AB // Clock value: Timer 0 Stopped
; 0000 00AC TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00AD TCNT0=0x00;
	OUT  0x32,R30
; 0000 00AE 
; 0000 00AF // Timer/Counter 1 initialization
; 0000 00B0 // Clock source: System Clock
; 0000 00B1 // Clock value: Timer1 Stopped
; 0000 00B2 // Mode: Normal top=0xFFFF
; 0000 00B3 // OC1A output: Disconnected
; 0000 00B4 // OC1B output: Disconnected
; 0000 00B5 // Noise Canceler: Off
; 0000 00B6 // Input Capture on Falling Edge
; 0000 00B7 // Timer1 Overflow Interrupt: Off
; 0000 00B8 // Input Capture Interrupt: Off
; 0000 00B9 // Compare A Match Interrupt: Off
; 0000 00BA // Compare B Match Interrupt: Off
; 0000 00BB TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00BC TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00BD TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00BE TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00BF ICR1H=0x00;
	OUT  0x27,R30
; 0000 00C0 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00C1 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00C2 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00C3 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C4 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C5 
; 0000 00C6 // Timer/Counter 2 initialization
; 0000 00C7 // Clock source: System Clock
; 0000 00C8 // Clock value: Timer2 Stopped
; 0000 00C9 // Mode: Normal top=0xFF
; 0000 00CA // OC2 output: Disconnected
; 0000 00CB ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00CC TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00CD TCNT2=0x00;
	OUT  0x24,R30
; 0000 00CE OCR2=0x00;
	OUT  0x23,R30
; 0000 00CF 
; 0000 00D0 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D1 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00D2 
; 0000 00D3 // External Interrupt(s) initialization
; 0000 00D4 // INT0: Off
; 0000 00D5 // INT1: Off
; 0000 00D6 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00D7 
; 0000 00D8 // USART initialization
; 0000 00D9 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00DA // USART Receiver: On
; 0000 00DB // USART Transmitter: Off
; 0000 00DC // USART Mode: Asynchronous
; 0000 00DD // USART Baud Rate: 9600
; 0000 00DE UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00DF UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(144)
	OUT  0xA,R30
; 0000 00E0 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00E1 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00E2 UBRRL=0x5F;
	LDI  R30,LOW(95)
	OUT  0x9,R30
; 0000 00E3 
; 0000 00E4 
; 0000 00E5 // Analog Comparator initialization
; 0000 00E6 // Analog Comparator: Off
; 0000 00E7 // The Analog Comparator's positive input is
; 0000 00E8 // connected to the AIN0 pin
; 0000 00E9 // The Analog Comparator's negative input is
; 0000 00EA // connected to the AIN1 pin
; 0000 00EB ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00EC 
; 0000 00ED // ADC initialization
; 0000 00EE // ADC Clock frequency: 921.600 kHz
; 0000 00EF // ADC Voltage Reference: AVCC pin
; 0000 00F0 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 00F1 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 00F2 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00F3 
; 0000 00F4 // SPI initialization
; 0000 00F5 // SPI disabled
; 0000 00F6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00F7 
; 0000 00F8 // TWI initialization
; 0000 00F9 // TWI disabled
; 0000 00FA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00FB  // i=100;
; 0000 00FC       PORTC.5=0;
	RCALL SUBOPT_0x0
; 0000 00FD       PORTC.4=0;
; 0000 00FE       PORTC.3=0;
; 0000 00FF       PORTC.2=0;
; 0000 0100       c=0;
	CLT
	BLD  R2,0
; 0000 0101       #asm("sei")
	sei
; 0000 0102       offset=0;
	CLR  R7
; 0000 0103 while (1)
_0x24:
; 0000 0104       {
; 0000 0105 
; 0000 0106  while (c)  {
_0x27:
	SBRS R2,0
	RJMP _0x29
; 0000 0107             i=read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R4,R30
; 0000 0108             if (i<20) i=1;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x2A
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0109 
; 0000 010A       PORTC.5=seqc[offset][0];
_0x2A:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	BRNE _0x2B
	CBI  0x15,5
	RJMP _0x2C
_0x2B:
	SBI  0x15,5
_0x2C:
; 0000 010B       PORTC.4=seqc[offset][1];
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	BRNE _0x2D
	CBI  0x15,4
	RJMP _0x2E
_0x2D:
	SBI  0x15,4
_0x2E:
; 0000 010C       PORTC.3=seqc[offset][2];
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4
	BRNE _0x2F
	CBI  0x15,3
	RJMP _0x30
_0x2F:
	SBI  0x15,3
_0x30:
; 0000 010D       PORTC.2=seqc[offset][3];
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x5
	BRNE _0x31
	CBI  0x15,2
	RJMP _0x32
_0x31:
	SBI  0x15,2
_0x32:
; 0000 010E       delay_ms(i);
	RCALL SUBOPT_0x6
; 0000 010F 
; 0000 0110       PORTC.5=seqc[offset+1][0];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x2
	BRNE _0x33
	CBI  0x15,5
	RJMP _0x34
_0x33:
	SBI  0x15,5
_0x34:
; 0000 0111       PORTC.4=seqc[offset+1][1];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x3
	BRNE _0x35
	CBI  0x15,4
	RJMP _0x36
_0x35:
	SBI  0x15,4
_0x36:
; 0000 0112       PORTC.3=seqc[offset+1][2];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x4
	BRNE _0x37
	CBI  0x15,3
	RJMP _0x38
_0x37:
	SBI  0x15,3
_0x38:
; 0000 0113       PORTC.2=seqc[offset+1][3];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x5
	BRNE _0x39
	CBI  0x15,2
	RJMP _0x3A
_0x39:
	SBI  0x15,2
_0x3A:
; 0000 0114       delay_ms(i);
	RCALL SUBOPT_0x6
; 0000 0115 
; 0000 0116       PORTC.5=seqc[offset+2][0];
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x2
	BRNE _0x3B
	CBI  0x15,5
	RJMP _0x3C
_0x3B:
	SBI  0x15,5
_0x3C:
; 0000 0117       PORTC.4=seqc[offset+2][1];
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x3
	BRNE _0x3D
	CBI  0x15,4
	RJMP _0x3E
_0x3D:
	SBI  0x15,4
_0x3E:
; 0000 0118       PORTC.3=seqc[offset+2][2];
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x4
	BRNE _0x3F
	CBI  0x15,3
	RJMP _0x40
_0x3F:
	SBI  0x15,3
_0x40:
; 0000 0119       PORTC.2=seqc[offset+2][3];
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x5
	BRNE _0x41
	CBI  0x15,2
	RJMP _0x42
_0x41:
	SBI  0x15,2
_0x42:
; 0000 011A       delay_ms(i);
	RCALL SUBOPT_0x6
; 0000 011B 
; 0000 011C       PORTC.5=seqc[offset+3][0];
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x2
	BRNE _0x43
	CBI  0x15,5
	RJMP _0x44
_0x43:
	SBI  0x15,5
_0x44:
; 0000 011D       PORTC.4=seqc[offset+3][1];
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x3
	BRNE _0x45
	CBI  0x15,4
	RJMP _0x46
_0x45:
	SBI  0x15,4
_0x46:
; 0000 011E       PORTC.3=seqc[offset+3][2];
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x4
	BRNE _0x47
	CBI  0x15,3
	RJMP _0x48
_0x47:
	SBI  0x15,3
_0x48:
; 0000 011F       PORTC.2=seqc[offset+3][3];
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x5
	BRNE _0x49
	CBI  0x15,2
	RJMP _0x4A
_0x49:
	SBI  0x15,2
_0x4A:
; 0000 0120       delay_ms(i);
	MOVW R26,R4
	RCALL _delay_ms
; 0000 0121       }
	RJMP _0x27
_0x29:
; 0000 0122       PORTC.5=0;
	RCALL SUBOPT_0x0
; 0000 0123       PORTC.4=0;
; 0000 0124       PORTC.3=0;
; 0000 0125       PORTC.2=0;
; 0000 0126 
; 0000 0127       }
	RJMP _0x24
; 0000 0128 }
_0x53:
	RJMP _0x53
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	CBI  0x15,5
	CBI  0x15,4
	CBI  0x15,3
	CBI  0x15,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1:
	MOV  R30,R7
	LDI  R26,LOW(_seqc*2)
	LDI  R27,HIGH(_seqc*2)
	LDI  R31,0
	RCALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LPM  R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ADIW R30,1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ADIW R30,2
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	ADIW R30,3
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	MOVW R26,R4
	RCALL _delay_ms
	MOV  R30,R7
	LDI  R31,0
	RCALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__ADDW1FN _seqc,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	MOV  R30,R7
	LDI  R31,0
	RCALL __LSLW2
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__ADDW1FN _seqc,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	MOV  R30,R7
	LDI  R31,0
	RCALL __LSLW2
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__ADDW1FN _seqc,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	MOV  R30,R7
	LDI  R31,0
	RCALL __LSLW2
	RJMP SUBOPT_0xB


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

;END OF CODE MARKER
__END_OF_CODE:
