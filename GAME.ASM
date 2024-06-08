.Model Small
.Stack 100h
.Data

bc_width EQU 320
bc_height EQU 200


filename_bc DB 'menu.bin', 0


mssg1 DB "ENTER PLAYER NAME: $"
space db " $"
filename DB 'text.txt', 0
filehandle DW ?
buffer DB 100 dup('$')
mssg DB "ENTER PLAYER NAME: $"
mssg2 DB "PLAYER ** $"
mssg3 DB " ** REGISTERED SUCCESSFULLY$"
mssg4 DB " Press Enter to Play: $"
ins1 DB '-- I N S T R U C T I O N S --$'
ins01 DB 13, 10, 13, 10, 13, 10, 'Duck Hunt was released as a Nintendo VS. System arcade game in April 1984,[3] and was later included in the PlayChoice-10 arcade console.$'
ins2 DB 13, 10, 13, 10, 'This is a first-person shooter game with moving on-screen targets'
     DB 13, 10, 'The player selects the game mode, one or two targets appear, and the player has three attempts to hit them before they disappear. Each round totals ten targets.$'
ins3 DB 13, 10, 'The player must hit a minimum number of targets to advance to the next round or else get a game over.'
     DB 'The difficulty progresses with faster targets of an increasing minimum number.'
     DB 13, 10, 13, 10, 'The player receives points per target and bonus points for shooting all ten targets per round. The highest scores are tracked per session.$'  
proj DB '-- A Project by  Ismail Hafeez  &  Manhab Zafar --$'

pause1 DB '-- G A M E  P A U S E D --      $'
pause2 DB ' Press R to Resume or Q to Quit      $'

quit1 DB "*** T H A N K  Y O U  F O R  P L A Y I N G ***$"
quit2 DB "W E  W I L L  M I S S  Y O U :($"

BULLET DB "BULLETS: $"
SCORE DB "SCORE:   $"
SCORE_NUM DB 0
BULLET_NUM DB 5

bleft DB 2
bm DB 3
br DB 4
face DB 5
beak1 DB 6
beak2 DB 7
iterator DB 35

line1 DB 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, '      ---------------------------$'
line2 DB 13, 10, 13, 10, '      ---------------------------$'
begin DB 13, 10, 13, 10, '          MODE 1 BEGINS IN$'
prompt1 DB '  1$'
prompt2 DB '  2$'
prompt3 DB '  3$'

no_bullets DB 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, '        *** NO MORE BULLETS ***$'
congratz DB 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, '        *** GAME COMPLETED ***$'
total_score DB 13, 10, 13, 10, '            FINAL SCORE: $'
mode2 DB 13, 10, 13, 10, '          MODE 2 BEGINS IN$'

fileHandle_bc DW ?

bc_data DB bc_width * bc_height dup(0)

.Code
MAIN PROC
start:
    MOV AX , @DATA
    MOV DS , AX
    
    ; Graphics mode

    MOV AH, 0
    MOV AL, 13h
    INT 10h

    call DIAG_PURPLE
    call DIAG_BLUE

    call DIAG_PURPLE
    call DIAG_BLUE

    call DIAG_PURPLE
    call DIAG_BLUE

    call DIAG_PURPLE

    CALL OpenFile
    CALL ReadData
	
    LEA BX , bc_data ; BL contains index at the current drawn pixel
	
    MOV CX,0
    MOV DX,0
    MOV AH,0ch
	
; Drawing loop
drawLoop:
    MOV AL,[BX]
    INT 10h 
    INC CX
    INC BX
    CMP CX,bc_width
JNE drawLoop 
	
    MOV CX , 0
    INC DX
    CMP DX , bc_height
