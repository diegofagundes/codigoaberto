.data
vetor: 
.word 2:valor1		# Cria a matriz na mem�ria com todos os seus elementos iguais a "2"
.text
ori $s6,$zero,valor2	# $s6 = n�mero total de linhas
ori $s7,$zero,valor3	# $s7 = n�mero total de colunas
la $s0,vetor		# $s0 = endere�o base do vetor
move $t0,$zero		# $t0 = contador de linhas (vari�vel "row" do c�digo de alto n�vel)
move $t1,$zero		# $t1 = contador de colunas (vari�vel "col" do c�digo de alto n�vel)
move $s1,$zero		# $s1 = resultado da soma

loop:   mul $t2, $t0, $s7	# $t2 = row * (n�mero de colunas)
	add $t2, $t2, $t1	# $t2 = row * (n�mero de colunas) + col
	sll $t2, $t2, 2		# $t2 � multiplicado por 4
	add $t2, $t2, $s0	# soma o endere�o base do vetor a $t2
	lw $t3, 0($t2)		# l� um elemento da matriz a partir da mem�ria
	add $s1, $s1, $t3	# soma valor da matriz ao acumulador de soma

	addi $t1,$t1,1		# col++
	bne $t1,$s7,loop	# se n�o chegou � �ltima coluna, pula para o loop
	move $t1,$zero		# col = 0
	addi $t0,$t0,1		# row++
	bne $t0,$s6,loop	# se n�o chegou � �ltima linha, pula para o loop
	
# intru��es para finalizar o programa:
li $v0, 10
syscall
       
         
         
         
