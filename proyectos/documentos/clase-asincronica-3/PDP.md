# PDP — Clase Asincrónica 3 (Teoría de Circuitos, UNSAM)

## 1. El problema

La cátedra pide resolver doce problemas de **Nilsson y Riedel** (caps. 6, 7 y 8)
de dos formas —analítica y por simulación— y **registrar el procedimiento**: el
circuito simulado, la configuración del análisis, las gráficas y la comparación
cuantitativa entre cálculo y simulación. El profesor entregó seis `.asc` de
ejemplo, no los problemas.

Lo que duele: una simulación que "parece bien" no prueba nada, y la configuración
con la que se hizo —qué directivas, qué paso de integración, qué se graficó y
cómo— se pierde en cuanto se cierra LTspice. LTspice guarda la configuración de
paneles en un `.plt` aparte que ni siquiera se escribe hasta cerrar la ventana.

**Para quién es:** Fran, para la Carpeta de Ingeniería de la materia. Y en
segundo lugar para quien abra un `.asc` dentro de seis meses sin acordarse de
nada — que también es Fran.

**Cómo sabremos que sirvió (validación):** que alguien pueda abrir cualquiera de
los diecisiete archivos, con doble clic y sin leer ningún otro documento, y
entender qué problema resuelve, qué hace cada directiva, cómo armar la gráfica y
qué número tiene que dar.

## 2. Qué NO es

- **No es un informe en Typst.** La guía lo dice explícitamente: *"No es
  necesario entregar un informe independiente, pero sí debe quedar registrado el
  procedimiento"*. El registro va adentro de las simulaciones. Si más adelante la
  cátedra pide un PDF, se arma con `/pdf-con-codigo` a partir de lo que ya está.
- **No incluye la medición en el laboratorio.** La guía la menciona como tercer
  paso; este proyecto cubre calcular y simular.
- **No responde las cinco preguntas de "Para pensar".** Son de redacción y van en
  la Carpeta, no en un `.asc`. Quedan como pendiente explícito.
- **No genera archivos `.plt`.** Se evaluó: el formato no está documentado por
  Analog Devices y un `.plt` mal armado abre un panel vacío sin decir por qué.
  En vez de eso, la receta de la gráfica va escrita, paso por paso, en la hoja.

## 3. Naturaleza y criticidad

| Campo | Valor |
|---|---|
| Naturaleza | `documentos` |
| Criticidad | `importante` — es una entrega con nota; rehacerla cuesta horas, pero no se pierde nada irrecuperable |
| Rigor que le corresponde | verificación automática registrada, y el verificador probado rompiéndolo |

**Sensibilidad: pública.** No hay datos personales ni de terceros: ni carátula,
ni mails, ni nombres de compañeros. Por eso vive en `claude-acceso` y no en un
repo aparte, a diferencia de `teoria-circuitos`. **Si algún día se le agrega una
carátula con los mails del grupo, deja de poder vivir acá** — es la regla 2 del
`CLAUDE.md` raíz, y la regla 5 de `verificar-estructura.ps1` lo mide.

## 4. Las fases

| # | Fase | Criterio de salida (resultado verificable) | Estado |
|---|---|---|---|
| 0 | Reconocimiento | los doce enunciados extraídos del Nilsson con sus figuras, y LTspice localizado y corriendo en batch | **CERRADA** 2026-09-04 |
| 1 | Construcción | los 17 `.asc` generados, corridos, y `verificar.py` en verde con el sabotaje probado | **CERRADA** 2026-09-04 |
| 2 | Segunda pasada y redacción | las cinco preguntas de "Para pensar" contestadas y la entrega armada para la Carpeta de Ingeniería | abierta |

**Fase en curso:** 2 — Segunda pasada y redacción.

**Qué la cierra, exactamente:** que existan, escritas, las respuestas a **dos**
de las cinco preguntas de "Para pensar" (la guía pide dos, no las cinco), y que
la carpeta de entrega esté armada con los `.asc`, sus `.log` y las capturas de
las gráficas que la guía pide en el punto 3 del entregable mínimo.

Las tres no idealidades que la guía pide en la segunda pasada **ya están** —
`X1`, `X2` y `X3`, una por cada tipo de circuito, con los valores supuestos
declarados y las cuatro preguntas contestadas adentro de cada archivo.

## 5. Riesgos

