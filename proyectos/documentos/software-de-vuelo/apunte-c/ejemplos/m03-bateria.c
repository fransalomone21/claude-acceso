/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define CELDA_MIN_MV   3300u   /* por debajo, la celda se degrada */
#define CELDA_MAX_MV   4200u   /* por encima, se arruina */
#define CARGA_MAX_MA   1500u   /* corriente de carga maxima */

int main(void) {
	/* Main program */
	const uint16_t celda_mv = 3290u;   /* lectura del ADC: una vez tomada, no se toca */
	const uint16_t carga_ma = 1200u;

	uint8_t baja      = celda_mv < CELDA_MIN_MV;
	uint8_t alta      = celda_mv > CELDA_MAX_MV;
	uint8_t carga_ok  = carga_ma <= CARGA_MAX_MA;
	uint8_t celda_ok  = !baja && !alta;

	printf("Celda: %u mV, carga: %u mA\n", celda_mv, carga_ma);
	printf("baja=%u alta=%u carga_ok=%u celda_ok=%u\n", baja, alta, carga_ok, celda_ok);
	printf("Alarmas activas: %u\n", baja + alta + !carga_ok);
	return 0;
}
