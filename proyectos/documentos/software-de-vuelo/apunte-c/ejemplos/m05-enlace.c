/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define RSSI_BUENO_DBM      (-80)    /* por encima: enlace sobrado */
#define RSSI_MARGINAL_DBM   (-105)   /* por encima: se escucha, con errores */

int main(void) {
	/* Main program */
	const int16_t rssi_dbm = -62;   /* potencia recibida de la estacion terrena */

	/* Del umbral mas exigente al menos exigente */
	if (rssi_dbm > RSSI_BUENO_DBM) {
		printf("bien ordenado: enlace bueno\n");
	} else if (rssi_dbm > RSSI_MARGINAL_DBM) {
		printf("bien ordenado: enlace marginal\n");
	} else {
		printf("bien ordenado: sin enlace\n");
	}

	/* Las mismas condiciones, al reves: la primera que da cierta gana */
	if (rssi_dbm > RSSI_MARGINAL_DBM) {
		printf("al reves:      enlace marginal\n");
	} else if (rssi_dbm > RSSI_BUENO_DBM) {
		printf("al reves:      enlace bueno\n");
	} else {
		printf("al reves:      sin enlace\n");
	}
	return 0;
}
