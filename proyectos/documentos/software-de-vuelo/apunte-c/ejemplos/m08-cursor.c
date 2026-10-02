/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Functions declaration */
static uint8_t  leer_u8(const uint8_t **cursor);
static uint16_t leer_u16(const uint8_t **cursor);

int main(void) {
	/* Main program */
	/* Telecomando recibido: codigo (1 byte), duracion en s (2 bytes, */
	/* el alto primero) y modo (1 byte)                              */
	const uint8_t tc[4] = { 0x31u, 0x01u, 0x2Cu, 0x02u };
	const uint8_t *cursor = tc;

	uint8_t  codigo   = leer_u8(&cursor);
	uint16_t duracion = leer_u16(&cursor);
	uint8_t  modo     = leer_u8(&cursor);

	printf("codigo=0x%02X duracion=%u s modo=%u\n", codigo, duracion, modo);
	printf("bytes consumidos: %td\n", cursor - tc);
	return 0;
}

/* Functions definition */
/* Lee un byte y deja el cursor del que llama apuntando al siguiente */
static uint8_t leer_u8(const uint8_t **cursor) {
	uint8_t valor = **cursor;
	(*cursor)++;
	return valor;
}

static uint16_t leer_u16(const uint8_t **cursor) {
	uint16_t alto = leer_u8(cursor);
	uint16_t bajo = leer_u8(cursor);
	return (uint16_t)((alto << 8) | bajo);
}
