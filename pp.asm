[org 0x0100]
jmp start

lengthPl: dw 5
counter: dd 0
gameName: db 'Ping Pong Game'
creater: db 'Members:'
studentName:db 'M.Tayyab (23F-3058) and M.Ali (23F-3016)'
menu: db 'Game Menu:' 
players: db 'Player 1 is on  Left side    Player 2  is on Right side '
menu1: db '1.Pressing w will move the player1 upward. and pressing  s will move downward'
menu2: db '2.Pressing o will move the player2 upward. and pressing  k will move downward' 
menu3: db '3.Whenever a  any player score 6 point that palyer will Win.' 
menu4: db '4.If the ball touches left side of screen then score of P2 increase. ' 
menu5: db '5.If the ball touches right side of screen then score of P1 increase.' 
player1: db 'Congartulation! Player 1 Wins.' ;
player2: db 'Congartulation! Player 2 Wins.' 
gameOver: db 'Thanks for playing . Program is shutting down (*+*)'
score: db 'Score: ' 
press: db 'Press Enter to start...' 
scoreP1: db 'Player 1 Score: ' 
scoreP2: db 'Player 2 Score: '
score1: dw 0
score2: dw 0
win: dw 0
change_key : dw 0
background_n : dw 224; this is startint of print backGround
; Sub-Routine to clear the screen
clrscr: push es
push ax
push cx
push di
mov ax, 0xb800
mov es, ax
xor di, di
mov cx, 2000
mov ax, 0x0720

cld
rep STOSW

pop di
pop cx
pop ax
pop es
ret
printscore_onscreen:
    push ax
    push di
    push si
    
    mov ax, 0xb800
    mov es, ax

    ; Print score1 at position 20
    mov si, score1
    mov ax, [si]
    add al, '0'       ; Convert to ASCII
    mov ah, 0x0f      ; Attribute
    mov di, 20        ; Screen offset
    mov [es:di], ax

    ; Print score2 at position 120
    mov si, score2
    mov ax, [si]
    add al, '0'       ; Convert to ASCII
    mov ah, 0x0f
    mov di, 120
    mov [es:di], ax

    pop si
    pop di
    pop ax
    ret

; Sub-Routine to print border on the screen
border:
 push bp
mov bp, sp
sub sp, 4
mov word[bp-2], 0 ; Left Vertical Border
mov word[bp-4], 158 ; Right Vertical Border
push ax
push di
push es
mov ax, 0xb800
mov es, ax

mov ax, 0x74B2 ;;color of the borders

vertical:
 mov di, word[bp-2]
mov [es:di], ax
add word[bp-2], 160
mov di, word[bp-4]
mov [es:di], ax
add word[bp-4], 160
cmp word[bp-2], 4000
jne vertical

pop es
pop di
pop cx
pop ax
mov sp, bp
pop bp
ret

; Checking if the ball has touched the right side of grid
rightCollisionCheck:
cmp dx, si
je rightCollisionTrue
add dx, 160
cmp dx, 4000
jl rightCollisionCheck
ret

rightCollisionTrue:
inc word[score1]
cmp word[score1],3
jne skip2
mov word[win],1
jmp gameOverr
skip2:
 jmp BallresetPlayer2;


; Checking if the ball has touched the left side of grid
leftCollisionCheck:
cmp dx, si
je leftCollisionTrue
add dx, 160
cmp dx, 4000
jl leftCollisionCheck
ret

leftCollisionTrue:
inc word[score2]
cmp word[score2],3
jne skip1
mov word[win],0
jmp gameOverr
skip1:
jmp BallresetPlayer1


moveBallStraightPLayer1:
push ax
push si
push dx;;;;;;;;;;;;;;;;;;;
mov ax,0x0720
mov si, word[bp-10]
mov [es:si], ax
add word[bp-10], 2
mov si, word[bp-10]

call checkPlayer2HitsBall
mov dx, 158
call rightCollisionCheck

mov ax, 0x0f09
mov [es:si], ax

