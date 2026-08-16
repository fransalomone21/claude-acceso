# Estado actual

Índice operativo compacto. **Esto se lee primero**, entero, en cualquier
sesión nueva — es más rápido que releer la bitácora. Para el detalle de cómo
se llegó a cada cosa, ir a `docs/03-bitacora.md`; para qué hacer después, a
`docs/04-plan.md`.

Se actualiza cada vez que cambia algo real. No es historial — para eso está
la bitácora. Si una línea de acá contradice la bitácora, la bitácora tiene
razón y esto está desactualizado: corregirlo.

---

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — entorno | cerrada |
| 1 — ancla (vida del jugador) | cerrada |
| 2 — rutina de daño del jugador | **cerrada, confirmada por efecto** |
| 3 — enemigos | **cerrada, confirmada por efecto** (2026-08-16) |
| 4 — tabla de armas | **cerrada**, pero sólo gobierna el daño que se le hace AL jugador |
| 4b — daño de SALIDA del jugador | **resuelto en análisis; falta el test por efecto** |
| 5 — daño de enemigos por arma | siguiente |

**Fase 4 — lo que se cerró, y con qué alcance.** La tabla de armas: **17
registros de `0x1E0`**, con dos bloques de parámetros de `0x30` (`+0x90`
jugador, `+0xC0` IA) y `Power` en `+0x18` de cada bloque. Escribir
`Power = 300` cambió el daño que el jugador **recibe** (reacción de arma
pesada en pantalla) — eso está confirmado. **No** cambió el daño que el
jugador **hace**, y nunca iba a cambiarlo: son dos sistemas distintos. Ficha
en `kb/estructuras.json#arma`, cálculo en
`kb/rutinas.json#calcular_dano_por_arma`.

**Fase 4b — la respuesta.** El daño de salida del jugador sale de una tabla
por **zona de impacto** colgada del personaje de la víctima, no de `Power`:

```
daño = factor_de_zona * 100.0        calculado en 0x00142B90
```

Esa función **ignora** el daño que le llega en `$f12`. Torso = `0.255` → los
`25.5` medidos; cabeza = `1.02` → 102, mata de un tiro. Ficha en
`kb/estructuras.json#zona_impacto` y `kb/rutinas.json#calcular_dano_zona`,
las dos en `probable` hasta que se vea el efecto. Herramienta:
`herramientas/zonas.py`.

**Ninguna de las dos tablas tiene dirección fija:** las dos viven en el heap y
se mueven entre niveles y partidas. Siempre se buscan sobre un volcado fresco:

```
python herramientas/pine.py volcar 0x0 0x2000000 volcados/ee-vivo.bin
python herramientas/armas.py listar volcados/ee-vivo.bin
python herramientas/zonas.py listar volcados/ee-vivo.bin
```

**Lo único que falta para cerrar 4b:** una bala al cuerpo de un enemigo con
los factores de zona escritos en 3.0 (ya puestos, ver *Estado de la máquina*).
Si muere de una, la fase cierra. Ver `HANDOFF.md`.

---

## Hechos confirmados

| Hecho | Evidencia |
|---|---|
| Identidad: `SLUS-21376`, CRC `5C891FF1`, versión `1.00`, NTSC-U | `pine.py info` en vivo + log de arranque → `kb/objetivo.json` |
| **Vida del jugador = `0x005A8DA8`** (`jugador 0x005A8AB0 + 0x2F8`, f32) | escaneo diferencial + correlación temporal + escritura con efecto en pantalla |
| **Daño al jugador: `0x0013BD20`** (`swc1 f20,0x2F8(s2)`, `0xE65402F8`) | watchpoint de escritura + golpe real; nop = vida infinita, probado contra fuego de AK |
| **El puntero de clase está en `objeto+0x10`**, no en `+0x00` | vtable del jugador `0x003DC5F8`; reconfirmado en 2026-08-16 por `lw $v0,0x10($t3)` en `0x0015BAE4` |
| **Método virtual #8 (`vtable+0x4C`) = "recibir daño"** | censo de las 279 vtables: sólo dos clases escriben en `+0x2F8` |
| **Clase del enemigo = `0x003DCA78`** — 32 objetos, pool desde `0x0058FE90`, paso `0x3C0`, vida `100.0` en `+0x2F8` | `clases.py`, y confirmado por efecto |
| **Daño al enemigo: `0x00134654`** (`0xE61402F8`); clamp de muerte `0x00134514` | nop puesto → cargador entero de AK sin matarlo; nop seguía puesto al releerlo |
| **Tabla de armas: 17 registros de `0x1E0`, `Power` en bloque+`0x18`** — gobierna el daño que se le hace **al jugador** | `Power = 300` → reacción de arma pesada en pantalla al recibir disparos |
| **El daño de salida del jugador NO usa `Power`**: sale de `zona * 100.0` en `0x00142B90` | 0 copias de descriptores fuera de la tabla; `25.5` no existe como inmediato (control positivo OK); `0.255` aparece 9 veces en 32 MB y las 9 en la tabla de zonas. **Falta el test por efecto** |
| **Objeto de arma por tirador: `0x006DE770 + n*0x110`**, descriptor en `+0x0C`, **dueño en `+0x10`**. El del jugador es `0x006DE770` | volcado: `+0x10` = `0x005A8AB0` (jugador); los siguientes, enemigos del pool |
| **Daño = `Power * (falloff + (1-falloff)*arg/Range)`**, calculado en `0x0015B20C` | desensamblado; con `falloff = 1` da constante, que es lo que se midió en la Fase 1 (10 escalones de 26.0) |
| **Cola de daño diferido = global `0x00414AD0`** (16 registros de `0x20`, contador en `0x00414CD0`) | `lui 0x41 + addiu 0x4AD0` en `0x0015B308`; único llamador de la encoladora |
| **El esquema de campos de arma está en texto en el ELF**, `0x004008A0`-`0x004009C8` | `Range`, `Power`, `Num Bullets In Clip`, `CommonParams`/`PlayerParams`/`AIParams`… rodata muerta pero legible |
| Daño de AK47 = 26.0 al jugador; 25.5 del jugador al enemigo | 10 escalones idénticos en `volcados/correlacion-vida-2.csv`; y medición del pool 2026-08-16 |
| `0x006CF54C` = segmentos del HUD (derivado, no fuente) | se recalculó solo al escribir en la vida |
| **1200.0 y 750.0 hardcodeados en el HUD** | `lui at,0x4496` / `lui at,0x443B`+`ori 0x8000` + `div.s` en los 3 sitios lectores |
| **Código del juego en `0x00100000-0x003BFFFF`**; datos `~0x0042xxxx-0x0045xxxx` | `xref.py mapa` + histograma de `lui` |
| **Mapeo del ELF: `offset_archivo = vaddr - 0xFF000`**, un solo `PT_LOAD` | verificado 6/6 contra encodings observados en vivo |
| **Los breakpoints de EJECUCIÓN crashean el emulador**; los watchpoints no | `bp poner` mató el proceso; los watchpoints aguantaron decenas de veces |
| **Los crashes son corrupción de heap del parche, no OneDrive** | Visor de eventos: `0xc0000374` en `ntdll.dll`; `DebugServer.cpp` muta `CBreakPoints` desde el hilo del socket sin mutex |
| **`--accion log` no cuenta hits** (es un stub) | `MemCheck::Log()` vacío en el fuente de PCSX2 |
| Un volcado completo de los 32 MB por PINE tarda **~3 s** | medido 2026-08-16 |

