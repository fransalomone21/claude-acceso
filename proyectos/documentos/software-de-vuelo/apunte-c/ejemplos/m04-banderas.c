/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define PWR_GPS      (1u << 0)
#define PWR_MAG      (1u << 1)   /* magnetometro */
#define PWR_TX       (1u << 2)   /* transmisor de radio */
#define PWR_CALEF    (1u << 3)   /* calefactor de la bateria */
#define PWR_CAMARA   (1u << 4)

/* Functions declaration */
static void imprimir_bits(const char *paso, uint8_t valor);

int main(void) {
	/* Main program */
	uint8_t potencia = PWR_GPS | PWR_MAG;          /* lo que arranca prendido */
	imprimir_bits("arranque", potencia);

	potencia |= PWR_TX | PWR_CAMARA;               /* prender dos, sin tocar el resto */
	imprimir_bits("+TX +camara", potencia);

	potencia &= ~PWR_CAMARA;                       /* apagar uno, sin tocar el resto */
	imprimir_bits("-camara", potencia);

	potencia ^= PWR_CALEF;                         /* conmutar: si estaba apagado, prende */
	imprimir_bits("^calefactor", potencia);
	potencia ^= PWR_CALEF;                         /* y otra vez: vuelve a como estaba */
	imprimir_bits("^calefactor", potencia);

	printf("TX prendido? %u  camara prendida? %u\n",
	       (potencia & PWR_TX) != 0u, (potencia & PWR_CAMARA) != 0u);
	return 0;
}

/* Functions definition */
static void imprimir_bits(const char *paso, uint8_t valor) {
	printf("%-12s 0x%02X  ", paso, valor);
	for (uint8_t mascara = 0x80u; mascara != 0u; mascara >>= 1) {
		putchar(((valor & mascara) != 0u) ? '1' : '0');
	}
	putchar('\n');
}
