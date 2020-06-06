;Primera directiva de manejo de bytes 
;************ ADDWF F,D,A ********************
;    MOVLW .30 ;Movemos un dato literal al registro de trabajo W
;    MOVWF 0X20; Almacenamos el valor de W en direcci�n 0x20
;    MOVLW .12; Movemos el dato literal al registro de trabajo
;    ADDWF 0X20, F, 0; Tenemos 30 en la direcci�n 0x20 y tenemos 
    ; 12 en el registro de trabajo y los sumamos.
    ; 30 + 12 = 42, el dato resultante se guarda en la direcci�n
    ;Absoluta 0x20
;*********** EJEMPLOS *****************
    CBLOCK 0X00 ; Creamos un bloque para las variables que vamos a usar
        primeraVariable ; Creamos una variable en 0x001 
	segundaVariable ; Creamos una variable en 0x002
    ENDC 
    ORG 0X0000
    GOTO MAIN 
    ORG 0X0008 ; Definimos el vector para la rutina de servicio a las interrupciones de alta prior
    GOTO ALTA_PRIOR ; Damos un alias a ese vector 
    ORG 0X0018 ; Definimos el vector para las baja prioridad
    GOTO BAJA_PRIOR ; Damos el alias 
    ORG 0X0020 ;Elegimos la posicion 0x0020 para la rutina principal
MAIN:
    MOVLW .12 ; Movemos el dato literal al registro W
    MOVWF primeraVariable; Movemos el dato a la varaible respectiva
    MOVLW .11 ;Movemos el dato literal al registro E
    ADDWF primeraVariable, F, 0; Sumamos el valor de W
    ;con el valor de la primera variable y se guarda en ella misma
    MOVLW .14 ; Movemos el dato literal hacia W 
    ADDWF primeraVariable, F, 0; Sumamos el dato de W con el valor
    ;de la suma anterior que ten�a primeraVariable
    ;*********** RESUMEN **************
;     ; W = 12
;       W > primeraVariable -> primeraVariable = 12 
;       W = 11
;       primeraVariable = primeraVariable(12) + W (11)
;       primeraVariable = 23
;       W = 14 
;       primeraVariable = primeraVariable(23) + W(14)
;       primeraVariable = 37 
;       ENTENDER ESTA DIRECTIVA ES TRATAR DE ENTENDER M�S A FONDO
;       LA SINTAXIS PROPIA DEL LENGUAJE ASM. POR UNA PARTE, 
;       SE DEBE ENTENDER EL FUNCIONAMIENTO DEL MNEM�NICO ADDWF F,D,A
;       ADDWF SIGNIFICA SUMAR EL VALOR DE W CON EL VALOR QUE TENGA
;       UN DETERMINADO FILE F, QUE PUEDE SER UNA VARIABLE, 
;       DIRECCI�N EN LA MEMORIA DE DATOS O UN OPERANDO(PUERTOS).
;       ANTES DE LA PRIMERA COMA SE OBSERVA UN "F" 
;       EL CUAL HACE REFERENCIA AL FILE QUE SE VA A SUMAR CON "W"
;       POR EJEMPLO:
;       ADDWF PORTX = SUMAR A W LO QUE EST� EN EL PUERTO X
;       ADDWF 0X20 = SUMAR A W EL VALOR GUARDADO EN LA DIRECCI�N 0X20
;       ADDWF VAR = SUMAR A W EL VALOR QUE TENGA VAR
;       A LA DERECHA DE LA PRIMERA COMA SE PUEDE VER UN "D", QUE 
;       HACE REFERENCIA A LA DIRECCI�N DE GUARDADO DEL RESULTADO DE LA SUMA
;       EN OTRAS PALABRAS, DONDE SE VA A GUARDAR EL RESULTADO. 
;       EJEMPLO:
;       ADDWF PORTB, W = SE VA A SUMAR W CON EL VALOR DE PORTB Y SE VA A GUARDAR EL VALOR EN EL REGISTRO W
;       ADDWF VAR, F = SE VA A SUMAR W CON VAR Y SE VA A GUARDAR EN VAR
;       ES NECESARIO PRECISAR QUE, EN RESUMIDAS CUENTAS, SI COLOCAS W SE VA A GUARDAR EN W Y SI COLOCAS F
;       SE VA A GUARDAR EN EL OPERANDO O DIRECCI�N DE MEMORIA QUE USES.
;       POR ULTIMO, VEMOS AL FINAL UN A, QUE HACE REFERENCIA A LA FORMA DE GUARDADO, SI SER� ABSOLUTA O RELATIVA 
;       AL SRAM (PUEDE SER NO USADO PERO SE RECOMIENDA HACERLO PARA MANTENER LAS BUENAS PRACTICAS)
;    */ 
    ORG 0X0C0
ALTA_PRIOR:
    RETFIE 
    ORG 0X0D0
BAJA_PRIOR:
    RETFIE
    END 
;***********************EJEMPLO 2: SUMAR EL VALOR DEL PORTB CON W Y SE MUERTRA POR EL PORTD***************************
    CBLOCK
    aux ; Creamos una variable auxiliar por si acaso
    END
    ORG 0X0000
    GOTO MAIN
    ORG 0X0020
MAIN:
    SETF TRISB; MOVEMOS 0XFF HACIA EL TRISB, HACIENDO QUE SEA DEFINIDO COMO ENTRADA
    CLRF TRISD; MOVEMOS 0X00 HACIA EL TRISDM DEFINIDO COMO SALIDA 
START:
    MOVLW .10 ;MOVEMOS .10 AL REGISTRO W
    ADDWF PORTB, W; SUMAMOS EL VALOR LE�DO EN EL PUERTO B CON EL 10 QUE ESTA EN W, Y SE GUARDA EN W 
    MOVWF LATD ; EN VALOR DE LA SUMA QUE ESTA EN W LO MOVEMOS HACIA EL LATD PARA SER MOSTRADO 
    GOTO START; VOLVEMOS A LA DIRECCION DE MEMORIA CON EL ALIAS START;
    END 
    
    
    

