

DATA SEGMENT

	PORTA_VAL DB 0
    PORTB_VAL DB 0
    PORTC_VAL DB 0
    
    keypadd db 55,56,57,47,52,53,54,42,49,50,51,45,67,48,61,43
    keypadn db 7,8,9,10,4,5,6,11,1,2,3,12,13,0,14,15                                       
;sample string
    
    error	DB	"ERROR$" 
    str     db   6  
    
    refresh db  "refreshed$"
    clear   db  "clearing memory$"
    stop db "stop calculator$" 
    
    
    welcom db "welcome$"
    myname db "my name is coco$"
    ready db "im ready$"
    
;port addresses  
    PORTA EQU 0F0H 	;PORTA IS CONNECTED TO THE D7-D0
	PORTB EQU 0F2H 	;PORTB0 IS RW, PORTB1 IS RS, PORTB2 IS EN
	PORTC EQU 0F4H
	PCW   EQU 0F6H	;PORT FOR IO CONTROL 
	
	
	temp db 0
	number1 dw 0 
	number2 dw 0
	result dw 0 
	num dw 0
               
ENDS

STACK SEGMENT
    DW   128  DUP(0)
ENDS

CODE SEGMENT
START:
; setregisters: segment  
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX  
    
;define IO ports
    MOV DX,PCW
    MOV AL,10000000B   ;to make all ports output
    OUT DX,AL  
    

	
	
	   
	CALL LCD_INIT	
		
	 
;welcoming


    MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	LEA SI,welcom
	CALL LCD_PRINTSTR 
	
	MOV CX,60000
	CALL DELAY    	 
	 
	 
	 
	MOV DL,2
	MOV DH,1
	CALL LCD_SET_CUR
	LEA SI,myname
	CALL LCD_PRINTSTR 
	
	MOV CX,60000
	CALL DELAY  
	
	
	CALL LCD_CLEAR
	 
	 
	MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	LEA SI,ready
	CALL LCD_PRINTSTR 
	
	MOV CX,60000
	CALL DELAY 
	  
	  
	CALL LCD_CLEAR 
	 
	 
	MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	

	
	mov al , 0
	out 82h,al
check1:  
    in al , 82h
    and al,01h
    cmp al,01h
    jne check1
    
    mov al,0
    out 82h,al 
     
     
    in al , 80h
    and al,0fh
    mov temp , al
    lea bx , keypadd
    xlat        
    MOV AH,al	
	CALL LCD_WRITE_CHAR  
	
	MOV CX,16000
	CALL DELAY       
	
	mov al , temp
	lea bx, keypadn
	xlat
	
	cmp al,10
	je divide
	
	cmp al,11
	je multipl
	
	cmp al ,12
	je minus 
	
	cmp al,15
	je plus
	
	cmp al,13
	je refreshd
	
	cmp al,14
	je errori
	
		
	mov bl,al
	mov ax,number1   
	mov cx,10
	mul cx
	mov bh,0
	add ax,bx
	mov number1,ax
	
	
    MOV CX,16000
	CALL DELAY
    
    mov al,0
    out 82h,al 
    	          
	jmp check1
	
	 
plus:
	
	mov al , 0
	out 82h,al
check2:  
    in al , 82h
    and al,01h
    cmp al,01h
    jne check2
    
    mov al,0
    out 82h,al 
     
     
    in al , 80h
    and al,0fh
    mov temp , al
    lea bx , keypadd
    xlat        
    MOV AH,al	
	CALL LCD_WRITE_CHAR
	mov al , temp
	lea bx, keypadn
	xlat
	 
    cmp al,14
	je equalp
	
	cmp al,13
	je refreshd
		
	
	cmp al,10
	je errori
	
	cmp al,11
	je errori
	
	cmp al ,12
	je errori 
	
	cmp al,15
	je errori
	
	
	
	
		
	mov bl,al
	mov ax,number2   
	mov cx,10
	mul cx
	mov bh,0
	add ax,bx
	mov number2,ax
	
	
    MOV CX,16000
	CALL DELAY
    
    mov al,0
    out 82h,al 
    	          
	jmp check2	 
