.arm
.align 2

.extern beeBitmap
.extern beePal

.extern beeBitmapLength
.extern beePalLength

@Params:
@ r0 - Palette address
@ r1 - Palette length
@Locals:
@ r2 - Palette VRAM
@ r3 - Scratch
CopyPalette:
	mov r2, #0x05000000
BytesLeftToCopy:
	ldrh r3, [r0], #2
	strh r3, [r2], #2
	subs r1, r1, #2
	bne BytesLeftToCopy
	bx lr

@Params:
@ r0 - Data address
@ r1 - Data length
@Locals:
@ r2 - Video RAM
@ r3 - Scratch
CopyData:
	mov r2, #0x06000000
DataLeftToCopy:
	ldr r3, [r0], #4
	str r3, [r2], #4
	subs r1, r1, #4
	bne DataLeftToCopy
	bx lr

.global main
main:
	ldr r0, =beePal
	ldr r1, =beePalLength
	ldr r1, [r1]

	bl CopyPalette

	ldr r0, =beeBitmap
	ldr r1, =beeBitmapLength
	ldr r1, [r1]

	bl CopyData

	mov r0, #0x04000000 @REG_DISPCNT
	ldr r1, =0x404 @Mode 4, BG2 ON
	strh r1, [r0] 
loop:
	b loop