pop dx
pop si
pop ax
ret
moveBallStraightPLayer2:
push ax
push si
push dx

mov ax,0x0720
mov si, word[bp-10]
mov [es:si], ax
sub word[bp-10], 2
mov si, word[bp-10]

call checkPlayer1HitsBall
mov dx, 0
call leftCollisionCheck

mov ax, 0x0f09
mov [es:si], ax

pop dx
pop si
pop ax
ret

moveBallDiagonallyUpPlayer1:
push ax
push si
push dx
mov ax,0x0720
mov si, word[bp-10]
mov [es:si], ax
sub word[bp-10], 158
mov si, word[bp-10]

call checkPlayer2HitsBall
mov dx, 158
call rightCollisionCheck

mov ax, 0x0f09;;;;;;;;;;;;;;;;
mov [es:si], ax

pop dx
pop si
pop ax
ret

moveBallDiagonallyUpPlayer2:
push ax
push si
push dx

mov ax,0x0720
mov si, word[bp-10]
mov [es:si], ax
sub word[bp-10], 162
mov si, word[bp-10]

call checkPlayer1HitsBall
mov dx, 0
call leftCollisionCheck

mov ax, 0x0f09;;;;;;;;;;;;;;
mov [es:si], ax

pop dx
pop si
pop ax
ret
BallresetPlayer2:
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
sub word[bp-10], 156
jmp ballMovementDiagonallyDownP1,;;;;;;;;;;;;;

BallresetPlayer1:
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
 add  word[bp-10], 2
jmp ballMovementDiagonallyUpP1



moveBallDiagonallyDownPlayer1:
push ax
push si
push dx

mov ax,0x0720
mov si, word[bp-10]
mov [es:si], ax
add word[bp-10], 162
mov si, word[bp-10]

call checkPlayer2HitsBall
mov dx, 158
call rightCollisionCheck

mov ax, 0x0f09
mov [es:si], ax

pop dx
pop si
pop ax
ret

moveBallDiagonallyDownPlayer2:
push ax
push si
push dx

mov ax,0x0720
mov si, word[bp-10]
mov [es:si], ax
add word[bp-10], 158
mov si, word[bp-10]

call checkPlayer1HitsBall
mov dx, 0
call leftCollisionCheck

mov ax, 0x0f09
mov [es:si], ax

pop dx
pop si
pop ax
ret

; printing game over on screen along with which player wins and there scores
gameOverr: 
call clrscr
mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 7

mov dx, 0x0301
mov cx, 16
push cs
pop es
mov bp, scoreP1
int 0x10

mov dx, 0x0501
mov cx, 16
push cs
pop es
mov bp, scoreP2
int 0x10

mov dx, 0x0112
push cs
pop es
mov cx, 30

cmp word[win], 1
je p1Win
jmp p2Win

p1Win: mov bp, player1
jmp printP

p2Win: mov bp, player2


printP: int 0x10
jmp printScore

printScore: mov dx, 516;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
push dx
mov dx, [score1]
push dx
call printNum

mov dx, 836
push dx
mov dx, [score2]
push dx
call printNum
push ax
mov ah,0x1
int 0x21
pop ax
call clrscr
mov dx, 0x0415
mov cx, 51
push cs
pop es
mov bp, gameOver
int 0x10

mov ax, 0x4c00
int 0x21

; Printing the score of both players
printNum: push bp
mov  bp, sp
push es
push ax
push bx
push cx
push dx
push di

mov ax, [bp+4]  
mov bx, 10      
mov cx, 0        
 
nextdigit: mov dx, 0    
div bx      
add dl, 0x30
push dx      
inc cx      
cmp ax, 0    
jnz nextdigit

mov ax, 0xb800
mov es, ax
mov di, [bp+6]
   
nextpos:    pop dx          
mov dh, 0x03    
mov [es:di], dx
add di, 2
loop nextpos    

pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 8

; Delaying movement of players
delay: mov dword[counter], 100000

incCounter: dec dword[counter]
cmp dword[counter],0
jne  incCounter
ret

; Sub-Routine of PingPong Game
game:
 push bp
