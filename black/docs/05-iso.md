# El ISO de BLACK — referencia

Qué hay adentro de `Black.iso`, qué formato tiene cada cosa y qué se puede
sacar de ahí **sin el emulador**. Levantado el 2026-08-16.

Lo que está acá es análisis estático: es barato, es reproducible y no
depende de que PCSX2 esté abierto. Lo que **no** está acá es confirmación por
efecto — para eso hay que jugar.

## Montarlo

```powershell
$img = Mount-DiskImage -ImagePath "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso" -PassThru
($img | Get-Volume).DriveLetter
```

Queda en `D:` (o la letra que devuelva). Para desmontarlo:
`Dismount-DiskImage -ImagePath "<misma ruta>"`.

---

## El ejecutable: `SLUS_213.76`

**Lo más importante de todo este documento.** Es un ELF MIPS de 3.371.868
bytes con **un solo `PT_LOAD`**, así que la traducción entre archivo y RAM es
una resta:

```
offset_en_archivo = direccion_EE - 0xFF000
direccion_EE      = offset_en_archivo + 0xFF000
```

**Verificado 6/6** contra encodings que se habían observado en vivo en
sesiones anteriores (`0x0013BD20`, `0x0013C120`, `0x0013C0F0`, `0x0013BC9C`,
`0x00134ACC`, `0x00178CE0`). No es un supuesto.

Mapa del segmento:

| Zona | Direcciones EE | Nota |
|---|---|---|
| `.text` | `0x00100000`–`0x00396F48` | el código del juego |
| `.vutext` | `0x00396F50`–`~0x003BC330` | microcódigo de las VU |
| datos | `~0x003BC330`–`0x0040E580` | **acá viven las vtables** |
| BSS | `0x0040E580`–`0x0049BFBC` | cero al arrancar, se llena en runtime |

Consecuencia que costó entender: las constantes de daño conocidas
(`0x0042C3AC` y compañía) **están en BSS**. No existen en el ejecutable. Y la
vida del jugador (`0x005A8DA8`) está fuera del segmento entero: es heap.

**No tiene tabla de símbolos.** Las 105 secciones son casi todas overlays de
microcódigo de VU (`.DVP.overlay.*`).

### Desensamblar

`mips.py` **no decodifica instrucciones de FPU** — muestra `cop1 0x4615A501`
donde dice `sub.s`. Para las rutinas de daño eso es justo lo que importa.
Usar `capstone`:

```python
from capstone import *
md = Cs(CS_ARCH_MIPS, CS_MODE_MIPS64 + CS_MODE_LITTLE_ENDIAN)
md.skipdata = True
```

**`CS_MODE_MIPS32` no sirve**: se corta en la primera instrucción propia del
R5900 (`sq`/`lq`, que aparecen en el prólogo de casi toda función) y devuelve
**cero instrucciones sin avisar**. Un desensamblado vacío parece un resultado
—"esta función no escribe ahí"— y es un bug. Ya pasó una vez.

---

## Estructura

585 archivos, 1,63 GB reales (el ISO son 3,9 GB con relleno).

| Carpeta | Archivos | Tamaño | Qué es |
|---|---|---|---|
| `LEVELS/` | 493 | 946 MB | los 8 niveles + `GLOBAL/` |
| `SOUND/` | 42 | 292 MB | bancos `.BKS`, streams, `.AWD` |
| `VIDEOS/` | 17 | 419 MB | cinemáticas `.M2V` (MPEG-2) |
| `EXPORT/FRONTEND/` | 9 | 4,7 MB | interfaz de usuario |
| `IOP/` | 10 | 0,4 MB | módulos del IOP (`.IRX`) |
| `CHARS/` | 6 | 0,1 MB | tablas de transición + 2 modelos de arma |
| `LANGUAGE/` | 3 | 0,2 MB | fuentes + textos |
| `DATA/` | 2 | — | `ANDY.AKU`, `VIEW.ICO` |
| raíz | 3 | 4,4 MB | `SLUS_213.76`, `GLOBDATA.BIN`, `SYSTEM.CNF` |

`SYSTEM.CNF`: `BOOT2 = cdrom0:\SLUS_213.76;1`, `VER = 1.00`, `VMODE = NTSC`.

### Niveles

`LEVEL_00`, `01`, `03`, `04`, `05`, `06`, `07`, `08` — **no hay `LEVEL_02`**.
Cada uno tiene exactamente un stage, `STG_0001`.

