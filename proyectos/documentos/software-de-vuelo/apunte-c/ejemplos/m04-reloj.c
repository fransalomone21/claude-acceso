/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

/* Macros */
#define MS_POR_SEG    1000u
#define MS_POR_MIN    (60u * MS_POR_SEG)
#define MS_POR_HORA   (60u * MS_POR_MIN)
#define MS_POR_DIA    (24u * MS_POR_HORA)

int main(void) {
	/* Main program */
	const uint32_t met_ms = 93784567u;   /* tiempo de mision: ms desde el despegue */
	uint32_t resto = met_ms;

	uint32_t dias  = resto / MS_POR_DIA;   resto %= MS_POR_DIA;
	uint32_t horas = resto / MS_POR_HORA;  resto %= MS_POR_HORA;
	uint32_t mins  = resto / MS_POR_MIN;   resto %= MS_POR_MIN;
	uint32_t segs  = resto / MS_POR_SEG;   resto %= MS_POR_SEG;

	printf("MET %" PRIu32 " ms\n", met_ms);
	printf("  = %" PRIu32 " d %02" PRIu32 ":%02" PRIu32 ":%02" PRIu32 ".%03" PRIu32 "\n",
	       dias, horas, mins, segs, resto);
	return 0;
}
