/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define VENTANA          4u                 /* potencia de dos: la mascara anda */
#define VENTANA_MASCARA  (VENTANA - 1u)

/* Global variables */
static uint16_t historia_mv[VENTANA] = { 0u };
static uint8_t  proxima = 0u;   /* donde se escribe la que viene */

/* Functions declaration */
static void guardar(uint16_t mv);
static void mostrar(void);

int main(void) {
	/* Main program */
	const uint16_t bus_mv = 4980u;

	for (uint16_t k = 0u; k < 6u; k++) {
		guardar((uint16_t)(bus_mv + k));   /* el bus sube de a 1 mV */
		mostrar();
	}
	return 0;
}

/* Functions definition */
static void guardar(uint16_t mv) {
	historia_mv[proxima] = mv;
	proxima = (uint8_t)((proxima + 1u) & VENTANA_MASCARA);   /* 0 1 2 3 0 1 ... */
}

static void mostrar(void) {
	printf("proxima=%u  [", proxima);
	for (uint8_t i = 0u; i < VENTANA; i++) {
		printf(" %4u", historia_mv[i]);
	}
	printf(" ]\n");
}
