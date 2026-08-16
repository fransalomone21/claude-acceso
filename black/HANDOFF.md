# Handoff — arrancar el chat de la Fase 4

Copiá esto como primer mensaje del chat nuevo:

```
Leé black/CLAUDE.md, black/ESTADO_ACTUAL.md y la primera entrada de
black/docs/03-bitacora.md. Vamos por la Fase 4: la tabla de armas.
```

Con eso alcanza. **No pegues este chat.** El `kb/` y la bitácora son la
memoria; el historial no hace falta y cuesta diez veces más.

---

## Las tres líneas, ya resueltas para el chat nuevo

**Fase** — 4, la tabla de armas. Las fases 1, 2 y 3 están **cerradas con
efecto confirmado**. La 4 cierra cuando se pueda leer o escribir el daño de
un arma concreta y verlo en pantalla.

**Modelo** — **Opus**. Es lectura de desensamblado e hipótesis sobre
estructuras, que es exactamente donde el plan dice que se paga solo. Bajar a
Sonnet recién cuando haya que cargar datos al `kb/` o escribir un mod.

**Contexto** — chat nuevo, limpio. El anterior terminó con medio mapa de
memoria adentro y el plan advierte que lo primero que se degrada en un
resumen son las direcciones hexadecimales.

---

## Por dónde entrar (esto es lo importante)

La pista vieja del `26.0` **se debilitó** y conviene no volver a ella de
entrada: esa región de BSS resultó ser un bloque de parámetros sueltos, no
una tabla, y la tabla **no está en el ISO** (0/5 ventanas coinciden con
archivo alguno). Detalle en `docs/05-iso.md`.

El hilo bueno es la **causalidad del daño**, ya trazada:

- En las dos rutinas de daño el valor **llega como argumento en `$f12`**
  (`mov.s $f21,$f12` en la del jugador, `mov.s $f20,$f12` en la del enemigo).
  No sale de ninguna tabla adentro de la rutina: **lo calcula quien llama**.
- Hay **34 sitios de llamada** al método virtual #8, hallados con el patrón
  `lw rX, 0x4c(rY)` seguido de `jalr rX`. El primero es `0x0013A83C`.
- El camino: agarrar los sitios de llamada que salgan del código de
  proyectiles y mirar **cómo arman `$f12`** antes del `jalr`. Ahí está el
  daño del arma, y de ahí se sube a la tabla.

Alternativa barata si eso se traba, y **es observación pura, sin riesgo**:
el cargador se ve en el HUD, así que es más fácil de anclar que el daño.
Localizar el tamaño de cargador de un arma y ver si el patrón se repite a
intervalos fijos — eso es lo que dice el escalón 5 de `docs/02-metodologia.md`.

## Herramientas que hay ahora y no había antes

- **`herramientas/clases.py`** — clases de entidad por vtable. `dano <volcado>`
  reproduce el censo que resolvió la Fase 3 en un comando.
- **`capstone`** (`pip install capstone`, ya instalado). `mips.py` **no**
  decodifica FPU. Usar `CS_MODE_MIPS64 + skipdata=True`; en `MIPS32` devuelve
  cero instrucciones sin avisar (lección 14).
- **`docs/05-iso.md`** — el ISO entero mapeado: `offset = vaddr − 0xFF000`
  (verificado 6/6), formatos, armas, tipos de enemigo.

## Estado de la máquina

- ISO montado en `D:`. Desmontar con
  `Dismount-DiskImage -ImagePath "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"`.
- Savestate del punto de trabajo en el **slot 6**.
- `volcados/ee-06.bin` es la RAM del EE de ese savestate — con eso se trabaja
  offline, sin PCSX2 abierto y sin riesgo.
- **Parches vivos en memoria** (se pierden al recargar el emulador):
  `0x0013BD20` en nop = vida infinita del jugador. `0x00134654` **restaurado**
  a `0xE61402F8` tras la prueba, o sea que los enemigos vuelven a morir.

## Direcciones que no hay que volver a buscar

| Qué | Dónde | Confianza |
|---|---|---|
| Vida del jugador | `0x005A8DA8` = jugador `0x005A8AB0` + `0x2F8` | confirmado |
| Daño al jugador | `0x0013BD20` — nop = vida infinita | confirmado |
| Clase del jugador | `0x003DC5F8` (puntero en objeto **`+0x10`**) | confirmado |
| Clase del enemigo | `0x003DCA78` — 32 objetos, paso `0x3C0`, vida `100.0` | confirmado |
| Daño al enemigo | `0x00134654` — nop = enemigos invulnerables | confirmado |
| Clamp de muerte del enemigo | `0x00134514` | probable |
| Método virtual #8 = "recibir daño" | `vtable+0x4C` | confirmado |
| Daño de AK47 | `26.0` por bala | confirmado |

**Callejones ya recorridos, no repetir:** `0x0013C120` es el método #9 de la
clase del **jugador**, no de enemigos. El escaneo diferencial no sirve para
la vida de un enemigo (muere antes de converger). La tabla de armas no está
en el ISO. Los saves de GameFAQs son Max Drive/CodeBreaker y no se pueden
usar sin herramientas de terceros.
