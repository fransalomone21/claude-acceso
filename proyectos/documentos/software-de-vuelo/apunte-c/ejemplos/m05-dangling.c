/* C libraries */
#include <stdio.h>
#include <stdint.h>

int main(void) {
	/* Main program */
	uint8_t en_pasada  = 0u;   /* el satelite no esta sobre la estacion */
	uint8_t bateria_ok = 1u;

	printf("Plan del transmisor:\n");
	if (en_pasada)
		if (bateria_ok)
			printf("  transmitir telemetria\n");
	else
		printf("  apagar el transmisor\n");

	printf("Fin del plan\n");
	return 0;
}
// ESPERA-WARNING: -Wdangling-else
