/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define N_MUESTRAS   8u

int main(void) {
	/* Main program */
	/* Temperatura de la bateria, en decimas de grado, una por minuto */
	const int16_t temp_dc[N_MUESTRAS] = { 182, 185, 191, 203, 214, 209, 197, 188 };

	int16_t minima = temp_dc[0];
	int16_t maxima = temp_dc[0];
	int32_t suma   = 0;

	for (uint8_t i = 0u; i < N_MUESTRAS; i++) {
		if (temp_dc[i] < minima) {
			minima = temp_dc[i];
		}
		if (temp_dc[i] > maxima) {
			maxima = temp_dc[i];
		}
		suma += temp_dc[i];
	}

	const size_t cantidad = sizeof(temp_dc) / sizeof(temp_dc[0]);
	printf("%zu bytes, %zu elementos\n", sizeof(temp_dc), cantidad);
	printf("min %d dC, max %d dC, promedio %d dC\n",
	       minima, maxima, (int)(suma / (int32_t)N_MUESTRAS));
	return 0;
}
