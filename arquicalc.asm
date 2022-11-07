; Laboratorio Arquitectura de Computadoras 2022, Ignacio Araújo

.data  ; Segmento de datos
ENTRADA equ 10
PUERTO_SALIDA_DEFECTO equ 1
PUERTO_LOG_DEFECTO equ 2

puerto_salida dw PUERTO_SALIDA_DEFECTO
puerto_log dw PUERTO_LOG_DEFECTO

stack dw dup(31) 0x0000 ; Declaración e inicialización en cero de la pila
stack_index dw -2 ; Índice actual de la pila, -2 es vacio

.code  ; Segmento de código

while_entrada:
	mov DX, [puerto_log]
	mov AX, 0
	out DX, AX ; Código cero indica que vamos a procesar un nuevo comando

	mov DX, ENTRADA
	in AX, DX
	
	mov DX, [puerto_log]
	out DX, AX ; Dejamos constancia en la bitacora del comando a procesar
	
	cmp AX, 1
	je case_1
	cmp AX, 2
	je case_2
	cmp AX, 3
	je case_3
	cmp AX, 4
	je case_4
	cmp AX, 5
	je case_5
	cmp AX, 6
	je case_6
	cmp AX, 7
	je case_7
	cmp AX, 8
	je case_8
	cmp AX, 9
	je case_9
	cmp AX, 10
	je case_10
	cmp AX, 11
	je case_11
	cmp AX, 12
	je case_12
	cmp AX, 13
	je case_13
	cmp AX, 14
	je case_14
	cmp AX, 15
	je case_15
	cmp AX, 16
	je case_16
	cmp AX, 17
	je case_17
	cmp AX, 18
	je case_18
	cmp AX, 19
	je case_19
	cmp AX, 254
	je case_254
	cmp AX, 255
	je case_255
	jne case_default ; No se cumplió para ningún caso, saltamos al caso default
	

	case_1: ; Comando Num
		mov DX, ENTRADA
		in AX, DX ; Leemos el párametro
		mov BX, [stack_index]
		cmp BX, 60 ; Comparamos con 60, que es el índice máximo que puede tener el stack
		je desborda1

		mov DX, [puerto_log]
		out DX, AX ; Dejamos constancia en la bitacora del parametro
		
		; Hacemos el push
		mov CX, AX ; Pasamos el párametro requerido por CX
		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito		
		
		jmp while_entrada ; Volvemos a iterar

		desborda1:
			mov DX, [puerto_log]
			mov AX, 4
			out DX, AX ; Código cuatro indica que se desbordó la pila
			jmp while_entrada ; Volvemos a iterar

	case_2: ; Comando Port
		mov DX, ENTRADA
		in AX, DX ; Leemos el párametro
		
		mov DX, [puerto_log]
		out DX, AX ; Dejamos constancia en la bitacora del parametro

		mov [puerto_salida], AX	; Asignamos el nuevo valor del puerto de salida

		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito		
		jmp while_entrada ; Volvemos a iterar
	case_3: ; Comando Log
		mov DX, ENTRADA
		in AX, DX ; Leemos el párametro
		
		mov DX, [puerto_log]
		out DX, AX ; Dejamos constancia en la bitacora del parametro

		mov [puerto_log], AX ; Asignamos el nuevo valor del puerto log
		mov DX, [puerto_log] ; Actualizamos el valor de DX 

		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito		
		jmp while_entrada ; Volvemos a iterar
	case_4: ; Comando Top
		call tope_stack
		mov AX, CX
		mov DX, [puerto_salida]
		out DX, AX	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito		
		jmp while_entrada ; Volvemos a iterar
	case_5: ; Comando Dump
		mov BX, [stack_index]
		mov DX, [puerto_salida]
		while_dump:
			cmp BX, -2
			je end_while_dump	
			mov AX, [stack+BX]
			out DX, AX
			sub BX, 2
			jmp while_dump
		end_while_dump:

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_6: ; Comando DUP
		mov BX, [stack_index]
		cmp BX, 60 ; Comparamos con 60, que es el índice máximo que puede tener el stack
		je desborda6
		cmp BX, -2 ; Comparamos con -2, que es el índice que tiene el stack cuando está vacío
		je falta_un_operando

		call tope_stack ; Retorna el tope del stack en CX
		call push_stack ; Agregamos CX al stack
		
		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar

		desborda6:
			mov DX, [puerto_log]
			mov AX, 4
			out DX, AX
			jmp while_entrada ; Volvemos a iterar
	case_7: ; Comando SWAP
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov AX, CX ; Guardamos el primer tope
		call pop_stack ; Lo quitamos
		call tope_stack
		mov BX, CX	; Guardamos el nuevo tope
		call pop_stack 

		mov CX, AX ; Para pasar BX como parametro del push
		call push_stack
		mov CX, BX	
		call push_stack			

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar

	case_8: ; Comando Neg
		mov BX, [stack_index]
		cmp BX, -2 ; El stack está vacío
		je falta_operando8

		call tope_stack
		call pop_stack
		neg CX ; Invertimos bit a bit y sumamos 1 para lograr la negación
		call push_stack ; Guardamos el nuevo valor negado

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar

		falta_operando8:
			mov DX, [puerto_log]
			mov AX, 8
			out DX, AX ; Código ocho indica la falta de operandos
			jmp while_entrada ; Volvemos a iterar
	case_9: ; Comando Fact
		mov BX, [stack_index]
		cmp BX, -2 ; El stack está vacío
		je falta_operando9

		call tope_stack ; Retorna el tope del stack en CX
		mov BX, 0 ; Seteamos en cero porque se utilizará para retornar el resultado de la función factorial
		call fact
		mov CX, BX ; Guardamos en CX el resultado de la función factorial
		call pop_stack ; Quitamos el elemento al cual le aplicamos la función factorial
		call push_stack ; Hacemos push en el stack con el parametro CX, en este caso el resultado de la función factorial		

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar

		falta_operando9:
			mov DX, [puerto_log]
			mov AX, 8
			out DX, AX ; Código ocho indica la falta de operandos
			jmp while_entrada ; Volvemos a iterar
	case_10: ; Comando Sum
		mov CX, 0 ; Resultado suma
		mov BX, [stack_index]
		while_sum:
			cmp BX, -2
			je end_while_sum ; Recorrimos todos los elementos del stack
			mov AX, [stack+BX] ; Accedemos al stack en el índice BX
			add CX, AX
			sub BX, 2
			call pop_stack
			jmp while_sum
		end_while_sum:
				
		call push_stack ; Añade el resultado, en CX, al stack

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_11: ; Comando +
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov BX, CX ; Guardamos el primer tope
		call pop_stack ; Lo quitamos
		call tope_stack
		mov AX, CX	; Guardamos el nuevo tope
		call pop_stack 

		add AX, BX ; Sumamos los operandos
		mov CX, AX ; Para pasar BX como parametro del push
		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_12: ; Comando -
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov BX, CX ; Guardamos el primer tope
		call pop_stack ; Lo quitamos
		call tope_stack
		mov AX, CX	; Guardamos el nuevo tope
		call pop_stack 

		sub AX, BX ; Restamos los operandos
		mov CX, AX ; Para pasar BX como parametro del push
		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_13: ; Comando *
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov BX, CX ; Guardamos el primer tope
		call pop_stack ; Lo quitamos
		call tope_stack
		mov AX, CX	; Guardamos el nuevo tope
		call pop_stack 

		imul BX ; Multiplica AX por BX conservando el signo y guarda el resultado en AX
		mov CX, AX ; Para pasar AX como parametro del push
		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_14: ; Comando /
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov BX, CX ; Guardamos el primer tope
		call pop_stack ; Lo quitamos
		call tope_stack
		mov AX, CX	; Guardamos el nuevo tope
		call pop_stack 
		
		
		; Para el correcto funcionamiento de IDIV necesitamos asignarle al registro DX
		; 0xFFFF en caso del que dividendo (AX) sea negativo, si es positivo necesitamos
		; asignarle 0x0000
		mov DX, 0x0000
		cmp AX, 0
		jl esNegativoDividendo14 ; AX es < 0
		fin_esNegativoDividendo14:

		idiv BX ; Divide AX por BX conservando el signo y guarda el resultado en AX
		mov CX, AX ; Para pasar AX como parametro del push
		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito

		jmp while_entrada ; Volvemos a iterar

		esNegativoDividendo14:
			mov DX, 0xFFFF
			jmp fin_esNegativoDividendo14
	case_15: ; Comando %
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov BX, CX ; Guardamos el primer tope
		call pop_stack ; Lo quitamos
		call tope_stack
		mov AX, CX	; Guardamos el nuevo tope
		call pop_stack 
		
		; Para el correcto funcionamiento de IDIV necesitamos asignarle al registro DX
		; 0xFFFF en caso del que dividendo (AX) sea negativo, si es positivo necesitamos
		; asignarle 0x0000
		mov DX, 0x0000
		cmp AX, 0
		jl esNegativoDividendo15 ; AX es < 0
		fin_esNegativoDividendo15:

		idiv BX ; Divide AX por BX conservando el signo y guarda el módulo en DX
		mov CX, DX ; Pasamos el módulo que está en el registro DX a CX para pasarlo como parametro del push
		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito

		jmp while_entrada ; Volvemos a iterar

		esNegativoDividendo15:
			mov DX, 0xFFFF
			jmp fin_esNegativoDividendo15
	case_16: ; Comando &
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov BX, CX ; Guardamos el primer tope
		call pop_stack ; Lo quitamos
		call tope_stack
		mov AX, CX	; Guardamos el nuevo tope
		call pop_stack 

		and AX, BX ; Sumamos los operandos
		mov CX, AX ; Para pasar BX como parametro del push
		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_17: ; Comando |
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov BX, CX ; Guardamos el primer tope
		call pop_stack ; Lo quitamos
		call tope_stack
		mov AX, CX	; Guardamos el nuevo tope
		call pop_stack 

		or AX, BX ; Sumamos los operandos
		mov CX, AX ; Para pasar BX como parametro del push
		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_18: ; Comando <<
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov AX, CX ; Guardamos el primer tope en AX, el cual será el desplazamiento
		call pop_stack ; Lo quitamos
		call tope_stack
		mov BX, CX ; Guardamos el segundo tope en BX
		call pop_stack 
		; Para usar la instrucción SAL necesitamos que el desplazamiento esté en CL
		mov CX, AX

		; Si hay 16 shifts o más no tiene sentido realizar la operación ya que siempre
		; dará una constante la cual es 0
		cmp CX, 16 
		jge masDe16Shifts18
		
		sal BX, CL ; Desplazamos a BX, CX lugares a la izquierda  
		mov CX, BX ; Guardamos en CX para pasarlo como parametro para hacer push al stack
		jmp end_masDe16Shifts18
		
		masDe16Shifts18:
			mov CX, 0
		end_masDe16Shifts18:

		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_19: ; Comando >>
		mov BX, [stack_index]
		cmp BX, 0
		je falta_un_operando
		cmp BX, -2 ; El stack está vacío
		je faltan_dos_operandos

		call tope_stack
		mov AX, CX ; Guardamos el primer tope en AX, el cual será el desplazamiento
		call pop_stack ; Lo quitamos
		call tope_stack
		mov BX, CX ; Guardamos el segundo tope en BX
		call pop_stack 
		; Para usar la instrucción SAL necesitamos que el desplazamiento esté en CL
		mov CX, AX

		; Si hay 16 shifts o más no tiene sentido realizar la operación ya que siempre
		; dará una constante, 0 si BX es positivo y -1 si es negativo
		cmp CX, 16 
		jge masDe16Shifts19
		
		sar BX, CL ; Desplazamos a BX, CX lugares a la izquierda  
		mov CX, BX ; Guardamos en CX para pasarlo como parametro para hacer push al stack
		jmp end_masDe16Shifts19
		
		masDe16Shifts19:
			cmp BX, 0
			jge esPositivo19
			mov CX, -1 ; Estamos en el caso de que BX sea negativo, de paso guardamos en CX ya que lo
					   ; necesitamos como parametro para hacer push al stack			
			jmp end_masDe16Shifts19

			esPositivo19:
			mov CX, 0
		end_masDe16Shifts19:

		call push_stack	

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_254: ; Comando Clear
		mov BX, [stack_index]
		while_clear:
			cmp BX, -2
			je end_while_clear ; Recorrimos todos los elementos del stack
			sub BX, 2
			call pop_stack
			jmp while_clear
		end_while_clear:

		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	
		jmp while_entrada ; Volvemos a iterar
	case_255: ; Comando Halt
		mov DX, [puerto_log]
		mov AX, 16
		out DX, AX ; Código dieciséis indica que se procesó con éxito	

		Halt:
			jmp Halt; Dejamos el programa en loop
	case_default:
		mov DX, [puerto_log]
		mov AX, 2
		out DX, AX ; Código dos indica que no se reconoce el comando
		jmp while_entrada ; Volvemos a iterar


