# Exception Handler
# Overflow: ExCode = 12
# Status  $12
# Cause   $13
# EPC     $14


.kdata
save0: .word 0
save1: .word 0
save2: .word 0
save3: .word 0


.ktext 0x80000180	# Reloca o tratador para residir no endere�o emitido pelo HW
 
.set noat		# WORKAROUND PARA O SPIM: permite a escrita de $at no tratador
move  $k1, $at   	# salva $at provisoriamente em $k1
.set at			# WORKAROUND PARA O SPIM: permite a escrita de $at no tratador

# Etapa 1: Salvamento de contexto em mem�ria (pilha n�o pode ser usada)
sw   $ra,save0
sw   $k1,save1 		# salva $at (usando $k1 como intermediario) para viabilizar 
			# o uso de pseudo-instrucao (inclusive esta)  
sw   $t0,save2
sw   $t1,save3



# Etapa 2: Decodifica��o do registrador Cause

####### IMPLEMENTAR!##################################


# Etapa 3: Tratamento de overflow atraves de aritmetica saturada

# WORKAROUND PARA O SPIM
# JUSTIFICATIVA: Para extrair um campo de uma instrucao, voce precisa carrega-la em
#                registrador, mas o SPIM nao permite que uma instrucao lw na area
#                .ktext referencie uma instrucao dentro desse segmento. Por isso, a rotina
#                de tratamento especifico de overflow (_satura) ter� que residir no 
#                segmento .text, mas todo o resto do tratador fica em .ktext. 
#                Por isso, o tratador invoca a rotina _satura. Al�m disso, como
#                as areas .ktext e .text estao muito distantes na memoria, nao se
#                pode usar a instrucao jal. Ao inves dela, usa-se um jalr, passando-se
#                o endereco de retorno como parametro.

la   $k0,_satura	# $k0 = endereco da rotina de tratamento especifico de overflow
jalr $k0		# invoca a rotina de tratamento espec�fico de overflow

# Etapa 4: Preparacao do sistema para novas excecoes

done:

####### IMPLEMENTAR!##################################
  

# Etapa 5: Restauracao de contexto

  lw    $ra,save0  
 .set noat		# WORKAROUND PARA O SPIM: permite a escrita de $at no tratador
  lw    $at,save1 	# restaura $at e n�o $k1
 .set at		# WORKAROUND PARA O SPIM: permite a escrita de $at no tratador
  lw    $t0,save2
  lw    $t1,save3
  		
 
# Etapa 6: Retorno ao fluxo normal de execucao

####### IMPLEMENTAR!##################################
  

.text
# CONTROLE DA SIMULACAO: INICIALIZACAO E TERMINO
.globl __start
__start:
	lw $a0 0($sp)		# argc
	addiu $a1 $sp 4		# argv
	addiu $a2 $a1 4		# envp
	sll $v0 $a0 2
	addu $a2 $a2 $v0
	jal main
	nop

	li $v0 10
	syscall			# syscall 10 (exit)	

# Etapa 3: Tratamento de overflow atraves de aritmetica saturada
_satura:
 
 # carrega a instrucao v�tima de overflow
 mfc0 $k0,$14           
 lw   $k0,0($k0) 		# $k0 = v�tima
 

 # extrai o n�mero do registrador-fonte da v�tima: vitima.rs

 ####### IMPLEMENTAR!################################## 

 
 # determina o conte�do do registrador-fonte da v�tima,
 # editando uma instru��o auxiliar

 ####### IMPLEMENTAR!################################## 

 auxiliar:add $k1,$t0,$zero     # $k1 = operando-fonte da v�tima


 # verifica qual deveria ser o sinal do resultado da operacao se o overflow 
 # nao o tivesse modificado e o satura no valor-limite da faixa apropriado
 slt  $t0,$k1,$zero
 bne  $t0,$zero,_neg           
 _pos:li    $k1,0x7FFFFFFF
 j  _cont
 _neg:lui   $k1,0x8000

_cont: 
# carrega novamente a instrucao v�tima de overflow
 mfc0 $k0,$14           
 lw   $k0,0($k0) 		# $k0 = v�tima

# isola o n�mero do registrador destino: vitima.rd
andi $t0,$k0,0xf800 

 # grava o valor saturado no registrador-destino da v�tima,
 # editando uma instru��o corretiva
 
 ####### IMPLEMENTAR!################################## 
 
 corretiva: add $t0,$zero,$k1	# registrador-destino da v�tima = valor saturado

 
 # retorna � rotina geral do tratador que invocou
 # esta rotina de tratamento espec�fico
 jr $ra

