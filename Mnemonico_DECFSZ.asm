  #INCLUDE <P18F4550.INC>
; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = HS             ; Oscillator Selection bits (HS oscillator (HS))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOR = ON              ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = OFF          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RB3)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

;***************** MNEMONICO DECFSZ F, D  ****************************
;El presente mnemonico es muy practico, pues podemos afirmar que es una combinacion entre
; los mnemonicos DECF F, D con el registro CPFSEQ, solo que en este caso cambian los datos de comparaci�n
;C�mo as�?... Si bien mantenemos el FILE para compararlo con en el caso anterior que empleamos el CPFSEQ, si no sabes como se 
;emplea el mnemonico mencionado recientemente, mira estos c�gidos en donde lo explico m�s a detalle;
; - https://github.com/FranciscoMotta/Mnemonicos_ASM/blob/master/Mnemonico_CPFSEQ.asm
; - https://github.com/FranciscoMotta/Mnemonicos_ASM/blob/master/Mnemonico_CPFSGT.asm
; - https://github.com/FranciscoMotta/Mnemonicos_ASM/blob/master/Mnemonico_CPFSLT.asm
; Volviendo al mnemonico DECFSZ, el otro dato de comparaci�n es 0, es decir, el registro que se introduce al lado derecho
; del mnemonico (DECFSZ REGISTRO), ser� decrementado constantemente y comparado para ver si hace el salto o no.
; Antes de pasar a la ejecuci�n tenemos que entender el mnemonico. Por una parte, vamos a ver que significa ese mnemonico:
; DECFSZ, proviene del ingles -> DECrement File Skip if it's Zero -> Es decir, decrementar el registro, saltar si este es 0
; Por otra parte, y como se dijo anteriormente, el registro har� 2 acciones en esa conversi�n, saltar o no.
; DECFSZ REGISTRO
; GOTO NO_ES_CERO
; GOTO ES_CERO
;********** RESOLUCI�N ****************
    CBLOCK 0x00
	variablePrueba; Mantenemos nuestra variable para las pruebas 
	varSuma ;Creamos una variable de suma
    ENDC 
    
    ORG 0X000
    GOTO MAIN
    ORG 0X008
    GOTO INT_ALTA_PRIOR 
    ORG 0X018
    GOTO INT_BAJA_PRIOR
    ORG 0X020
MAIN:
    CLRF TRISD ; Movemos el dato 0x00 en TRISD haciendo que sea salida
    CLRF varSuma; Limpiamos el valor inicial de varSuma
START: ; Posici�n en la memoria de programa con el alias START
    MOVLW .15;Movemos un dato literal decimal al registro W
    MOVWF variablePrueba; Luego el dato que est� en W lo movemos hacia variablePrueba
COMPAR:
    DECFSZ variablePrueba, F;Decrementamos a variableCuenta, la guardamos en ella misma y preguntamos si es 0 o no. 
    GOTO NO_ES_CERO; Si no es 0 venimos a esta posici�n de la memoria de programa
    GOTO ES_CERO; De ser 0 venimos a esta posici�n 
NO_ES_CERO:;Posici�n de memoria de programa con el alias NO_ES_CERO
    MOVLW 0X0F; Movemos un dato literal decimal hacia W
    GOTO MOSTRAR; vamos a la posici�n de memoria de programa con el alias MOSTRAR
ES_CERO:; Posici�n de la memoria de programa con el alias ES_CERO
    MOVLW 0XF0;Movemos un dato literal decimal hacia W
    MOVWF LATD; Mostramos el dato cargado por el puerto D
    GOTO START; regresamos a la posici�n de memoria con el ALIAS START para cargar el dato de nuevo y volver a realizar la comparaci�n
MOSTRAR:; Posici�n de memoria de programa con el alias MOSTRAR 
    MOVWF LATD; Movemos a LATD el dato cargado en las posiciones de memoria NO_ES_CERO y ES_CERO
    GOTO COMPAR; Regresamos a decremetar el registro
INT_ALTA_PRIOR:
    RETFIE 
    ORG 0X0F0
INT_BAJA_PRIOR:
    RETFIE 
    END 





