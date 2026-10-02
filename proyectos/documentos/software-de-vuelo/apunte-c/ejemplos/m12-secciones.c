/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define N   256u

/* Global variables */
static const uint16_t TABLA_NTC[N] = { 4012u, 3998u, 3981u };  /* .rodata: flash */
static uint16_t       ganancia[N]  = { 1000u, 1000u, 1002u };  /* .data: flash Y RAM */
static uint16_t       historia[N];                             /* .bss: RAM, en cero */

/* Functions declaration */
static uint16_t corregir(uint8_t canal);

int main(void) {
	/* Main program */
	uint16_t local = corregir(2u);   /* stack */

	printf("TABLA_NTC %zu B, ganancia %zu B, historia %zu B, local %zu B\n",
	       sizeof(TABLA_NTC), sizeof(ganancia), sizeof(historia), sizeof(local));
	printf("canal 2: %u (historia[2]=%u, historia[3]=%u)\n", local, historia[2], historia[3]);
	return 0;
}

/* Functions definition */
static uint16_t corregir(uint8_t canal) {
	historia[canal] = (uint16_t)(((uint32_t)TABLA_NTC[canal] * ganancia[canal]) / 1000u);
	return historia[canal];
}