JNE drawLoop

	
    ; Press any key to exit
    MOV AH , 0
    INT 16h
    
    call CloseFile
    
    ;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h 

    call instructions

    ; Press any key to exit
    MOV AH , 0
    INT 16h

     ;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h

    Mov ah, 3dh                 ; function to open a file
    lea dx, filename            ; set offset
    Mov al, 2                   ; open existing file for writing
    int 21h                     ; interrupt
    mov filehandle, ax          ; move file handle to variable

    ; leaving lines

    MOV CX, 11

    LOOP_LINE:

        mov dl, 10
        mov ah, 2
        int 21h
        mov dl, 13
        mov ah, 2
        int 21h

    LOOP LOOP_LINE

    ; leaving spaces

    MOV CX, 20

    LOOP_SPACE:

        LEA DX, space
        MOV AH, 9
        INT 21H

    LOOP LOOP_SPACE

    ; Prompting user

    LEA DX, MSSG
    MOV AH, 9
    INT 21H
    MOV SI, 0
    MOV CX, 0

    AGAIN:
        MOV AH, 1
        INT 21H
        CMP AL, 13
        JE WRITE_FILE
        MOV BUFFER[SI], AL
        INC SI
        INC CX
    JMP AGAIN

    WRITE_FILE:
        ; Writing content of the buffer into the file
        MOV AH, 40h
        MOV BX, filehandle
        LEA DX, buffer
        INT 21H 

    ; Closing File

    MOV AH, 3EH
    MOV BX, filehandle
    INT 21H
    
    ;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h 

    ; Reopening File for Reading

    Mov ah, 3dh                 ; function to open a file
    lea dx, filename            ; set offset
    Mov al, 0                   ; open existing file for reading
    int 21h                     ; interrupt
    mov filehandle, ax          ; move file handle to variable

    ; leaving lines

    MOV CX, 11

    LOOP_LINE1:

        mov dl, 10
        mov ah, 2
        int 21h
        mov dl, 13
        mov ah, 2
        int 21h

    LOOP LOOP_LINE1

    ; leaving spaces

    MOV CX, 15

    LOOP_SPACE1:

        LEA DX, space
        MOV AH, 9
        INT 21H

    LOOP LOOP_SPACE1

    ; Showing name on screen

    Lea dx, mssg2
    mov ah, 9
    int 21h

    READ_FILE:
        Mov ah, 3fh 
        Mov bx, filehandle
        Mov cx, 100
        lea dx, buffer
        int 21h

    ; Displaying Content of File

    LEA DX, buffer
    MOV AH, 9
    INT 21H

    Lea dx, mssg3
    mov ah, 9
    int 21h

    ; leaving lines

    MOV CX, 4

    LOOP_LINE2:

        mov dl, 10
        mov ah, 2
        int 21h
        mov dl, 13
        mov ah, 2
        int 21h

    LOOP LOOP_LINE2

    ; leaving spaces

    MOV CX, 27

    LOOP_SPACE2:

        LEA DX, space
        MOV AH, 9
        INT 21H

    LOOP LOOP_SPACE2
   
    LEA DX, mssg4
    MOV AH, 9
    INT 21H

    ; Wait for keypress to exit
    MOV AH, 00h
    INT 16h

    ; Closing File

    MOV AH, 3EH
    MOV BX, filehandle
    INT 21H

    ; Set video mode to 13h (320x200 256-color graphics mode)
    mov ah, 0
    mov al, 13h
    int 10h
    
    call countdown

    ; Display the cursor
    mov ax, 1
    int 33h

looping:

    mov ah, 0
    mov al, 13h
    int 10h

    call set_background

    ; Display the cursor
    mov ax, 1
    int 33h

    mov al, SCORE_NUM
    cmp al, 6
    jge display_prompt2
    push ax

    call set_score

    mov al, BULLET_NUM
    cmp al, 0
    jl display_prompt
    push ax

    call set_bullets 

    call duck
    call count_delay
    call check_click

    call count_delay
   
jmp looping

display_prompt:
    mov ah, 0
    mov al, 13h
    int 10h
    lea dx, no_bullets
    mov ah, 9
    int 21h

    lea dx, total_score
    mov ah, 9
    int 21h
    mov dl, SCORE_NUM
    add dl, 48
    mov ah, 2
    int 21h
    jmp end_program

display_prompt2:
    mov ah, 0
    mov al, 13h
    int 10h
    call mode2_countdown
    mov score_num, 0
    mov bullet_num, 3

mode2loop:

    mov ah, 0
    mov al, 13h
    int 10h

    call set_background

    ; Display the cursor
    mov ax, 1
    int 33h

    mov al, SCORE_NUM
    cmp al, 4
    jge display_prompt22
    push ax

    call set_score

    mov al, BULLET_NUM
    cmp al, 0
    jl display_prompt
    push ax

    call set_bullets 

    call duck_mode2
    call count_delay
    call check_click
    call count_delay
   
