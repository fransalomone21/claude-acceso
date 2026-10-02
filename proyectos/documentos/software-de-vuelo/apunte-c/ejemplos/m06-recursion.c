/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

/* Global variables */
static uint8_t profundidad = 0u;       /* cuantas llamadas hay abiertas ahora */
static uint8_t profundidad_max = 0u;   /* la peor que hubo */

/* Functions declaration */
static void    probar(uint32_t fallas);
static uint8_t unos_recursivo(uint32_t x);
static uint8_t unos_iterativo(uint32_t x);

int main(void) {
	/* Main program */
	probar(0x00000005u);   /* registro de fallas: dos bits abajo */
	probar(0x80000000u);   /* un solo bit, pero arriba de todo */
	return 0;
}

/* Functions definition */
static void probar(uint32_t fallas) {
	profundidad_max = 0u;
	uint8_t r = unos_recursivo(fallas);
	printf("0x%08" PRIX32 ": recursivo=%u iterativo=%u, llamadas anidadas=%u\n",
	       fallas, r, unos_iterativo(fallas), profundidad_max);
}

/* Cuantos bits en 1: el de abajo, mas los unos del resto */
static uint8_t unos_recursivo(uint32_t x) {
	uint8_t total = 0u;

	profundidad++;
	if (profundidad > profundidad_max) {
		profundidad_max = profundidad;
	}
	if (x != 0u) {
		total = (uint8_t)((x & 1u) + unos_recursivo(x >> 1));
	}
	profundidad--;
	return total;
}

/* Lo mismo con un bucle: una sola llamada, memoria fija */
static uint8_t unos_iterativo(uint32_t x) {
	uint8_t total = 0u;

	for (uint8_t bit = 0u; bit < 32u; bit++) {
		total = (uint8_t)(total + ((x >> bit) & 1u));
	}
	return total;
}