equalp:
    
    mov ax,number1
    mov bx,number2
    add ax,bx
    mov result ,ax
    
    
	MOV CX,60000
	CALL DELAY 
	
	
	jmp endall 
	 
	 
minus:
    
    mov al , 0
	out 82h,al
check3:  
    in al , 82h
    and al,01h
    cmp al,01h
    jne check3
    
    mov al,0
    out 82h,al 
     
     
    in al , 80h
    and al,0fh
    mov temp , al
    lea bx , keypadd
    xlat        
    MOV AH,al	
	CALL LCD_WRITE_CHAR
	mov al , temp
	lea bx, keypadn
	xlat
	 
    cmp al,14
	je equalm
	
	cmp al,13
	je refreshd
	
	
	cmp al,10
	je errori
	
	cmp al,11
	je errori
	
	cmp al ,12
	je errori 
	
	cmp al,15
	je errori
	
		
	mov bl,al
	mov ax,number2   
	mov cx,10
	mul cx
	mov bh,0
	add ax,bx
	mov number2,ax
	
	
    MOV CX,16000
	CALL DELAY
    
    mov al,0
    out 82h,al 
    	          
	jmp check3	 
equalm:
    
    mov ax,number1
    mov bx,number2
    sub ax,bx
    mov result ,ax
   	 
	 
	MOV CX,60000
	CALL DELAY 
	
	
	jmp endall 	 
	 
	 
	 
multipl:

    mov al , 0
	out 82h,al
check4:  
    in al , 82h
    and al,01h
    cmp al,01h
    jne check4
    
    
    mov al,0
    out 82h,al 
     
     
    in al , 80h
    and al,0fh
    mov temp , al
    lea bx , keypadd
    xlat        
    MOV AH,al	
	CALL LCD_WRITE_CHAR
	mov al , temp
	lea bx, keypadn
	xlat
	 
    cmp al,14
	je equalmu
	 
	cmp al,13
	je refreshd 
	
	
	
	cmp al,10
	je errori
	
	cmp al,11
	je errori
	
	cmp al ,12
	je errori 
	
	cmp al,15
	je errori
	
		
	mov bl,al
	mov ax,number2   
	mov cx,10
	mul cx
	mov bh,0
	add ax,bx
	mov number2,ax
	
	
    MOV CX,16000
	CALL DELAY
    
    mov al,0
    out 82h,al 
    	          
	jmp check4	 
equalmu:
    
    mov ax,number1
    mov cx,number2
    mul cx
    mov result ,ax 
  
	MOV CX,60000
	CALL DELAY 
	
	
	jmp endall 	 
      
      
      
 
divide: 

	mov al , 0
	out 82h,al
check5:  
    in al , 82h
    and al,01h
    cmp al,01h
    jne check5
    
    mov al,0
    out 82h,al 
     
     
    in al , 80h
    and al,0fh
    mov temp , al
    lea bx , keypadd
    xlat        
    MOV AH,al	
	CALL LCD_WRITE_CHAR
	mov al , temp
	lea bx, keypadn
	xlat
	 
    cmp al,14
	je equald
	 
	cmp al,13
	je refreshd 
	
		
	
	cmp al,10
	je errori
	
	cmp al,11
	je errori
	
	cmp al ,12
	je errori 
	
	cmp al,15
	je errori
	
	
	
	
		
	mov bl,al
	mov ax,number2   
	mov cx,10
	mul cx
	mov bh,0
	add ax,bx
	mov number2,ax
	
	
    MOV CX,16000
	CALL DELAY
    
    mov al,0
    out 82h,al 
    	          
	jmp check5	 
equald:
    mov dx,0
    mov ax,number1
    mov cx,number2
    div cx
    mov result ,ax 
    
   
	MOV CX,60000
	CALL DELAY 
	
	
	jmp endall  
 
 
 
 
errori:   

    MOV CX,60000
	CALL DELAY
    
    CALL LCD_CLEAR
    MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	LEA SI,error
	CALL LCD_PRINTSTR   
    jmp refreshd
   
   
   