jmp mode2loop

display_prompt22:
    mov ah, 0
    mov al, 13h
    int 10h
    lea dx, congratz
    mov ah, 9
    int 21h

    lea dx, total_score
    mov ah, 9
    int 21h
    mov dl, SCORE_NUM
    add dl, 48
    mov ah, 2
    int 21h
    jmp end_program

end_program:
    ; Press any key to exit
    MOV AH , 0
    INT 16h
    ; Terminate the program
    mov ah, 4Ch
    int 21h



    
MAIN ENDP

; procedures

OpenFile PROC 

    ; Open file

    MOV AH, 3Dh
    MOV AL, 0 ; read only
    LEA DX, filename_bc
    INT 21h
    
    ; you should check carry flag to make sure it worked correctly
    ; carry = 0 -> successful , file handle -> AX
    ; carry = 1 -> failed , AX -> error code
     
    MOV [fileHandle_bc], AX
    
    RET

OpenFile ENDP

ReadData PROC

    MOV AH,3Fh
    MOV BX, [fileHandle_bc]
    MOV CX,bc_width*bc_height ; number of bytes to read
    LEA DX, bc_data
    INT 21h
    RET
ReadData ENDP 


CloseFile PROC
	MOV AH, 3Eh
	MOV BX, [fileHandle_bc]

	INT 21h
	RET
CloseFile ENDP

delay proc         ; Delay subroutine definition

push ax            ; Preserve registers
push bx
push cx
push dx

mov cx, 3       ; Set CX to 1000 (Delay count)
D1:
mov bx, 5         ; Set BX to 10 (Inner delay count)
D2:
dec bx             ; Decrement BX
jnz D2             ; Jump if not zero to D2 (inner loop)
loop D1            ; Decrement CX and repeat outer loop if CX is not zero

pop dx             ; Restore registers
pop cx
pop bx
pop ax

ret                ; Return from subroutine
delay endp         ; End of delay subroutine

instructions PROC

;Change to Text MODE
    MOV AH,0          
    MOV AL,03h
    INT 10h 

    ; leaving lines

    MOV CX, 3

    LOOP_LINE3:

        mov dl, 10
        mov ah, 2
        int 21h
        mov dl, 13
        mov ah, 2
        int 21h

    LOOP LOOP_LINE3

    ; leaving spaces

    MOV CX, 25

    LOOP_SPACE3:

        LEA DX, space
        MOV AH, 9
        INT 21H

    LOOP LOOP_SPACE3

    LEA DX, ins1
    MOV AH, 9
    INT 21h

    LEA DX, ins01
    MOV AH, 9
    INT 21h

    LEA DX, ins2
    MOV AH, 9
    INT 21h

    LEA DX, ins3
    MOV AH, 9
    INT 21h

    ; leaving lines

    MOV CX, 3

    LOOP_LINE4:

        mov dl, 10
        mov ah, 2
        int 21h
        mov dl, 13
        mov ah, 2
        int 21h

    LOOP LOOP_LINE4

    ; leaving spaces

    MOV CX, 15

    LOOP_SPACE4:

        LEA DX, space
        MOV AH, 9
        INT 21H

    LOOP LOOP_SPACE4

    LEA DX, proj
    MOV AH, 9
    INT 21h

ret

instructions endp

