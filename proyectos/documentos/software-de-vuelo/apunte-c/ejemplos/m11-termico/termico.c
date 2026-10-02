/* termico.c -- la implementacion: lo static no sale de este archivo */

/* User libraries */
#include "termico.h"

/* Global variables */
static termico_config_t config;
static uint8_t  calefactor    = 0u;
static uint16_t conmutaciones = 0u;

/* Functions declaration */
static void poner_calefactor(uint8_t prendido);

/* Functions definition */
void termico_iniciar(const termico_config_t *cfg) {
	config = *cfg;
	calefactor = 0u;
	conmutaciones = 0u;
}

uint8_t termico_actualizar(int16_t temp_dc) {
	if (temp_dc < config.prender_dc) {
		poner_calefactor(1u);
	} else if (temp_dc > config.apagar_dc) {
		poner_calefactor(0u);
	} else {
		/* entre los dos umbrales: se queda como estaba (histeresis) */
	}
	return calefactor;
}

uint16_t termico_conmutaciones(void) {
	return conmutaciones;
}

static void poner_calefactor(uint8_t prendido) {
	if (prendido != calefactor) {
		calefactor = prendido;
		conmutaciones++;
	}
}
