# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para
eso, `docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva,
sin memoria del chat anterior, retome exactamente donde quedó esta.

Última actualización: 2026-08-14, sesión en la nube (Sonnet), Fase 2
infraestructura global + corrección de encoding + validación end-to-end
de `preparar_entorno.ps1` en la notebook real.

---

**OBJECTIVE**
Checkpoint 1: encontrar la dirección de memoria de la vida del jugador.
(La infraestructura global — Fase 2 — está terminada y validada.)

**CURRENT STATE**
`perfil-global/` instalado y verificado en `~/.claude` de la notebook.
`preparar_entorno.ps1` corrido de punta a punta con éxito: PINE activo,
`PCSX2.ini` parchado, PCSX2 abierto (sin ISO — falta cargar BLACK a mano).
El proyecto BLACK en sí sigue igual que al final de la sesión 7: `escanear.py`
funciona, sesión `prueba-auto` creada, falta el primer filtro real — con el
agregado de que ahora hace falta reconfirmar identidad porque PCSX2 se
reinició sin el juego cargado.

**CONFIRMED FACTS**
Ver tabla completa en `ESTADO_ACTUAL.md`. Resumen: `SLUS-21376` /
`5C891FF1` / v1.00, PINE funciona, Documentos redirigido a OneDrive en la
notebook, cheats en `cheats_ws`, savestates `<SERIAL> (<CRC>).<slot>.p2s`,
pnach `<SERIAL>_<CRC>.pnach`.

**ACTIVE HYPOTHESES**
Ninguna sobre BLACK todavía.

**RECENT EXPERIMENTS**
Sesión `prueba-auto` en `volcados/escaneo-prueba-auto/` (en la notebook, no
en este repo — `volcados/` está en `.gitignore`).

**ARCHITECTURE DECISION (nueva)**
El entorno cloud NO puede ejecutar PCSX2, PINE, Ghidra ni ninguna herramienta
de reverse engineering en vivo. Todo el trabajo de BLACK checkpoint 1 en
adelante debe ocurrir en **Claude Code LOCAL** en la PC/notebook del usuario.
El cloud sólo sirve para editar herramientas y documentación cuando no hay
acceso a la máquina real.

**IMPORTANT FILES**
- `herramientas/escanear.py` — escáner diferencial
- `herramientas/pine.py`, `herramientas/estado.py` — cliente PINE, savestates
- `kb/objetivo.json` — identidad confirmada
- `kb/mapa-memoria.json`, `rutinas.json`, `estructuras.json` — placeholder
- `../perfil-global/` — infraestructura global (instalar en PC local)

**IMPORTANT ADDRESSES**
Ninguna de BLACK todavía.

**FAILED APPROACHES**
- Filtrar `bajo` con la misma foto → 0 candidatos, sin error. Corregido.
- Asumir `~/Documents` en Windows sin verificar OneDrive. Corregido.
- Asumir `python3` fuera de Linux/Mac. Corregido.
- Separador `.` en `.pnach` (es `_`). Corregido.
- Nombre `cheats` fijo para carpeta de trucos. Corregido.

**OPEN QUESTIONS**
- ¿La vida es estática o dinámica? Se sabrá con el primer filtro real.
- ¿`preparar_entorno.ps1` funciona de punta a punta? Sin validar todavía.

**NEXT ACTION**
Infraestructura ya instalada y validada — no hace falta repetir el setup.
Con PCSX2 abierto en la notebook (quedó así, sin ISO):

```powershell
# 1. Cargar BLACK a mano en PCSX2
# 2. Confirmar identidad:
cd black
python herramientas\fijar_objetivo.py
# 3. Retomar el filtro:
python herramientas\escanear.py filtrar prueba-auto bajo
```

Si la sesión `prueba-auto` ya no sirve (PCSX2 reiniciado), crear nueva
sesión con `nuevo` y tomar foto antes del daño.

**DO NOT REPEAT**
- No reabrir la investigación de `~/Documents` en Windows (resuelto, bitácora 5).
- No asumir `python3`, `.` en `.pnach`, o `cheats` como nombre fijo.
- No intentar trabajo en vivo de BLACK desde una sesión cloud.
- No crear triggers/webhooks de monitoreo sin propósito claro (ya hubo huérfanos).
- No escribir ningún `.ps1` con tildes, comillas curvas o em-dashes — UTF-8
  se lee como Windows-1252 en PowerShell y rompe el parser (bitácora 9).
  Todo script de PowerShell de este proyecto es ASCII puro, sin excepción.
- El fallo de la prueba "PY coincide con el intérprete real" en
  `prueba_herramientas.py` es una meta-prueba sin impacto — no investigar,
  no es un bug del proyecto.

**TOOLS / ENVIRONMENT**
Python 3.11+, numpy opcional. Windows: `herramientas/windows/preparar_entorno.ps1`.
PCSX2 2.6.3 con PINE en slot 28011. Todo en la notebook.
Para trabajo futuro: abrir Claude Code LOCAL, no cloud.

**MODEL RECOMMENDATION**
Sonnet para el filtrado mecánico (checkpoint 1 — seguir el procedimiento).
Opus al llegar al primer breakpoint de escritura real y leer desensamblado.

**EFFORT RECOMMENDATION**
Medio. El procedimiento es claro; es seguir `docs/02-metodologia.md` escalón 1.

---

READY FOR NEW SESSION