pause PROC

        ; Set video mode 13h (320x200 pixels, 256 colors)
        MOV AH, 00h
        MOV AL, 13h
        INT 10h

        ; Set all pixels to blue (color index 6)
        MOV AX, 0A000h    ; Segment for video memory in mode 13h
        MOV ES, AX
        XOR DI, DI        ; Start from the beginning of video memory
        MOV CX, 320 * 200 ; Total pixels in the upper half of the screen
        MOV AL, Ah        ; purple color index
        REP STOSB         ; Store the color index in each pixel location

        ; leaving lines

        MOV CX, 3

        LOOP_LINE5:

            mov dl, 10
            mov ah, 2
            int 21h
            mov dl, 13
            mov ah, 2
            int 21h

        LOOP LOOP_LINE5

        ; leaving spaces

        MOV CX, 8

        LOOP_SPACE5:

            LEA DX, space
            MOV AH, 9
            INT 21H

        LOOP LOOP_SPACE5

        LEA DX, pause1
        MOV AH, 9
        INT 21H

        ; leaving lines

        MOV CX, 3

        LOOP_LINE6:

            mov dl, 10
            mov ah, 2
            int 21h
            mov dl, 13
            mov ah, 2
            int 21h

        LOOP LOOP_LINE6

        ; leaving spaces

        MOV CX, 3

        LOOP_SPACE6:

            LEA DX, space
            MOV AH, 9
            INT 21H

        LOOP LOOP_SPACE6

        LEA DX, pause2
        MOV AH, 9
        INT 21H

        wait_for_key:
            MOV AH, 0       ; Function 0 of interrupt 16h: Read key
            INT 16h         ; Call interrupt 16h to read the key

            CMP AL, 'q'     ; Compare the key read with 'q'
            JE quitGame    ; If 'q' is pressed, jump to quit_game
            CMP AL, 'r'     ; Compare the key read with 'r'
            JE resumeGame  ; If 'r' is pressed, jump to resume_game

            JMP wait_for_key ; If neither 'q' nor 'r' is pressed, continue waiting for a key

        quitGame:
            call quit_game

        resumeGame:
            JMP looping 

        ret

pause endp

quit_game PROC
    
    ; Set video mode back to text mode
    MOV AH, 00h
    MOV AL, 03h    
    INT 10h

    ; leaving lines

    MOV CX, 8

    LOOP_LINE7:

        mov dl, 10
        mov ah, 2
        int 21h
        mov dl, 13
        mov ah, 2
        int 21h

    LOOP LOOP_LINE7

    ; leaving spaces

    MOV CX, 17

    LOOP_SPACE7:

        LEA DX, space
        MOV AH, 9
        INT 21H

    LOOP LOOP_SPACE7

    ; quiting game message1

    LEA DX, QUIT1
    MOV AH, 9
    INT 21H

    ; leaving lines

    MOV CX, 5

    LOOP_LINE8:

        mov dl, 10
        mov ah, 2
        int 21h
        mov dl, 13
        mov ah, 2
        int 21h

    LOOP LOOP_LINE8

    ; leaving spaces

    MOV CX, 24

    LOOP_SPACE8:

        LEA DX, space
        MOV AH, 9
        INT 21H

    LOOP LOOP_SPACE8

    ; quiting game message2

    LEA DX, QUIT2
    MOV AH, 9
    INT 21H

    ; waiting for key
    MOV AH, 0       
    INT 16h  
    
    ; Set video mode back to text mode
    MOV AH, 00h
    MOV AL, 03h     
    INT 10h

    ; quiting
    MOV AH, 4Ch    ; Function 4Ch of interrupt 21h: Terminate program
    INT 21h        ; Call interrupt 21h to terminate the program

quit_game ENDP

DIAG_PURPLE PROC

; ####### DIAG #######

mov ah, 0Ch        ; Set AH to 0Ch (Write Pixel)
mov al, 5          ; Set AL to 5 (Color of the pixel)
mov bh, 0          ; Set BH to 0 (Page number)
mov cx, 0          ; Col # (X-coordinate of the pixel)
mov dx, 0          ; Row # (Y-coordinate of the pixel)

repeat_purple: 
int 10h            ; Call BIOS video services to write the pixel
inc dx             ; Increment DX to move the pixel down (diagonal movement)
inc cx             ; Increment CX to move the pixel right (diagonal movement)
mov al, 5          ; Set AL to 0 (Erase the previous pixel)
int 10h            ; Call BIOS video services to erase the previous pixel
mov al, 5          ; Set AL to 5 (Color of the pixel)
call delay         ; Call the delay subroutine to introduce delay
cmp dx, 6120        ; Check if the pixel is about to reach the bottom of the screen
jne repeat_purple        ; Repeat until it is about to reach the bottom
;cmp cx, 318        ; Check if the pixel is about to reach the right edge of the screen
;jne repeat6        ; Repeat until it is about to reach the right edge

