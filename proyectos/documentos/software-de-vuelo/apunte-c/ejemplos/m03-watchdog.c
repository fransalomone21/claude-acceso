/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Global variables */
static uint16_t resets_totales = 0u;   /* static global: solo la ve este .c */

/* Functions declaration */
static void registrar_reset(void);

int main(void) {
	/* Main program */
	registrar_reset();
	registrar_reset();
	registrar_reset();
	printf("Resets totales: %u\n", resets_totales);
	return 0;
}

/* Functions definition */
static void registrar_reset(void) {
	uint16_t automatica = 0u;      /* nace en cada llamada */
	static uint16_t cuenta = 0u;   /* nace una vez, vive toda la ejecucion */

	automatica++;
	cuenta++;
	resets_totales++;
	printf("Reset del watchdog: automatica=%u, static=%u\n", automatica, cuenta);
}
