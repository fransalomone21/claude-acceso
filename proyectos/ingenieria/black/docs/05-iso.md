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

### El mapa exacto, de la tabla de secciones

Hay un solo `PT_LOAD`, pero **sí hay tabla de secciones**, y con nombres
reales. El mapa aproximado que traía este documento antes ("datos
~`0x003BC330`–`0x0040E580`") era una estimación por histograma; esto es lo que
declara el archivo (2026-08-16):

| Sección | Dirección EE | Tamaño | Qué es |
|---|---|---|---|
| `.text` | `0x00100000` | `0x296F48` | el código del juego |
| `.vutext` | `0x00396F50` | `0x0253E0` | microcódigo de las VU |
| `.data` | **`0x003BC380`** | `0x035DDC` | **acá viven las vtables y las tablas de punteros** |
| `.vudata` | `0x003F2160` | `0x0000C0` | |
| `.rodata` | **`0x003F2280`** | `0x01A528` | cadenas, nombres de campo, tablas de constantes |
| `.gcc_except_table` | `0x0040C800` | `0x000F84` | |
| `.lit4` | **`0x0040D800`** | `0x000104` | **pool de literales f32** — 65 constantes |
| `.sdata` | `0x0040D980` | `0x000C00` | datos chicos, direccionados por `$gp` |
| `.sbss` | `0x0040E580` | `0x0006D0` | |
| `.bss` | `0x0040EC80` | `0x08D33C` | hasta `0x0049BFBC` |

Entry point `0x00100008`. El resto de las 105 secciones son overlays de
microcódigo de VU (`.DVP.overlay.*`).

**`$gp = 0x004157F0`**, sacado de la sección `.reginfo` (`ri_gp_value`). No hay
ningún `lui $gp` en `.text`: el valor lo pone el cargador. Importa porque hay
**3051 accesos con base `$gp`** repartidos en **561 offsets distintos** — o sea
561 globales que ninguna herramienta que busque `lui`+`addiu` va a encontrar
jamás. Todos caen en la ventana de ±32 KB alrededor de `$gp`, que cubre
`.lit4`, `.sdata`, `.sbss` y el principio de `.bss`.

**No tiene tabla de símbolos**, pero sí tiene **nombres de tipo de C++ sin
demanglear** en `.rodata` (`Q24Kaim13CShooterAgent` y compañía). Ver la
sección de Kynapse.

Consecuencia que costó entender: las constantes de daño conocidas
(`0x0042C3AC` y compañía) **están en BSS**. No existen en el ejecutable. Y la
vida del jugador (`0x005A8DA8`) está fuera del segmento entero: es heap.

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

## ¿El ELF lleva LBAs horneados? — RESUELTO, NO (2026-08-16)

**Era la tarea 6.1, y decidía el camino de escritura.** Reconstruir un ISO de
PS2 reasigna el LBA de los 585 archivos aunque no cambie un byte de contenido.
Si el juego llevara sectores escritos a mano, `mkps2iso` quedaba cerrado como
camino y el parche in-place pasaba a ser el único. **No los lleva.** El plan B
sigue vivo, con dos condiciones que están más abajo.

### La geografía del disco, primero

| | |
|---|---|
| archivos | 585 |
| sectores declarados en el PVD | 1.913.872 (3,65 GiB) |
| rango de LBA con datos | **1.050.000 .. 1.903.423** = `0x100590 .. 0x1D0B3F` |
| antes del primer archivo | 1.050.000 sectores = **2,05 GiB de relleno** |

Ese relleno de cabecera es deliberado: empuja los datos al **borde exterior**
del DVD, que es donde el lector va más rápido. No es desperdicio, es layout.

La tabla completa está en **`kb/lbas-iso.json`**, y se rehace con:

```bash
python herramientas/lbas.py tabla "<ruta>/Black.iso" --json kb/lbas-iso.json
```

### El confundido que había que desactivar antes de medir

Los LBA de este ISO van de `0x100590` a `0x1D0B3F`. **El `.text` de BLACK va de
`0x00100000` a `0x00396F47`.** O sea que *cualquier puntero a código del juego
parece un LBA*, y también cualquier par de índices `u16` chicos empaquetados en
un `u32`. Contar apariciones sin un piso de ruido del **mismo rango numérico**
no mide nada.

Por eso `lbas.py buscar` corre siempre con dos controles:

- **positivo**: mete una aguja distintiva sacada del propio objetivo (no cero,
  pocas apariciones) y verifica que el barrido la encuentre. Si eso falla,
  cualquier "no hay LBAs" es un bug y no un hallazgo;
- **negativo**: la **misma cantidad** de valores inventados del **mismo rango**,
  buscados en las **mismas cinco codificaciones**.

### La medición sobre el ELF

`SLUS_213.76`, 3.371.868 bytes, base `0xFF000`. Conjunto real 1644 valores
(585 LBA más sus vecinos ±1); conjunto señuelo 1644, semilla 20260816.
Control positivo: aguja `0x70000C28` en el offset `0x1008`, 1 aparición,
encontrada.

| codificación | reales | señuelos |
|---|---|---|
| `u32` LE suelto | 31/1644 | 22/1644 |
| `u32` BE suelto | 23/1644 | 12/1644 |
| `LBA*2048` LE | 18/1644 | 13/1644 |
| **inmediato `lui`+`ori`/`addiu`** | **0/1644** | **0/1644** |
| inmediato del offset en bytes | 0/1644 | 0/1644 |

**Forma de los 83 golpes literales: 11 alineados a 4, corrida contigua más
larga = 1, y 74 de 83 adentro de `.text`.** Una tabla de LBAs es lo contrario:
alineada, contigua y en `.data`. El leve exceso sobre los señuelos se explica
solo: los LBA reales vienen en tríos consecutivos (`1068005/6/7`) porque se
buscan con sus vecinos ±1, así que un mismo sitio de ruido marca tres valores;
los señuelos son uniformes y marcan uno. Por sitio independiente, real ≈ ruido.

> **La fila que más pesa es la de los inmediatos, y hay que entender por qué.**
> Un valor de 32 bits **no existe como palabra contigua dentro del código**
> MIPS: se arma con dos instrucciones de 16 bits. Buscar `u32` en `.text` no lo
> vería nunca. Con 31.760 `lui` indexados y radio 16, **ni un solo par** arma un
> LBA ni un offset de sector — ni de los reales ni de los inventados.
>
> Y antes de creerle a ese cero se falsificó el agujero obvio: el EE compila en
> ABI de 64 bits y podría usar `daddiu` (opcode `0x19`), que el buscador no
> mira. Se midió con qué opcode se completa cada `lui` del ELF:
> `addiu` 9182, `lw` 6880, `ori` 5626, `sw` 573… **`daddiu`: cero apariciones.**
> El buscador cubre las formas que este binario realmente usa.

### El barrido de los 585 archivos, y la única corrida que asustaba

`lbas.py buscar --profundo` sobre el ISO montado entero. La métrica de "exceso
sobre el ruido" marca 408 archivos, y **eso es un artefacto de la métrica**, no
un hallazgo: en bancos de audio y video de decenas de MB la estadística de
bytes no es uniforme. Lo que discrimina de verdad es la **corrida contigua**.

Sólo dos archivos tienen corridas ≥ 5: `LEVEL_06/UNIT_01.BIN` (10) y
`LEVEL_04/UNIT_05.BIN` (8). **Se miraron los bytes, no se supuso.** La corrida
de 10 es el valor `0x001D001D` repetido diez veces, rodeado de `0x001D0022`,
`0x001D7722`, `0x051D001D`, `0x000A001D`: son **pares de índices `u16`** de la
geometría que caen dentro de la ventana numérica de los LBA. No es una tabla de
sectores.

### La evidencia estructural: quién traduce ruta → sector

Las dos anteriores son negativas. Esta es positiva, y es la que cierra.

**Todo pedido de archivo del ELF es una ruta de texto con `printf`**, no un
número:

```
GlobData.bin                              Levels\Level_%02u\LevelDat.bin
Levels\Level_%02u\Unit_%02d.bin           Levels\Level_%02u\Stg_%04u\StLevel.bin
Levels\Level_%02u\Stg_%04d\StUnit%02d.bin Language/Strings/Main%s.bin
sound\streams\%s.ssh                      Export\FrontEnd\FEMain.bin
```

Y quien las resuelve es **`IOP/GTFSCDVD.IRX`**, un módulo del IOP cuyo nombre
interno es **`gtfsdvd`** — el sistema de archivos propio de Criterion. Importa
`cdvdman` (lectura de sectores cruda) y trae exactamente tres mensajes de
error:

```
Error reading TOC
ERROR: Exceeded maximum directories per disk (%d)
ERROR: Exceeded maximum files per disk (%d)
```

Un módulo que **lee la TOC del disco y arma su tabla de archivos en memoria**,
con un tope por disco. Eso es resolución en runtime. Un LBA horneado no
necesitaría leer ninguna TOC, y un tope por disco no tendría sentido.

### Veredicto y sus condiciones

**`mkps2iso` NO está cerrado: sigue siendo un plan B viable.** Pero el parche
in-place sigue siendo el camino preferido, y ahora por razones medidas y no por
miedo:

| | in-place | reconstruir |
|---|---|---|
| bytes que cambian | sólo los editados | el layout entero |
| LBA de los 585 archivos | intactos | reasignados |
| CRC del ELF (⇒ savestates y `.pnach`) | intacto | intacto si no se toca el ELF |
| relleno de 2,05 GiB del borde exterior | intacto | **hay que reproducirlo a mano** |
| sirve para agrandar un archivo | **no** | sí |

Tres condiciones para el día que haya que reconstruir:

1. **No exceder los máximos de `gtfsdvd`.** Reconstruir el mismo árbol no puede
   excederlos; agregar archivos, sí. *Los números exactos no se sacaron* — ver
   el hilo abierto de abajo.
2. **Reproducir el relleno de cabecera** o aceptar que todo se corre al borde
   interno del disco. No rompe nada, pero cambia el tiempo de búsqueda, y BLACK
   transmite audio y video desde el disco.
3. **No tocar el ELF**, o los savestates y los `.pnach` dejan de aplicar.

> **Hilo abierto, anotado como tal.** Los máximos de archivos y directorios de
> `gtfsdvd` no se pudieron leer en frío: un `.IRX` es un ELF **reubicable**, sus
> inmediatos valen cero hasta que el cargador los parchea, así que reconstruir
> pares `lui`/`addiu` sobre el archivo no da nada (se intentó: 1 sitio, y
> apuntaba cuatro bytes adentro de una cadena). El camino que sí sirve es leer
> el módulo **ya cargado** en la RAM del IOP con el juego corriendo. No es
> urgente: sólo importa si algún día se agregan archivos al ISO.

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

Contenido típico de un nivel: `LEVEL.AWD`, `LEVELDAT.BIN`, `COLLIDE.AWD`,
`DESTRUCT.*`, `AMBIENCE.*`, `MUSIC.BKS`, `SPCH_EN.*`, `SPEECH.SLB`, `FPGUNS/`
y `STG_0001/`. La geometría va en **varios** `UNIT_NN.BIN` (hasta `UNIT_07`,
no uno solo) con su `STUNIT NN.BIN` correspondiente dentro de `STG_0001/`.

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

### La tabla de armas SÍ está en el ISO: `GLOBDATA.BIN + 0x00130E20`

> **Esto corrige lo que decía este documento hasta el 2026-08-16**, que era
> "la tabla de estadísticas de armas NO está en el ISO". Era un falso
> negativo: aquella búsqueda comparaba la **ventana de 96 bytes** alrededor
> del `26.0` de la RAM viva contra los archivos. Esa ventana arranca con tres
> punteros al heap, que en el archivo son offsets chicos — nunca podía dar
> coincidencia. Lo que la encontró fue buscar por **firma estructural**: los
> campos invariantes del bloque de parámetros, no los bytes crudos.

Firma usada (bloque de `0x30` de `kb/estructuras.json#arma`): `Range` en
`+0x14`, `Power` en `+0x18`, `falloff` en `+0x1C`, con los perfiles ya
medidos en vivo — ASR `60/26`, escopeta `25/38`, HVY `100/100`, Magnum
`1000/500`.

| Firma buscada en los 585 archivos | Dónde apareció |
|---|---|
| `Range=60, Power=26, falloff=1` (ASR) | 6 × `GLOBDATA.BIN` |
| `Range=1000, Power=500` (Magnum) | 1 × `GLOBDATA.BIN` |
| `Range=100, Power=100, falloff=1` (HVY) | 1 × `GLOBDATA.BIN` |
| `Power=26, falloff=1` | 22 × `GLOBDATA.BIN` |

**17 registros de `0x1E0` desde el offset `0x00130E20`** de `GLOBDATA.BIN` —
el mismo conteo y el mismo paso que la tabla en RAM. El paso está verificado
por dos anclas independientes: el Magnum cae en el registro `+2` y la HVY en
el `+10`, exactos. Los dos bloques de parámetros están donde los pone la ficha
de RAM: `+0x90` (jugador) y `+0xC0` (IA).

| # | offset | jugador `Range/Power/falloff` | IA `Range/Power/falloff` | `+0x1C0` |
|---|---|---|---|---|
| 0 | `0x00130E20` | 60 / 26 / 1 | 1000 / 26 / 1 | `PST` |
| 1 | `0x00131000` | 25 / 38 / 1 | 20 / 133.3 / 0 | — |
| 2 | `0x001311E0` | **1000 / 500** / 1 | 1000 / 200 / 1 | `PST` |
| 3 | `0x001313C0` | 30 / 26 / 1 | 1000 / 26 / 1 | `SMG` |
| 4 | `0x001315A0` | 60 / 26 / 1 | 1000 / 26 / 1 | `ASR` |
| 5 | `0x00131780` | 60 / 26 / 1 | 1000 / 26 / 1 | `ASR` |
| 6 | `0x00131960` | 1000 / 26 / 1 | 1000 / 26 / 1 | `RPG` |
| 7 | `0x00131B40` | 1000 / 50 / 1 | 1000 / 26 / 1 | `RPG` |
| 8 | `0x00131D20` | 30 / 26 / 1 | 1000 / 13 / 1 | `SMG` |
| 9 | `0x00131F00` | 30 / 26 / 1 | 1000 / 13 / 1 | `SMG` |
| 10 | `0x001320E0` | **100 / 100** / 1 | 1000 / 70 / 1 | `HVY` |
| 11 | `0x001322C0` | 70 / 70 / 1 | 1000 / 100 / 1 | `PST` |
| 12 | `0x001324A0` | 60 / 26 / 1 | 1000 / 26 / 1 | `ASR` |
| 13 | `0x00132680` | 25 / 38 / 1 | 20 / 133.3 / 0 | — |
| 14 | `0x00132860` | 60 / 26 / 1 | 1000 / 26 / 1 | `PST` |
| 15 | `0x00132A40` | 1000 / 26 / 1 | 1000 / 26 / 1 | `SMG` |
| 16 | `0x00132C20` | 60 / 26 / 1 | 1000 / 26 / 1 | basura |

**Dos cosas sin resolver, dichas como tales:**

1. En el archivo el código de 3 letras de `+0x1C0` **parece alinear bien** con
   los parámetros del mismo registro (`SMG` con `Range=30`, `ASR` con `60`,
   `HVY` con `100/100`), que es lo contrario de lo que se observó en RAM,
   donde estaba corrido un registro. Uno de los dos está mal leído. Hasta
   resolverlo, seguir identificando armas por el perfil de parámetros.
2. Los `0x90` bytes iniciales de cada registro **no** son los tres punteros de
   la ficha de RAM: en el archivo son seis sub-entradas de `0x18` con forma
   `{offset, offset, offset, contador, ?, ?}`. La resolución a punteros la
   hace el cargador.

> **Lo que esto habilita, y lo que no.** Habilita un mod **permanente**: editar
> `GLOBDATA.BIN` en el ISO cambia los `Power` sin `.pnach` y sin escribir en
> memoria. Lo que **no** cambia es el daño de salida del jugador — eso sale de
> las zonas de impacto (`kb/rutinas.json#calcular_dano_zona`), no de esta
> tabla. Y **no está confirmado por efecto**: nadie editó todavía el ISO y vio
> el cambio en pantalla. Es `probable`, no `confirmado`.

`GUNS.BIN` sigue sin tener una sola aparición del `26.0`: es geometría de las
armas colocadas en el nivel, no estadísticas. Eso de la versión anterior se
mantiene.

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

## Los nombres de hueso — la entrada barata a la Fase 5b

En `.data`, dirección **fija**, hay un `const char*[11]` con nombres de hueso:

```
0x003BCE70   NECK  MIDSPINE  LOWERSPINE  SHOULDER_LT  ELBOW_LT
             SHOULDER_RT  ELBOW_RT  UPPERLEG_LT  KNEE_LT
             UPPERLEG_RT  KNEE_RT
```

Lo consume **una sola función**, `0x001381E0`, que hace exactamente esto:

```
s1 = objeto que llega en $a0
s0 = s1 + 0x0C                     ; destino
s3 = 0x003BCE70                    ; la tabla de nombres
s2 = 10                            ; 11 vueltas (10..0)
bucle:
    a1 = [s3]                      ; nombre[i]
    si a1 == 0 -> saltar
    v0 = buscar_hueso_por_nombre(s1, a1)      ; jal 0x00138298
    [s0] = v0                      ; guardar el ÍNDICE
    s0 += 4 ;  s3 += 4 ;  s2 -= 1
```

O sea: al construir el personaje, **resuelve los 11 nombres a índices de hueso
del esqueleto y los cachea en `objeto+0x0C .. +0x38`**. El ayudante
`0x00138298` es una búsqueda lineal por `strcmp` que expone el layout del
esqueleto:

```
esqueleto = [objeto+0x00]
[esqueleto+0x5C] = cantidad de huesos
[esqueleto+0x60] = array de const char* con los nombres
```

**Por qué importa.** La Fase 5b pregunta qué elige el byte de zona que entra
en `$a1` a `0x00142B90`. Acá hay once índices de hueso cacheados por
personaje, en offsets fijos, resueltos por nombre. Es el candidato natural.

**Lo que NO se puede decir todavía:** que zona == índice de hueso. Son 11
nombres contra 24 registros de `0xC` en la tabla de zonas, y faltan los
nombres obvios (cabeza, pelvis, manos, pies). Puede ser que estos once sean
un subconjunto con tratamiento especial y las zonas vengan del esqueleto
completo. **Hipótesis**, no hallazgo.

Dos constantes vecinas, sin identificar, por si sirven de pista:
`0x003F5110` = `1, 0.5, 0.4, 0.3, 0.2, 0.2` (¿rampa?), y `0x003F5128` =
`0, 5, 12, 22`, cuatro floats que `0x00138244` copia a `[objeto]+0x28`.

> **Trampa de herramienta que se pagó acá.** `xref.py absoluto 0x003BCE70`
> decía **NADA**. Era falso: el `lui` está en `0x001381E4` y el `addiu` en
> `0x00138208`, **nueve** instrucciones después, y el `--radio` por defecto
> era 8. Ya está subido a 16. Un "NADA" de `xref.py` no es prueba de nada si
> no se probó con radio grande.

---

## Kynapse — el middleware de IA, con los nombres puestos

`.rodata` trae **nombres de tipo de C++ sin demanglear** del namespace `Kaim`
(Kynapse, de Kynogon): `Q24Kaim13CShooterAgent`, `Q24Kaim10CFleeAgent`,
`Q24Kaim11CPathFinder`… Junto a cada clase están **los nombres de sus
parámetros**, que es lo que sirve: son los tunables de la IA, con nombre.

| Clase | Parámetros que declara | Dónde |
|---|---|---|
| `CShooterAgent` | `DangerousConeAngle`, `TargetBot`, **`GunRange`**, **`MaxInaccuracy`**, `AimAtTargetInterval` | `0x00404458`+ |
| `CFleeAgent` | `MaxDeltaHeight`, `MaxPointsToFlee`, `MaxEntitiesToFlee` | `0x00404070`+ |
| `CFollowerAgent` | `DistFromEntity`, `AngleFromEntity`, `EntityToFollow` | idem |
| `CHideAgent` | `ResearchType` (`FAR_FROM_ENEMY`/`CLOSE_TO_ME`), `MaxDangerousEntities` | idem |
| `CPathFinder` | `DistGoal`, `DistStop`, `DistSlowDown`, `MaxYawSpeed`, `MaxDeltaAngle`, `MaxPathSize`, `HoleHeight`… | `0x00407FE0`+ |
| `CGapDynamicAvoidance` | `TrackingUpdatePeriod`, `CollisionDiagrammWidth`, `SlowSpeedFactor` | `0x004087D8`+ |
| `CRepulsorDynamicAvoidance` | `DynDelayTime`, `TimeMinTrigger`, `DetectionDistanceRatio` | `0x00408260`+ |
| `CWorld` | `MaxEntity`, `MaxTeam`, `OneMeter`, `Tpf`, `MaxPeriodicTask` | `0x00406D20`+ |

**`GunRange` y `MaxInaccuracy` del `CShooterAgent` son la puntería del
enemigo.** Si algún día se quiere "enemigos que erran más", el hilo empieza
ahí y no en la tabla de armas.

Igual que el esquema de armas de `0x004008A0`, estos nombres son **rodata que
documenta un formato binario**: el parser no los lee en runtime. Sirven para
saber qué campos existen, no para encontrarlos por nombre en RAM.

Otros esquemas del ValueDB que aparecen completos, con los mismos nombres que
los `.cfg` que **no** están en el ISO:

- `Collision.cfg` (`0x003F7C18`): `Light/Medium/Heavy/World Object Max
  Impulse`, `Object Impulse Threshold`, `Footstep Impulse`.
- `AIWeapon.cfg` (`0x003F7E78`): `Emphasis Decay Frames`, `Distance
  Weighting`, `Line of Sight Weighting`, `MaxEnemiesSoundedPerFrame`.
- `DSP.cfg` (`0x003F8A40`): `Tinnitus`, `LowHealth`, `HeartbeatThreshold`,
  `Full Muff` — el sistema de sordera por explosión.

---

## Tablas de nombres útiles, con dirección fija

Todas en `.data`, todas son `const char*[]` consecutivos. Salen con
`tablas.py punteros` (ver abajo).

| Dirección | N | Qué es |
|---|---|---|
| `0x003BCE70` | 11 | **nombres de hueso** (arriba) |
| `0x003BD160` | 8 | **puntos de anclaje**: `J_B_Hand_Loc`, `J_B_Grenade_Loc`, `J_B_Shield_Loc`, `Flash_Loc`, `Bullet_Loc`, `Grenade_Loc` |
| `0x003BDC68` | 10 | tipos de munición: `AMMOTYPE_HP/LT/HV/SS/HC/FG/RG` |
| `0x003BDB98` | 24 | mensajes de pickup de munición, uno por arma |
| `0x003BD924` | 23 | grupos de volumen de audio (`VGPlayerWeapon`, `VGEnemyWeapons1..3`…) |
| `0x003BCAD0` | 10 | los `.IRX` del IOP que se cargan al arrancar |
| `0x003BCFC0`+ | ~11 c/u | tablas de animación por estado (`S_501`, `C_730`…) |

---

## Cómo se rehace este barrido: `tablas.py`

`herramientas/tablas.py` es la herramienta de reconocimiento en frío. Va al
revés que las otras: no parte de un dato conocido, barre el binario buscando
cosas con **forma** de tabla.

```bash
python herramientas/tablas.py esquemas  D:/SLUS_213.76 --base 0xFF000
python herramientas/tablas.py punteros  D:/SLUS_213.76 --base 0xFF000 --min 5 \
    --desde 0x003BC380 --hasta 0x003F2160
python herramientas/tablas.py flotantes D:/SLUS_213.76 --base 0xFF000 \
    --desde 0x0040D800 --hasta 0x0040D904
python herramientas/tablas.py vecinos   D:/SLUS_213.76 --base 0xFF000 0x003BCE70
```

`--base` es la dirección EE del primer byte del archivo: **`0xFF000` para el
ELF**, `0` para un volcado de RAM. Todo lo que sale es `hipotesis` hasta que
alguien le escriba un valor y vea el efecto.

Acotar con `--desde`/`--hasta` a `.data` y `.rodata` cambia mucho la señal:
sobre el archivo entero, `punteros` devuelve 106 corridas y la mitad son ruido
de `.rodata` apuntándose a sí misma.

---

## Formatos de archivo

### El contenedor con alineación 128 — RESUELTO (2026-08-16)

Estuvo anotado como "falta entender el formato" durante días. La respuesta no
salió de mirar bytes: salió de **decompilar el cargador** con Ghidra.

**Cómo se llegó, en cuatro pasos.** La cadena `GlobData.bin` está en
`0x003F2AD8`; `decompilar.py xref` da un único llamador,
**`FUN_00105858`** — la máquina de estados de arranque. Ahí se ve el pedido de
archivo asíncrono:

```c
FUN_001093c0(streamer, PTR_s_GlobData_bin, 8, 1, /*callback=*/0x105d48, ...);
```

Y el callback **`0x00105D48`** es el parser. No parsea: **arregla punteros**.

```c
iVar2 = base_del_bloque_cargado;
*(int *)(iVar2 + 0x04) += iVar2;      // <- la clave
*(int *)(iVar2 + 0x08) += iVar2;
*(int *)(iVar2 + 0x0C) += iVar2;
*(int *)(iVar2 + 0x10) += iVar2;
*(int *)(iVar2 + 0x14) += iVar2;
*(int *)(iVar2 + 0x18) += iVar2;
```

**Los u32 de la cabecera son offsets relativos al inicio del archivo, y el
cargador los convierte EN EL LUGAR en punteros absolutos sumándoles la
dirección de carga.** Por eso la vieja hipótesis de "tabla de offsets
creciente" falló: no es una tabla ordenada, es una **cabecera de layout fijo**
donde cada ranura es una sección distinta, y no tienen por qué venir en orden.

El mismo mecanismo es **recursivo**, y ahí aparece el patrón de registros:

```c
pbVar7 = *(byte **)(iVar2 + 0x0C);                    // una sección
*(byte **)(pbVar7 + 4) = pbVar7 + *(int *)(pbVar7 + 4);   // relativo a SÍ MISMA
for (i = 0; i < *pbVar7; i++)                          // pbVar7[0] = CANTIDAD (u8)
    FUN_00382c70(*(int *)(pbVar7 + 4) + i * 0x24);     // registros de 0x24

iVar6 = *(int *)(iVar2 + 0x10);
*(int *)(iVar6 + 4) += iVar6;
if (*(char *)(iVar6 + 1) != 0)                         // cantidad en +0x01 acá
    ... registros de 0x20, cada uno con sus propios fixups en +0x08..+0x18
```

O sea, la forma general de un bloque es
`{u8 cantidad, ..., u32 offset_relativo_a_este_bloque, ...}` y los registros
tienen paso fijo. **El paso y la posición de la cantidad cambian por
sección** — no hay un encabezado universal.

#### Verificación contra los archivos reales

| Archivo | Ranuras `+0x04..+0x18` válidas | Veredicto |
|---|---|---|
| `GLOBDATA.BIN` | 6/6 → `0x80`, `0xF9300`, `0x130C80`, `0x132F80`, `0x133800`, `0x133F80` | encaja |
| `STLEVEL.BIN` | 4/6 (dos en cero) → `0x80`, `0x04`, `0x680`, `0x240600` | encaja |
| `STUNIT01.BIN` | 2/6 → `0x480`, `0x80` | encaja |
| `UNIT_01.BIN` | 5/6 | encaja |
| `LEVELDAT.BIN` | 3/6 **fuera de rango** | **otro layout** |
| `GUNS.BIN` | `+0x00` es un tamaño (`0x24000`), no una cantidad | **otro layout** |

> **CONTROL POSITIVO — el que convierte esto en un hallazgo.** La tabla de
> armas está en `GLOBDATA.BIN + 0x00130E20`, y eso ya estaba establecido por
> otra vía (firma estructural de `Range/Power/falloff`). Según la cabecera
> recién decodificada, cae **dentro de la sección que arranca en `0x00130C80`,
> a `+0x1A0` de su inicio**. La predicción no se ajustó para que diera: la
> dirección era conocida de antes.
>
> Segundo control, independiente: en `STLEVEL.BIN`, la sección que la cabecera
> declara en `0x80` arranca con los bytes `62 67 31 5F 73 68 67` = `"bg1_shg"`
> — la tabla de nombres de entidades que ya estaba documentada acá.

**Lo que sigue sin saberse:** qué es cada sección (sólo se identificó la de
armas y la de nombres), y el layout de `LEVELDAT.BIN` y `GUNS.BIN`, que usan
otro juego de ranuras. El camino está claro: buscar el `xref` de su cadena de
ruta y decompilar su callback, igual que acá.

Lo que ya se sabía y se mantiene: **el texto adentro está sin comprimir**, así
que `strings` sobre estos archivos rinde.

| Archivo | Cabecera | Contenido útil |
|---|---|---|
| `GLOBDATA.BIN` (1,26 MB) | `09, 0x80, 0xF9300, 0x132F80…` | 2118 cadenas en los primeros 200 KB; nombres tipo `bg1_asr_shl`. **Y la tabla de armas en `0x00130E20`** |
| `STLEVEL.BIN` (2,5 MB) | `0A, 0x80, 07, 0xA00…` | **nombres de entidades del stage** (ver arriba) |
| `STUNIT01.BIN` (326 KB) | `03, 0x3F800, 0x80` | nombres `bc1_*` |
| `GUNS.BIN` (227 KB) | `0x25580, 0x80` | geometría de armas |
| `UNIT_01.BIN` (9 MB) | `18, …` | geometría del nivel (`AircraftCrumpled`…) |
| `LEVELDAT.BIN` (763 KB) | `11, 0B, 0x5057C` | datos del nivel |

### Audio: los `.AWD` están abiertos

`.AWD` es un **RenderWare Audio Wave Dictionary** y **vgmstream lo lee de
fábrica**. No hizo falta escribir parser. Herramienta:
`herramientas/awd.py` (ver `06-herramientas-externas.md` para el montaje).

```bash
python herramientas/awd.py listar "D:/LEVELS/LEVEL_01/STG_0001/AIWPNS.AWD"
python herramientas/awd.py catalogo D:/ --json kb/catalogo-awd.json
```

**36 archivos, 1385 streams**, PS-ADPCM de 4 bits, 16-22 kHz mono. Y lo que
importa acá: **muchos traen los nombres que les puso Criterion**.

`STG_0001/AIWPNS.AWD` = *AI Weapons*: **dice qué armas usa la IA en cada
nivel**. Es una fuente de nombres independiente del binario, y por eso sirve
para cruzar contra los 17 registros de la tabla de armas, que hoy se
identifican por perfil de parámetros porque el código de 3 letras está
corrido.

| Nivel | Armas de la IA (prefijo `E_`) |
|---|---|
| 00 | `BlackHd`, `Lkiss2`, `Mac10`, `Uzi` |
| 01 | `DieHard2`, `Mac10`, `Uzi`, `WeWere` |
| 03 | `Alias`, `Commando`, `Hvy`, `KarlDH`, `LKiss` |
| 04 | `Hvy`, `Mac10`, `Rock`, `Uzi`, `WeWere` |
| 05 | `Alias`, `Hvy`, `LKiss`, `Mac10`, `Uzi` |
| 06 | `Hvy`, `Mac10`, `Uzi` |
| 07 | `Hvy`, `LKiss`, `Mac10`, `Navy`, `Uzi` |
| 08 | `Alias`, `Hvy`, `KarlDH`, `Mac10`, `Uzi` |

**Los nombres en clave son referencias a películas** — el equipo bautizó los
sets de sonido por la película de donde sacaron el arma: `WeWere` (*We Were
Soldiers*, M16), `BlackHd` (*Black Hawk Down*), `DieHard2` y `KarlDH` (*Die
Hard*), `LKiss` (*The Long Kiss Goodnight*), `Rock` (*The Rock*), `Commando`,
`Navy`, `Alias`. **El mapeo nombre-en-clave → arma real es hipótesis**, salvo
los que se llaman por su nombre (`Mac10`, `Uzi`, `Hvy`, `Rpg`).

Cada arma trae el set `_S0` (inicio), `_M0..M3` (variantes del cuerpo) y `_E0`
(final). Los genéricos que aparecen sueltos: `Distant0`, `MgnDst*` (magnum a
distancia), `Shtg0`, `Snpr0`, `Pstl*`, `MCHNGN*`, `SBMCHGN*`, `Silenced0`,
`CarrieSnpr`.

`SOUND/PAUDIO.AWD` (*Player Audio*) tiene 6 streams **sin nombres**: vgmstream
devuelve `1`..`6`. Es un resultado honesto —ese archivo no trae tabla de
nombres— no una falla de la herramienta.

Lo que vgmstream **no** abre, y devuelve `failed opening` limpio: `.SSH`,
`.BKS`, `.SLB`, `.WDD`, `.DB`. El par `.SSH` + `.BKS` parece cabecera + banco
de streams; sigue sin atacarse.

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