RET
DIAG_PURPLE ENDP

DIAG_BLUE PROC

; ####### DIAG #######

mov ah, 0Ch        ; Set AH to 0Ch (Write Pixel)
mov al, 3          ; Set AL to 5 (Color of the pixel)
mov bh, 0          ; Set BH to 0 (Page number)
mov cx, 0          ; Col # (X-coordinate of the pixel)
mov dx, 0          ; Row # (Y-coordinate of the pixel)

repeat_blue: 
int 10h            ; Call BIOS video services to write the pixel
inc dx             ; Increment DX to move the pixel down (diagonal movement)
inc cx             ; Increment CX to move the pixel right (diagonal movement)
mov al, 3          ; Set AL to 0 (Erase the previous pixel)
int 10h            ; Call BIOS video services to erase the previous pixel
mov al, 3          ; Set AL to 5 (Color of the pixel)
call delay         ; Call the delay subroutine to introduce delay
cmp dx, 6120        ; Check if the pixel is about to reach the bottom of the screen
jne repeat_blue        ; Repeat until it is about to reach the bottom
;cmp cx, 318        ; Check if the pixel is about to reach the right edge of the screen
;jne repeat6        ; Repeat until it is about to reach the right edge

RET
DIAG_BLUE ENDP

delay_duck proc         ; Delay subroutine definition
    push ax            ; Preserve registers
    push bx
    push cx
    push dx

    mov cx, 8000       ; Set CX Delay count
    D1_duck:
    mov bx, 10         ; Set BX to 10 (Inner delay count)
    D2_duck:
    dec bx             ; Decrement BX
    jnz D2_duck             ; Jump if not zero to D2 (inner loop)
    loop D1_duck            ; Decrement CX and repeat outer loop if CX is not zero

    pop dx             ; Restore registers
    pop cx
    pop bx
    pop ax

    ret                ; Return from subroutine
delay_duck endp         ; End of delay subroutine

delay_duck_mode2 proc         ; Delay subroutine definition
    push ax            ; Preserve registers
    push bx
    push cx
    push dx

    mov cx, 2900       ; Set CX Delay count
    D1_duck2:
    mov bx, 10         ; Set BX to 10 (Inner delay count)
    D2_duck2:
    dec bx             ; Decrement BX
    jnz D2_duck2             ; Jump if not zero to D2 (inner loop)
    loop D1_duck2            ; Decrement CX and repeat outer loop if CX is not zero

    pop dx             ; Restore registers
    pop cx
    pop bx
    pop ax

    ret                ; Return from subroutine
delay_duck_mode2 endp         ; End of delay subroutine

set_background PROC

    ; Set all pixels to blue (color index 6)
    MOV AX, 0A000h    ; Segment for video memory in mode 13h
    MOV ES, AX
    XOR DI, DI        ; Start from the beginning of video memory
    MOV CX, 320 * 160 ; Total pixels in the upper half of the screen
    MOV AL, 3         ; blue color index
    REP STOSB         ; Store the color index in each pixel location

    mov ah, 6                 ; Scroll up window (clear window)
    mov al, 0                 ; Number of lines to scroll (0 means clear the window)

    ; brown 
    mov bh, 6                 ; Color attribute (14h)

    ; truck
    mov ch, 12               ; Top row of window (15)
    mov cl, 34               ; Leftmost column of window (15 + 250 = 265)
    mov dh, 21                ; Bottom row of window (23)
    mov dl, 35               ; Rightmost column of window (17 + 250 = 267)
    int 10h

    ; green
    mov bh, 2                 ; Color attribute (14h)

    ; leaves
    mov ch, 9               ; Top row of window (15)
    mov cl, 31               ; Leftmost column of window (15 + 250 = 265)
    mov dh, 15                ; Bottom row of window (23)
    mov dl, 38               ; Rightmost column of window (17 + 250 = 267)
    int 10h

    ; Draw a orange rectangle in the lower half of the screen
    MOV DI, 320 * 160 ; Start from the beginning of the lower half of the screen
    MOV CX, 320 * 40 ; Total pixels in the lower half of the screen
    MOV AL, 6           ; orange color index
    REP STOSB         ; Store the color index in each pixel location

    ret

