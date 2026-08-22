# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-22**, PC, **con el juego corriendo**.
**7b CERRADA, con negativo confirmado.** `+0x78` de un personaje fija el
modelo visual del arma, no el bloque de IA que la dispara de verdad. Lo que
sigue (7c) es leer desensamblado para encontrar quién escribe de verdad el
array de `0x006E18B8` al spawnear — no es jugar ni escribir memoria.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — el bloque de **7b** en N2 (ya dice CERRADA,
   negativo) y la fila de `+0x78` en la tabla de hechos.
2. `black/docs/03-bitacora.md`, **sólo la entrada (33)**. La (32) está
   resumida acá abajo si hace falta más detalle de cómo se armó el ISO.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`, `docs/05-iso.md`,
`docs/90-glosario-ee.md`, las entradas (29)–(32), y nada de `perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**7b está cerrada.** La pregunta que sigue abierta es **7c — de dónde sale
el puntero que el juego escribe en `0x006E18B8 + n*0x24 + 0x04` al spawnear
un enemigo.** Cierra cuando se identifique la función que hace esa escritura
(por xref al array, en frío, sobre el ELF) y de qué campo del registro de
personaje —o de qué otra tabla— saca el valor.

**Por qué no es `+0x78`, medido:** `Black-mod-7b.iso` (parche en
`STLEVEL.BIN` de `E_BLACKHD_M0`, `+0x78 → RPG0`) jugado hasta `LEVEL_00`,
expuesto a los enemigos, array de 10 completo. El registro en RAM YA leía
`+0x78 = 'RPG0'` y aun así `n=4,5,6,7,9` seguían apuntando al bloque de IA
de siempre (`0x01842C40`, igual que el control `n=3`). Las dos mitades
confirmadas: la causa se escribió (se ve en el propio registro) y el efecto
no se produjo (se ve en el array). Detalle completo, con las direcciones
exactas de cada lectura: bitácora (33).

**Candidatos sin probar, quedaron anotados en `kb/estructuras.json`:**
`personaje+0x8C` (`DISTANT0=4, MGNDST0=4, MGNDST2=6, RPG0=3` — mismo grupo
que el arma pero con menos resolución) y `personaje+0xA8` (float, coincide
con facción más que con arma). Ninguno se probó: Fran decidió cerrar 7b con
el negativo en vez de parchear el ISO de nuevo.

**Por qué 7c es mejor camino que seguir probando campos a ciegas:** ya se
probó el candidato con más evidencia circunstancial (`+0x78`, el único que
particionaba con resolución completa) y falló. Seguir con `+0x8C`/`+0xA8`
es la misma apuesta de nuevo. Leer quién escribe el array de verdad
contesta la pregunta una sola vez, para cualquier campo que sea.

**Modelo: OPUS.** Es desensamblado nuevo (xref sobre `0x006E18B8`, subir al
llamador, leer en C) — territorio de formar hipótesis, no de ejecutar un
runbook. **Esfuerzo: alto, sin fan-out** — es lectura de un solo hilo.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

- **`+0x78` de un personaje = modelo VISUAL del arma, confirmado.**
  `FUN_00136848` compone `<+0x78>_LOD` y carga esa geometría. No toca el
  array de `0x006E18B8`.
- **El array de armas se llena progresivamente al spawnear, no con el
  stage.** Con el jugador en `LEVEL_00` pero sin ver enemigos, `n=9` daba
  puntero nulo. Hace falta estar expuesto a los tiradores para leer las 10
  entradas con sentido. `kb/mapa-memoria.json#array_shooters_0x24` tiene la
  nota.
- **El parche de ISO funciona de punta a punta, confirmado por tercera vez**
  (ya lo habían confirmado 6.6 y 7a): `parche_iso.py` edita in-place, el
  juego carga el valor nuevo en RAM al leer el archivo del stage. La técnica
  no es lo que falló acá — falló la hipótesis sobre qué campo leer.
- **`entidad+0x58` es el puntero al registro de personaje** (paso `0xB0`),
  no una escuadra. Sigue valiendo de la (32)/(31).
- Estructura completa del registro de personaje, con offsets y confianza:
  `kb/estructuras.json`, no hace falta releer la bitácora para eso.

## 4. LO QUE SIGUE, CONCRETO

```
python herramientas/ubicaciones.py          # control positivo del entorno
python herramientas/decompilar.py info      # control positivo de Ghidra
python herramientas/xref.py --help          # repasar la sintaxis antes de usarlo
```

1. `xref.py` (o `decompilar.py xref`) sobre **`0x006E18B8`** en frío, sobre
   el ELF (`kb/ubicaciones.json#elf_copia`) — quién escribe ahí, no quién lee.
2. Subir al llamador hasta la función que decide el registro de arma al
   spawnear un enemigo.
3. `decompilar.py c <función>` y leerla en C. Buscar de qué campo del
   registro de personaje (o de qué otra tabla, si no es el registro) sale
   el índice o el puntero.
4. Control positivo con un dato ya conocido: la función tiene que producir
   `0x01842C40` para un `E_BLACKHD_M0` o `E_LKISS2_M0` sin parchear.

No hace falta jugar para este paso — es lectura en frío sobre el ELF. Si
hace falta un control con RAM viva, `decompilar.py estado` trae el heap
del savestate adentro de Ghidra sin necesidad de PCSX2 corriendo.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **PCSX2 quedó abierto** con **`Black-mod-7b.iso`** cargado, PID nuevo de
  esta sesión (se cerró el proceso viejo y se relanzó para garantizar el
  ISO correcto). Ejecutable:
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
  (NO el de Program Files). PINE 28011 responde.
- **RAM LIMPIA.** El nop de vida infinita en `0x0013BD20` (puesto para que
  Fran se expusiera a los enemigos sin morir) **se restauró y se releyó**:
  vuelve a valer `0xE65402F8`. Cero parches vivos.
- El jugador murió una vez en la sesión (antes de que el nop tomara
  efecto) y respawneó; no se registró en qué punto exacto del nivel quedó.
- **`Black-mod-7b.iso` no se tocó en esta sesión** (no hizo falta: la
  pregunta se contestó, no se abrió una hipótesis nueva que necesitara
  parche nuevo). `Black-mod-armas.iso` tampoco.
- Nuevo lanzador: `C:\Users\frans\Desktop\BLACK\ABRIR-BLACK-MOD-7B.bat`
  (mismo patrón que los otros dos de esa carpeta).
- **Se borró `black/HANDOFF.md`** (raíz del proyecto): era una copia
  huérfana de la Fase 6, sin tocar desde el commit `9792a5f`, y contradecía
  a este archivo. Este (`sesiones/HANDOFF.md`) es el único canónico — así
  lo señala `black/CLAUDE.md`.
- `ubicaciones.py` 13/13 al abrir esta sesión. Las rutas NO se copian a
  mano: `python herramientas/ubicaciones.py ruta iso_original`.
- **OJO, fuera del proyecto:** `perfil-global/` sigue desincronizado entre
  ramas. No correr `perfil-global/install.ps1` desde esta rama.

---

READY FOR NEW SESSION
