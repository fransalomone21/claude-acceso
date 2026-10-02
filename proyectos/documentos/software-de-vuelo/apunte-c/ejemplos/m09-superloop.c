/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>

/* Macros */
#define PERIODO_LED_MS   1500u
#define PERIODO_TM_MS    4000u
#define DURACION_MS      9000u   /* en la placa es while (1); aca, 9 segundos */

/* Global variables */
/* En la placa lo avanza el SysTick, uno por ms. Arranca 2 s antes de que el */
/* contador de 32 bits de la vuelta (pasa cada 49,7 dias)                    */
static volatile uint32_t tick_ms = 0xFFFFFFFFu - 2000u;

/* Functions declaration */
static uint32_t obtener_tick(void);
static void     simular_systick(void);

int main(void) {
	/* Main program */
	const uint32_t inicio = obtener_tick();
	uint32_t ultimo_led = inicio, ultimo_tm = inicio, ultimo_ingenuo = inicio;
	uint32_t vueltas = 0u, cuenta_led = 0u, cuenta_ingenua = 0u;

	while ((obtener_tick() - inicio) < DURACION_MS) {
		const uint32_t ahora = obtener_tick();

		if ((ahora - ultimo_led) >= PERIODO_LED_MS) {
			ultimo_led = ahora;
			cuenta_led++;
			printf("t=%5" PRIu32 " ms  LED conmuta  (tick=0x%08" PRIX32 ")\n",
			       ahora - inicio, ahora);
		}
		if ((ahora - ultimo_tm) >= PERIODO_TM_MS) {
			ultimo_tm = ahora;
			printf("t=%5" PRIu32 " ms  telemetria\n", ahora - inicio);
		}
		if (ahora >= (ultimo_ingenuo + PERIODO_LED_MS)) {   /* MAL: se rompe en la vuelta */
			ultimo_ingenuo = ahora;
			cuenta_ingenua++;
		}
		vueltas++;   /* el resto del superloop: nadie espera a nadie */
		simular_systick();
	}
	printf("%" PRIu32 " vueltas del superloop, ninguna se quedo esperando\n", vueltas);
	printf("LED: %" PRIu32 " conmutaciones; con la cuenta ingenua, %" PRIu32 "\n",
	       cuenta_led, cuenta_ingenua);
	return 0;
}

/* Functions definition */
static uint32_t obtener_tick(void) { return tick_ms; }   /* en la placa: HAL_GetTick() */
static void simular_systick(void)  { tick_ms++; }        /* en la PC, cada vuelta = 1 ms */