set_background endp

duck proc

mov bleft, 2
mov bm, 3
mov br, 4
mov face, 5
mov beak1, 6
mov beak2, 7
mov iterator, 35

mov ah, 6                 ; Scroll up window (clear window)
mov al, 0                 ; Number of lines to scroll (0 means clear the window)
    

moveduck:

    mov bh, 0Eh               ; Color attribute (14h)

    ; body left YELLOW
    mov bh, 0Eh
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, bleft                ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, bleft                  ; Rightmost column of window (adjust this as needed)
    int 10h

    ; body mid YELLOW
    mov bh, 0Eh
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, bm                ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, bm                  ; Rightmost column of window (adjust this as needed)
    int 10h

    ; body right YELLOW
    mov bh, 0Eh
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, br               ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, br                ; Rightmost column of window (adjust this as needed)
    int 10h  

    ; face YELLOW
    mov bh, 0Eh
    mov ch, 4                 ; Top row of window (0 means starting at the top)
    mov cl, face               ; Leftmost column of window (0 means extreme left)
    mov dh, 4                 ; Bottom row of window
    mov dl, face                ; Rightmost column of window (adjust this as needed)
    int 10h 

    ; beak ORANGE
    mov bh, 12               ; Color attribute (14h)
    mov ch, 4                 ; Top row of window (0 means starting at the top)
    mov cl, beak1                 ; Leftmost column of window (0 means extreme left)
    mov dh, 4                 ; Bottom row of window
    mov dl, beak2                  ; Rightmost column of window (adjust this as needed)
    int 10h 

    call delay_duck

    ; body left BLUE
    mov bh, 3
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, bleft               ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, bleft                ; Rightmost column of window (adjust this as needed)
    int 10h

    ; body mid BLUE
    mov bh, 3
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, bm                  ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, bm                 ; Rightmost column of window (adjust this as needed)
    int 10h

    ; body right BLUE
    mov bh, 3
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, br                 ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, br                 ; Rightmost column of window (adjust this as needed)
    int 10h 

    ; face BLUE
    mov bh, 3
    mov ch, 4                 ; Top row of window (0 means starting at the top)
    mov cl, face                 ; Leftmost column of window (0 means extreme left)
    mov dh, 4                 ; Bottom row of window
    mov dl, face                 ; Rightmost column of window (adjust this as needed)
    int 10h 

    ; beak BLUE
    mov bh, 3               ; Color attribute (14h)
    mov ch, 4                 ; Top row of window (0 means starting at the top)
    mov cl, beak1                 ; Leftmost column of window (0 means extreme left)
    mov dh, 4                 ; Bottom row of window
    mov dl, beak2                  ; Rightmost column of window (adjust this as needed)
    int 10h 

    ; inc/dec variables
    inc bleft
    inc bm
    inc br
    inc face
    inc beak1
    inc beak2
    dec iterator

    ; comparing to terminate
    mov al, iterator
    cmp al, 0
    mov al, 0

    ; continue looping
    jne short near_move

    jmp exit
        
near_move:
    jmp moveduck

exit:    
    ret

duck endp

duck_mode2 proc

mov bleft, 2
mov bm, 3
mov br, 4
mov face, 5
mov beak1, 6
mov beak2, 7
mov iterator, 35

mov ah, 6                 ; Scroll up window (clear window)
mov al, 0                 ; Number of lines to scroll (0 means clear the window)
    

