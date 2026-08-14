# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para
eso, `docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva,
sin memoria del chat anterior, retome exactamente donde quedó esta.

Última actualización: 2026-08-14, sesión en la nube (Sonnet), tras cerrar
triggers/webhooks huérfanos y agregar `ESTADO_ACTUAL.md`.

---

**OBJECTIVE**
Checkpoint 1: encontrar la dirección de memoria de la vida del jugador.

**CURRENT STATE**
Entorno resuelto en la notebook de Fran. Identidad del juego confirmada.
`escanear.py` funciona de punta a punta con `--pedir` por defecto y detección
de "foto repetida". Sesión de escaneo `prueba-auto` creada, falta el primer
filtro real (el intento anterior comparó una foto contra sí misma, ya
arreglado).

**CONFIRMED FACTS**
Ver tabla completa en `../ESTADO_ACTUAL.md`. Resumen: `SLUS-21376` /
`5C891FF1` / v1.00, PINE funciona, Documentos redirigido a OneDrive en la
notebook, cheats en `cheats_ws`, savestates `<SERIAL> (<CRC>).<slot>.p2s`,
pnach `<SERIAL>_<CRC>.pnach`.

**ACTIVE HYPOTHESES**
Ninguna sobre BLACK todavía.

**RECENT EXPERIMENTS**
Sesión `prueba-auto` en `volcados/escaneo-prueba-auto/` (en la notebook, no
en este repo — `volcados/` está en `.gitignore`).

**IMPORTANT FILES**
- `herramientas/escanear.py` — escáner diferencial, `--pedir` default ahora
- `herramientas/pine.py`, `herramientas/estado.py` — cliente PINE, savestates
- `kb/objetivo.json` — identidad confirmada, `version_activa: "NTSC-U"`
- `kb/mapa-memoria.json`, `rutinas.json`, `estructuras.json` — todo
  `hipotesis` placeholder, nada de BLACK confirmado todavía

**IMPORTANT ADDRESSES**
Ninguna de BLACK todavía.

**FAILED APPROACHES**
- Filtrar `bajo` con la misma foto que el paso anterior → 0 candidatos, sin
  señal de error. Causa raíz identificada y con guardarraíl agregado (commit
  `c51b2b5`): no repetir este error, pero si vuelve a pasar, revisar que
  `--pedir` esté efectivamente tomando una foto nueva y no reusando una vieja
  por algún problema de reloj/mtime del sistema de archivos.
- Asumir `~/Documents` en Windows sin verificar redirección de OneDrive.
- Asumir `python3` como nombre de comando fuera de Linux/Mac.
- Asumir separador `.` en nombres de `.pnach` (es `_`).
- Asumir nombre `cheats` para la carpeta de trucos (puede ser otro,
  configurado en el `.ini`).

**OPEN QUESTIONS**
- ¿La vida es un valor estático o dinámico (requiere puntero)? Se sabrá al
  reiniciar el nivel con la dirección ya encontrada (ver metodología,
  escalón 1).
- ¿`preparar_entorno.ps1` funciona de punta a punta? Sin validar todavía.

**NEXT ACTION**
```powershell
cd black
git pull
python herramientas\escanear.py filtrar prueba-auto bajo
```
Alternar `bajo`/`subio` hasta que queden pocos candidatos, después
`escanear.py listar prueba-auto` y compartir la salida.

**DO NOT REPEAT**
No reabrir la investigación de por qué `~/Documents` fallaba en Windows —
está resuelto y documentado en la bitácora 2026-08-14 (5). No re-suponer
`python3`, `.` como separador de `.pnach`, o `cheats` como nombre fijo de
carpeta — los tres ya tienen su arreglo (leer del `.ini` real o de
`sys.executable`, según el caso).

**TOOLS / ENVIRONMENT**
Python 3.11+, numpy opcional. Windows: `herramientas/windows/preparar_entorno.ps1`
(sin validar de punta a punta). PCSX2 2.6.3 con PINE en slot 28011.

**MODEL RECOMMENDATION**
Sonnet para lo mecánico (correr comandos, cargar datos al `kb/`). **Opus**
quedaría reservado para cuando aparezca el primer breakpoint de escritura
real y haya que leer desensamblado (checkpoint 2 del plan) — ahí sí conviene
subir.

**EFFORT RECOMMENDATION**
Medio. Nada de esto es ambiguo todavía; es seguir el procedimiento de
`docs/02-metodologia.md` escalón 1.

---

READY FOR NEW SESSION
