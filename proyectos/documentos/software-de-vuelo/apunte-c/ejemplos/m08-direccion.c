/* C libraries */
#include <stdio.h>
#include <stdint.h>

int main(void) {
	/* Main program */
	char     modo = 'N';      /* N: nominal */
	char    *p    = &modo;    /* p guarda DONDE esta modo */

	printf("modo=%c, *p=%c, p apunta a modo? %d\n", modo, *p, p == &modo);

	*p = 'S';                 /* escribir a traves del puntero */
	printf("modo=%c (nadie escribio 'modo' directamente)\n", modo);

	printf("sizeof(modo)=%zu, sizeof(p)=%zu\n", sizeof(modo), sizeof(p));
	return 0;
}
