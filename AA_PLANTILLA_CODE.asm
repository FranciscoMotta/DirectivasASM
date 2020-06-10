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

;***************** PLANTILLA DE C�DIGO VACIO *********************
;********** RESOLUCI�N ****************
    CBLOCK 0x00
	variablePrueba; Mantenemos nuestra variable para las pruebas 
	varSuma ;Creamos una variable de suma
    ENDC 
    
    ORG 0X000
    GOTO MAIN;Creamos un alias para la posicion 0x000 de la memoria de programa 
    ;Esto nos redirige al MAIN, y es a donde apunta el PC cuando se reinicia el microcontrolador
    ORG 0X008
    GOTO INT_ALTA_PRIOR; A�adimos el alias de la rutina de servicio para la interrupcion de alta prioridad
    ; Esto sucede en la posici�n 0x008 del PC
    ORG 0X018
    GOTO INT_BAJA_PRIOR; Hacemos lo mismo para el de baja prioridad
    ORG 0X020
MAIN: ; Damos un alias de MAIN a la posicion 0X020 para el PC 
    ;dentro de esta parte podemos configurar nuestros puertos de trabajo dem�s cosas
START:; Damos otro al�as a otra posici�n de memoria de programa para iniciar
    ; la rutina que deseamos 
    ORG 0X0C0 
INT_ALTA_PRIOR: ; Damos el alias de INT_ALTA_PRIOR 
    ; a la posicion 0X0C0 para que ac� vaya una rutina de servicio a la interrupci�n
    ; todo ello se ver� m�s adelante
    RETFIE ; usamos el retorno de interrupcion 
    ORG 0X0F0
INT_BAJA_PRIOR: ; Hacemos lo mismo para la de baja prioridad 
    RETFIE 
    END 