mov bp, sp
sub sp, 10
;; making local variables
mov word[bp-2], 2 ; First player
mov word[bp-4], 156 ; Second Player
mov word[bp-6], 0 ; Last Position of player 1
mov word[bp-8], 0 ; Last Position of player 2
mov word[bp-10], 644 ; Ball position
push es
push ax
push bx
push cx
push dx
push si
push di
mov ax, 0xb800
mov es, ax

mov si, word[bp-2] ; Load player 1 starting position
mov di, word[bp-4] ; Load player 2 starting position
mov cx, word[bp+4] ; Load player length
mov ax, 0x4700 ;; color of the paddels

; Printing both players
printPlayer:
mov [es:si], ax ; PLayer 1
mov [es:di], ax ; PLayer 2
mov word[bp-6], si
mov word[bp-8], di
add si, 160
add di, 160
loop printPlayer

; Printing ball
mov si, word[bp-10]
mov ax, 0x4700
mov [es:si], ax

; Call ball movements here
call ballMovementDiagonallyDown1

;End Program
endG: pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop es
mov sp, bp
pop bp
ret 2

; Ball movement Diagonally Down when player 1 hits the ball
ballMovementDiagonallyDown1:
call moveBallDiagonallyDownPlayer1

call delay

add si, 162

call inputP1
cmp si, 4000
jl ballMovementDiagonallyDown1

ballMovementDiagonallyUp1:
call moveBallDiagonallyUpPlayer1
call delay


sub si, 158

call inputP1
cmp si, 0
jg ballMovementDiagonallyUp1
jmp ballMovementDiagonallyDown1

; Ball movement Diagonally Up when player 1 hits the ball
ballMovementDiagonallyUpP1:
call moveBallDiagonallyUpPlayer1

call delay

sub si, 158


call printscore_onscreen
call border

call inputP1
cmp si, 0
jg ballMovementDiagonallyUpP1

ballMovementDiagonallyDownP1:
call moveBallDiagonallyDownPlayer1
call delay

add si, 162

call printscore_onscreen
call border
call inputP1
cmp si, 4000
jl ballMovementDiagonallyDownP1
jmp ballMovementDiagonallyUpP1

; Ball movement Diagonally Up when player 2 hits the ball
ballMovementDiagonallyUpP2:
call moveBallDiagonallyUpPlayer2
call delay

sub si, 162


call printscore_onscreen
call border

call inputP1
cmp si, 0
jg ballMovementDiagonallyUpP2

ballMovementDiagonallyDownP2:
call moveBallDiagonallyDownPlayer2
call delay

add si, 158


call printscore_onscreen
call border
call inputP1
cmp si, 4000
jl ballMovementDiagonallyDownP2
jmp ballMovementDiagonallyUpP2

; Ball movement Straight when player 1 hits the ball
ballMovementStraight1:
call moveBallStraightPLayer1
call delay

add si, 2


call printscore_onscreen
call border
call inputP1
jmp ballMovementStraight1

; Ball movement Straight when player 2 hits the ball
ballMovementStraight2:
call moveBallStraightPLayer2
call delay

sub si, 2


call printscore_onscreen
call border
call inputP1
jmp ballMovementStraight2

; Ball movement Diagonally Down when player 2 hits the ball
ballMovementDiagonallyDown2:
call moveBallDiagonallyDownPlayer2
call delay

add si, 158


call printscore_onscreen
call border
call inputP1
cmp si, 4000
jl ballMovementDiagonallyDown2

ballMovementDiagonallyUp2:
call moveBallDiagonallyUpPlayer2
call delay

sub si, 162


call printscore_onscreen
call border
call inputP1
cmp si, 0
jg ballMovementDiagonallyUp2
jmp ballMovementDiagonallyDown2

; Checking if player 2 hits the ball
checkPlayer2HitsBall:
push bx
push si

mov bx, word[bp-4]
cmp si, bx
jne secondP2
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp ballMovementDiagonallyUpP2

