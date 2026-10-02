/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define N_MODOS   3u
#define N_PASOS   10u   /* un paso cada 100 ms: el patron dura un segundo */

/* Global variables */
/* El LED de estado del OBC: una fila por modo, una columna por paso */
static const uint8_t PATRON_LED[N_MODOS][N_PASOS] = {
	{ 1u, 0u, 0u, 0u, 0u, 0u, 0u, 0u, 0u, 0u },   /* nominal: un destello */
	{ 1u, 0u, 1u, 0u, 0u, 0u, 0u, 0u, 0u, 0u },   /* seguro: dos destellos */
	{ 1u, 1u, 1u, 1u, 1u, 0u, 0u, 0u, 0u, 0u },   /* falla: medio segundo prendido */
};
static const char *const NOMBRE_MODO[N_MODOS] = { "nominal", "seguro", "falla" };

int main(void) {
	/* Main program */
	for (uint8_t modo = 0u; modo < N_MODOS; modo++) {
		printf("%-8s ", NOMBRE_MODO[modo]);
		for (uint8_t paso = 0u; paso < N_PASOS; paso++) {
			putchar((PATRON_LED[modo][paso] != 0u) ? '#' : '.');
		}
		putchar('\n');
	}
	printf("La tabla ocupa %zu bytes\n", sizeof(PATRON_LED));
	return 0;
}
