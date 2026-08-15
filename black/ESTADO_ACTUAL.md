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

**Checkpoint 1 CERRADO.** Sigue: determinar si la dirección de vida es
estable o dinámica, y de ahí al primer mod real.

## Estado

Entorno resuelto en la notebook (Windows, PCSX2 2.6.3, PINE en 28011).
Identidad confirmada. Pipeline de escaneo y muestreo funcionando de punta a
punta. La vida del jugador está localizada y confirmada en pantalla.

## Hechos confirmados

| Hecho | Evidencia |
|---|---|
| Identidad: `SLUS-21376`, CRC `5C891FF1`, versión `1.00`, NTSC-U | `pine.py info` en vivo + log de arranque de PCSX2 → `kb/objetivo.json` |
| **Vida del jugador = `0x005A8DA8`, tipo `f32`** | escaneo diferencial + búsqueda nativa de PCSX2 (coincidieron) + correlación temporal 90s + escritura de 333.0 con efecto visto en pantalla → `kb/mapa-memoria.json` |
| **Daño por golpe = 26.0 constante** | 10 escalones idénticos en `volcados/correlacion-vida-2.csv` |
| `0x006CF54C` = segmentos del HUD (derivado, no fuente) | se recalculó solo de 8 a 1 al escribir en `0x005A8DA8` |
| PINE funciona en la notebook (TCP 127.0.0.1:28011) | conexión real confirmada |
| PINE **no** tiene opcodes de breakpoint | tabla de opcodes contigua `0x00`-`0x0F` en `herramientas/pine.py` |
| El `DebugServer` (puerto 21512) que sí maneja breakpoints **no está en esta máquina** | `Get-NetTCPConnection`: sólo escucha 28011; binario oficial en `C:\Program Files\PCSX2\` |
| "Documentos" redirigido a OneDrive en la notebook | log de PCSX2 + captura de Configuración > Carpetas |
| Carpeta de cheats real: `cheats_ws` | misma captura |
| Savestates: `<SERIAL> (<CRC>).<slot>.p2s` · pnach: `<SERIAL>_<CRC>.pnach` | listado real + log de PCSX2 |

## Hipótesis activas

- **Vida máxima**: se observó ~440 tras una curación y 649.79 tras otra. El
  techo real **no está determinado**. Puede no haber techo, o depender del
  ítem de curación.
- `0x0065F458` (f32, rango 0.23..0.59) sigue sin identificar. Se movía mucho
  durante el juego; podría ser un ratio normalizado o algo de física.

## Último experimento

`vigilar.py grabar` a 10 Hz durante 90s sobre 6 candidatos mientras el
usuario jugaba y narraba cada curación y cada golpe. El CSV
(`volcados/correlacion-vida-2.csv`) mostró la correlación exacta. Después,
escritura de 130.0 y 333.0 por PINE con efecto confirmado en pantalla.

## Problemas abiertos

- **Bug**: `vigilar.py analizar` crashea con traceback al imprimir la sección
  "primeros" de los escalones. El análisis hubo que hacerlo leyendo el CSV a
  mano. Pendiente de arreglar.
- No se validó `herramientas/windows/preparar_entorno.ps1` de punta a punta.
- Falta saber si `0x005A8DA8` es estable entre cargas de nivel.

## Próxima acción

Determinar estable vs dinámica (escalón 1 de `docs/02-metodologia.md`):

```powershell
cd black
python herramientas\pine.py leer 0x005A8DA8 --tipo f32   # anotar el valor
# recargar el nivel / morir y volver a cargar en el juego
python herramientas\pine.py leer 0x005A8DA8 --tipo f32   # ¿sigue siendo vida?
```

Si mantiene un valor de vida coherente → **estática**, sirve directo en un
`.pnach` de escritura constante (vida infinita sin tocar la rutina). Si tiene
basura → dinámica, hay que llegar por puntero (escalón 3).

## Riesgos relevantes

- Las direcciones son válidas sólo para NTSC-U / `5C891FF1`. No portan a PAL.
- **No escribir valores arbitrarios en `0x006CF54C`**: es un índice del
  render del HUD y escribirle 999 crasheó el emulador a pantalla negra.
- Guardar savestate antes de cada experimento de escritura.
