/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

/* Macros */
#define N_SENSORES   4u

/* Global variables */
static const uint8_t  ID_SENSOR[N_SENSORES]   = { 0x11u, 0x12u, 0x21u, 0x30u };
static const uint16_t UMBRAL_SENSOR[N_SENSORES] = { 450u, 450u, 800u, 120u };

/* Functions declaration */
static const uint16_t *buscar_umbral(uint8_t id);
static void informar(uint8_t id);

int main(void) {
	/* Main program */
	informar(0x21u);
	informar(0x99u);   /* un id que no existe */
	return 0;
}

/* Functions definition */
/* Devuelve donde esta el umbral del sensor, o NULL si el id no existe */
static const uint16_t *buscar_umbral(uint8_t id) {
	const uint16_t *encontrado = NULL;

	for (uint8_t i = 0u; (i < N_SENSORES) && (encontrado == NULL); i++) {
		if (ID_SENSOR[i] == id) {
			encontrado = &UMBRAL_SENSOR[i];
		}
	}
	return encontrado;
}

static void informar(uint8_t id) {
	const uint16_t *umbral = buscar_umbral(id);

	if (umbral != NULL) {
		printf("sensor 0x%02X: umbral %u\n", id, *umbral);
	} else {
		printf("sensor 0x%02X: no existe, no se lee nada\n", id);
	}
}
