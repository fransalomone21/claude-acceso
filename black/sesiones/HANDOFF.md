# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-17**, PC con PCSX2 vivo. Fase 7b **abierta y
rediseñada**; 7a cerrada.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — entero, es corto.
2. `black/docs/03-bitacora.md`, **sólo la entrada (28)** — es la de esta
   sesión y trae el mapa RAM↔archivo que cambia el costo de todo lo que sigue.
3. `black/docs/08-experimentos.md`, **el recuadro de CORRECCIÓN de E5**
   antes que el cuerpo de E5, que apunta al nivel equivocado.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md` (la máquina ya
está configurada, 13/13 en `inventario.py`), `docs/05-iso.md` (fase 6 ya está
resuelta en lo que importa acá), `docs/90-glosario-ee.md` hasta que haga falta
desensamblado, y nada de `perfil-global/`.

## 2. LA FASE QUE SE ABRE, Y QUÉ LA CIERRA

**Fase 7b — qué dato fija QUÉ TIPO de enemigo aparece.**

**Cierra cuando** se pueda cambiar qué enemigo aparece y **verlo por efecto**:
un `so1` que pasa a ser un `rg1` tiene que cambiar el registro de arma que le
toca en `0x006E18B8 + n*0x24 + 0x04`, leíble con `pine.py` sin mirar la
pantalla. Que el dato "parezca el indicado" no cierra nada.

**7c** (de dónde sale el puntero al spawnear) sigue abierta y ahora es más
barata: la imagen del stage está en RAM en dirección conocida.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

1. **Los archivos de stage se cargan LITERALES en RAM**, sin relocalizar:

   | archivo | base en EE | anclas |
   |---|---|---|
   | `LEVELS/LEVEL_00/STG_0001/STLEVEL.BIN` (2.502.240 B) | **`0x01412400`** | 7/7 |
   | `LEVELS/LEVEL_00/STG_0001/STUNIT01.BIN` (326.432 B) | **`0x01053000`** | 2/2 |

   `direccion = base + offset_en_el_archivo`. **Por eso ya no hace falta
   copiar 3,9 GB para probar una edición del nivel: se prueba en RAM,
   reversible, y recién si anda se lleva al ISO con `parche_iso.py`.**

2. **El savestate slot 3 está en `LEVEL_00`, no en `LEVEL_01`.** El plan de E5
   nombraba `LEVEL_01` por el nombre del savestate. Medido por huella de
   tamaño de los chunks residentes.

3. **`LEVEL_00/STG_0001` sólo tiene `bc1_lr1_mil` y `bc1_so1_mil`.**
   `bc1_rg1_mil` (el del RPG) está residente igual, cargado desde
   `STUNIT01.BIN` del mismo stage. El modo de falla que E5 predecía —"falta el
   modelo"— **no aplica en `LEVEL_00`**.

4. **Cadena entidad → escuadra:**
   `0x006E18B8 + n*0x24` `+0x08` → **registro de entidad `0x0065FD00 + k*0x80`**
   (`+0x10..+0x18` posición XYZ, `+0x50` facción, `+0x58` escuadra, `+0x5C`
   toma 2/3/4). El `+0x58` apunta a un **descriptor con nombre en texto**
   dentro de la imagen de `STLEVEL`: `Enemy0_None`, `Enemy0_Mid`,
   `Enemy1_Low`, `Enemy0_High`, `Team0_Tom`, `Team1_Matt`.

5. **Los dos de vida `FLT_MAX` son los COMPAÑEROS del jugador** (`Team0_Tom`,
   `Team1_Matt`). Cierra por qué no disparan, que estaba como callejón sin
   explicación.

6. **Corroboración de una hipótesis vieja:** el directorio de recursos de arma
   del stage (`STLEVEL+0x80`, 7 registros de paso `0x28`) asocia
   `0001_bg1_ak1` con `Enemy0_Mid` — la escuadra de los tiradores que medimos
   usando el **registro 5**, anotado como "ASR". Es lo que predice
   *"el código de 3 letras está corrido un registro"*. Sigue en `hipotesis`:
   nadie escribió nada para probarlo.

7. **Negativo que orienta:** **0** `u32` alineados en los 32 MB apuntan a la
   cabecera, al nombre o al payload de los chunks `bc1_`. Como sí existen
   punteros a la imagen de `STLEVEL`, el personaje se resuelve **por
   ID/nombre, no por puntero cacheado**.

## 4. LO QUE SIGUE, CONCRETO

1. Volcar la imagen del stage y buscar **la lista de puntos de spawn**:

   ```
   python herramientas/pine.py volcar 0x01412400 0x262BE0 volcados/stlevel-l00.bin
   ```

   Entradas: las apariciones "grupo B" de los nombres (tag `0x3f800000`, con
   floats alrededor) y el campo `+0x5C` del registro de entidad.
2. Escritura de prueba **en RAM**, 4 u 11 bytes, reversible.
3. Si anda, recién ahí `parche_iso.py` y el ISO.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- PCSX2 (`pcsx2-qt.exe`, build `d75a0ad`) **corriendo con el ISO ORIGINAL**,
  PINE en 28011, DebugServer en 21512.
- **Savestate slot 3 cargado.** Vida del jugador ~`999245`.
- **Cero escrituras, cero parches vivos.** Esta sesión fue toda lectura.
- Un savestate tapa cualquier mod en RAM: para ver el efecto de una edición
  del ISO hay que jugar el nivel, no cargar un estado guardado previo.
