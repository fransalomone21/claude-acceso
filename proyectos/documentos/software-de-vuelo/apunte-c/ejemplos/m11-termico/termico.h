/* termico.h -- la interfaz del control termico: lo que el resto del OBC puede usar */
#ifndef TERMICO_H
#define TERMICO_H

#include <stdint.h>

typedef struct {
	int16_t prender_dc;   /* por debajo, se prende el calefactor */
	int16_t apagar_dc;    /* por encima, se apaga */
} termico_config_t;

void     termico_iniciar(const termico_config_t *cfg);
uint8_t  termico_actualizar(int16_t temp_dc);   /* 1: el calefactor queda prendido */
uint16_t termico_conmutaciones(void);

#endif /* TERMICO_H */
