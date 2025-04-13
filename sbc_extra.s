; STARTUP AND SERIAL I/O ROUTINES ===========================================================
; BY G. SEARLE 2013 =========================================================================
ACIA := $5000
ACIAData := ACIA
ACIAStatus := ACIA+1
ACIACommand := ACIA+2
ACIAControl := ACIA+3

.segment "IOHANDLER"
.org $FF00
Reset:
	LDX     #STACK_TOP
	TXS
	LDA #$1F			; 8-N-1, 19200 baud
	;LDA 	#$95		; Set ACIA baud rate, word size and Rx interrupt (to control RTS)
	STA	ACIAControl
	LDA #$0B			; No parity, no echo, no interrupts
	STA ACIACommand
	LDA #$1B			; Begin with escape

; Display startup message
	LDX #0
ShowStartMsg:
	LDA	StartupMessage,X
	BEQ	WaitForKeypress
	JSR	MONCOUT
	INX
	BNE	ShowStartMsg

; Wait for a cold/warm start selection
WaitForKeypress:
	JSR	MONRDKEY
	BCC	WaitForKeypress
	
	AND	#$DF			; Make upper case
	CMP	#'W'			; compare with [W]arm start
	BEQ	WarmStart

	CMP	#'C'			; compare with [C]old start
	BNE	Reset

	JMP	COLD_START	; BASIC cold start

WarmStart:
	JMP	RESTART		; BASIC warm start

MONCOUT:
	PHA
SerialOutWait:
	;LDA	ACIAStatus
	;AND	#2
	;CMP	#2
	;BNE	SerialOutWait
	LDY #$FF ; Use a delay loop since TX_EMPTY is bugged on real hardware
TXDELAY:
	DEY
	BNE TXDELAY
	PLA
	STA	ACIAData
	RTS

MONRDKEY:
	LDA	ACIAStatus
	AND	#$08
	BEQ	NoDataIn
	LDA	ACIAData
	SEC		; Carry set if key available
	RTS
NoDataIn:
	CLC		; Carry clear if no key pressed
	RTS

MONISCNTC:
	JSR	MONRDKEY
	BCC	NotCTRLC ; If no key pressed then exit
	CMP	#3
	BNE	NotCTRLC ; if CTRL-C not pressed then exit
	SEC		; Carry set if control C pressed
	RTS
NotCTRLC:
	CLC		; Carry clear if control C not pressed
	RTS

StartupMessage:
	.byte	$0C,"Cold [C] or warm [W] start?",$0D,$0A,$00
	
.segment "VECTS"
.org $FFFA
	.word	Reset		; NMI 
	.word	Reset		; RESET 
	.word	Reset		; IRQ 

