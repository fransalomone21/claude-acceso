/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

/* Macros */
#define TEMP_MAX_DC   450   /* 45.0 grados, en decimas: la temperatura puede ser negativa */

int main(void) {
	/* Main program */
	uint16_t muestras = 0u;   /* el sensor de la camara todavia no midio nada */
	int32_t  suma_dc  = 0;

	/* Si muestras vale 0, la division ni se intenta: && corta antes */
	uint8_t caliente = (muestras != 0u) && ((suma_dc / muestras) > TEMP_MAX_DC);
	printf("Sin muestras: caliente=%u\n", caliente);

	suma_dc += 412;  muestras++;
	suma_dc += 497;  muestras++;
	suma_dc += 516;  muestras++;
	caliente = (muestras != 0u) && ((suma_dc / muestras) > TEMP_MAX_DC);
	printf("Promedio %" PRId32 " dC en %u muestras: caliente=%u\n",
	       suma_dc / muestras, muestras, caliente);

	char modo = caliente ? 'S' : 'N';   /* S: modo seguro, N: nominal */
	printf("Modo: %c\n", modo);

	uint8_t a = 2u;
	uint8_t b = 1u;
	printf("a & b = %u, a && b = %u\n", a & b, a && b);

	uint8_t n = 5u;
	uint8_t antes   = n++;
	uint8_t despues = ++n;
	printf("antes=%u despues=%u n=%u\n", antes, despues, n);
	return 0;
}
