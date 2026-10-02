#include <stdio.h>
#include <stdint.h>

int main(void) {
	uint16_t muestra   = 1207;    /* contador de muestras: nunca es negativo */
	int16_t  velocidad = -3450;   /* rpm: el signo dice para que lado gira */
	float    tension   = 11.8f;   /* V del bus de potencia */
	uint16_t corriente = 420;     /* mA */

	/* mA -> A ANTES de multiplicar, o la potencia sale mil veces grande */
	float potencia = tension * (corriente / 1000.0f);

	printf("Muestra #%u\n", muestra);
	printf("Velocidad: %d rpm\n", velocidad);
	printf("Bus: %.1f V, %u mA -> %.2f W\n", tension, corriente, potencia);
	return 0;
}