refreshd:
    
    mov temp , 0
    mov	number1 , 0 
    mov	number2 , 0
    mov	result , 0 
    mov	num , 0   
    
    CALL LCD_CLEAR
    
                 
    MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	LEA SI,refresh
	CALL LCD_PRINTSTR
	
	MOV CX,60000
	CALL DELAY
	
	CALL LCD_CLEAR
	 
	MOV DL,1
	MOV DH,1
	CALL LCD_SET_CUR
	LEA SI,clear
	CALL LCD_PRINTSTR 
	
	MOV CX,60000
	CALL DELAY    
          
    jmp START      
          
          
       	 
	 
	 
endall:
    
    mov ax,result
    mov num,ax    
    mov ax, 0 
    mov bx,0        ; Initialize a counter to zero
    mov cx, 10        ; Set the divisor to 10
divide_loop:
    cmp num, 0        ; Check if the number is zero
    je  end_program   ; If yes, end the program
    inc bl            ; Increment the counter 
    xor dx, dx        ; Clear any previous remainder
    div cx            ; Divide bx by 10, result in ax, remainder in dx
    mov num, ax       ; Copy the quotient back to num
    jmp divide_loop   ; Repeat the process    
end_program:
    add bl,1    
         
    
    lea di,str
    mov dl,bl
    mov dh,0   
    add di,dx
    add di,1    
    mov byte ptr[di],'$'
    mov ax,result
    mov cl,10
while:  dec  di
        div  cl
        add ah,48
        mov [di],ah
        mov ah,0
        cmp ax,0
    jne    while   

    ; Print the result using printf    
    MOV DL,2
	MOV DH,1
	CALL LCD_SET_CUR
	LEA SI,str
	CALL LCD_PRINTSTR   
    MOV CX,60000
	CALL DELAY
	
    
 	
             
      
	mov al , 0
	out 82h,al
checke:  
    in al , 82h
    and al,01h
    cmp al,01h
    jne checke
    
    mov al,0
    out 82h,al 
     
     
    in al , 80h
    and al,0fh
    mov temp , al
    lea bx , keypadd
    xlat        
        	
	mov al , temp
	lea bx, keypadn
	xlat
	
	cmp al,13
	je  refreshd
    jmp checke   
       
       
       
   
	
	  	
  
	HLT
;end of main procedure





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                    ;
;		LCD function library.        ;
;                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PROC DELAY
;input: CX, this value controls the delay. CX=50 means 1ms
;output: none
	JCXZ @DELAY_END
	@DEL_LOOP:
	LOOP @DEL_LOOP	
	@DELAY_END:
	RET
ENDP DELAY



; LCD initialization
PROC LCD_INIT
;input: none
;output: none

;make RS=En=RW=0
	MOV AL,0
	CALL OUT_B
;delay 20ms
	MOV CX,1000
	CALL DELAY
;reset sequence
	MOV AH,30H
	CALL LCD_CMD
	MOV CX,250
	CALL DELAY
	
	MOV AH,30H
	CALL LCD_CMD
	MOV CX,50
	CALL DELAY
	
	MOV AH,30H
	CALL LCD_CMD
	MOV CX,500
	CALL DELAY
	
;function set
	MOV AH,38H
	CALL LCD_CMD
	
	MOV AH,0CH
	CALL LCD_CMD
	
	MOV AH,01H
	CALL LCD_CMD
	
	MOV AH,06H
	CALL LCD_CMD
	
	RET	
ENDP LCD_INIT




;sends commands to LCD
PROC LCD_CMD
;input: AH = command code
;output: none

;save registers
	PUSH DX
	PUSH AX
;make rs=0
	MOV AL,PORTB_VAL
	AND AL,0FDH		;En-RS-RW
	CALL OUT_B
;set out data pins
	MOV AL,AH
	CALL OUT_A
;make En=1
	MOV AL,PORTB_VAL
	OR	AL,100B		;En-RS-RW
	CALL OUT_B
;delay 1ms
	MOV CX,50
	CALL DELAY
