/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define N_TC   4u   /* los codigos validos van de 0 a N_TC - 1 */

/* Functions declaration */
static void tc_ping(void);
static void tc_reinicio(void);
static void tc_foto(void);
static void tc_estado(void);
static void despachar(uint8_t codigo);

/* Global variables */
/* La tabla de despacho: el codigo es el indice, el elemento es la funcion */
static void (*const MANEJADOR[N_TC])(void) = { tc_ping, tc_reinicio, tc_foto, tc_estado };

int main(void) {
	/* Main program */
	despachar(0u);
	despachar(3u);
	despachar(2u);
	despachar(9u);   /* fuera de la tabla */
	return 0;
}

/* Functions definition */
static void despachar(uint8_t codigo) {
	printf("TC %u: ", codigo);
	if (codigo < N_TC) {
		MANEJADOR[codigo]();
	} else {
		printf("desconocido, rechazado\n");
	}
}

static void tc_ping(void)     { printf("pong\n"); }
static void tc_reinicio(void) { printf("reinicio programado\n"); }
static void tc_foto(void)     { printf("camara: foto en cola\n"); }
static void tc_estado(void)   { printf("estado: nominal\n"); }