Contenido típico de un nivel: `LEVEL.AWD`, `LEVELDAT.BIN`, `UNIT_01.BIN`,
`COLLIDE.AWD`, `DESTRUCT.*`, `AMBIENCE.*`, `MUSIC.BKS`, `SPCH_EN.*`,
`FPGUNS/` y `STG_0001/`.

Nombres de misión que aparecen en los textos (**el mapeo a cada carpeta no
está verificado**): Veblensk City Street · Graznei Bridge · Vlodnik Canal ·
Treneska Border Crossing · Naszran Town · Naszran Foundry · el cementerio.

---

## Armas

Cada nivel trae en `FPGUNS/` los modelos de primera persona de las armas que
usa, como pares `BG1_XXX.DB` + `BG1_XXX.WDD`.

**Los códigos vienen de a pares y el segundo es la versión plateada.** Los
textos del juego lo dicen: *"silver weapons have unlimited ammunition"*.

| Normal | Plateada | Arma |
|---|---|---|
| `ASR` | `AS5` | fusil de asalto |
| `AK1` | `AK5` | AK47 |
| `HVY` | `HV5` | ametralladora pesada |
| `MGN` | `MG5` | magnum |
| `PST` | `PS5` | pistola |
| `SHG` | `SH5` | escopeta |
| `SMG` | `SM5` | SMG |
| `SNR` | `SN5` | fusil de francotirador |
| `RM1` | `RM5` | — |
| `GK1` | `GK5` | — |
| `MP1` | `MP5` | MP5 |
| `M16` | `M45` | M16A2 |
| `P90` | `P95` | P90 |
| `RPG` | — | RPG (sin versión plateada) |
| `BNS` | — | aparece en los 8 niveles |
| `GRL`, `MC5`, `SM3` | — | sin identificar |

El universo completo son 31 códigos. `RPG` y `BNS` son los únicos que
aparecen en los 8 niveles.

> **La tabla de estadísticas de armas NO está en el ISO.** Se buscó la
> ventana de 96 bytes alrededor de cada aparición del daño conocido (`26.0`)
> en la RAM viva, contra `GLOBDATA.BIN`, `SLUS_213.76`, `LEVELDAT.BIN`,
> `STLEVEL.BIN`, `GUNS.BIN`, `GUNS_S.BIN`, `UNIT_01.BIN`, `STUNIT01.BIN` y
> `TRANS_CH.BIN`: **cero coincidencias, 5 de 5**. `GUNS.BIN` no tiene ni una
> aparición del `26.0`: es geometría de las armas colocadas en el nivel, no
> estadísticas.

---

## Tipos de enemigo

`STG_0001/STLEVEL.BIN` es la colocación de entidades del stage y **las nombra
en texto plano**. Prefijos: `bg1_` para armas, **`bc1_` para personajes**.

| Nombre | Veces | Qué parece |
|---|---|---|
| `bc1_asr_goggles` | 13 | soldado con fusil de asalto y antiparras |
| `bc1_cae_vl` | 10 | — |
| `bc1_lr1_*` | 8 | — |
| `bc1_so1_*` | 10 | soldado |
| `bc1_sk1_*` | 8 | — |
| `bc1_tom_com` | 6 | comandante |
| `bc1_et1_bla` | 6 | — |
| `bc1_sd1_*` | 10 | variantes `visor`, `civ`, `bla` |
| `bc1_shd_plexi` | 4 | **el del escudo** — la ayuda del juego dice matarlo con granadas |
| `bc1_co1_*` | 6 | — |
| `bc1_rg1_mil` | 2 | **el del RPG** — hay objetivos de "eliminate all rpg enemies" |

Sufijos: `_mil` (militar), `_civ` (civil), `_bla`, `_com` (comandante), más
variantes de atuendo (`goggles`, `visor`, `plexi`).

---

## Formatos de archivo

### El contenedor con alineación 128

Varios `.BIN` arrancan con `{u32 algo, u32 0x80, ...}` y bloques alineados a
`0x80`. La cabecera **no** es una tabla de offsets creciente — se probó y los
valores no crecen monótonamente. Falta entender el formato; lo que sí sirve
es que **el texto adentro está sin comprimir**, así que `strings` sobre estos
archivos rinde.

