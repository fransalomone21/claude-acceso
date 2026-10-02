#include <stdio.h>
#include <stdint.h>

int main(void) {
	uint16_t mv = 3790;   /* bateria: 3000 mV es 0 %, 4200 mV es 100 % */

	uint16_t mal   = (mv - 3000) / (4200 - 3000) * 100;   /* divide primero: 790/1200 = 0 */
	uint16_t bien  = (mv - 3000) * 100 / (4200 - 3000);   /* multiplica primero */
	float    exact = (mv - 3000) * 100.0f / (4200 - 3000); /* un float en la cuenta */

	printf("mal   : %u %%\n", mal);
	printf("bien  : %u %%\n", bien);
	printf("exact : %.1f %%\n", exact);
	return 0;
}
