/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Types */
/* Los mismos 4 bytes, vistos de dos maneras */
typedef union {
	uint32_t palabra;
	uint8_t  bytes[4];
} vista_t;

int main(void) {
	/* Main program */
	const uint32_t met_s = 0x00016E58u;   /* 93784 s */
	vista_t v = { .palabra = met_s };

	printf("en memoria:   %02X %02X %02X %02X\n",
	       v.bytes[0], v.bytes[1], v.bytes[2], v.bytes[3]);

	/* Para la trama (big endian, el mas significativo primero): con corrimientos */
	uint8_t trama[4];
	trama[0] = (uint8_t)(met_s >> 24);
	trama[1] = (uint8_t)(met_s >> 16);
	trama[2] = (uint8_t)(met_s >> 8);
	trama[3] = (uint8_t)met_s;
	printf("en la trama:  %02X %02X %02X %02X\n", trama[0], trama[1], trama[2], trama[3]);
	return 0;
}
