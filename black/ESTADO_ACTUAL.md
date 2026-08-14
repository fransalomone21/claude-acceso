# Estado actual

Índice operativo compacto. **Esto se lee primero**, entero, en cualquier
sesión nueva — es más rápido que releer la bitácora. Para el detalle de cómo
se llegó a cada cosa, ir a `docs/03-bitacora.md`; para qué hacer después, a
`docs/04-plan.md`.

Se actualiza cada vez que cambia algo real. No es historial — para eso está
la bitácora. Si una línea de acá contradice la bitácora, la bitácora tiene
razón y esto está desactualizado: corregirlo.

---

## Objetivo actual

Checkpoint 1 del plan: encontrar la dirección de memoria de la **vida del
jugador**. Ver `docs/02-metodologia.md`, escalón 1, y `docs/04-plan.md`,
fase 1.

## Estado

Entorno resuelto en la notebook de Fran (Windows, PCSX2 2.6.3). Identidad
del juego confirmada. El pipeline de escaneo (`escanear.py`) funciona de
punta a punta en esa máquina, con `--pedir` automático por defecto. Falta
ejecutar el primer filtro real.

## Hechos confirmados

| Hecho | Evidencia |
|---|---|
| Identidad: `SLUS-21376`, CRC `5C891FF1`, versión `1.00`, NTSC-U | `pine.py info` en vivo + log de arranque de PCSX2 → `kb/objetivo.json` |
| PINE funciona en la notebook (TCP 127.0.0.1:28011) | conexión real confirmada, ver bitácora 2026-08-14 (4) |
| "Documentos" está redirigido a OneDrive en la notebook (`C:\Users\frans\OneDrive\Documents\PCSX2\...`) | log de PCSX2 + captura de `Configuración > Carpetas`, confirmado con `--pedir` funcionando sin `--desde` manual |
| Carpeta de cheats real: `cheats_ws` (no `cheats`, el default de fábrica) | misma captura |
| Nombre de savestates: `<SERIAL> (<CRC>).<slot>.p2s` | listado real de archivos en la notebook |
| Nombre de `.pnach` real: `<SERIAL>_<CRC>.pnach` (guión bajo, no punto) | log de PCSX2 cargando `SLUS-21376_5C891FF1.pnach` |
| Vida del jugador | **sin confirmar todavía** — es el objetivo actual |

## Hipótesis activas

Ninguna sobre BLACK todavía (no arrancó el escaneo real). Ver
`kb/mapa-memoria.json`, `kb/rutinas.json`, `kb/estructuras.json` para las
entradas placeholder marcadas `hipotesis`.

## Último experimento

Sesión de escaneo `prueba-auto` creada en la notebook (`--tipo u32`,
`--pedir`), foto inicial tomada. El usuario tomó daño en el juego. El primer
`filtrar ... bajo` que se intentó comparó el savestate contra sí mismo (no
se había tomado una foto nueva) — eso ya está resuelto: el código ahora lo
detecta y corta con un error explícito en vez de dar "0 candidatos" en
silencio (commit `c51b2b5`). Falta correr el filtro de nuevo, ya con el
arreglo activo.

## Problemas abiertos

- No se validó `herramientas/windows/preparar_entorno.ps1` de punta a punta
  en ninguna corrida real; todo lo que funcionó en la notebook se hizo con
  pasos manuales (activar PINE a mano, clonar a mano). El script en sí queda
  sin verificar por ejecución.
- Nada de BLACK en sí (vida, rutinas, estructuras, tablas) está confirmado
  todavía — es la fase 1 recién arrancando.

## Próxima acción

En la notebook, con `prueba-auto` ya creada:
```powershell
git pull
python herramientas\escanear.py filtrar prueba-auto bajo
```
Si el daño ya se tomó antes de crear la sesión (savestate posterior al daño),
puede hacer falta `nuevo` de nuevo con una foto tomada ANTES del daño.
Alternar `bajo`/`subio` unas 3-4 veces hasta que queden pocos candidatos
(`escanear.py listar prueba-auto`).

## Riesgos relevantes

- Las direcciones que se encuentren son válidas sólo para NTSC-U /
  `5C891FF1`. No portan a PAL sin re-confirmar.
- Escribir en memoria al azar puede colgar el emulador — guardar savestate
  antes de cada experimento nuevo (regla de seguridad, `docs/04-plan.md`).
