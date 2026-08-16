# Handoff — arrancar el chat que sigue

Copiá esto como primer mensaje del chat nuevo:

```
Leé black/CLAUDE.md, black/ESTADO_ACTUAL.md y la primera entrada de
black/docs/03-bitacora.md. La Fase 4b está resuelta en análisis: el daño de
salida del jugador sale de la tabla de ZONAS DE IMPACTO, no de Power. Falta
sólo el test por efecto, que ya está montado.
```

Con eso alcanza. **No pegues el chat anterior.** El `kb/` y la bitácora son la
memoria; el historial no hace falta y cuesta diez veces más.

---

## Las tres líneas, ya resueltas para el chat nuevo

**Fase** — 4b, último tramo. Cierra con **una bala**: con los factores de zona
en 3.0, un enemigo tiene que morir de un solo impacto al cuerpo en vez de
cuatro. Si muere, `zona_impacto` y `calcular_dano_zona` pasan de `probable` a
`confirmado` y se abre la Fase 5.

**Modelo** — **Sonnet** alcanza: el desensamblado ya está leído y el análisis
cerrado. Lo que queda es correr el test, actualizar el `kb/` y escribir el
mod. Subir a Opus sólo si el test falla y hay que volver al desensamblado.

**Contexto** — chat nuevo. Lo que sigue no necesita nada del anterior.

---

## El test pendiente, en tres comandos

Los factores **ya están escritos en 3.0** (36/36, sin discrepancias). Si el
emulador no se recargó desde entonces, sólo falta disparar:

1. Una bala al **cuerpo** de un enemigo. Antes hacían falta cuatro.
2. Medir, no confiar en la impresión:

```bash
python herramientas/pine.py volcar 0x0 0x2000000 volcados/ee-post.bin
```

   El pool de enemigos está en `0x0058FE90`, paso `0x3C0`, vida en `+0x2F8`.
   Línea de base en `volcados/ee-4b-antes.bin`: #6 en 49.0, #2/#9/#11 en 100.0.

3. Restaurar siempre, haya salido o no:

```bash
python herramientas/zonas.py restaurar volcados/zonas-originales.json
```

**Si el emulador se recargó**, los factores volvieron solos a los originales.
Rehacer: volcar, `zonas.py listar` para ver la tabla nueva, y
`zonas.py escribir <volcado> 3.0 --guardar volcados/zonas-originales.json`.

**Y el confound que hay que descartar** (lección 16, que salió justo de esto):
releer un factor **después** del disparo para comprobar que el 3.0 seguía
puesto. Un enemigo que muere con el parche perdido no prueba nada.

## Lo que ya está resuelto (no volver a buscarlo)

| Qué | Dónde | Confianza |
|---|---|---|
| Vida del jugador | `0x005A8DA8` = jugador `0x005A8AB0` + `0x2F8` | confirmado |
| Daño al jugador | `0x0013BD20` — nop = vida infinita | confirmado |
| Clase del jugador | `0x003DC5F8` (puntero en objeto **`+0x10`**) | confirmado |
| Clase del enemigo | `0x003DCA78` — 32 objetos, pool `0x0058FE90`, paso `0x3C0`, vida `100.0` | confirmado |
| Daño al enemigo | `0x00134654` — nop = enemigos invulnerables | confirmado |
| Método virtual #8 = "recibir daño" | `vtable+0x4C` | confirmado |
| Tabla de armas (daño **hacia** el jugador) | 17 registros de `0x1E0`, `Power` en bloque+`0x18` | confirmado |
| **Daño de salida del jugador = `zona * 100.0`** | **`0x00142B90`**, tabla de `0xC` por zona | **probable — es el test** |
| Objeto de arma por tirador | `0x006DE770 + n*0x110`; descriptor `+0x0C`, dueño `+0x10` | probable |
| Cola de daño diferido | global `0x00414AD0`, contador `0x00414CD0` | probable |

## Después del test: la Fase 5

Con las dos tablas identificadas, la pregunta de la Fase 5 cambia de forma. Ya
no es "de dónde sale el daño" sino **qué elige la zona**: el `$a1` que entra a
`0x00142B90` es un byte con signo que sale del sistema de colisión con el
esqueleto. Ahí está la diferencia entre un headshot y un tiro al brazo, y es
lo que falta para un mod de daño que se comporte bien.

Segundo pendiente, más barato: el `* 0.7` de `0x00142DF4` depende del
**"Weapon Impact Level"** del tirador (`[[tirador+0x2A4]+0x108]`) — que es uno
de los nombres de campo que están escritos en texto en el ELF. Ese sí conecta
el arma con el daño de salida, y es el único lugar donde lo hace.

## Herramientas

- **`herramientas/zonas.py`** (nueva) — `listar` / `escribir` / `restaurar`
  sobre la tabla de zonas. Busca por cadena de punteros desde el pool de
  enemigos, nunca hardcodeada; sólo escribe las palabras que hoy son factores
  plausibles, así no pisa los denormales de las zonas 17-23.
- **`herramientas/armas.py`** — lo mismo para la tabla de armas.
- **`pine.py volcar 0x0 0x2000000`** tarda **~3 s**. Volcar y trabajar
  offline es mucho más barato que leer dirección por dirección.

## Trampas que ya se pagaron

- **`lw $a0, 0x3c($a1)` es una CARGA, no `a1+0x3C`.** Comerse una indirección
  al seguir una cadena de punteros da tablas de ceros que parecen un
  hallazgo. El barrido que no dependía de la cadena (buscar el float `0.255`
  suelto en los 32 MB) fue el que la corrigió.
- **No escribir en `0x0042Cxxx`**: es zona de HUD, mete barras negras.
- **No escribir valores arbitrarios en `0x006CF54C`**: índice de render, crashea.
- **Los breakpoints de EJECUCIÓN crashean PCSX2**; los watchpoints no.
- `capstone` necesita `CS_MODE_MIPS64 + skipdata=True`; en `MIPS32` devuelve
  cero instrucciones sin avisar (lección 14).
- **No llamar `dis.py` a un script**: colisiona con el módulo `dis` de la stdlib.

## Estado de la máquina

- ISO montado en `D:`. Desmontar con
  `Dismount-DiskImage -ImagePath "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"`.
- **Parches vivos** (se pierden al recargar el emulador): `0x0013BD20` en nop
  = **vida infinita del jugador PUESTA**; **los 36 factores de zona en 3.0**.
  Los 34 `Power` y `0x00134654` están restaurados.
- `volcados/ee-4b.bin` — RAM con la tabla de zonas **intacta** (0x00709F40).
  `volcados/ee-4b-antes.bin` — línea de base del pool para el test.
