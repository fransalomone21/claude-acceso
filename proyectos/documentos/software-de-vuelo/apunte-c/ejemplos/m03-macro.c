#include <stdio.h>
#include <stdint.h>

#define MARGEN_MAL    100u + 50u      /* sin parentesis */
#define MARGEN_BIEN   (100u + 50u)    /* con parentesis */

int main(void) {
	/* el doble del margen, en mA: tendria que dar 300 */
	uint16_t doble_mal  = 2u * MARGEN_MAL;
	uint16_t doble_bien = 2u * MARGEN_BIEN;

	printf("Sin parentesis: %u mA\n", doble_mal);
	printf("Con parentesis: %u mA\n", doble_bien);
	return 0;
}