| Archivo | Cabecera | Contenido útil |
|---|---|---|
| `GLOBDATA.BIN` (1,26 MB) | `09, 0x80, 0xF9300, 0x132F80…` | 2118 cadenas en los primeros 200 KB; nombres tipo `bg1_asr_shl` |
| `STLEVEL.BIN` (2,5 MB) | `0A, 0x80, 07, 0xA00…` | **nombres de entidades del stage** (ver arriba) |
| `STUNIT01.BIN` (326 KB) | `03, 0x3F800, 0x80` | nombres `bc1_*` |
| `GUNS.BIN` (227 KB) | `0x25580, 0x80` | geometría de armas |
| `UNIT_01.BIN` (9 MB) | `18, …` | geometría del nivel (`AircraftCrumpled`…) |
| `LEVELDAT.BIN` (763 KB) | `11, 0B, 0x5057C` | datos del nivel |

### Tablas de transición de animación

`CHARS/TRANS_CH.BIN` (161 entradas) y `CHARS/TRANS_FP.BIN` (37), cabecera
`{cantidad, 0x10, …}` y offsets alineados a `0x10` — la única familia donde
la hipótesis de tabla de offsets **sí cerró**. Nombres tipo `SH_S_100`,
`SD_DF_S_100`, `SK_DF_S_490`.

### Interfaz de usuario

`EXPORT/FRONTEND/*.BIN` tienen magic **`26307940 9592E537`** y adentro dicen
`"Apt Data:7"` / `"Apt constant file"` — es el sistema de UI de Criterion,
con referencias a `.tif` y `.wav`. Nueve archivos: `CORE`, `COMMON`,
`FEMAIN`, `INGAMEON`, `LOADING`, `PSEMENU`, `RING`, `WPNSCOPE`, `CNTRDISC`.

### Textos

`LANGUAGE/STRINGS/MAINUS.BIN` (54.710 bytes): **1524 cadenas ASCII planas**,
sin comprimir. Objetivos, "black intel", nombres de misión, créditos.
Es la fuente para ponerle nombre a cualquier cosa.

`LANGUAGE/FONTS/{BIG,SMALL}.BIN` arrancan con `"4.1v"`.

---

## El ValueDB

El ejecutable referencia rutas `../Export/ValueDB/...` (`Controls_PS2.cfg`,
`BaseMix.cfg`, `Collision.cfg`, `AIWeapon.cfg`, `Streams.cfg`, `DSP.cfg`) y
un `weaponList.txt` por nivel. **Ninguno de esos archivos está en el ISO**:
son las fuentes de compilación, y lo que se embarcó es el resultado ya
volcado en `GLOBDATA.BIN` y compañía.

En RAM, la región `0x0042C000`–`0x0042E000` es un **bloque de parámetros
sueltos** direccionados de a uno por el código: se encontraron 147
direcciones efectivas distintas, tomadas con `addiu`, espaciadas de a 8
bytes. El vecindario de una de las apariciones de `26.0` es
`33, -75, 4, 136, 30, 94, 26, 1, 1, 1, 0.7` — parámetros heterogéneos, **no
entradas uniformes de una tabla de armas**.

> Corolario incómodo: **que `26.0` aparezca cinco veces en esa región no
> prueba que sean el daño del arma.** Pueden ser cinco tunables distintos que
> casualmente valen 26. La pista que se venía siguiendo desde el 15 es más
> débil de lo que parecía.

## De dónde sale el daño, entonces

Del desensamblado de las dos rutinas de daño (jugador `0x0013BB78`, enemigo
`0x00133FA8`): **el daño llega como argumento**, en `$f12` — el primer
flotante por convención MIPS. `mov.s $f21, $f12` en la del jugador,
`mov.s $f20, $f12` en la del enemigo. No se lee de ninguna tabla adentro de
la rutina: lo calcula **quien llama**.

Hay **34 sitios de llamada** al método virtual #8 (`lw rX, 0x4c(rY)` seguido
de `jalr rX`) repartidos por todo el código. Ahí está el próximo hilo para
la Fase 4.

> **Ojo con un falso amigo:** en `0x0013BC70` hay un `mul.s $f12, $f21, $f12`
> que parece un multiplicador de daño y **no lo es**. La constante que carga
> justo antes es `0x3B83126F` ≈ `0.004` (1/250) y el resultado va como
> argumento a `jal 0x110698`: es el daño normalizado a 0..1 para un efecto de
> feedback (vibración o flash). Etiquetarlo como "multiplicador de daño"
> habría costado horas.
