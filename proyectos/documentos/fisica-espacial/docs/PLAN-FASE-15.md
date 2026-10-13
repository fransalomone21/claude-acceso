# Plan de la fase 15 — el material del 28/09 y lo que pidió Aníbal

Escrito el 2026-10-13, cuando Fran pidió incorporar todo al apunte en la
misma sesión. Por eso este plan nace **ejecutado**: cada fila dice dónde
quedó escrito, no dónde iría. La fase 15 era de tipo C (decidir qué entra y
dónde, sin escribir); la escritura es la fase 16 (`PDP.md`).

Material: `C:\Users\frans\Desktop\01 - UNSAM\Fisica Espacial\Material catedra\2026-09-28 Impulso angular\`.
Lo que dice cada archivo, textual o descripto, quedó en el repo privado
`catedras/fisica-espacial/REGISTRO.md`, entradas ANI-R2b y ANI-R3.

## Los nueve archivos

| Archivo | Qué dice (dónde) | ¿Entra? | Dónde quedó |
|---|---|---|---|
| `Repaso impulso angular.pptx` | 9 diapositivas, todas imagen, recortes del Sears: mano derecha para ω (diap. 1), la energía cinética sumada partícula por partícula hasta que aparece $I$ (diap. 2, ec. 9.16), Tabla 9.2 (diap. 3), torca escalar y vectorial (diap. 4–5, ecs. 10.2–10.3, Fig. 10.4), §10.5–10.6 (diap. 6–7), Beer 18.33 y 18.35 (diap. 8–9) | Ya estaba casi todo desde la fase 9 (módulo `rotacion`, que sigue al Sears en el mismo orden). Confirma que «el $I$ aparece al escribir la energía» es esta presentación | `rotacion` §2 (energía → $I$), §4 (torque y mano derecha); los Beer 18.33/18.35 son del tipo del Problema 1 de CR (satélite con propulsores), ya en `inercia` |
| `Analogía Precesión - MCU.pdf` | El párrafo del Sears §10.7 (pág. 324) de la pelota atada a una cuerda, con dibujo a mano: $Delta bold(p) arrow.r Delta bold(L)$, $bold(F) arrow.r bold(tau)$ (1 pág.) | Sí: es ANI-20 | `rotacion`, «Primera explicación: el movimiento circular uniforme, con L en lugar de p», con la tabla satélite ↔ giróscopo; y anticipado en `gravitacion`, al final de la pseudo-ingravidez |
| `Giroscopos como Actuador_Sensor.pdf` | Hoja manuscrita: $bold(M)$ entrada → $bold(Omega)$ salida (actuador) y $bold(Omega)$ entrada → $bold(M)$ salida (sensor), $bold(M) = bold(Omega) times bold(L)$, vistas de frente y de arriba (1 pág.) | Sí | `rotacion`, «Actuador y sensor: la misma ecuación leída para los dos lados» |
| `Video 2 ventilador.mp4` | 57 s, Aníbal girando un ventilador encendido con las manos; se ve el aparato resistirse y torcerse a 90° (cuadros cada 4 s; el audio no se transcribió) | Sí, como ejemplo | `rotacion`, misma sección (el sensor en vivo); y el Ejercicio 6 del parcialito 4 |
| `lappas2002.pdf` | CMG de un cardán para microsatélites: $h = 0,35$ N·m·s a 20 000 rpm, cuatro CMG dan 52,5 mN·m, «amplificación de torque» (Tabla 3, pág. 109) | Sí, como aplicación | `rotacion`, misma sección (CMG); Ejercicio 10 del parcialito 4 |
| `wrigley1965.pdf` | El giróscopo como referencia de dirección y para guiado inercial; modelo vectorial $bold(M) = bold(omega) times bold(H)$; giróscopos de uno y dos grados de libertad; bloqueo de cardán (págs. 713–714) | Sí, como aplicación | `rotacion` (guiado inercial y girocompás) y `euler-giroscopo` (bloqueo de cardán, caja de cuaterniones) |
| `Niña con rueda.pdf` | El parcialito 3: la estudiante que intenta subir el eje de una rueda que gira (1 pág.) | Ya estaba en los modelos de parcial | `rotacion`, sección del sensor (como ejemplo de lo mismo); modelos de parcial 4 (Ej. 6) |
| `Rueda - resolucion.pdf` | La resolución: el eje no sube, se tuerce a la derecha de ella; «el vector spin persigue al vector torque» (2 págs.). Autoría `hipótesis` (ANI-R3) | La idea sí, el documento no | `rotacion`, «Tercera explicación» (la regla, con fuente en Meriam, que la dice igual) |
| `Parcialito_3_Salomone.pdf` | La respuesta de Fran al parcialito 3 | No: es personal | — |

## Los cinco pedidos de ANI-R1

| Criterio | Pedido | Dónde quedó |
|---|---|---|
| ANI-20 | Analogía giróscopo ↔ órbita | `rotacion`, «Primera explicación…» (tabla de seis filas) y la caja rosa del giróscopo; `gravitacion` lo anticipa |
| ANI-21 | Pseudo-ingravidez | `gravitacion`, «La pseudo-ingravidez: por qué flota la astronauta» (S&Z §5.2 pág. 139 y §13.4 pág. 408) |
| ANI-23 | El momento de inercia aparece al escribir la energía cinética | `rotacion` §2, desde la fase 9; confirmado contra la diapositiva 2 del `Repaso` |
| ANI-24 | No se calculan momentos de inercia: se va a la tabla | `rotacion` §2 (tabla de seis cuerpos) desde la fase 9; ahora además `inercia`, «Los ejes principales sin calcular nada: la simetría» |
| ANI-25 | Steiner: que exista y qué dice | `rotacion` §3 desde la fase 9; ahora además la versión completa (con productos) en `inercia` |

## El choque C1

**Sigue abierto.** El 1er parcial (ANI-R4) también dice «el impulso angular
del satélite» por $bold(h)$: la cátedra lo usa en el examen. El apunte sigue
diciendo «momento angular» con la aclaración donde hace falta; la pasada de
las ~30 apariciones no se hizo. Lo decide Fran.

## Lo que llegó el 2026-10-13 y entró en la misma pasada

| Material | Dónde quedó |
|---|---|
| `Kleppner D-322-327.pdf` (§8.3–8.4) | `rotacion`: la pregunta correcta (por qué no oscila como un péndulo), $Omega$ independiente del ángulo (Ej. 8.7), la demostración con dos masas (Ej. 8.8), la precesión de los equinoccios (Ej. 8.9) y el girocompás (Ej. 8.10) |
| `J.L. Meriami-266-272.pdf` (art. 7/11) | `rotacion`: la analogía partícula ↔ rotor en forma vectorial y «el spin persigue al torque» |
| `CR 1a_clase_26.docx` | `cinematica-cr` (órbita y actitud, el rígido como idealización); `inercia` (mancuerna inclinada, cinco reglas de simetría, desigualdad triangular, ejes perpendiculares, Steiner completo, clasificación de trompos, CubeSat 3U); `euler-giroscopo` (cuaterniones, eje intermedio, Explorer 1) |
| `Temas de CR_2 (1).docx`, `Lista de temas Impulso angular (2).pdf` | Idénticas a las transcriptas en `fuentes/TEMARIO.md`, salvo la fila «Definición CR ¿?», que contesta `cinematica-cr` |
| `1er parcial 2026.pdf` | Registrado en `catedras` (ANI-R4, criterios ANI-41 a 47). Sus temas ya estaban en el apunte (`hiperbola`, `perifocal-lagrange`, `cohete`) |
