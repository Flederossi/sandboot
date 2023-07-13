bits 16
org 0x7c00


%define BG 0x08				; Color used as background for simulation canvas
%define FG 0x0e				; Color used for the sand particles

%define X1 110				; X-coordinate for the top left point of the simulation canvas
%define Y1 50				; Y-coordinate for the top left point of the simulation canvas
%define X2 210				; X-coordinate for the bottom right point of the simulation canvas
%define Y2 150				; Y-coordinate for the bottom right point of the simulation canvas

%define SX 160				; X-coordinate for the spawn point of the sand particles
%define SY 50				; Y-coordinate for the spawn point of the sand particles


print_info_message:
	mov si, msg			; load the message
	mov ah, 0x0e			; write char mode
	mov al, [si]			; load first char
	print_loop:
		int 0x10		; print character
		inc si
		mov al, [si]		; load next char
		cmp al, 0		; check if end of string
		jne print_loop
	xor ax, ax
	sleep_loop:
		int 0x16		; wait for user input
		cmp al, 0x0d		; check if input is return key
		jne sleep_loop

init_video_mode:
	mov ah, 0x00			; set video mode
	mov al, 0x13			; graphical video mode 13h : 320x200
	int 0x10
	mov bh, 0x00			; draw on page 0

init_draw_bg:
	mov ah, 0x0c			; pixel drawing mode
	mov al, BG			; set color to background color
	mov cx, X2			; set pixel ptr to bottom right corner
	mov dx, Y2
	int 0x10
	mov si, 0x01			; setup reg to check if any sand has moved

draw_bg_new_column:
	dec cx				; move pixel ptr to the next pixel
	cmp cx, X1			; check if pixel ptr hits border -> go to next row
	jl draw_bg_new_row
	int 0x10			; draw bg pixel
	jmp draw_bg_new_column

draw_bg_new_row:
	mov cx, X2			; reset the column of the pixel ptr
	dec dx				; move pixel ptr to the next row
	cmp dx, Y1			; check if whole simulation canvas is drawn (last line) -> go to simulation
	jl add_new_particle
	int 0x10			; draw bg pixel
	jmp draw_bg_new_column

add_new_particle:
	cmp si, 0x00			; check if any sand particle moved (0x00 no particle moved, 0x01 at least one particle)
	je init_draw_bg			; reset everything if no particle moved (no more particles can be spawned)
	mov si, 0x00			; reset the reg
	mov ah, 0x0c			; pixel drawing mode
	mov al, FG
	mov cx, SX
	mov dx, SY
	int 0x10			; draw new sand particle at spawn coordinates

reset_check_ptr:
	mov cx, X2			; reset to pixel ptr to the bottom right edge
	mov dx, Y2

check_pixel:
	mov ah, 0x0d			; mode to get color of specific pixel
	int 0x10
	cmp al, FG			; check if curr pixel of the pixel ptr is sand particle
	je update_particle		; update if pixel is sand particle

check_new_column:
	dec cx				; move the pixel ptr to check every pixel one pixel to the left
	cmp cx, X1			; check if pixel ptr hits border
	jl check_new_row		; jump to next row
	jmp check_pixel

check_new_row:
	mov cx, X2			; reset the column of the pixel ptr
	dec dx				; move the pixel ptr one row up
	cmp dx, Y1			; check if pixel ptr is at top left corner
	jl add_new_particle		; spawn new particle and start check again from bottom right corner
	jmp check_pixel

draw_new_particle_pos:
	mov ah, 0x0c			; pixel drawing mode
	mov al, FG
	int 0x10			; draw the updated sand particle
	mov si, 0x01			; set the reg to check if any sand particle moved to 0x01 (true)
	ret

move_down:
	call draw_new_particle_pos
	dec dx
	jmp check_new_column

move_left:
	call draw_new_particle_pos
	inc cx
	dec dx
	jmp check_new_column

move_right:
	call draw_new_particle_pos
	dec cx
	dec dx
	jmp check_new_column

update_particle:
	mov ah, 0x0c			; pixel drawing mode
	mov al, BG
	int 0x10			; set the sand particle pixel to blank

	mov ah, 0x0d			; pixel check mode

	inc dx				; check pixel down
	int 0x10
	cmp al, BG
	je move_down			; move the sand particle on down if pixel is blank

	dec cx				; check pixel down left
	int 0x10
	cmp al, BG
	je move_left			; move the sand particle down to the left if pixel is blank

	inc cx				; check pixel down right
	inc cx
	int 0x10
	cmp al, BG
	je move_right			; move the sand particle down to the right if pixel is blank

	dec cx
	dec dx
	mov ah, 0x0c			; pixel drawing mode
	mov al, FG
	int 0x10			; set the blank sand particle pixel back to a normal sand particle if no move available
	jmp check_new_column

msg db 13, 10, " < Sandboot 1.0 >", 13, 10, 10, " Start simulation? [Return]", 0

times 510 - ($-$$) db 0
dw 0xaa55				; magical number
