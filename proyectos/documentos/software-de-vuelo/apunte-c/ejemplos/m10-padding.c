/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

/* Types */
typedef struct {          /* en el orden en que se le ocurrieron a alguien */
	uint8_t  modo;
	uint32_t met_s;
	uint8_t  resets;
	uint16_t bateria_mv;
} desordenado_t;

typedef struct {          /* los mismos campos, del mas grande al mas chico */
	uint32_t met_s;
	uint16_t bateria_mv;
	uint8_t  modo;
	uint8_t  resets;
} ordenado_t;

int main(void) {
	/* Main program */
	printf("desordenado: %2zu bytes (modo@%zu met_s@%zu resets@%zu bateria_mv@%zu)\n",
	       sizeof(desordenado_t), offsetof(desordenado_t, modo),
	       offsetof(desordenado_t, met_s), offsetof(desordenado_t, resets),
	       offsetof(desordenado_t, bateria_mv));
	printf("ordenado:    %2zu bytes (met_s@%zu bateria_mv@%zu modo@%zu resets@%zu)\n",
	       sizeof(ordenado_t), offsetof(ordenado_t, met_s),
	       offsetof(ordenado_t, bateria_mv), offsetof(ordenado_t, modo),
	       offsetof(ordenado_t, resets));
	printf("1000 paquetes en la memoria: %zu contra %zu bytes\n",
	       1000u * sizeof(desordenado_t), 1000u * sizeof(ordenado_t));
	return 0;
}
