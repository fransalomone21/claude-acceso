/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define LECTURA_OK      0u
#define LECTURA_FALLA   1u

/* Functions declaration */
static uint8_t leer_presion(uint8_t sensor, uint16_t *hpa);

int main(void) {
	/* Main program */
	uint16_t presion_hpa = 0u;

	for (uint8_t sensor = 0u; sensor < 3u; sensor++) {
		if (leer_presion(sensor, &presion_hpa) == LECTURA_OK) {
			printf("sensor %u: %u hPa\n", sensor, presion_hpa);
		} else {
			printf("sensor %u: falla, el valor no se usa\n", sensor);
		}
	}
	return 0;
}

/* Functions definition */
/* Devuelve si salio bien; el dato, por el puntero. En la PC, el sensor 1 "no contesta" */
static uint8_t leer_presion(uint8_t sensor, uint16_t *hpa) {
	uint8_t resultado = LECTURA_FALLA;

	if (sensor != 1u) {
		*hpa = (uint16_t)(1012u + sensor);
		resultado = LECTURA_OK;
	}
	return resultado;
}
