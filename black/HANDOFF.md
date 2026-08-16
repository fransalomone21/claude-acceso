# Handoff — arrancar el chat que sigue

Copiá esto como primer mensaje del chat nuevo:

```
Leé black/CLAUDE.md, black/ESTADO_ACTUAL.md y la primera entrada de
black/docs/03-bitacora.md. La Fase 4b quedó cerrada y confirmada por efecto:
el daño de salida del jugador es zona_de_impacto * 100.0. Arrancá por el mod
de daño con pnach (es corto), y después Fase 5.
```

Con eso alcanza. **No pegues el chat anterior.** El `kb/` y la bitácora son la
memoria; el historial no hace falta y cuesta diez veces más.

---

## Las tres líneas, ya resueltas para el chat nuevo

**Fase** — **5, en dos tramos.**

- **5a — el mod de daño (corto, hacelo primero).** Cierra cuando
  `mods/*.toml` compile a un `.pnach`, PCSX2 lo cargue **al arrancar** y el
  daño del jugador salga cambiado sin que nadie escriba nada a mano. Es la
  primera vez que el proyecto produce algo que sobrevive a cerrar el
  emulador, y ahora se puede porque la palanca está en el ELF.
- **5b — qué elige la zona.** Cierra cuando se pueda decir, con evidencia,
  qué determina el byte de zona que entra en `$a1` a `0x00142B90` — o sea
  dónde está la diferencia entre un headshot y un tiro al brazo.

**Modelo** — **Sonnet para 5a**: no hay nada que descubrir, es compilar un
pnach con una dirección que ya está confirmada. **Opus para 5b**: es
desensamblado nuevo del sistema de colisión con el esqueleto, territorio sin
mapear. Cambiá con `/model` en el corte entre los dos tramos, no antes.

**Contexto** — chat nuevo ahora. Y **el próximo corte va entre 5a y 5b**:
5a no deja casi nada en contexto que 5b necesite, y 5b arranca leyendo
desensamblado, que es lo que más come.

**Cuánto falta para el próximo cambio de sesión** — 5a es aproximadamente un
cuarto de sesión: la dirección está confirmada, `pnach.py` ya existe y hay
plantilla en `mods/ejemplo-plantilla.toml`. 5b se come una sesión entera larga
y probablemente no cierre en la primera. O sea: **cortá cuando 5a esté
commiteado**, aunque el contexto todavía dé — es un corte limpio y barato, y
evita entrar a leer desensamblado con medio chat ya gastado.

---

## 5a — el mod, en concreto

La palanca es `0x00142CA0`:

```
0x00142CA0   3C0142C8   lui $at, 0x42C8      ; 100.0
0x00142CA4   44810000   mtc1 $at, $f0
0x00142CAC   46000D02   mul.s $f20, $f1, $f0 ; daño = factor_de_zona * 100.0
```

Cambiar el inmediato `0x42C8` escala **todo** el daño de salida de una sola
vez, contra cualquier víctima. `0x42C8` = 100.0; `0x4396` = 300.0; `0x4416` =
600.0. Es código del ELF, **dirección fija**, así que va a un `.pnach` — a
diferencia de los factores por zona, que son por tipo de personaje, viven en
el heap y cambian de dirección en cada arranque.

Mapeo del ELF ya verificado 6/6: `offset_archivo = vaddr - 0xFF000`.

**Cómo se verifica que quedó, y no confundas la precondición con el efecto:**
que el `.pnach` exista y PCSX2 lo liste no prueba nada (lección 7). El efecto
es disparar y ver el daño cambiado, con el emulador **recién arrancado** y sin
ninguna escritura por PINE.

## 5b — qué elige la zona

`$a1` entra a `0x00142B90` como **byte con signo** y se multiplica por `0xC`
en `0x00142BC4`. En el llamador (`0x00134330`) viene de `$s4`, que a su vez
sale de `$t0` en el prólogo del método #8 del enemigo (`0x00133FDC`:
`sra $s4, $t0, 0x18`). O sea: **la zona la elige quien llama al método
virtual #8**, no la rutina de daño.

Entradas baratas, en orden:

1. Subir por los llamadores del método #8 hasta encontrar quién arma ese
   byte. Los 37 sitios ya están enumerados en la evidencia de
   `kb/rutinas.json#calcular_dano_por_arma`.
