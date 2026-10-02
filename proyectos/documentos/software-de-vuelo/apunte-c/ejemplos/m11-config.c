/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define OBC_MODELO        2        /* 1: el de ingenieria, 2: el de vuelo */
#define OBC_DEPURACION             /* borrar esta linea para la version de vuelo */

#if OBC_MODELO == 1
#define RAM_KB   64u
#elif OBC_MODELO == 2
#define RAM_KB   128u
#else
#error "OBC_MODELO desconocido: tiene que ser 1 o 2"
#endif

#ifdef OBC_DEPURACION
#define LOG(texto)   printf("[%s:%d] %s\n", __FILE__, __LINE__, (texto))
#else
#define LOG(texto)   do { } while (0)   /* en vuelo, desaparece */
#endif

/* Types */
typedef struct {
	uint32_t met_s;
	uint16_t bateria_mv;
	uint8_t  modo;
	uint8_t  resets;
} housekeeping_t;

/* Si alguien agrega un campo, no compila: la trama de tierra espera 8 bytes */
_Static_assert(sizeof(housekeeping_t) == 8u, "housekeeping_t ya no mide 8 bytes");

int main(void) {
	/* Main program */
	LOG("arranque");
	printf("modelo %d, %u KB de RAM\n", OBC_MODELO, RAM_KB);
	LOG("configuracion leida");
	return 0;
}