moveduck2:

    mov bh, 0Eh               ; Color attribute (14h)

    ; body left YELLOW
    mov bh, 0Eh
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, bleft                ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, bleft                  ; Rightmost column of window (adjust this as needed)
    int 10h

    ; body mid YELLOW
    mov bh, 0Eh
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, bm                ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, bm                  ; Rightmost column of window (adjust this as needed)
    int 10h

    ; body right YELLOW
    mov bh, 0Eh
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, br               ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, br                ; Rightmost column of window (adjust this as needed)
    int 10h  

    ; face YELLOW
    mov bh, 0Eh
    mov ch, 4                 ; Top row of window (0 means starting at the top)
    mov cl, face               ; Leftmost column of window (0 means extreme left)
    mov dh, 4                 ; Bottom row of window
    mov dl, face                ; Rightmost column of window (adjust this as needed)
    int 10h 

    ; beak ORANGE
    mov bh, 12               ; Color attribute (14h)
    mov ch, 4                 ; Top row of window (0 means starting at the top)
    mov cl, beak1                 ; Leftmost column of window (0 means extreme left)
    mov dh, 4                 ; Bottom row of window
    mov dl, beak2                  ; Rightmost column of window (adjust this as needed)
    int 10h 

    call delay_duck_mode2

    ; body left BLUE
    mov bh, 3
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, bleft               ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, bleft                ; Rightmost column of window (adjust this as needed)
    int 10h

    ; body mid BLUE
    mov bh, 3
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, bm                  ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, bm                 ; Rightmost column of window (adjust this as needed)
    int 10h

    ; body right BLUE
    mov bh, 3
    mov ch, 5                 ; Top row of window (0 means starting at the top)
    mov cl, br                 ; Leftmost column of window (0 means extreme left)
    mov dh, 6                 ; Bottom row of window
    mov dl, br                 ; Rightmost column of window (adjust this as needed)
    int 10h 

    ; face BLUE
    mov bh, 3
    mov ch, 4                 ; Top row of window (0 means starting at the top)
    mov cl, face                 ; Leftmost column of window (0 means extreme left)
    mov dh, 4                 ; Bottom row of window
    mov dl, face                 ; Rightmost column of window (adjust this as needed)
    int 10h 

    ; beak BLUE
    mov bh, 3               ; Color attribute (14h)
    mov ch, 4                 ; Top row of window (0 means starting at the top)
    mov cl, beak1                 ; Leftmost column of window (0 means extreme left)
    mov dh, 4                 ; Bottom row of window
    mov dl, beak2                  ; Rightmost column of window (adjust this as needed)
    int 10h 

    ; inc/dec variables
    inc bleft
    inc bm
    inc br
    inc face
    inc beak1
    inc beak2
    dec iterator

    ; comparing to terminate
    mov al, iterator
    cmp al, 0
    mov al, 0

    ; continue looping
    jne short near_move2

    jmp exit2
        
near_move2:
    jmp moveduck2

exit2:  
    ret

duck_mode2 endp

count_delay proc         ; Delay subroutine definition
    push ax            ; Preserve registers
    push bx
    push cx
    push dx

    mov cx, 55000       ; Set CX Delay count
    D1_count:
    mov bx, 10         ; Set BX to 10 (Inner delay count)
    D2_count:
    dec bx             ; Decrement BX
    jnz D2_count             ; Jump if not zero to D2 (inner loop)
    loop D1_count            ; Decrement CX and repeat outer loop if CX is not zero

    pop dx             ; Restore registers
    pop cx
    pop bx
    pop ax

    ret                ; Return from subroutine
count_delay endp         ; End of delay subroutine

countdown proc

    ; Set video mode to 13h (320x200 256-color graphics mode)
    mov ah, 0
    mov al, 13h
    int 10h

    lea dx, line1
    mov ah, 9
    int 21h

    lea dx, begin
    mov ah, 9
    int 21h
    
    lea dx, prompt3
    mov ah, 9
    int 21h

    lea dx, line2
    mov ah, 9
    int 21h

    call count_delay
    call count_delay
    call count_delay

    mov ah, 0
    mov al, 13h
    int 10h

    lea dx, line1
    mov ah, 9
    int 21h
    lea dx, begin
    mov ah, 9
    int 21h
    lea dx, prompt2
    mov ah, 9
    int 21h
    lea dx, line2
    mov ah, 9
    int 21h

    call count_delay
    call count_delay
    call count_delay

    mov ah, 0
    mov al, 13h
    int 10h

    lea dx, line1
    mov ah, 9
    int 21h
    lea dx, begin
    mov ah, 9
    int 21h
    lea dx, prompt1
    mov ah, 9
    int 21h
    lea dx, line2
    mov ah, 9
    int 21h

    call count_delay
    call count_delay
    call count_delay

    ret

countdown endp

