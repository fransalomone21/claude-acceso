/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define CUENTA_INICIAL    5u
#define PANELES           4u
#define PANEL_TRABADO     2u    /* en esta corrida, el panel 2 no confirma */

int main(void) {
	/* Main program */
	for (uint8_t t = CUENTA_INICIAL; t > 0u; t--) {
		printf("T-%u ", t);
	}
	printf("despliegue\n");

	uint8_t desplegados = 0u;
	for (uint8_t panel = 0u; panel < PANELES; panel++) {
		if (panel == PANEL_TRABADO) {
			printf("panel %u: sin confirmacion, se aborta la secuencia\n", panel);
			break;
		}
		printf("panel %u: desplegado\n", panel);
		desplegados++;
	}
	printf("Desplegados: %u de %u\n", desplegados, PANELES);
	return 0;
}
