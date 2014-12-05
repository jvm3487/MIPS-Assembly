	.globl strsort
	.ent strsort
	.text
strsort:
	# this function should sort an array of strings into
	# ascending order (smallest first)
	# you will do this by modifying the array in memory
	# $a0 is the array of strings (of type char * *)
	# $a1 is the number of strings in that array
	# You should call strcmp(char * s0, char * s1)
	# to compare the strings.  
	#  - It will return a negative number if s0 < s1
	#  - It will return if s0 == s1
	#
	
	
	#STORE S REGISTERS
	#STORE ARGUMENT REGISTERS
	
	addiu $sp, $sp, -32  #make space for 8 words in new frame
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $fp, 28($sp)
	addiu $fp, $sp, 28
	
	
	addi $s5, $a0, 0                  #store pointer to strarray in $s5
	li $s0, 0							#store i=0 in $s0
	addi $s1, $a1, -1  					#store n-1 in $s1
	.L_Outer_Loop:
	bge $s0, $s1, .L_Outer_Loop_End 	#check if i is >= n-1
	li $s3, 0 					#store j=0 in $s3
	sub $s4, $s1, $s0 					#compute new end value for j=n-1-i
	.L_Inner_Loop:
	bge $s3, $s4, .L_Inner_Loop_End		#condition for inner loop branch
	sll $s6, $s3, 2                     #compute offset for jth string
	add $s6, $s5, $s6					#add offset to address of strarray
	lw $a0, 0($s6)						#loading the jth str pointer into $a0
	lw $a1, 4($s6)              		#loading j+1th str pointer into $a1
	jal strcmp
	blez $v0, .L_ENDIF					#see if return value indicates out of order strings
	lw $a0, 0($s6)						#copied these loads because argument registers were trashed
	lw $a1, 4($s6)              		#
	sw $a0, 4($s6)						#if out of order, store back the j and j+1th strings into opposite locations
	sw $a1, 0($s6)
	.L_ENDIF:
	addi $s3, $s3, 1     				#increment j
	b .L_Inner_Loop
	.L_Inner_Loop_End:
	addi $s0, $s0, 1
	b .L_Outer_Loop
	.L_Outer_Loop_End:
	
	
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $fp, 28($sp)
	addiu $sp, $sp, 32
	
	jr $ra
	.end strsort

	
	
# DO NOT EDIT BELOW THIS LINE

.data
stra1:
	.asciiz "a string to come first\n"
stra2:
	.asciiz "better be second\n"
stra3:
	.asciiz "better be third\n"
stra4:
	.asciiz "could be fourth\n"
stra5:
	.asciiz "definitely fifth\n"
stra6:
	.asciiz "definitely sixth\n"
stra7:
	.asciiz "totally seventh\n"
stra8:
	.asciiz "yes, this is last\n"

strb1:
	.asciiz "1\n"
strb2:
	.asciiz "2\n"
strb3:
	.asciiz "3\n"
strb4:
	.asciiz "4\n"
strb5:
	.asciiz "5\n"
colonSpace:
	.asciiz ": "
spcspc:
	.asciiz "  "
strNL:
	.asciiz "\n"
inputMesg:
	.asciiz "Input array: \n"
sortedMesg:
	.asciiz "Sorted array: \n"
calleeSaveFailMesg:
	.asciiz "You failed to save / restore a register properly!\n"
array1:
	.word stra8
	.word stra7
	.word stra4
	.word stra3
	.word stra1
	.word stra5
	.word stra2
	.word stra6

array2:
	.word strb5
	.word strb2
	.word strb1
	.word strb3
	.word strb4

arrays:
	.word array1
	.word array2
	.word 0
lengths:
	.word 8
	.word 5
	.word 0
checkVals:
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
.globl main
.ent main
.text
main: 

	addiu $sp, $sp, -64
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	sw $s5, 28($sp)
	sw $s6, 32($sp)
	sw $s7, 36($sp)
	addiu $fp, $sp, 60

	la $s0, arrays

	la $s1, lengths

.Lmain_lp:
	lw $s2, 0($s0)
	beqz $s2, .Lmain_done
	lw $s3, 0($s1)