secondP2: add bx, 160
cmp si, bx
jne thirdP2
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp ballMovementDiagonallyUpP2

thirdP2: add bx, 160
cmp si, bx
jne forthP2
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp ballMovementStraight2

forthP2: add bx, 160
cmp si, bx
jne fifthP2
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp ballMovementDiagonallyDown2

fifthP2: add bx, 160
cmp si, bx
jne hitP2exit
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
sub word[bp-10], 2
jmp ballMovementDiagonallyDown2

hitP2exit: pop si
pop bx
ret

; Checking if player 1 hits the ball
checkPlayer1HitsBall:
push bx
push si

mov bx, word[bp-2]
cmp si, bx
jne secondP1
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp ballMovementDiagonallyUpP1

secondP1 add bx, 160
cmp si, bx
jne thirdP1
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp ballMovementDiagonallyUpP1

thirdP1 add bx, 160
cmp si, bx
jne forthP1
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp ballMovementStraight1

forthP1: add bx, 160
cmp si, bx
jne fifthP1
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp ballMovementDiagonallyDown1

fifthP1 add bx, 160
cmp si, bx
jne hitP1exit
push ax
mov ax, 0x4700
mov [es:si], ax
pop ax
add word[bp-10], 2
jmp ballMovementDiagonallyDown1

hitP1exit: pop si
pop bx
ret

; Movement of player 1 Downward
movePlayer1Down:
push ax
push si

mov si, word[bp-6]
add si, 160
cmp si, 4000
jg exitP1Down
add word[bp-6], 160
mov ax, 0x4700
mov [es:si], ax
mov si, word[bp-2]
mov ax, 0x0720
mov [es:si], ax
add word[bp-2], 160

exitP1Down:
 pop si
pop ax
ret

; Movement of player 1 Upward
movePlayer1Up:
push ax
push si

mov si, word[bp-2]
sub si, 160
cmp si, 0
jl exitP1Up
sub word[bp-2], 160
mov ax, 0x4700
mov [es:si], ax
mov si, word[bp-6]
mov ax,0x0720
mov [es:si], ax
sub word[bp-6], 160

exitP1Up: pop si
pop ax
ret

; Movement of player 2 Downward
movePlayer2Down:
push es
push ax
push si

mov ax, 0xb800
mov es, ax

mov si, word[bp-8]
add si, 160
cmp si, 4000
jg exitP2Down
add word[bp-8], 160
mov ax, 0x4700
mov [es:si], ax
mov si, word[bp-4]
mov ax, 0x0720
mov [es:si], ax
add word[bp-4], 160

exitP2Down: pop si
pop ax
pop es
ret
change_background:
push es
push ax
cmp word[change_key],0
je make_blue;0x1
cmp word[change_key],2
je make_cyan; 0x3
cmp word[change_key],1
je make_green;0x2
;; other wise make black
push 224
call  printb
call border
mov word[change_key],0
jmp escape
make_blue:
 push bp
mov bp,sp
push ax
push di
mov di,224
push cx
mov ax,0xb800
mov es,ax
mov ax ,0x01F7 ; wave Ascci
mov cx,10
looop3:
push di
lp3:
mov [es:di],ax
add di,360
cmp di,3840
jb lp3
pop di 
add di,6
loop looop3
add word[change_key],1
pop cx
pop di
pop ax
pop bp
jmp escape
make_cyan:
 push bp
mov bp,sp
push ax
push di
mov di,224
push cx
mov ax,0xb800
mov es,ax
mov ax ,0x03F7 ; wave Ascci
mov cx,10
looop4:
push di
lp4:
mov [es:di],ax
add di,360
cmp di,3840
jb lp4
pop di 
add di,6
loop looop4
add word[change_key],1
pop cx
pop di
pop ax
pop bp
jmp escape
make_green: 
push bp
mov bp,sp
push ax
push di
mov di,224
push cx
mov ax,0xb800
mov es,ax
mov ax ,0x02F7 ; wave Ascci
mov cx,10
looop5:
push di
lp5
mov [es:di],ax
add di,360
cmp di,3840
jb lp5
pop di 
add di,6
loop looop5
add word[change_key],1
pop cx
pop di
pop ax
pop bp
escape:
 pop ax
 pop  es
