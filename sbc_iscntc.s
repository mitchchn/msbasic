.segment "CODE"
ISCNTC:
    jmp MONISCNTC
;    JSR	MONRDKEY
;	BCC	NotCTRLC ; If no key pressed then exit
;	CMP	#3
;	BNE	NotCTRLC ; if CTRL-C not pressed then exit
;	SEC		; Carry set if control C pressed
;	RTS
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