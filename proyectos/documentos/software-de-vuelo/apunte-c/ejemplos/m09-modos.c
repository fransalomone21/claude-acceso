/* C libraries */
#include <stdio.h>
#include <stdint.h>

/* Macros */
#define N_EVENTOS   7u

/* Types */
typedef enum {
	MODO_ARRANQUE,
	MODO_DETUMBLING,   /* frenar el giro que dejo la separacion */
	MODO_NOMINAL,
	MODO_SEGURO,
	MODO_FALLA
} modo_t;

typedef enum {
	EV_NINGUNO,
	EV_SEPARACION,      /* se solto del lanzador */
	EV_GIRO_BAJO,       /* el giro bajo del umbral */
	EV_BATERIA_BAJA,
	EV_BATERIA_OK
} evento_t;

/* Global variables */
static const char *const NOMBRE_MODO[] = { "ARRANQUE", "DETUMBLING", "NOMINAL",
                                           "SEGURO", "FALLA" };
static const char *const NOMBRE_EV[]   = { "ninguno", "separacion", "giro bajo",
                                           "bateria baja", "bateria ok" };

/* Functions declaration */
static modo_t transicion(modo_t modo, evento_t ev);

int main(void) {
	/* Main program */
	const evento_t llegan[N_EVENTOS] = { EV_NINGUNO, EV_SEPARACION, EV_BATERIA_BAJA,
	                                     EV_GIRO_BAJO, EV_BATERIA_BAJA, EV_NINGUNO,
	                                     EV_BATERIA_OK };
	modo_t modo = MODO_ARRANQUE;

	for (uint8_t i = 0u; i < N_EVENTOS; i++) {
		const modo_t nuevo = transicion(modo, llegan[i]);
		printf("%-10s + %-12s -> %s\n",
		       NOMBRE_MODO[modo], NOMBRE_EV[llegan[i]], NOMBRE_MODO[nuevo]);
		modo = nuevo;
	}

	modo = (modo_t)9;   /* un bit dado vuelta en la RAM */
	printf("(corrupto) + %-12s -> %s\n",
	       NOMBRE_EV[EV_NINGUNO], NOMBRE_MODO[transicion(modo, EV_NINGUNO)]);
	return 0;
}

/* Functions definition */
static modo_t transicion(modo_t modo, evento_t ev) {
	modo_t siguiente = modo;   /* sin evento que importe, se queda */

	switch (modo) {
	case MODO_ARRANQUE:
		if (ev == EV_SEPARACION) {
			siguiente = MODO_DETUMBLING;
		}
		break;
	case MODO_DETUMBLING:
		if (ev == EV_GIRO_BAJO) {
			siguiente = MODO_NOMINAL;
		}
		break;
	case MODO_NOMINAL:
		if (ev == EV_BATERIA_BAJA) {
			siguiente = MODO_SEGURO;
		}
		break;
	case MODO_SEGURO:
		if (ev == EV_BATERIA_OK) {
			siguiente = MODO_NOMINAL;
		}
		break;
	case MODO_FALLA:
		break;   /* de FALLA sale tierra, con un telecomando: no se sale solo */
	default:
		siguiente = MODO_FALLA;   /* un valor que no es ningun modo */
		break;
	}
	return siguiente;
}
