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

**Fase 2 — CERRADA.** Vida infinita confirmada con efecto: `nop` en
`0x0013BD20` (`swc1 f20,0x2F8(s2)` → `0x00000000`), probado contra fuego real
de AK47 en el primer nivel, vida estable durante varios minutos de combate.
Sin probar: si cubre otras fuentes de daño (cuerpo a cuerpo, caídas,
explosiones) además de proyectiles.

**Siguiente:** decidir Fase 3 — ¿la rutina es genérica (abre Fases 3 y 5
juntas)?, tabla de armas, o empezar a explorar el ISO (carpetas `data/`,
`levels/`, `guns/`, vistas ahora por el usuario) para mapear contenido sin
depender del emulador en vivo.

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
| **La vida NO es un global: es `jugador+0x2F8`** | `xref.py absoluto 0x005A8DA8` → 0 instrucciones la arman. Base real **`0x005A8AB0`**, leída del registro en vivo (`a2`) al disparar un watchpoint de lectura. `0x005A8AB0 + 0x2F8 = 0x005A8DA8` exacto |
| **La instrucción que aplica daño al JUGADOR es `0x0013BD20`** (`swc1 f20,0x2F8(s2)`) | watchpoint de ESCRITURA sobre `0x005A8DA8` + golpe real → paró en `0x0013BD20` con `s2 = 0x005A8AB0` (base del jugador), `f21 = 26.0` (daño) y `f20 = 724.0 = 750.0−26.0`. Se predijo 724.0 antes de reanudar y al continuar la vida quedó en 724.0. `kb/rutinas.json#aplicar_dano` |
| **`0x0013C120` NO era el brazo del jugador** | en el mismo instante tenía `f22 = 0.0` y `s0 = 0x590D90`, que no es el objeto del jugador. La sesión anterior eligió mal entre los 8 candidatos |
| **Los crashes del emulador son corrupción de heap del parche, NO OneDrive** | Visor de eventos: dos crashes con firma idéntica `0xc0000374` (`STATUS_HEAP_CORRUPTION`) en `ntdll.dll+0x112165`. `source/DebugServer.cpp` muta `CBreakPoints` desde el hilo del socket (`std::thread(clientHandler).detach()`), sin mutex ni marshalling al hilo de CPU |
| **1200.0 y 750.0 hardcodeados en el HUD** | `lui at,0x4496` (=1200.0) y `lui at,0x443B`+`ori 0x8000` (=750.0), seguidos de `div.s f12, vida, esa constante`, en los 3 sitios lectores |
| **`gp` del juego = `0x004157F0`** | `depurador.py evaluar "gp"`, y `gp - 0x7150 = 0x0040E6A0` coincidió con la dirección vigilada |
| Los watchpoints funcionan en la build parcheada, y el PC de la pausa **es** la instrucción que accedió | prueba de control sobre `0x0040E6A0`: pausó en `0x002B6B14` = `sw a2,-0x7150(gp)`, y `gp-0x7150` da exactamente la dirección vigilada |
| **`--accion log` NO cuenta hits** (es un stub, igual que `MemCheck::Log()`) | control sobre el timer del motor: el valor cambiaba entre lecturas y el contador quedó en 0. Hay que usar `--accion break` |
| **Los breakpoints de EJECUCIÓN crashean el emulador** | `bp poner 0x0013C120` cortó la conexión a mitad del comando y mató el proceso (nada escuchando en 21512). Los **watchpoints** en cambio pausaron y resumieron limpio decenas de veces. `depurador.py` ahora exige `--se-que-crashea` para `bp poner` |
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

- **La rutina de daño podría ser GENÉRICA**, no del jugador. El offset `0x2F8`
  aparece con `s0`, `s1`, `s2`, `a1` y `a2` como base en distintos sitios. Si
  es "una entidad recibe daño", esto abre de una las Fases 3 y 5. Test: poner
  un breakpoint en `0x0013C120` y matar a un enemigo — si para, es genérica.
- **Vida máxima = 1200.0**, no `FLT_MAX`. El `0x005A8DB0` con `FLT_MAX` sigue
  ahí, pero el 1200.0 está hardcodeado en el código que lee la vida. El
  recuerdo original de "~1200" era correcto; el `HANDOFF` que lo declaró falso
  se equivocó. Falta determinar qué elige la rama entre 1200.0 y 750.0
  (¿dificultad? ¿tipo de entidad?).
- **`0x0065F458` (f32, 0.23..0.59) es probablemente el ratio del HUD**: el
  resultado de `div.s f12, vida, 1200.0`. 750/1200 = 0.625, del mismo orden.
