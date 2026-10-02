/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define TC_PING         0x01u
#define TC_REINICIO     0x02u
#define TC_FOTO         0x10u
#define TC_FOTO_COLOR   0x11u

/* Functions declaration */
static void ejecutar(uint8_t codigo);

int main(void) {
	/* Main program */
	ejecutar(TC_PING);
	ejecutar(TC_FOTO_COLOR);
	ejecutar(TC_FOTO);
	ejecutar(0x7Fu);   /* un byte corrupto en el enlace */
	return 0;
}

/* Functions definition */
static void ejecutar(uint8_t codigo) {
	printf("TC 0x%02X: ", codigo);
	switch (codigo) {
	case TC_PING:
		printf("pong\n");
		break;
	case TC_REINICIO:
		printf("reinicio programado\n");
		break;
	case TC_FOTO:
	case TC_FOTO_COLOR:
		printf("camara: foto en cola\n");
		break;
	default:
		printf("desconocido, rechazado\n");
		break;
	}
}
