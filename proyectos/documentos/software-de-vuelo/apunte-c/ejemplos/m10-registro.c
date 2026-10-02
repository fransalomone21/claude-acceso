/* C libraries */
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

/* Macros */
#define PIN_CALEFACTOR   9u
/* En la placa: #define GPIOC ((gpio_t *)0x40020800u). En la PC no hay */
/* periferico en esa direccion: se apunta a una variable que hace de GPIOC */
#define GPIOC   (&gpioc_simulado)

/* Types */
/* El bloque de registros de un puerto GPIO de la F446RE, en el orden del manual */
typedef struct {
	volatile uint32_t MODER;     /* 0x00: modo de cada pata */
	volatile uint32_t OTYPER;    /* 0x04 */
	volatile uint32_t OSPEEDR;   /* 0x08 */
	volatile uint32_t PUPDR;     /* 0x0C */
	volatile uint32_t IDR;       /* 0x10: lo que se lee */
	volatile uint32_t ODR;       /* 0x14: lo que se escribe */
	volatile uint32_t BSRR;      /* 0x18 */
	volatile uint32_t LCKR;      /* 0x1C */
	volatile uint32_t AFR[2];    /* 0x20 */
} gpio_t;

/* Global variables */
static gpio_t gpioc_simulado;

int main(void) {
	/* Main program */
	printf("ODR en +0x%02zX, BSRR en +0x%02zX, tamanio %zu bytes\n",
	       offsetof(gpio_t, ODR), offsetof(gpio_t, BSRR), sizeof(gpio_t));

	GPIOC->ODR |= (1u << PIN_CALEFACTOR);        /* prender el calefactor */
	printf("ODR = 0x%04X\n", (unsigned)GPIOC->ODR);

	GPIOC->ODR &= ~(1u << PIN_CALEFACTOR);       /* apagarlo */
	printf("ODR = 0x%04X\n", (unsigned)GPIOC->ODR);
	return 0;
}
