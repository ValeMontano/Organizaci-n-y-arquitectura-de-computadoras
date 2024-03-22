# Valeria Montaño, Daniel Rios
.text
main:
	addi s0, zero, 3	# Numero de discos
	addi s1, s0, -1
	
	# Calculo de offset
	add t6, zero, s0	# Copia Numero de discos
	addi t0, zero, 1	# Iterador
	add t1, zero, zero	# Acumulador (offset)
for:	bge t0, t6, endfor
	addi t1, t1, 32	# Acumulador += 32 bits
	addi t0, t0, 1
	jal for
endfor: nop

	# Inicialización de apuntadores
	lui a0, 0x10010		# Apuntador a punta de torre
	add a1, a0, t1		# Apuntador a base Torre A
	addi a2, a1, 8		# Apuntador a base Torre B
	addi a3, a1, 4		# Apuntador a base Torre C

imprimir_discos:
	slti t0, s0, 1		
	beq t0, zero, while
	addi s0, zero, 3	
	jalr ra
	
while:
	sw s0, 0(a1)		# Almacena valor del disco en apuntador de torre A
	addi a1, a1, -32	# Restamos 32 bits para ir al registro anterior
	addi s0, s0, -1		# Restampos la cantidad de discos por 1
	jal imprimir_discos
	
	nop

hanoi:
	slti t0, s0, 1			# Establece t0 a 1 si el número de discos es menor que 1 (discos < 1)
	bne t0, zero, swap		# Si t0 es diferente de 0 (hay discos para mover), continúa; de lo contrario, salta a mover_disco.
	
	addi sp, sp, -4			# Decrementa el puntero del stack para hacer espacio
	sw ra, 0(sp)			# Guarda el registro ra (dirección de retorno) en el stack

	# Preparación para la primera llamada recursiva: hanoi(discos - 1, inicio, apoyo, destino).
	addi s0, s0, -1			# Decrementa el número de discos
	add a1, zero, a1		# Prepara el registro a1 como 'inicio'
	add t0, zero, a2		# Temporalmente guarda el valor de 'destino' en t0
	add a2, zero, a3		# Prepara el registro a2 como 'destino'
	add a3, zero, t0		# Prepara el registro a3 como 'apoyo'
	jal hanoi			# Realiza la llamada recursiva
	
	# Mueve el disco de la torre de inicio a la torre de destino.
	addi a1, a1, 32			# Ajusta la dirección de la torre de inicio para el siguiente disco	
	lw t1, 0(a1)			# Lee el disco de la posición actual
	sw zero, 0(a1)			# Borra el disco de la posición actual
	sw t1, 0(a2)			# Escribe el disco en la torre de destino
	addi a2, a2, -32		# Ajusta la dirección de la torre de destino para el próximo disco
	
	# Preparación para la segunda llamada recursiva: hanoi(discos - 1, apoyo, destino, inicio).
	add t0, zero, a1		# Temporalmente guarda el valor de 'inicio' en t0
	add a1, zero, a3		# Prepara el registro a1 como 'apoyo' para la próxima llamada
	add a3, zero, a2		# Prepara el registro a3 como 'inicio'
	add a2, zero, t0		# Prepara el registro a2 como 'destino'
	jal hanoi			# Realiza la segunda llamada recursiva
	
	add t0, zero, a1		# Guarda puntero de torre A en t0
	add a1, zero, a2		# Cambia puntero de torre B a torre A
	add a2, zero, t0		# Cambia  puntero de torre A a tirre B
	
	# Restauración del estado y retorno de la función.
	addi s0, s0, 1			# Incrementa el número de discos, preparándose para la siguiente operación
	lw ra, 0(sp)			# Restaura el registro ra del stack
	addi sp, sp, 4			# Incrementa el puntero del stack
	beq s0, s1, exit		# Si el número de discos es igual a s1, salta a 'exit'
	jalr ra				# Retorna de la función
	

swap:
	addi a1, a1, 32		# Mover posición abajo para la torre inicio
	lw t1, 0(a1)		# Leer disco
	sw zero, 0(a1)		# Borrar disco
	sw t1, 0(a3)		# Escribir disco
	addi a3, a3, -32	# Mover posición arriba para la torre destino
	jalr ra
	

exit:
	nop
