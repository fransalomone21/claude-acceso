#include <stdio.h>
#include <stdint.h>

int main(void) {
	printf("char     : %zu byte\n", sizeof(char));
	printf("short    : %zu bytes\n", sizeof(short));
	printf("int      : %zu bytes\n", sizeof(int));
	printf("long     : %zu bytes\n", sizeof(long));
	printf("float    : %zu bytes\n", sizeof(float));
	printf("double   : %zu bytes\n", sizeof(double));
	printf("uint8_t  : %zu byte\n", sizeof(uint8_t));
	printf("int16_t  : %zu bytes\n", sizeof(int16_t));
	printf("uint32_t : %zu bytes\n", sizeof(uint32_t));
	return 0;
}
