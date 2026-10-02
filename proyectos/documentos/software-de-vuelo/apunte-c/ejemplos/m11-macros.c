/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define CUADRADO_MAL(x)   x * x
#define CUADRADO(x)       ((x) * (x))
#define MAYOR(a, b)       (((a) > (b)) ? (a) : (b))

/* Functions declaration */
static inline uint8_t mayor(uint8_t a, uint8_t b);

int main(void) {
	/* Main program */
	const uint8_t n = 3u;
	printf("CUADRADO_MAL(n + 1) = %d, CUADRADO(n + 1) = %d\n",
	       CUADRADO_MAL(n + 1), CUADRADO(n + 1));

	uint8_t muestra = 5u;
	uint8_t tope = MAYOR(muestra++, 2u);
	printf("macro:   tope=%u, muestra=%u (se incremento dos veces)\n", tope, muestra);

	muestra = 5u;
	tope = mayor(muestra++, 2u);
	printf("funcion: tope=%u, muestra=%u\n", tope, muestra);
	return 0;
}

/* Functions definition */
static inline uint8_t mayor(uint8_t a, uint8_t b) {
	return (a > b) ? a : b;
}
