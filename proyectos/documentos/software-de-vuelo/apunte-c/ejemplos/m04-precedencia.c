/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define ESTADO_GPS_FIX   0x08u   /* bit 3: el GPS tiene posicion */

int main(void) {
	/* Main program */
	uint8_t estado = 0x05u;   /* bits 0 y 2 prendidos; el 3, apagado: sin fix */

	if (estado & ESTADO_GPS_FIX == ESTADO_GPS_FIX) {
		printf("sin parentesis: GPS con fix\n");
	} else {
		printf("sin parentesis: GPS sin fix\n");
	}

	if ((estado & ESTADO_GPS_FIX) == ESTADO_GPS_FIX) {
		printf("con parentesis: GPS con fix\n");
	} else {
		printf("con parentesis: GPS sin fix\n");
	}
	return 0;
}
// ESPERA-WARNING: -Wparentheses