## Callejones cerrados — no repetir

- **Los cinco `26.0` de `0x0042C3AC..0x0042D56C` NO son la tabla de armas.**
  Están en BSS, se les escribió 300.0 y no cambió ningún daño; además
  ensucian el HUD (aparecen dos barras negras en pantalla). Restaurados.
- **La tabla de armas no está en el ISO ni en el ELF.** Se carga por stage al
  heap, y `GUNS.BIN` **no** aparece literal en RAM (0/24 archivos).
- **`0x0013C120` es el método #9 de la clase del JUGADOR**, no el brazo de
  daño de los enemigos. Falsificado por efecto.
- **El escaneo diferencial no sirve para la vida de un enemigo**: muere en 4
  balas y el filtro necesita más rondas de las que da. Por clase salió en una
  pasada.
- Los saves de GameFAQs son Max Drive/CodeBreaker: no se pueden usar sin
  herramientas de terceros.

## Hipótesis activas

- **Vida máxima = 1200.0**, no `FLT_MAX`; está hardcodeada en el código que
  lee la vida. Falta determinar qué elige la rama entre 1200.0 y 750.0
  (¿dificultad? ¿tipo de entidad?).
- `arma+0x18` (valores 25, 10, 50) es candidato a **cargador**. Sin
  confirmar: no se comparó contra el número del HUD.
- El código de 3 letras de `arma+0x1C0` está **corrido un registro** respecto
  de los parámetros. Para identificar un arma, guiarse por el perfil de
  parámetros y no por ese campo.
- `0x0065F458` (f32, 0.23..0.59) sigue sin identificar; probable ratio del HUD.

## Estado de la máquina

- PCSX2 2.6.3 en la notebook, PINE en 28011. ISO montado en `D:`.
- **Parches vivos en memoria** (se pierden al recargar el emulador):
  `0x0013BD20` en nop = **vida infinita del jugador PUESTA**.
  `0x00134654` restaurado a `0xE61402F8` (los enemigos mueren normal).
  Los 34 `Power` de la tabla **restaurados 34/34**, sin discrepancias.
  **Los 36 factores de zona ESCRITOS EN 3.0** (= 300 de daño por impacto),
  originales en `volcados/zonas-originales.json`. Restaurar con:
  `python herramientas/zonas.py restaurar volcados/zonas-originales.json`
- Savestate del punto de trabajo en el **slot 6**. `volcados/ee-06.bin` es su
  RAM. De esta sesión: `ee-4b.bin` (tabla de zonas intacta, el bueno para
  releer valores originales) y `ee-4b-antes.bin` (pool con #6 en 49.0,
  #2/#9/#11 en 100.0 — la línea de base del test pendiente).

## Problemas abiertos

- **`pruebas/prueba_herramientas.py` borra `construido/.gitkeep`**, que está
  trackeado: hace `rmtree` de `construido/` al terminar. Restaurarlo a mano
  (`git checkout -- black/construido/.gitkeep`) antes de commitear.
- No se validó `herramientas/windows/preparar_entorno.ps1` de punta a punta.
- `armas.py` no tiene test en `pruebas/`.

## Riesgos relevantes

- Las direcciones son válidas sólo para NTSC-U / `5C891FF1`. No portan a PAL.
- **No escribir valores arbitrarios en `0x006CF54C`**: es un índice del render
  del HUD y escribirle 999 crasheó el emulador a pantalla negra.
- No escribir en `0x0042Cxxx`: es zona de HUD, ensucia la pantalla.
