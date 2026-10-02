#include <stdio.h>
#include <stdint.h>

int main(void) {
	int16_t temperatura = -18;   /* declarada... y olvidada */
	printf("Reporte enviado\n");
	return 0;
}
// ESPERA-WARNING: -Wunused-variable