; Función factorial, recibe el parametro en CX y retorna el resultado en BX
fact proc
	cmp CX, 0 ; Comparo CX con cero
	je es_cero_fact
	dec CX ; Reduzco en uno para realizar de nuevo la invocación
	call fact ; Realizo la llamada recursiva
	inc CX
	mov AX, CX ; Pasamos CX a BX porque mul hará AX*BX
	mul BX ; Paso recursivo
	mov BX, AX ; Asigno el resultado del paso recursivo
	jmp fin_fact
	es_cero_fact:
		mov BX, 1 ; Asigno el paso base
	fin_fact:
		ret
fact endp

; Código común para las operaciones binarias
falta_un_operando:
	call pop_stack; Removemos el elemento del stack y continuamos como si faltaran los 2 operandos
faltan_dos_operandos:
	mov DX, [puerto_log]
	mov AX, 8
	out DX, AX ; Código ocho indica la falta de operandos
	jmp while_entrada ; Volvemos a iterar


push_stack proc ; Agrega CX al stack
	push AX ; Respaldamos AX
	push BX ; Respaldamos BX

	mov BX, [stack_index] ; Guardamos el índice del programa en BX
	add BX, 2
	mov [stack_index], BX ; Aumentamos el índice del stack en 2, para indicar la nueva posición actual del stack
	mov AX, CX ; Movemos a AX el elemento recibido como parametro
	mov [stack+BX], AX ; Guardamos AX (parametro) en el stack

	pop BX ; Reestablecemos AX 
	pop AX ; Reestablecemos BX
	ret
push_stack endp

pop_stack proc ; Borra el elemento en la cima del stack
	push BX ; Respaldamos AX

	mov BX, [stack_index]	
	sub BX, 2
	mov [stack_index], BX

	pop BX ; Reestablecemos BX
	ret
pop_stack endp

tope_stack proc ; Retorna el tope del stack en CX
	push BX ; Respaldamos AX

	mov BX, [stack_index]
	mov CX, [stack+BX]

	pop BX ; Reestablecemos BX
	ret
tope_stack endp

.ports ; Definición de puertos
ENTRADA: 255

.interrupts
