#include <stdio.h>
#include <stdint.h>

#define VUELTAS_DE_PRUEBA 3u   /* en la PC lo cortamos; en la placa es while (1) */

int main(void) {
	uint32_t vuelta = 0;

	/* Inicializacion: corre UNA sola vez */
	printf("Inicializando perifericos...\n");

	/* Superloop: lo mismo, una y otra vez, mientras haya energia */
	while (vuelta < VUELTAS_DE_PRUEBA) {
		vuelta++;
		printf("Vuelta %u: leer sensores, atender telecomandos, mandar telemetria\n", vuelta);
	}
	return 0;
}
