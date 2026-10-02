/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Global variables */
static volatile uint32_t paquetes = 0u;   /* lo incrementan main y la ISR de la radio */

/* Functions declaration */
static void isr_radio(void);

int main(void) {
	/* Main program */
	/* "paquetes++" en main son tres pasos. En la PC no hay interrupciones: */
	/* se escriben los tres a mano, y la ISR "cae" entre el segundo y el tercero */
	uint32_t leido = paquetes;   /* 1. leer  (lee 0) */
	leido = leido + 1u;          /* 2. sumar (1, en un registro) */
	isr_radio();                 /*    <- interrupcion: la ISR cuenta su paquete */
	paquetes = leido;            /* 3. escribir (escribe 1: pisa lo de la ISR) */

	printf("paquetes contados: %u, paquetes que hubo: 2\n", (unsigned)paquetes);
	return 0;
}

/* Functions definition */
static void isr_radio(void) {
	paquetes++;
	printf("ISR: paquetes=%u\n", (unsigned)paquetes);
}
