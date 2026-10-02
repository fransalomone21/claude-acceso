/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define REINTENTOS_MAX   4u

/* Functions declaration */
static uint8_t enviar_y_esperar_ack(uint8_t intento);

int main(void) {
	/* Main program */
	uint8_t intento = 0u;
	uint8_t ack     = 0u;

	do {
		intento++;
		ack = enviar_y_esperar_ack(intento);
	} while ((ack == 0u) && (intento < REINTENTOS_MAX));

	if (ack != 0u) {
		printf("Paquete confirmado en el intento %u\n", intento);
	} else {
		printf("Sin ACK tras %u intentos: paquete a la cola de reenvio\n", intento);
	}
	return 0;
}

/* Functions definition */
/* En la PC no hay radio: la estacion "contesta" recien al tercer intento */
static uint8_t enviar_y_esperar_ack(uint8_t intento) {
	printf("  intento %u: enviado\n", intento);
	return intento >= 3u;
}
