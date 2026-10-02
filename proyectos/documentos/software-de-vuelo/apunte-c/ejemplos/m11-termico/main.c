/* main.c -- usa el control termico sin saber como esta hecho por dentro */

/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* User libraries */
#include "termico.h"
#include "termico.h"   /* incluido dos veces a proposito: la guarda lo aguanta */

int main(void) {
	/* Main program */
	const termico_config_t cfg = { .prender_dc = -50, .apagar_dc = 0 };
	const int16_t temp_dc[] = { 20, -30, -55, -48, -20, -5, 3, -10, -60 };
	const uint8_t n = (uint8_t)(sizeof(temp_dc) / sizeof(temp_dc[0]));

	termico_iniciar(&cfg);
	for (uint8_t i = 0u; i < n; i++) {
		uint8_t prendido = termico_actualizar(temp_dc[i]);
		printf("%4d dC -> calefactor %s\n",
		       temp_dc[i], (prendido != 0u) ? "PRENDIDO" : "apagado");
	}
	printf("conmutaciones: %u\n", termico_conmutaciones());
	return 0;
}
