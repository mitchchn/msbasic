.segment "CODE"
MONRDKEY:
	LDA	ACIA_STATUS
	AND	#$08
	BEQ	NoDataIn
	LDA	ACIA_DATA
	SEC		; Carry set if key available
	RTS
NoDataIn:
	CLC		; Carry clear if no key pressed
	RTS

MONCOUT:
	PHA
SerialOutWait:
	LDY     #$FF ; Use a delay loop since TX_EMPTY is bugged on real hardware
TXDELAY:
	DEY
	BNE     TXDELAY
	PLA
	STA	ACIA_DATA
	RTS        
        
ISCNTC:
        ;jmp     MONISCNTC
        ;JSR	MONRDKEY
	;BCC	NotCTRLC ; If no key pressed then exit
	;CMP	#3
	;BNE	NotCTRLC ; if CTRL-C not pressed then exit
	;SEC		; Carry set if control C pressed
	RTS
;NotCTRLC:
;	CLC		; Carry clear if control C not pressed
;	RTS
;
;        nop
;        nop
;        nop
;        nop
;        lsr     a
;        bcc     RET2
;        jsr     GETLN
;        cmp     #$03
;!!! *used*to* run into "STOP"