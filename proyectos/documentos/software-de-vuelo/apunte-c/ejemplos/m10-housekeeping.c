/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

/* Types */
/* Un paquete de housekeeping: el estado general del satelite, cada minuto */
typedef struct {
	uint32_t met_s;        /* tiempo de mision */
	uint16_t bateria_mv;
	int16_t  temp_obc_dc;  /* decimas de grado */
	uint8_t  modo;
	uint8_t  resets;
} housekeeping_t;

/* Functions declaration */
static void mostrar(const housekeeping_t *hk);
static void contar_reset(housekeeping_t *hk);

int main(void) {
	/* Main program */
	housekeeping_t hk = {
		.met_s       = 93784u,
		.bateria_mv  = 3790u,
		.temp_obc_dc = -42,
		.modo        = 2u,
	};                      /* lo que no se nombra (resets) queda en cero */

	mostrar(&hk);
	contar_reset(&hk);
	hk.modo = 3u;           /* con el punto, desde la variable */
	mostrar(&hk);

	housekeeping_t copia = hk;   /* asignar copia el struct entero */
	copia.resets = 0u;
	printf("hk.resets=%u, copia.resets=%u\n", hk.resets, copia.resets);
	return 0;
}

/* Functions definition */
/* Recibe un puntero a const: lee sin copiar los 12 bytes, y promete no tocarlos */
static void mostrar(const housekeeping_t *hk) {
	printf("MET %" PRIu32 " s | bat %u mV | OBC %d dC | modo %u | resets %u\n",
	       hk->met_s, hk->bateria_mv, hk->temp_obc_dc, hk->modo, hk->resets);
}

/* Con la flecha, a traves del puntero */
static void contar_reset(housekeeping_t *hk) {
	hk->resets++;
}
