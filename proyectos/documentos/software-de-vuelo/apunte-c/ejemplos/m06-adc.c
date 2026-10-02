/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define ADC_CUENTAS_MAX   4095u   /* ADC de 12 bits */
#define ADC_VREF_MV       3300u

/* Functions declaration */
static uint16_t adc_a_mv(uint16_t cuentas);

int main(void) {
	/* Main program */
	const uint16_t panel_x   = 2048u;   /* sensor de corriente del panel +X */
	const uint16_t panel_y   = 3790u;
	const uint16_t termistor = 4095u;  /* tope de escala */

	printf("panel +X : %4u cuentas = %4u mV\n", panel_x, adc_a_mv(panel_x));
	printf("panel +Y : %4u cuentas = %4u mV\n", panel_y, adc_a_mv(panel_y));
	printf("termistor: %4u cuentas = %4u mV\n", termistor, adc_a_mv(termistor));
	return 0;
}

/* Functions definition */
/* Convierte una lectura cruda del ADC a milivolts en el pin */
static uint16_t adc_a_mv(uint16_t cuentas) {
	uint32_t mv = ((uint32_t)cuentas * ADC_VREF_MV) / ADC_CUENTAS_MAX;
	return (uint16_t)mv;
}