- **OneDrive quedó DESCARTADO como causa de los crashes** (2026-08-15, noche).
  El Visor de eventos de Windows tiene los dos crashes con firma idéntica:
  excepción `0xc0000374` (`STATUS_HEAP_CORRUPTION`), módulo `ntdll.dll` +
  `0x112165`, proceso `PCSX2-MCP\pcsx2-qt.exe`. OneDrive no puede producir
  eso: un archivo lockeado da errores de E/S, no corrupción de heap dentro del
  proceso. Además OneDrive no estaba corriendo y los savestates no tienen
  atributos de Files-On-Demand.
- **La causa probable es un defecto de threading del parche.**
  `source/DebugServer.cpp` (viene con la build) atiende cada cliente en
  `std::thread(clientHandler, sock).detach()` y desde ahí llama directo a
  `CBreakPoints::AddBreakPoint` / `AddMemCheck` / `ClearAllBreakPoints`, sin un
  solo mutex y sin marshalling al hilo de CPU — mientras el hilo de emulación
  lee esos mismos contenedores. Explica los tres síntomas: los breakpoints de
  EJECUCION matan al instante (fuerzan invalidación del caché del recompilador
  mientras el EE ejecuta desde él), los watchpoints aguantan decenas de veces
  y después mueren (corrompen menos por operación, pero acumulan), y "murió
  sola sin que nadie tocara nada" (la corrupción detona asincrónicamente).
  **El savestate es el DETECTOR, no la causa**: reservar ~48 MB fuerza un
  recorrido del heap y ahí Windows encuentra el daño ya hecho. Por eso los dos
  crashes cayeron 3 y 5 segundos después de un savestate.
  Mitigación a probar (barata, no requiere recompilar): pausar el EE antes de
  toda mutación de breakpoint y reanudar después.
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

**Fase 2 tiene la instrucción localizada y confirmada. Falta el efecto.**

**(1) Vida infinita — el test que cierra la fase.** `nop` sobre `0x0013BD20`
(`swc1 f20,0x2F8(s2)`, codificación `0xE65402F8` → `0x00000000`), recibir
golpes y ver que la vida no baja. Guardar la codificación original para poder
revertir. Puede no cubrir el camino de muerte, que sigue sin ubicarse.

**(2) ¿La rutina es genérica?** Vigilar la vida de un enemigo, o watchpoint de
lectura sobre su objeto, y ver si el store que dispara es `0x0013C120`. Si los
dos brazos son de la misma función, se ganan las Fases 3 y 5 de un saque.

**NO sacar savestate antes de los experimentos.** Los dos crashes cayeron 3 y
5 segundos después de un savestate: la corrupción de heap ya estaba hecha y la
reserva de ~48 MB es lo que la hace detonar. El savestate es el detector, no
la causa (ver hechos confirmados).

Runbook que funcionó, para repetirlo:

```
python herramientas/depurador.py vigilante poner 0x005A8DA8 --tipo write --accion break
# recibir un golpe
python herramientas/depurador.py estado                 # da el PC
python herramientas/depurador.py evaluar s2             # da la base de la entidad
python herramientas/depurador.py registros --categoria 2  # f20 = valor a escribir, f21 = dano
python herramientas/depurador.py vigilante quitar 0x005A8DA8
python herramientas/depurador.py continuar
```

**(3) Tabla de armas.** Sigue pendiente y ahora es más barato: `depurador.py
vigilante poner 0x0042C3AC --tipo read --accion break` dice quién lee el 26.0.
Es sólo lectura.

Reproducir el análisis de esta sesión (necesita el PCSX2 parcheado corriendo):

```
python herramientas/depurador.py vigilante poner 0x005A8DA8 --tipo read --accion break
python herramientas/depurador.py estado          # da el PC del lector
python herramientas/depurador.py evaluar "a2"    # da la base real del objeto
python herramientas/volcar_vivo.py 0x00100000 0x003C0000 volcados/codigo-vivo.bin
python herramientas/xref.py stores 0x2F8 volcados/codigo-vivo.bin --base 0x00100000 --fpu
```

## Riesgos relevantes

- Las direcciones son válidas sólo para NTSC-U / `5C891FF1`. No portan a PAL.
- **No escribir valores arbitrarios en `0x006CF54C`**: es un índice del
  render del HUD y escribirle 999 crasheó el emulador a pantalla negra.
- Guardar savestate antes de cada experimento de escritura.
