# Banco de consignas — lo que los TP realmente piden

Itemizado el **2026-09-22** desde `fuentes/TP_II_completo.pdf`, la *Guía de
Trabajos Prácticos — II Cuatrimestre* (Prof. Guillermo Ruisi, octubre 2024),
7 páginas, TP N.º 6, 7 y 8. El PDF está en el repo desde el 2026-08-23 y es
**byte por byte** el mismo archivo que `TP_II_cuatrimestre.pdf`: los dos tienen
MD5 `23556307f1dfb159f9708c4f3a5abc09`.

**Por qué existe este archivo.** El apunte se escribió *mirando* la guía, pero
nada medía si la cubría. Que el Módulo 4 hable de diodos no dice que conteste
el punto 3 del TP N.º 6, y la primera pasada de este banco encontró **seis
consignas sin ninguna sección que las respondiera** — entre ellas la parte 3
entera del TP N.º 7, que pide un circuito que el apunte no tenía dibujado. Es
la falla silenciosa de la naturaleza `documentos`: sale impreso, incompleto, y
nadie se entera hasta que alguien va al laboratorio.

## Cómo se lee la columna «Dónde se responde»

`M4 §Curva característica` es el **módulo** y el **título exacto de la
sección** de `apunte/modulos/mN-*.typ` que contesta la consigna. No es una
referencia aproximada: `verificar-cobertura.py` la resuelve contra el archivo y
se pone en rojo si el módulo o la sección no existen. Varias anclas se separan
con ` · `; la primera es la que alcanza para contestar y las que siguen amplían.

Una celda vacía es una **consigna huérfana** y es rojo. La única excepción
admitida se escribe `PENDIENTE — <motivo>`: es una consigna que el apunte
todavía no cubre **a propósito**, con la razón al lado. El verificador las
cuenta y las nombra por separado, igual que la matriz de cumplimiento cuenta
los recortes. Declarar una excepción es un acto, no un silencio.

**43 consignas, 42 mapeadas, 1 diferida.**

## TP N.º 6 — Polarización del diodo

| # | Lo que pide la consigna | Dónde se responde |
|---|---|---|
| 1 | Armar el circuito y medir $I_T$ y $V_D$ variando $V_S$ de 0 a 1,2 V de a 0,1 V | M4 §Levantar la curva en el laboratorio · M4 §Curva característica |
| 2 | Repetir la misma operación cambiando la polarización del diodo | M4 §Levantar la curva en el laboratorio · M4 §Polarización |
| 3 | Pasar los puntos a un par de ejes en hoja milimetrada, con la escala más adecuada en ambos ejes | M4 §Levantar la curva en el laboratorio |
| 4 | Sacar conclusiones de la curva obtenida | M4 §Curva característica · M4 §Modelos del diodo |
| 5 | Armar LED + 330 Ω y subir la alimentación hasta llegar a 20 mA; medir la tensión del LED | M4 §El diodo LED |
| 6 | Repetir con LED de otros colores y sacar conclusiones | M4 §El diodo LED |
| 7 | Completar la tabla del datasheet del 1N4007: VRRM, VR, IF, IFSM, VF, IR, trr, Cj | M4 §Lectura del datasheet: el 1N4007 |
| 8 | Explicar brevemente qué significa cada una de las ocho características | M4 §Lectura del datasheet: el 1N4007 |

## TP N.º 7 — Fuentes de alimentación

### Parte 1 — Rectificador de media onda

| # | Lo que pide la consigna | Dónde se responde |
|---|---|---|
| 9 | Calcular $V_"out"$ para $V_"in" = 12 V_"RMS"$ con $R = 1$ kΩ | M4 §Rectificador de media onda |
| 10 | Calcular la corriente máxima por el diodo y la potencia disipada en la carga | M4 §Rectificador de media onda |
| 11 | Calcular el rizado en la salida con capacitor de filtrado de 100 µF | M5 §Deducción del rizado |
| 12 | Armar el circuito en el protoboard con un 1N4007 y carga de 1 kΩ | M5 §Anatomía de una fuente lineal |
| 13 | Medir con multímetro la tensión de entrada (CA) y la continua de salida sin carga y con carga | M5 §Sin carga y con carga: por qué el tester marca de más |
| 14 | Medir el rizado con el capacitor de 100 µF y registrar los valores pico a pico | M5 §El rizado se mide en alterna |
| 15 | Capturar en el osciloscopio entrada CA y salida CC antes y después del filtrado | M5 §Qué capturar, y de qué sirve |
| 16 | Comparar la tensión continua calculada con la medida | M5 §Sin carga y con carga: por qué el tester marca de más |
| 17 | Explicar cómo afecta el capacitor de filtrado al rizado, medido contra teórico | M5 §El filtro capacitivo · M5 §Deducción del rizado |

