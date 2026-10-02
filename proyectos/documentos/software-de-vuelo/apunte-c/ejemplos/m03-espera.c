/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

/* Macros */
#define ESPERA_MAX   100000u   /* cota fija: la espera SIEMPRE termina */

/* Global variables */
/* La pone en 1 la interrupcion del magnetometro, no el codigo de abajo */
static volatile uint8_t dato_listo = 0u;

int main(void) {
	/* Main program */
	uint32_t intentos = 0u;

	while ((dato_listo == 0u) && (intentos < ESPERA_MAX)) {
		intentos++;
	}

	if (dato_listo != 0u) {
		printf("Magnetometro: dato listo tras %" PRIu32 " intentos\n", intentos);
	} else {
		printf("Magnetometro: sin respuesta tras %" PRIu32 " intentos\n", intentos);
		printf("Magnetometro marcado como caido\n");
	}
	return 0;
}