| Riesgo | Prob. | Consec. | Estrategia | Disparador observable |
|---|---|---|---|---|
| Los valores tomados del libro escaneado están mal leídos | baja | alta | mitigar: cada figura se recortó a 300–400 dpi y se leyó ampliada; la reducción de la red del 6.25 se hizo paso por paso y la simulación la confirma | un `.meas` que no cierra contra el cálculo y el cálculo tampoco cierra contra sí mismo |
| Una edición a mano de un `.asc` se pierde en la próxima corrida | media | media | aceptar y avisar: está escrito en el contrato del proyecto | un cambio que "desaparece" después de `verificar.py` |
| La versión de LTspice cambia y mueve algún resultado | baja | media | vigilar: `verificar.py` compara contra el cálculo analítico, no contra una corrida anterior, así que un cambio de versión que altere un número lo pone en rojo | `verificar.py` en rojo sin que nadie haya tocado nada |
| La cátedra pide después un informe formal | media | baja | aceptar: el material está todo y se arma con `/pdf-con-codigo` | un enunciado nuevo en el campus |

## 6. Decisiones

| Fecha | Decisión | Alternativas descartadas | Por qué perdieron |
|---|---|---|---|
| 2026-09-04 | La explicación va **adentro** del `.asc`, como comentarios de LTspice | un README por problema; un informe único | un README no se abre al hacer doble clic en un esquemático, que es como se usa el archivo |
| 2026-09-04 | Los `.asc` se **generan** con Python, no se dibujan a mano | dibujarlos en la GUI de LTspice | un cable que no llega a tocar un pin no da error de compilación; las coordenadas de los pines salen de los `.asy` de la instalación |
| 2026-09-04 | Conmutador **dibujado** en 7.1, 7.21 y 7.25; `.ic` en 7.4, 7.8, 7.23, 8.1 y 8.38 | dibujarlo siempre; usar `.ic` siempre | donde el enunciado pregunta por el antes *y* el después (7.1) hace falta el conmutador; donde da la respuesta ya empezada, dibujar el pasado es trabajo sin información. Y un conmutador que abre antes de cerrar sobre una bobina es una derivada infinita |
| 2026-09-04 | Se agregan dos hojas de `.op` (7.1b y 7.8b) que el enunciado no pide | resolver el estado previo a mano y escribirlo | `.op` es la herramienta correcta para una pregunta de régimen permanente, y el archivo lo demuestra en vez de afirmarlo |
| 2026-09-04 | Nada de `.plt` | generarlos junto al `.asc` | formato no documentado y sin forma de verificarlo sin abrir la GUI; un `.plt` mal armado falla en silencio |
| 2026-09-04 | Se guardan los `.log` en git y no los `.raw` | guardar todo; guardar nada | los `.log` son 62 KB y son la evidencia; los `.raw` son 178 MB y se rehacen en 40 s |

## 7. Verificación

**Cómo se verifica cada entregable:** `python verificar.py` regenera los
diecisiete `.asc`, los corre en batch con LTspice y compara **97 controles**
contra los números calculados a mano, que están escritos en el bloque `CONTROL`
de cada archivo. Tolerancia 2 %, o absoluta cuando el esperado es cero.

Los dos `.op` no dejan resultados en el `.log`: van al `.raw`, y por eso LTspice
se llama con `-ascii` y `verificar.py` los lee de ahí.

**Qué se registra de cada verificación:** el `.log` de cada corrida queda
commiteado, con la versión de LTspice en la primera línea. La tabla de
calculado-contra-medido está en `ltspice/LEEME.md`. Las deficiencias y límites
detectados están en la sección "Las cuatro trampas" del mismo archivo, cada una
con el síntoma exacto tal como se veía antes de entenderla.

**El verificador, ¿alguna vez falló?** Sí. `python probar-verificador.py` le mete
cinco defectos de clases distintas —un valor de componente, una condición
inicial, un valor barrido por `.step`, un circuito que directamente no corre, y
un `.meas` borrado—, exige rojo en los cinco, restaura y vuelve a correr el
verificador entero para comprobar que el disco quedó limpio. Corrido el
2026-09-04: los cinco detectados, control positivo en verde, disco limpio.

Y falló **de verdad**, no sólo cuando lo saboteé: la primera corrida encontró
cinco defectos reales (el `Rser` por defecto de las bobinas, el nodo integrador
sin `.ic`, el `.meas` de `.ac` en decibeles, el `DERIV AT 0`, y el interruptor S2
con los pines de mando cortocircuitados), más **un error en mi propia
predicción** sobre los cruces por cero del 8.1.
