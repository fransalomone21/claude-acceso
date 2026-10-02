/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Global variables */
/* El modo de la mision, guardado tres veces (triple redundancia) */
static uint8_t modo_a = 2u;
static uint8_t modo_b = 2u;
static uint8_t modo_c = 2u;

/* Functions declaration */
static uint8_t votar(uint8_t a, uint8_t b, uint8_t c);
static void    leer_modo(void);

int main(void) {
	/* Main program */
	leer_modo();

	modo_b ^= 0x40u;   /* un ion pesado da vuelta el bit 6 de una copia */
	leer_modo();

	modo_b = votar(modo_a, modo_b, modo_c);   /* "fregado": se corrige la copia mala */
	leer_modo();
	return 0;
}

/* Functions definition */
/* Cada bit del resultado es el que tienen al menos dos de las tres copias */
static uint8_t votar(uint8_t a, uint8_t b, uint8_t c) {
	return (uint8_t)((a & b) | (a & c) | (b & c));
}

static void leer_modo(void) {
	printf("copias %3u %3u %3u -> modo votado %u\n",
	       modo_a, modo_b, modo_c, votar(modo_a, modo_b, modo_c));
}
