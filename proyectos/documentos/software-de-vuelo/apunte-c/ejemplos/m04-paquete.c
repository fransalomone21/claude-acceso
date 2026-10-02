/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define CCSDS_TIPO_TM    0u        /* 0: telemetria, 1: telecomando */
#define APID_TERMICO     0x2C1u    /* el subsistema termico de nuestro OBC */
#define APID_MASCARA     0x07FFu   /* 11 bits */
#define CUENTA_MASCARA   0x3FFFu   /* 14 bits */

int main(void) {
	/* Main program */
	/* Armar: version (3 bits) | tipo (1) | cabecera secundaria (1) | APID (11) */
	uint16_t armada = (uint16_t)((0u << 13) | (CCSDS_TIPO_TM << 12) | (1u << 11)
	                             | (APID_TERMICO & APID_MASCARA));
	printf("Armada:   0x%04X\n", armada);

	/* Desarmar una que llego de tierra */
	const uint16_t recibida = 0x1A5Fu;
	printf("Recibida: 0x%04X -> version=%u tipo=%u sec=%u apid=0x%03X\n", recibida,
	       (recibida >> 13) & 0x7u, (recibida >> 12) & 0x1u,
	       (recibida >> 11) & 0x1u, recibida & APID_MASCARA);

	/* El contador de secuencia da la vuelta solo, con la mascara */
	uint16_t cuenta = 16382u;
	for (uint8_t i = 0u; i < 3u; i++) {
		cuenta = (cuenta + 1u) & CUENTA_MASCARA;
		printf("cuenta=%u\n", cuenta);
	}
	return 0;
}
