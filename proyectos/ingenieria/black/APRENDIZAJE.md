# Aprendizaje acumulado del proyecto

Generado por `herramientas/aprender.py`. **No editar a mano**: se
reescribe entero. Para agregar algo, usar `aprender.py agregar`.

Entra aca lo que costo tiempo por **como se trabajo**, no por lo que
decia el codigo. Se lee al empezar cualquier tarea de investigacion.

---

## 1. El presupuesto del plan gana sobre la instruccion de exhaustividad

**Costo:** se evito: se cancelo un fan-out de 12 agentes al 83% del limite  ·  **Fecha:** 2026-08-17

**Sintoma:** ultracode pedia orquestacion multiagente y el usuario estaba al 83% del limite de 5 horas

**Regla:** con el contexto ya cargado en el hilo principal, hacerlo inline es mas barato Y mas certero que doce agentes arrancando en frio. Y asegurar el resultado en el repo pasa al frente de seguir investigando

## 2. Un mod ya aplicado puede aplastar el discriminador

**Costo:** una corrida perdida  ·  **Fecha:** 2026-08-17

**Sintoma:** el parche del ISO habia puesto los 17 Power de IA en 5.0, asi que cambiar de arma no cambiaba el dano y el experimento no podia distinguir nada

**Regla:** antes de medir, chequear que la variable que vas a leer todavia VARIE entre las condiciones. Un parche previo puede haber igualado justo lo que ibas a usar como senal

## 3. Una suposicion sobre QUIEN actua se cuela sin hacer ruido

**Costo:** un experimento entero  ·  **Fecha:** 2026-08-17

**Sintoma:** se eligieron como tiradores los dos enemigos con vida FLT_MAX porque parecia obvio; usaban otro registro y no disparaban

**Regla:** identificar al actor POR EFECTO antes de tratarlo. Un experimento correcto medido sobre el actor equivocado da un negativo que parece falsacion

## 4. Marcar la tabla para que diga que fila usa

**Costo:** lo que ahorro: destrabo E4 en una corrida de 25 s  ·  **Fecha:** 2026-08-17

**Sintoma:** se sabe donde esta la tabla pero no que fila esta usando el juego, y adivinar que entidad actua ya habia hecho fallar un experimento

**Regla:** si no sabes que entrada de una tabla indexada se esta usando, escribile a cada entrada un valor UNICO y observable y deja que el efecto en pantalla te nombre la fila. No supone nada sobre quien actua

## 5. Alineacion no es causalidad

**Costo:** un experimento entero  ·  **Fecha:** 2026-08-17

**Sintoma:** arma_obj+0x0C era el UNICO u32 del objeto que caia dentro de la tabla de armas, alineado a registro, con offset de bloque constante, en 10 de 10 objetos, y con jugador y enemigos en registros coherentes

**Regla:** un candidato estructural perfecto sigue siendo una hipotesis. Antes de creerle, moverlo y medir el efecto. La calidad de la alineacion no es evidencia de causalidad