# print message
	la $a0, inputMesg
	li $v0, 4
	syscall
	#print array
	move $a0, $s2
	move $a1, $s3
	jal print_array
        la $t0, checkVals
	sw $sp, 0($t0)
	sw $fp, 4($t0)
	sw $s0, 8($t0)
	sw $s1, 12($t0)
	sw $s2, 16($t0)
	sw $s3, 20($t0)
	sw $s4, 24($t0)
	sw $s5, 28($t0)
	sw $s6, 32($t0)
	sw $s7, 36($t0)
	move $a0, $s2
	move $a1, $s3
	jal strsort
	la $t0, checkVals
	lw $t1, 0($t0)
	bne $t1, $sp, .Lmain_calleeSaveFail
	lw $t1, 4($t0)
	bne $t1, $fp, .Lmain_calleeSaveFail
	lw $t1, 8($t0)
	bne $t1, $s0, .Lmain_calleeSaveFail
	lw $t1, 12($t0)
	bne $t1, $s1, .Lmain_calleeSaveFail
	lw $t1, 16($t0)
	bne $t1, $s2, .Lmain_calleeSaveFail
	lw $t1, 20($t0)
	bne $t1, $s3, .Lmain_calleeSaveFail
	lw $t1, 24($t0)
	bne $t1, $s4, .Lmain_calleeSaveFail
	lw $t1, 28($t0)
	bne $t1, $s5, .Lmain_calleeSaveFail
	lw $t1, 32($t0)
	bne $t1, $s6, .Lmain_calleeSaveFail
	lw $t1, 36($t0)
	bne $t1, $s7, .Lmain_calleeSaveFail
	# print message
	la $a0, sortedMesg
	li $v0, 4
	syscall
	#print array
	move $a0, $s2
	move $a1, $s3
	jal print_array
	addiu $s0, $s0, 4
	addiu $s1, $s1, 4
	b .Lmain_lp
.Lmain_done:
	lw $s4, 24($sp)	
	lw $s3, 20($sp)	
	lw $s2, 16($sp)	
	lw $s1, 12($sp)	
	lw $s0, 8($sp)	
	lw $ra, 4($sp)
	lw $fp, 0($sp)
	addiu $sp, $sp, 64
	jr $ra
.Lmain_calleeSaveFail:
	la $a0, calleeSaveFailMesg
	li $v0, 4
	syscall
	li $v0, 10
	syscall
	li $v0, 17
	syscall
	j .Lmain_calleeSaveFail
.end main


.globl strcmp
.ent strcmp
.text
strcmp:	
	# s1 in $a0
	# s2 in $a1
	lbu $t0, 0($a0)
	lbu $t1, 0($a1)
	beqz $t0, .Lstrcmp_s0Done
	beqz $t1, .Lstrcmp_s0Greater
	blt $t0, $t1, .Lstrcmp_s0Less
	bgt $t0, $t1, .Lstrcmp_s0Greater
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	b strcmp
.Lstrcmp_s0Done:
	beqz $t1, .Lstrcmp_stringsEq
.Lstrcmp_s0Less:
	la $v0, -1
	j  .Lstrcmp_ret
.Lstrcmp_s0Greater:	
	li $v0, 1
	j  .Lstrcmp_ret
.Lstrcmp_stringsEq:
	li $v0, 0
.Lstrcmp_ret:
	# Trash all caller saves and argument regs
	# To make sure students obey calling conventions!
        li $a0, 0xbad0
	li $a1, 0xbad1
	li $a2, 0xbad2
	li $a3, 0xbad3
	li $t0, 0xbad4
	li $t1, 0xbad5
	li $t2, 0xbad6
	li $t3, 0xbad7
	li $t4, 0xbad8
	li $t5, 0xbad9
	li $t6, 0xbada
	li $t7, 0xbadb
	li $t8, 0xbadc
	li $t9, 0xbadd		
	jr $ra
	.end strcmp

	.globl print_array
	.ent print_array
	.text
print_array:
	#array pointer in s0
	#length in s1
	addiu $sp, $sp, -32
	sw $fp, 0($sp)
	sw $ra, 4($sp)
	sw $s0, 8($sp)
	sw $s1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	sw $s4, 24($sp)
	addiu $fp, $sp, 28

	move $s0, $a0
	move $s1, $a1
	li $s2, 0
	bge $s2, $s1, .Lpar_end
.Lpar_lp:
	la $a0, spcspc
	li $v0, 4
	syscall
	move $a0, $s2
	li $v0, 1
	syscall
	la $a0, colonSpace
	li $v0, 4
	syscall
	lw $a0, 0($s0)
	li $v0, 4
	syscall
	la $a0, strNL
	li $v0, 4
	syscall
	addiu $s0, $s0, 4
	addiu $s2, $s2, 1
	blt $s2, $s1, .Lpar_lp
.Lpar_end:
	lw $s7, 36($sp)
	lw $s6, 32($sp)
	lw $s5, 28($sp)
	lw $s4, 24($sp)	
	lw $s3, 20($sp)	
	lw $s2, 16($sp)	
	lw $s1, 12($sp)	
	lw $s0, 8($sp)	
	lw $ra, 4($sp)
	lw $fp, 0($sp)
	addiu $sp, $sp, 32
	jr $ra
	.end print_array