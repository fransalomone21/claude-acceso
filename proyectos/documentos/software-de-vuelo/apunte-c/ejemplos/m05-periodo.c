/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

/* Macros */
#define PERIODO_MIN_S   1u
#define PERIODO_MAX_S   60u
#define LECTURAS_MAX    10u    /* cota: no se lee para siempre */

int main(void) {
	/* Main program */
	uint16_t periodo_s = 10u;   /* el que trae de fabrica */
	uint16_t pedido_s  = 0u;
	uint8_t  lecturas  = 0u;

	while (lecturas < LECTURAS_MAX) {
		lecturas++;
		if (scanf("%" SCNu16, &pedido_s) != 1) {
			printf("entrada no numerica: se deja de leer\n");
			break;
		}
		if ((pedido_s < PERIODO_MIN_S) || (pedido_s > PERIODO_MAX_S)) {
			printf("%u s: fuera de rango, se ignora\n", pedido_s);
			continue;
		}
		periodo_s = pedido_s;
		printf("%u s: aceptado\n", periodo_s);
	}
	printf("Periodo de telemetria: %u s\n", periodo_s);
	return 0;
}
