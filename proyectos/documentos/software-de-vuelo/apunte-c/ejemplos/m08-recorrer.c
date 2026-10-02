/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define LARGO_TRAMA   6u

int main(void) {
	/* Main program */
	/* Trama de telemetria: 5 bytes de datos y, al final, el XOR de los 5 */
	const uint8_t trama[LARGO_TRAMA] = { 0xA5u, 0x10u, 0x3Cu, 0x07u, 0x5Au, 0xD4u };

	const uint8_t *p   = trama;                    /* el nombre del vector es &trama[0] */
	const uint8_t *fin = trama + LARGO_TRAMA - 1u; /* apunta al byte de control */
	uint8_t control = 0u;

	printf("trama == &trama[0]? %d   *(trama + 2) == trama[2]? %d\n",
	       trama == &trama[0], *(trama + 2) == trama[2]);

	while (p < fin) {
		control ^= *p;
		p++;                                       /* al byte siguiente */
	}
	printf("XOR calculado 0x%02X, recibido 0x%02X: %s\n",
	       control, *fin, (control == *fin) ? "trama sana" : "trama corrupta");

	const uint32_t palabras[2] = { 0u, 0u };
	printf("un paso de uint8_t avanza %td byte; uno de uint32_t, %td bytes\n",
	       (const char *)(trama + 1) - (const char *)trama,
	       (const char *)(palabras + 1) - (const char *)palabras);
	return 0;
}
