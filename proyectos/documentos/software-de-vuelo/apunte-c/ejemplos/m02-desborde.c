#include <stdio.h>
#include <stdint.h>

int main(void) {
	uint8_t paquete = 254;   /* 8 bits: de 0 a 255, y ni uno mas */

	for (int i = 0; i < 3; i++) {
		printf("Paquete #%u\n", paquete);
		paquete++;           /* despues de 255 vuelve a 0, sin avisar */
	}
	return 0;
}
