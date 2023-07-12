bits 16
org 0x7c00

%define W 159
%define H 99

%define SX 80
%define SY 0

%define BG 0x08
%define FG 0x0e ; 6

; set the graphical video mode
init_video_mode:
	mov ah, 0x00
	mov al, 0x13 ; 320x200
	int 0x10
	mov bh, 0x00

; initialize the drawing of the background
init_draw_bg:
	mov ah, 0x0c
	mov al, BG
	mov cx, W
	mov dx, H
	int 0x10

; shift the pixel pointer to draw bg on column to the right
draw_bg_new_column:
	dec cx
	cmp cx, -1
	je draw_bg_new_row
	int 0x10
	jmp draw_bg_new_column

; shift the pixel pointer to draw bg on row down
draw_bg_new_row:
	mov cx, W
	dec dx
	cmp dx, -1
	je add_new_particle
	int 0x10
	jmp draw_bg_new_column

; add a new sand particle at the top center of the screen
add_new_particle:
	mov ah, 0x0c
	mov al, FG
	mov cx, SX
	mov dx, SY
	int 0x10

; reset the pixel pointer to check every pixel to the down right
reset_check_ptr:
	mov cx, W
	mov dx, H

; checks if pixel ptr is at sand particle
check_pixel:
	mov ah, 0x0d
	int 0x10
	cmp al, FG
	je update_particle

; shift the pixel ptr one column to the left
check_new_column:
	dec cx
	cmp cx, -1
	je check_new_row
	jmp check_pixel

; shift the pixel ptr one row up
check_new_row:
	mov cx, W
	dec dx
	cmp dx, -1
	je add_new_particle
	jmp check_pixel

; procedure to draw the new sand particle pixel
draw_new_particle_pos:
	mov ah, 0x0c
	mov al, FG
	int 0x10
	ret

; move the particle down
move_down:
	call draw_new_particle_pos
	dec dx
	jmp check_new_column

; move the particle down left
move_left:
	call draw_new_particle_pos
	inc cx
	dec dx
	jmp check_new_column

; move the particle down right
move_right:
	call draw_new_particle_pos
	dec cx
	dec dx
	jmp check_new_column

; check where current particle can move to
update_particle:
	mov ah, 0x0c
	mov al, BG
	int 0x10

	mov ah, 0x0d

	inc dx
	int 0x10
	cmp al, BG
	je move_down

	dec cx
	int 0x10
	cmp al, BG
	je move_left

	inc cx
	inc cx
	int 0x10
	cmp al, BG
	je move_right

	dec cx
	dec dx
	mov ah, 0x0c
	mov al, FG
	int 0x10
	jmp check_new_column

times 510 - ($-$$) db 0
dw 0xaa55