mode2_countdown proc

    ; Set video mode to 13h (320x200 256-color graphics mode)
    mov ah, 0
    mov al, 13h
    int 10h

    lea dx, line1
    mov ah, 9
    int 21h

    lea dx, mode2
    mov ah, 9
    int 21h
    
    lea dx, prompt3
    mov ah, 9
    int 21h

    lea dx, line2
    mov ah, 9
    int 21h

    call count_delay
    call count_delay
    call count_delay

    mov ah, 0
    mov al, 13h
    int 10h

    lea dx, line1
    mov ah, 9
    int 21h
    lea dx, mode2
    mov ah, 9
    int 21h
    lea dx, prompt2
    mov ah, 9
    int 21h
    lea dx, line2
    mov ah, 9
    int 21h

    call count_delay
    call count_delay
    call count_delay

    mov ah, 0
    mov al, 13h
    int 10h

    lea dx, line1
    mov ah, 9
    int 21h
    lea dx, mode2
    mov ah, 9
    int 21h
    lea dx, prompt1
    mov ah, 9
    int 21h
    lea dx, line2
    mov ah, 9
    int 21h

    call count_delay
    call count_delay
    call count_delay

    ret

mode2_countdown endp

check_click proc

main_loop:

    ; Display the cursor
    mov ax, 1
    int 33h

    ; Check for mouse event
    mov ax, 3
    int 33h

    ; Check if left button clicked
    test bx, 1
    jz exiting ; If not clicked, continue looping
    
    ; Get mouse Y coordinate
    mov dx, dx ; Row (y coordinate is already in DX from int 33h)
    
    ; Check if the click is in the top 20% of the screen
    cmp dx, 60 ;40
    jl end_program_near ; If Y coordinate < 40, end program
    
    ; Continue looping if not in the top 20%
    jmp exiting

    end_program_near:
        inc score_num
        inc score_num
        jmp exiting

    exiting:
        dec bullet_num
        ret

check_click endp

SET_SCORE PROC
    ; Set up the stack frame
    push bp
    mov bp, sp

    ; Retrieve BULLET_NUM from the stack
    mov al, [bp+4]       ; Get the value of BULLET_NUM from the stack (offset BP by 4)
    mov SCORE_NUM, al   ; Store it in BULLET_NUM

    ; leaving lines
    MOV CX, 21
LOOP_LINE9:
    mov dl, 10
    mov ah, 2
    int 21h
    mov dl, 13
    mov ah, 2
    int 21h
    LOOP LOOP_LINE9

    ; leaving spaces
    MOV CX, 3
LOOP_SPACE9:
    LEA DX, SPACE
    MOV AH, 9
    INT 21H
    LOOP LOOP_SPACE9

    LEA DX, SCORE
    MOV AH, 9
    INT 21H

    ; Get SCORE_NUM from the stack
    MOV DL, SCORE_NUM        ; Load the variable into DL
    ADD DL, 48        ; Convert number to ASCII character
    MOV AH, 2
    INT 21H

    LEA DX, SPACE
    MOV AH, 9
    INT 21H

    pop bp
    RET 2
SET_SCORE ENDP


SET_BULLETS PROC
    ; Set up the stack frame
    push bp
    mov bp, sp

    ; Retrieve BULLET_NUM from the stack
    mov al, [bp+4]       ; Get the value of BULLET_NUM from the stack (offset BP by 4)
    mov BULLET_NUM, al   ; Store it in BULLET_NUM

    ; leaving lines
    MOV CX, 1
LOOP_LINE10:
    mov dl, 10
    mov ah, 2
    int 21h
    mov dl, 13
    mov ah, 2
    int 21h
    LOOP LOOP_LINE10

    MOV CX, 3
LOOP_SPACE10:
    LEA DX, SPACE
    MOV AH, 9
    INT 21H
    LOOP LOOP_SPACE10

    LEA DX, BULLET
    MOV AH, 9
    INT 21H

    ; Debugging output
    MOV DL, BULLET_NUM     ; Load BULLET_NUM value into DL
    ADD DL, 48             ; Convert number to ASCII character
    MOV AH, 2
    INT 21H

    LEA DX, SPACE
    MOV AH, 9
    INT 21H

    ; Restore the stack frame and return
    pop bp
    RET 2                  ; Return and clean up 2 bytes (for the parameter)
SET_BULLETS ENDP

END MAIN
