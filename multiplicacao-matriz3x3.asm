.data 
	mat1: .space 36			# alocando espaco para as matrizes
	mat2: .space 36
	res:  .space 36
	newline: .ascii "\n"
.text

main: 
    sw $s0 -4($sp)			# alocando registradores salvos na pilha
    sw $s1 -8($sp)
    sw $s2 -12($sp)
    sw $s3 -16($sp)
    sw $s4 -20($sp)
    sw $s5 -24($sp)
    sw $s6 -28($sp)
    sw $s7 -32($sp)

	la $s0, mat1
	la $s1, mat2
	la $s2, res

	addi $a0, $s0, 0
	addi $a1, $s1, 0
	addi $a2, $zero, 0
	addi $a3, $zero, 1

	jal insere				# populando as matrizes
	addi $a2, $zero, 16
	jal insere
	addi $a2, $zero, 32
	jal insere
	addi $a3, $0, 2
	addi $a2, $zero, 4
	jal insere
	addi $a2, $zero, 8
	jal insere
	addi $a2, $zero, 12
	jal insere
	addi $a2, $zero, 20
	jal insere
	addi $a2, $zero, 24
	jal insere
	addi $a2, $zero, 28
	jal insere
	
    addi $s3, $zero, 3
	addi $s4, $zero, 0      # i  
	j for_1

restaurando:
    lw $s0 -4($sp)     		# restaurando salvos
    lw $s1 -8($sp)
    lw $s2 -12($sp)
    lw $s3 -16($sp)
    lw $s4 -20($sp)
    lw $s5 -24($sp)
    lw $s6 -28($sp)
    lw $s7 -32($sp)
    j fim

insere: 
	add $t3, $zero, $a2
	add $a2, $a2, $a0 
	sw $a3, 0($a2)
    
	add $t3, $t3, $a1
	sw $a3, 0($t3)
	jr $ra

for_1:
	slt $t0, $s4, $s3
	beq $t0, $zero, print_for_1
	addi $s5, $zero, 0      # j
	j for_2
fim_for_1:
    addi $s4, $s4, 1        # incrementa i
	j for_1

for_2:
	slt $t2, $s5, $s3
	beq $t2, $zero, fim_for_1
	sll $t3, $s3, 2         # colTotal*4
	mul $t3, $t3, $s4
	sll $t4, $s5, 2
	add $s6, $t3, $t4       # indice ij

	add $s6, $s6, $s2       # endereco ij de res 
	sw $zero, 0($s6)
	addi $s7, $zero, 0      # k
	j for_3
fim_for_2:
    addi $s5, $s5, 1        # incrementa j
	j for_2

for_3:
    slt $t4, $s7, $s3
    beq $t4, $zero, fim_for_2
    sll $t5, $s3, 2
    mul $t5, $t5, $s4       # totalCol * 4 * i
    sll $t6, $s7, 2         # k * 4
    add $t6, $t6, $t5       # indice ik

    add $t6, $t6, $s0
    lw $t5, 0($t6)          # conteudo de mat1[i][k]

    sll $t7, $s3, 2
    mul $t7, $t7, $s7       # totalCol * 4 * k 
    sll $t8, $s5, 2         # j * 4
    add $t7, $t7, $t8       # indice jk

    add $t7, $t7, $s1
    lw $t8, 0($t7)          # conteudo de mat2[k][j]

    mul $t5, $t5, $t8
    lw $t9, 0($s6)          # restaura conteudo de res[i][j]
    add $t9, $t9, $t5       # incrementa res[i][j]

    sw $t9, 0($s6)

    addi $s7, $s7, 1
    j for_3

print_for_1:
    addi $s4, $zero, 0
loop:
    slt $t0, $s4, $s3
	beq $t0, $zero, restaurando
	addi $s5, $zero, 0      # j
	j print_for_2
fim_print_for_1:
    addi $s4, $s4, 1        # incrementa i
    li $v0, 4
    la $a0, newline 		# quebra de linha
    syscall
	j loop

print_for_2:
	slt $t2, $s5, $s3
	beq $t2, $zero, fim_print_for_1
	sll $t3, $s3, 2         # colTotal*4
	mul $t3, $t3, $s4
	sll $t4, $s5, 2
	add $s6, $t3, $t4       # indice ij

	add $s6, $s6, $s2       # endereco ij de res 
    lw $t5, 0($s6)

    li $v0, 1			    # imprimindo propriamente dito
    addi $a0, $t5, 0
    syscall
    li $a0, 32              # espaco 
    li $v0, 11
    syscall

fim_print_for_2:
    addi $s5, $s5, 1        # incrementa j
	j print_for_2

fim:
	li $v0, 10
	syscall