# Estado actual

Índice operativo compacto. **Esto se lee primero**, entero, en cualquier
sesión nueva — es más rápido que releer la bitácora. Para el detalle de cómo
se llegó a cada cosa, ir a `docs/03-bitacora.md`; para qué hacer después, a
`docs/04-plan.md`.

Se actualiza cada vez que cambia algo real. No es historial — para eso está
la bitácora. Si una línea de acá contradice la bitácora, la bitácora tiene
razón y esto está desactualizado: corregirlo.

---

## Infraestructura global

`perfil-global/` instalado y **verificado funcionando** en la notebook
(2026-08-15). Las skills viven en `~/.claude/skills/` — no en
`claude-code-skills/`, que era un path equivocado y por eso nunca cargaban.

Skills disponibles: `/engineering-orchestrator`, `/spec-interview`,
`/verify-before-build`.

---

## Objetivo actual

**Fase 2 EN CURSO, 3 de 4 objetivos cubiertos sin debugger.** Estructura del jugador mapeada, mapa de memoria acotado, candidata a vida máxima encontrada. Falta desempatar cuál de las 69 instrucciones candidatas escribe la vida.

## Estado

Entorno resuelto en la notebook (Windows, PCSX2 2.6.3, PINE en 28011).
Identidad confirmada. Pipeline de escaneo y muestreo funcionando de punta a
punta. La vida del jugador está localizada y confirmada en pantalla.

## Hechos confirmados

| Hecho | Evidencia |
|---|---|
| Identidad: `SLUS-21376`, CRC `5C891FF1`, versión `1.00`, NTSC-U | `pine.py info` en vivo + log de arranque de PCSX2 → `kb/objetivo.json` |
| **Vida del jugador = `0x005A8DA8`, tipo `f32`** | escaneo diferencial + búsqueda nativa de PCSX2 (coincidieron) + correlación temporal 90s + escritura de 333.0 con efecto visto en pantalla → `kb/mapa-memoria.json` |
| **`0x005A8DA8` es ESTÁTICA** | recarga de nivel → 750.0 (HP inicial coherente); 2 golpes → 698.0 = 750−2×26. Sobrevive recargas y responde al daño exacto. `kb/mapa-memoria.json#vida_jugador.estable = true` |
| **Daño por golpe = 26.0 constante** | 10 escalones idénticos en `volcados/correlacion-vida-2.csv` |
| `0x006CF54C` = segmentos del HUD (derivado, no fuente) | se recalculó solo de 8 a 1 al escribir en `0x005A8DA8` |
| **La vida NO es un global: es `jugador+0x28`** | `xref.py absoluto 0x005A8DA8` → 0 instrucciones la arman, 0 literales en 32 MB. Base `0x005A8D80` por `xref.py punteros` → `kb/estructuras.json#jugador` |
| **Código del juego en `0x00100000-0x003BFFFF`** | `xref.py mapa` (densidad ≥88%) + los 69 candidatos a store caen todos ahí |
| **Datos/globales en `~0x0042xxxx-0x0045xxxx`** | histograma de `lui`: 0x0041 ×4922, 0x0044 ×2084, 0x0043 ×639 |
| El checkbox "Log" del breakpoint de PCSX2 no imprime nada | `MemCheck::Log()` es un stub vacío en el fuente de PCSX2 |
| PINE funciona en la notebook (TCP 127.0.0.1:28011) | conexión real confirmada |
| PINE **no** tiene opcodes de breakpoint | tabla de opcodes contigua `0x00`-`0x0F` en `herramientas/pine.py` |
| El `DebugServer` (puerto 21512) que sí maneja breakpoints **no está en esta máquina** | `Get-NetTCPConnection`: sólo escucha 28011; binario oficial en `C:\Program Files\PCSX2\` |
| "Documentos" redirigido a OneDrive en la notebook | log de PCSX2 + captura de Configuración > Carpetas |
| Carpeta de cheats real: `cheats_ws` | misma captura |
| Savestates: `<SERIAL> (<CRC>).<slot>.p2s` · pnach: `<SERIAL>_<CRC>.pnach` | listado real + log de PCSX2 |

## Hipótesis activas

- **Vida máxima**: candidata encontrada en `jugador+0x30` (`0x005A8DB0`), que
  vale `FLT_MAX`. Si es eso, **no hay techo** — lo que explica los ~440 y
  649.79 observados sin llegar nunca a un límite. Test: escribirle un finito
  y curarse.
- **Tabla de armas**: el daño de 26.0 aparece cinco veces agrupadas en la
  región de datos (`0x0042C3AC`, `0x0042C5EC`, `0x0042C92C`, `0x0042CCFC`,
  `0x0042D56C`). Huele a tabla de descriptores de arma.
- **`0x005A8D80` puede no ser el inicio real del objeto**: el primer u32 no
  parece un puntero a vtable. Podría ser un sub-objeto.
- `0x0065F458` (f32, rango 0.23..0.59) sigue sin identificar. Se movía mucho
  durante el juego; podría ser un ratio normalizado o algo de física.

## Último experimento

`vigilar.py grabar` a 10 Hz durante 90s sobre 6 candidatos mientras el
usuario jugaba y narraba cada curación y cada golpe. El CSV
(`volcados/correlacion-vida-2.csv`) mostró la correlación exacta. Después,
escritura de 130.0 y 333.0 por PINE con efecto confirmado en pantalla.

## Problemas abiertos

- **`pruebas/prueba_herramientas.py` borra `construido/.gitkeep`**, que está
  trackeado: hace `rmtree` de `construido/` al terminar. Hay que restaurarlo a
  mano (`git checkout -- black/construido/.gitkeep`) antes de commitear.
- No se validó `herramientas/windows/preparar_entorno.ps1` de punta a punta.
## Próxima acción

Tres caminos, todos baratos y sin debugger. En orden de costo:

**(a) Confirmar que `0x005A8D80` es el jugador.** `vigilar.py` sobre los 0x60
bytes del objeto mientras el usuario se mueve y dispara: los campos de posición
tienen que moverse. Sólo lectura, cero riesgo.

**(b) Matar o confirmar la vida máxima.** Escribir un finito en `0x005A8DB0`
(`jugador+0x30`, hoy `FLT_MAX`) y curarse. Si la vida topa ahí, confirmado.
Es un flotante, no un índice de render: bajo riesgo.

**(c) Buscar la tabla de armas.** `inspeccionar.py` sobre `0x0042C3AC` y las
otras cuatro apariciones agrupadas de 26.0. Si hay periodicidad, es la tabla, y
es el mod con mejor relación esfuerzo/resultado del proyecto.

Recién después, si hace falta desempatar los 69 candidatos a instrucción de
escritura: **un** breakpoint de memoria en `0x005A8DA8` (Write + Change, size
4). Precaución obligatoria: savestate antes, y probar el mecanismo sobre una
dirección inocua primero — ver riesgos.

Reproducir el análisis de esta sesión:

```
python herramientas/estado.py extraer "<savestate.p2s>" volcados/ee.bin
python herramientas/xref.py absoluto 0x005A8DA8 volcados/ee.bin
python herramientas/xref.py punteros 0x005A8DA8 volcados/ee.bin
python herramientas/xref.py stores 0x28 volcados/ee.bin --fpu
```

## Riesgos relevantes

- Las direcciones son válidas sólo para NTSC-U / `5C891FF1`. No portan a PAL.
- **No escribir valores arbitrarios en `0x006CF54C`**: es un índice del
  render del HUD y escribirle 999 crasheó el emulador a pantalla negra.
- Guardar savestate antes de cada experimento de escritura.
