/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>

/* Functions declaration */
static void nombrar(uint32_t foto);

int main(void) {
	/* Main program */
	const char mision[] = "OBC-1";

	printf("\"%s\": strlen=%zu, sizeof=%zu\n", mision, strlen(mision), sizeof(mision));
	printf("el ultimo byte vale %d\n", mision[5]);

	nombrar(42u);
	nombrar(10042u);   /* la camara ya saco mas de 9999 fotos */
	return 0;
}

/* Functions definition */
static void nombrar(uint32_t foto) {
	char archivo[13];   /* IMG_ + 4 cifras + .RAW + el '\0' */
	int necesita = snprintf(archivo, sizeof(archivo), "IMG_%04" PRIu32 ".RAW", foto);

	if ((necesita < 0) || ((size_t)necesita >= sizeof(archivo))) {
		printf("foto %" PRIu32 ": \"%s\" no entraba (necesitaba %d + 1): recortado\n",
		       foto, archivo, necesita);
	} else {
		printf("foto %" PRIu32 ": \"%s\"\n", foto, archivo);
	}
}