ret
; Movement of player 2 Upward
movePlayer2Up:
push ax
push si

mov si, word[bp-4]
sub si, 160
cmp si, 0
jl exitP2Up
sub word[bp-4], 160
mov ax, 0x4700
mov [es:si], ax
mov si, word[bp-8]
mov ax,0x0720
mov [es:si], ax
sub word[bp-8], 160

exitP2Up: pop si
pop ax
ret

; Taking input from player 1 controls
inputP1: ;push ax
;push dx

mov ah, 1 ;; check key press or not 
int 0x16
jz exitInputP1

mov ah, 0 ;; read Key
int 0x16

; AH = BIOS scan code
cmp al, 'w'
je movePlayer1Up
cmp al, 's'
je movePlayer1Down
cmp al, 'o'
je movePlayer2Up
cmp al, 'k'
je movePlayer2Down
cmp al,'c'
je change_background
call border
push word[background_n]
call printb
cmp ah, 01
je gameOverr

exitInputP1:
ret

; Taking input from player 2 controls
inputP2:

ret

; Welcome screen
intro: mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0xf
mov dx, 0x0419
mov cx, 14
push cs
pop es
mov bp, gameName
int 0x10

mov bl,0x7
mov dx, 0x0801
mov cx, 8
push cs
pop es
mov bp, creater
int 0x10

mov dx, 0x080A
mov cx, 40
push cs
pop es
mov bp, studentName
int 0x10

mov ah, 01
int 0x21
ret

; Displaying Game Menu/Instructions
gameMenu:
 mov ah, 0x13
mov al, 1
mov bh, 0
mov bl, 0xf ;; bright white colore
mov dx, 0x0101
mov cx, 10
push cs
pop es
mov bp, menu
int 0x10

mov bl, 0x7
mov dx, 0x0301
mov cx, 51
push cs
pop es
mov bp, players
int 0x10

mov dx, 0x0501
mov cx, 77
push cs
pop es
mov bp, menu1
int 0x10

mov dx, 0x0701
mov cx, 77
push cs
pop es
mov bp, menu2
int 0x10

mov dx, 0x0901
mov cx, 59
push cs
pop es
mov bp, menu3
int 0x10

mov dx, 0x0b01
mov cx, 67
push cs
pop es
mov bp, menu4
int 0x10

mov dx, 0x0d01
mov cx, 68
push cs
pop es
mov bp, menu5
int 0x10

mov dx, 0x0f01
mov cx, 23
push cs
pop es
mov bp, press
int 0x10

mov ah, 01
int 0x21
ret
printb :
push bp
mov bp,sp
push ax
push di
mov di,[bp+4]
push cx
mov ax,0xb800
mov es,ax
mov ax ,0x07F7 ; wave Ascci
mov cx,10
looop1:
push di
lp1:
mov [es:di],ax
add di,360
cmp di,3840
jb lp1
pop di 
add di,6
loop looop1
pop cx
pop di
pop ax
pop bp
ret 2
clearprintb :
push bp
mov bp,sp
push ax
push di
mov di,[bp+4]
add word[background_n],4
push cx
mov ax,0xb800
mov es,ax
mov ax ,0x0720 ; wave Ascci
mov cx,10
looop2:
push di
lp2:
mov [es:di],ax
add di,360
cmp di,3840
jb lp2
pop di 
add di,6
loop looop2
cmp di,288
jne skip
mov word[background_n],224;;reset it 
skip:
pop cx
pop di
pop ax
pop bp
ret 2
 graphics:
        call clrscr
call border
mov ax, 80 ; Starting position of printing line between two players

ret
start: call clrscr ; call the clrscr subroutine
call intro
call clrscr

call gameMenu
call printscore_onscreen;
call graphics
push word[background_n]
call printb
call border

push word [lengthPl]
call game

mov ax, 0x4c00 ; terminate program
int 0x21