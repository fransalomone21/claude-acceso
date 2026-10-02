#include <stdio.h>
#include <stdint.h>

int main(void) {
	uint8_t config_dec = 42;         /* decimal */
	uint8_t config_hex = 0x2A;       /* hexadecimal: 0x adelante */
	uint8_t config_oct = 052;        /* octal: un cero adelante */
	uint8_t config_bin = 0b101010;   /* binario: extension de gcc, estandar recien en C23 */

	uint8_t id_camara  = 010;        /* la idea: el ID 10, con dos cifras */

	float   altura_m   = 5.5e5f;     /* 5,5 x 10^5 m: 550 km */
	char    modo       = 'S';        /* S de safe mode */

	printf("Config: %u %u %u %u\n", config_dec, config_hex, config_oct, config_bin);
	printf("Config en hexa: 0x%02X\n", config_dec);
	printf("ID de la camara: %u\n", id_camara);
	printf("Altura: %.0f m\n", altura_m);
	printf("Modo: %c, que para C es el numero %d\n", modo, modo);
	return 0;
}