### Parte 2 — Rectificador de onda completa con puente de diodos

| # | Lo que pide la consigna | Dónde se responde |
|---|---|---|
| 18 | Calcular la tensión continua de salida para $V_"in" = 12 V_"RMS"$ | M4 §Puente de Graetz |
| 19 | Calcular la corriente máxima por **cada** diodo y la potencia disipada en la carga | M4 §Puente de Graetz · M4 §Comparación |
| 20 | Calcular el rizado en la salida con filtrado de 100 µF | M5 §Deducción del rizado |
| 21 | Armar el puente en el protoboard con cuatro 1N4007 y carga de 1 kΩ | M4 §Puente de Graetz |
| 22 | Medir la continua de salida sin carga y con carga | M5 §Sin carga y con carga: por qué el tester marca de más |
| 23 | Medir el rizado de la señal rectificada y filtrada, pico a pico | M5 §El rizado se mide en alterna |
| 24 | Capturar entrada y salida antes y después del filtrado | M5 §Qué capturar, y de qué sirve |

### Parte 3 — Fuente doble con transformador de punto medio

| # | Lo que pide la consigna | Dónde se responde |
|---|---|---|
| 25 | Con 12 V_RMS en cada bobina secundaria, calcular las continuas de salida positiva y negativa | M5 §Qué tensión da cada rama · M5 §La fuente doble (simétrica) |
| 26 | Calcular la corriente por cada rama para una carga de 1 kΩ | M5 §La fuente doble (simétrica) |
| 27 | Calcular el rizado en las tensiones positiva y negativa con filtrado de 100 µF | M5 §La fuente doble (simétrica) · M5 §Deducción del rizado |
| 28 | Armar el circuito con el transformador de punto medio y cuatro 1N4007 como puente | M5 §La fuente doble (simétrica) · M3 §Transformador con punto medio (center tap) |
| 29 | Medir las continuas positiva y negativa sin carga y con carga | M5 §Sin carga y con carga: por qué el tester marca de más |
| 30 | Medir el rizado de las señales positiva y negativa, pico a pico | M5 §El rizado se mide en alterna |
| 31 | Capturar las tensiones de salida antes y después del filtrado | M5 §Qué capturar, y de qué sirve · M5 §La masa del osciloscopio está conectada a tierra |

## TP N.º 8 — Fuente de alimentación con regulador zener

| # | Lo que pide la consigna | Dónde se responde |
|---|---|---|
| 32 | Calcular la tensión de salida sin regulación, a la salida del puente y del capacitor | M5 §El filtro capacitivo |
| 33 | Determinar el valor pico de la señal rectificada de CA | M4 §Puente de Graetz |
| 34 | Calcular el ripple de la salida sin regular considerando la carga de 1 kΩ | M5 §Deducción del rizado |
| 35 | Calcular la resistencia limitadora $R_S$ tomando 5 V como referencia de salida regulada | M5 §Criterio de diseño |
| 36 | Verificar que la corriente mínima de mantenimiento (5 mA) se cumpla en todo momento | M5 §Criterio de diseño |
| 37 | Calcular la corriente máxima por el zener y la potencia disipada por $R_S$ y por el zener | M5 §Criterio de diseño |
| 38 | Asegurar que la limitadora y el zener no excedan sus límites de potencia | M5 §Criterio de diseño |
| 39 | Medir la tensión en el punto 2 (antes del zener) con $R_L = 1$ kΩ | M5 §Sin carga y con carga: por qué el tester marca de más |
| 40 | Medir con el osciloscopio el ripple de la señal rectificada sin regular y guardar la imagen | M5 §El rizado se mide en alterna · M5 §Qué capturar, y de qué sirve |
| 41 | Medir la tensión en el punto 3 (después del zener) y comparar con el valor teórico | M5 §El regulador con diodo zener |
| 42 | Observar la señal después del zener y **evaluar la reducción del ripple** | M5 §Cuánto rizado queda después del zener |
| 43 | Registrar todos los cálculos y mediciones y adjuntar las capturas, en el formato del informe | PENDIENTE — el anexo de informes técnicos es la fase 4 del `PDP.md`, todavía sin abrir; hasta que exista, el formato lo da la guía de la cátedra y no el apunte |

## Lo que este banco NO mide

Que la sección **realmente conteste** la consigna. Eso se lee. El script atrapa
el ancla rota, el módulo cruzado y la sección renombrada —que es la clase de
error que ya se cometió en el apunte de IISE, donde 11 de 11 anclas escritas de
memoria dieron rojo— pero un ancla que resuelve a una sección irrelevante le
pasa por al lado.

Tampoco mide la guía del **I** cuatrimestre (`TP_I_cuatrimestre.pdf`, TP 1 a 5).
Eso es trabajo pendiente, y está anotado como tal en `ESTADO_ACTUAL.md`.
