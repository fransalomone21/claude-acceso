/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define DUTY_MAX_PCT   80u   /* el calefactor nunca al 100 %: se quema el driver */

/* Functions declaration */
static void limitar_copia(uint8_t duty);
static void limitar(uint8_t *duty);

int main(void) {
	/* Main program */
	uint8_t duty = 95u;   /* lo que pidio el control termico */

	limitar_copia(duty);
	printf("Despues de limitar_copia: %u %%\n", duty);

	limitar(&duty);
	printf("Despues de limitar:       %u %%\n", duty);
	return 0;
}

/* Functions definition */
/* Recibe una COPIA: lo que cambie aca no sale de la funcion */
static void limitar_copia(uint8_t duty) {
	if (duty > DUTY_MAX_PCT) {
		duty = DUTY_MAX_PCT;
	}
	printf("  adentro de limitar_copia: %u %%\n", duty);
}

/* Recibe DONDE esta la variable: escribe en la del que llamo */
static void limitar(uint8_t *duty) {
	if (*duty > DUTY_MAX_PCT) {
		*duty = DUTY_MAX_PCT;
	}
}
