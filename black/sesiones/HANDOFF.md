# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-17, madrugada**, PC con PCSX2 vivo.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — entero, es corto.
2. `black/docs/00-conops.md` — **nuevo**: qué quiere ser el proyecto y contra
   qué se valida. Se lee antes de decidir en qué trabajar.
3. `black/docs/08-experimentos.md` — **nuevo**: el método experimental y la
   batería E1..E6 que sigue.

**NO leer** salvo que la tarea lo pida: la bitácora entera, `docs/90-glosario-ee.md`,
`docs/06-herramientas-externas.md`.

## 2. LA FASE QUE SE ABRE, Y QUÉ LA CIERRA

**Fase 7 — arquitectura de entidades y de la IA.**

Sirve al objetivo que fijó Fran el 2026-08-17: **hacer BLACK más difícil y
meterle cambios tipo remaster** — cambiarles el arma a los enemigos,
sustituir tipos de enemigo, y a largo plazo coop y niveles nuevos.

**La cierra:** tener identificados **por efecto** los campos que gobiernan
(a) el arma que usa un enemigo y (b) qué tipo de enemigo aparece en un nivel.
Con eso se puede componer un nivel distinto sin herramientas nuevas.

## 3. MODELO

**Sonnet 5.** El trabajo que sigue es correr el banco de experimentos ya
construido e interpretar tablas. Pasar a **Opus** sólo si hay que leer
desensamblado para encontrar la rutina que asigna el arma a un enemigo.

## 4. ESTADO DE LA MÁQUINA

- **El emulador que corre NO es el de Program Files.** Es
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
  (build `d75a0ad`), con **DebugServer en 21512 y PINE en 28011**. Atajos en
  `C:\Users\frans\Desktop\BLACK\`: `ABRIR-BLACK-ORIGINAL.bat` y
  `ABRIR-BLACK-MOD-ARMAS.bat`.
- **Dos ISO** en `C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\`:
  `Black.iso` (original, 3.919.609.856 B, **nunca editar**) y
  `Black-mod-armas.iso` (parcheado: `Power` de IA en `5.0` en los 17 registros).
  El original queda montado en `D:`.
- **Savestates** en `C:\Users\frans\Documents\PCSX2\sstates\`, y se cargan con
  `python herramientas/pine.py cargarestado --slot N`.
  **Slot 3 = la condición experimental**: jugador pegado a dos tiradores cerca
  del primer auto del nivel 1, con la vida ya inflada a ~1e6.
  Slot 4 = distancia media, vida normal. Slot 10 = **no sirve**, muere en segundos.
- **Parches vivos en memoria: NINGUNO.** Todo lo que se escribió en la sesión
  se restauró. Se pierde igual al reiniciar el emulador.
- Ghidra 12.1.2 + EE Reloaded en `C:\Users\frans\herramientas\ghidra_12.1.2_PUBLIC`,
  proyecto en `...\ghidra-proyectos2\BLACK` (el de `ghidra-proyectos` **sin el 2**
  tiene análisis malo de MIPS R6: no usarlo). Copia del ELF en
  `C:\Users\frans\herramientas\SLUS_213.76`, mapeo `offset = vaddr - 0xFF000`.

## 5. LO QUE YA ESTÁ RESUELTO — NO REHACER

- **6.1 cerrada: el ELF no lleva LBAs horneados.** Resuelve por nombre contra
  la TOC vía `IOP/GTFSCDVD.IRX`. `mkps2iso` sigue siendo plan B viable.
- **6.6 cerrada: el mod permanente anda**, confirmado por efecto en las tres
  capas (archivo → RAM → 24 impactos de −5.0 en pantalla).
- **`arma + bloque + 0x20` = `Time Between Bullets`**, confirmado por efecto.
  Cuantizado a frames; la relación **no** es proporcional.
- **Kynapse está linkeado pero MUERTO**: 0 de 182 metaclases inicializadas con
  un nivel cargado. No perder tiempo buscando sus objetos en RAM.
- **El ELF no trae DWARF** (`.debug_str` mide 1 byte) ni RTTI de las clases de
  Criterion. Los únicos nombres son los de `Kaim::`.
- **Trampa de medición que ya costó una hora:** las herramientas que leen un
  volcado asumen que el byte 0 del archivo es la dirección EE 0. **Volcar
  siempre desde 0.** `pine.py volcar` ahora avisa si no.
- La tabla de armas está en `0x01842220` en RAM y en `GLOBDATA.BIN + 0x00130E20`
  en el ISO, 17 registros de `0x1E0`.

## 6. EL PRIMER COMANDO

```powershell
cd C:\Users\frans\Desktop\claude-acceso\black
python herramientas/inventario.py
python herramientas/decompilar.py info
```

Y después, el experimento que sigue (**E4** de `docs/08-experimentos.md`):
volcar el objeto de arma de un enemigo y buscarle el índice a la tabla de 17.

```powershell
python herramientas/pine.py cargarestado --slot 3
python herramientas/pine.py volcar 0 0x02000000 volcados/ee-e4.bin
python herramientas/clases.py objetos volcados/ee-e4.bin 0x003DCA78
python herramientas/inspeccionar.py 0x006DE770 --largo 0x220
```

El objeto de arma por tirador está en `0x006DE770 + n*0x110`, con el dueño en
`+0x10`. Si adentro hay un campo con un valor entre 0 y 16, ese es el índice
del arma, y escribirlo le cambia el arma al enemigo.
