/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define N_CELDAS   6u

/* Functions declaration */
static void mal(const uint16_t celdas_mv[N_CELDAS]);
static uint32_t total_mv(const uint16_t celdas_mv[], uint8_t cantidad);

int main(void) {
	/* Main program */
	const uint16_t celdas_mv[N_CELDAS] = { 3712u, 3708u, 3715u, 3699u, 3710u, 3705u };

	printf("en main: sizeof=%zu\n", sizeof(celdas_mv));
	mal(celdas_mv);
	printf("pack: %u mV\n", (unsigned)total_mv(celdas_mv, N_CELDAS));
	return 0;
}

/* Functions definition */
static void mal(const uint16_t celdas_mv[N_CELDAS]) {
	printf("en mal:  sizeof=%zu\n", sizeof(celdas_mv));
}

static uint32_t total_mv(const uint16_t celdas_mv[], uint8_t cantidad) {
	uint32_t total = 0u;

	for (uint8_t i = 0u; i < cantidad; i++) {
		total += celdas_mv[i];
	}
	return total;
}
// ESPERA-WARNING: -Wsizeof-array-argument
