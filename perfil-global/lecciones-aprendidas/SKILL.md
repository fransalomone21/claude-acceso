---
name: lecciones-aprendidas
description: Registro acumulado de lecciones de proceso (no de codigo) que ya costaron tiempo al menos una vez, mas el protocolo para agregar nuevas. Leer al empezar una tarea de investigacion o debugging. Escribir al cerrar cualquier tarea donde algo fallo por como se trabajo, no por que decia el codigo.
---

# Lecciones aprendidas

Errores de **proceso**, no de código. Cada uno costó tiempo real al menos una
vez. El código roto se arregla y se olvida; estos vuelven a pasar salvo que
estén escritos.

Esto es distinto de la bitácora de un proyecto: la bitácora registra qué pasó
en *ese* proyecto. Esto registra cómo trabajar mejor en *cualquiera*.

---

## 1. "No puedo" es una afirmación sobre el mundo y necesita evidencia

La regla de evidencia (hipótesis ≠ confirmado) aplica también a las propias
capacidades. Declarar algo imposible sin verificarlo es el mismo error que
declarar una dirección de memoria confirmada sin verla en pantalla.

**Origen:** se afirmó dos veces "no puedo manejar el debugger" sin revisar.
La verificación real (leer la tabla de opcodes del protocolo, buscar
alternativas, chequear qué puertos escuchaban en la máquina) tardó tres
minutos y cambió el mapa: existía un canal que sí lo permitía, sólo que
requería otra build. La respuesta final siguió siendo "no", pero por razones
distintas y con un camino alternativo identificado.

**Cómo aplicarla:** antes de responder "no se puede", nombrá qué evidencia
concreta lo respalda. Si no hay ninguna, buscala primero.

---

## 2. Observar antes que intervenir

Cuando dos métodos responden la misma pregunta, elegir el que **no modifica**
el sistema observado. La intervención se reserva para cuando la observación
ya no alcanza.

**Origen:** para identificar cuál dirección de memoria era la vida del
jugador, escribir valores de prueba era destructivo (crasheó el emulador) y
los breakpoints requerían intervención manual. Muestrear pasivamente los
candidatos mientras el usuario jugaba resolvió la pregunta entera con cero
riesgo.

**Cómo aplicarla:** ante un candidato a modificar, preguntarse primero si
alcanza con mirarlo cambiar.

---

## 3. Reformular la pregunta antes de resolver la difícil

Si un paso parece requerir una capacidad que no tenés, el problema puede
estar en cómo está planteada la pregunta, no en la capacidad que falta.

**Origen:** se estaba resolviendo "cómo pongo un breakpoint" cuando la
pregunta real era "cómo correlaciono un valor con un evento observable". La
segunda tenía una respuesta que ya estaba en la caja de herramientas del
proyecto, sin herramientas nuevas ni riesgo.

**Cómo aplicarla:** cuando aparece un bloqueo, escribir la pregunta un nivel
más arriba de abstracción y ver si se disuelve.

---

## 4. Causalidad y descarte de la alternativa, no sólo correlación

Correlación fuerte da confianza alta, no confirmación. Confirmación es:
intervenir en la causa y ver el efecto, **más** descartar explícitamente la
hipótesis alternativa más plausible.

**Origen:** la correlación temporal entre una dirección y los eventos de daño
era casi perfecta. Lo que la volvió confirmación fueron dos cosas: escribir
en esa dirección y ver que un valor derivado se recalculaba solo, y después
comprobar que la hipótesis rival (que fuera munición de reserva, porque el
HUD mostraba un número casi idéntico) quedaba descartada porque la munición
no se movió.

**Cómo aplicarla:** antes de declarar algo confirmado, nombrá en voz alta la
segunda explicación más probable y diseñá el test que la mata.

---

## 5. Un valor derivado se parece muchísimo a su fuente

Dos valores pueden moverse en los mismos instantes exactos y ser cosas
distintas: uno la fuente, el otro lo que se dibuja. Escribirle a un derivado
puede romper el sistema, porque suele estar acotado a un rango que la fuente
no tiene.

**Origen:** dos direcciones se movían en timestamps idénticos. Una era la
vida (continua, con decimales); la otra, los segmentos de la barra del HUD
(entero, rango 0-8). Escribirle 999 a la segunda crasheó el emulador a
pantalla negra: era un índice de render fuera de rango.

**Cómo aplicarla:** un valor entero y acotado que acompaña a uno continuo es
casi siempre el espejo, no el original. Escribí en el continuo.

---

## 6. Los recuerdos del usuario son pistas, no datos

Tratarlos como hipótesis de baja confianza. Sirven para desempatar entre
finalistas al final; no para descartar candidatos al principio.

**Origen:** "la vida máxima era ~1200" resultó falso (era ~440 y subiendo).
Usarlo como filtro fuerte habría descartado la dirección correcta.

**Cómo aplicarla:** agradecé el dato, anotalo como hipótesis, y no lo pongas
en el camino crítico hasta tener con qué contrastarlo.

---

## 7. Instalado no es instalado hasta que se verificó que el sistema lo lee

Copiar un archivo a una ruta no garantiza que la herramienta lo cargue. La
verificación es ver el efecto, no ver el archivo.

**Origen:** un skill quedó "instalado" durante días en
`~/.claude/claude-code-skills/`, una carpeta que Claude Code no lee. El
script de verificación confirmaba que el archivo existía — que era cierto e
inútil. La convención real era `~/.claude/skills/`. El síntoma: el skill
nunca aparecía disponible, y eso se atribuyó a otra cosa.

**Cómo aplicarla:** un verificador tiene que comprobar el **efecto**
(¿aparece en la lista?, ¿responde?), no la **precondición** (¿existe el
archivo?).

---

## Protocolo para agregar una lección

Una entrada nueva entra sólo si cumple las tres:

1. **Costó tiempo real**, no es una precaución teórica.
2. **Es de proceso, no de código.** Un bug arreglado va a la bitácora del
   proyecto; cómo se llegó a trabajar mal va acá.
3. **Va a volver a pasar** en otro proyecto, no sólo en este.

Formato: título en imperativo o afirmación corta · **Origen** (el caso
concreto, con lo que costó) · **Cómo aplicarla** (qué hacer distinto la
próxima vez).

Si una lección nueva contradice una vieja, no se agrega al final: se corrige
la vieja. Este archivo no es historial.