;make En=0
	MOV AL,PORTB_VAL
	AND AL,0FBH		;En-RS-RW
	CALL OUT_B
;delay 1ms
	MOV CX,50
	CALL DELAY
;restore registers
	POP AX
	POP DX	
	RET
ENDP LCD_CMD




PROC LCD_CLEAR
	MOV AH,1
	CALL LCD_CMD
	RET	
ENDP LCD_CLEAR



;writes a character on current cursor position
PROC LCD_WRITE_CHAR
;input: AH
;output: none

;save registers
	PUSH AX
;set RS=1
	MOV AL,PORTB_VAL
	OR	AL,10B		;EN-RS-RW
	CALL OUT_B
;set out the data pins
	MOV AL,AH
	CALL OUT_A
;set En=1
	MOV AL,PORTB_VAL
	OR	AL,100B		;EN-RS-RW
	CALL OUT_B
;delay 1ms
	MOV CX,500
	CALL DELAY
;set En=0
	MOV AL,PORTB_VAL
	AND	AL,0FBH		;EN-RS-RW
	CALL OUT_B
;return
	POP AX
	RET	
ENDP LCD_WRITE_CHAR





;prints a string on current cursor position
PROC LCD_PRINTSTR
;input: SI=string address, string should end with '$'
;output: none

;save registers
	PUSH SI
	PUSH AX
;read and write character
	@LCD_PRINTSTR_LT:
		LODSB
		CMP AL,'$'
		JE @LCD_PRINTSTR_EXIT
		MOV AH,AL
		CALL LCD_WRITE_CHAR	
	JMP @LCD_PRINTSTR_LT
	
;return
	@LCD_PRINTSTR_EXIT:
	POP AX
	POP SI
	RET	
ENDP LCD_PRINTSTR




;sets the cursor
PROC LCD_SET_CUR
;input: DL=ROW, DH=COL
;		DL = 1, means upper row
;		DL = 2, means lower row
;		DH = 1-8, 1st column is 1
;output: none

;save registers
	PUSH AX
;LCD uses 0 based column index
	DEC DH
;select case	
	CMP DL,1
	JE	@ROW1
	CMP DL,2
	JE	@ROW2
	JMP @LCD_SET_CUR_END
	
;if DL==1 then
	@ROW1:
		MOV AH,80H
	JMP @LCD_SET_CUR_ENDCASE
	
;if DL==2 then
	@ROW2:
		MOV AH,0C0H
	JMP @LCD_SET_CUR_ENDCASE
		
;execute the command
	@LCD_SET_CUR_ENDCASE:	
	ADD AH,DH
	CALL LCD_CMD
	
;exit from procedure
	@LCD_SET_CUR_END:
	POP AX
	RET
ENDP LCD_SET_CUR






PROC LCD_SHOW_CUR
;input: none
;output: none
	PUSH AX
	MOV AH,0FH
	CALL LCD_CMD
	POP AX
	RET
ENDP LCD_SHOW_CUR




PROC LCD_HIDE_CUR
;input: none
;output: none
	PUSH AX
	MOV AH,0CH
	CALL LCD_CMD
	POP AX
	RET
ENDP LCD_HIDE_CUR



;sends data to output port and saves them in a variable
PROC OUT_A
;input: AL
;output: PORTA_VAL
	PUSH DX
	MOV DX,PORTA
	OUT DX,AL
	MOV PORTA_VAL,AL
	POP DX
	RET	
ENDP OUT_A


PROC OUT_B
;input: AL
;output: PORTB_VAL	
	PUSH DX
	MOV DX,PORTB
	OUT DX,AL
	MOV PORTB_VAL,AL
	POP DX
	RET
ENDP OUT_B

PROC OUT_C
;input: AL
;output: PORTC_VAL	
	PUSH DX
	MOV DX,PORTC
	OUT DX,AL
	MOV PORTC_VAL,AL
	POP DX
	RET
ENDP OUT_C



CODE ENDS ;end of CODE segment
END START ; set entry point and stop the assembler.
.