2. El perfil de zonas ya conocido acota la respuesta: hay **24 zonas**, con
   valores repetidos en grupos (1.02 en 2 y 11; 0.255 en 4, 5, 9, 12, 16).
   Ese agrupamiento es la forma del esqueleto — usalo para validar cualquier
   hipótesis sobre el mapeo.
3. Las zonas 17-23 tienen los floats **corridos un campo** (`+0x00` trae
   denormales, `+0x04` trae el valor bueno). Puede ser que el registro tenga
   otro layout ahí, o que la tabla termine en la 17 y lo de después sea otra
   cosa. Sin resolver.

## Lo que ya está resuelto (no volver a buscarlo)

| Qué | Dónde | Confianza |
|---|---|---|
| Vida del jugador | `0x005A8DA8` = jugador `0x005A8AB0` + `0x2F8` | confirmado |
| Daño al jugador | `0x0013BD20` — nop = vida infinita | confirmado |
| Clase del jugador | `0x003DC5F8` (puntero en objeto **`+0x10`**) | confirmado |
| Clase del enemigo | `0x003DCA78` — 32 objetos, pool `0x0058FE90`, paso `0x3C0`, vida `100.0` | confirmado |
| Daño al enemigo | `0x00134654` — nop = enemigos invulnerables | confirmado |
| Método virtual #8 = "recibir daño" | `vtable+0x4C` | confirmado |
| Tabla de armas → daño que se le hace **al jugador** | 17 registros de `0x1E0`, `Power` en bloque+`0x18` | confirmado |
| **Daño de salida del jugador = `zona * 100.0`** | **`0x00142B90`**, escala en `0x00142CA0` | **confirmado** |
| Objeto de arma por tirador | `0x006DE770 + n*0x110`; descriptor `+0x0C`, dueño `+0x10` | probable |
| Cola de daño diferido | global `0x00414AD0`, contador `0x00414CD0` | probable |

## Herramientas

- **`herramientas/zonas.py`** (nueva) — `listar` / `escribir` / `restaurar`
  sobre la tabla de zonas. Busca por cadena de punteros desde el pool de
  enemigos; sólo escribe las palabras que hoy son factores plausibles, así no
  pisa los denormales de las zonas 17-23.
- **`herramientas/armas.py`** — lo mismo para la tabla de armas.
- **`pine.py volcar 0x0 0x2000000`** tarda **~3 s**. Volcar y trabajar
  offline es mucho más barato que leer dirección por dirección.

## Trampas que ya se pagaron

- **`lw $a0, 0x3c($a1)` es una CARGA, no `a1+0x3C`.** Comerse una indirección
  al seguir una cadena de punteros da tablas de ceros que parecen un
  hallazgo. Lo que la corrigió fue el barrido que **no** dependía de la
  cadena: buscar el float `0.255` suelto en los 32 MB.
- **No escribir en `0x0042Cxxx`**: es zona de HUD, mete barras negras.
- **No escribir valores arbitrarios en `0x006CF54C`**: índice de render, crashea.
- **Los breakpoints de EJECUCIÓN crashean PCSX2**; los watchpoints no.
- `capstone` necesita `CS_MODE_MIPS64 + skipdata=True`; en `MIPS32` devuelve
  cero instrucciones sin avisar (lección 14).
- **No llamar `dis.py` a un script**: colisiona con el módulo `dis` de la stdlib.
- **`pruebas/prueba_herramientas.py` borra `construido/.gitkeep`** (hace
  `rmtree` de `construido/`). Restaurarlo con
  `git checkout -- black/construido/.gitkeep` antes de commitear.

## Estado de la máquina

- ISO montado en `D:`. Desmontar con
  `Dismount-DiskImage -ImagePath "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"`.
- **Parche vivo, uno solo** (se pierde al recargar el emulador): `0x0013BD20`
  en nop = **vida infinita del jugador PUESTA**. Todo lo demás restaurado: los
  34 `Power` (34/34), los 36 factores de zona (36/36) y `0x00134654` en
  `0xE61402F8`.
- `volcados/ee-4b.bin`, `ee-4b-antes.bin`, `ee-4b-post.bin` — la RAM con la
  tabla de zonas intacta y las dos puntas de la medición que cerró la 4b.

## Deuda conocida

- `armas.py` y `zonas.py` no tienen test en `pruebas/`.
- No se validó `herramientas/windows/preparar_entorno.ps1` de punta a punta.
