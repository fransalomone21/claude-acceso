# Handoff — arrancar el chat que sigue

Copiá esto como primer mensaje del chat nuevo:

```
Leé black/CLAUDE.md, black/ESTADO_ACTUAL.md y la primera entrada de
black/docs/03-bitacora.md. Falta cerrar el daño de SALIDA del jugador:
la tabla de armas ya está, pero el disparo del jugador no la usa.
```

Con eso alcanza. **No pegues el chat anterior.** El `kb/` y la bitácora son la
memoria; el historial no hace falta y cuesta diez veces más.

---

## Las tres líneas, ya resueltas para el chat nuevo

**Fase** — 4b, el último tramo: el daño de salida del jugador. Cierra cuando
se pueda **cambiar el daño que hace el jugador con un arma y verlo** (un
enemigo que muere en una bala en vez de cuatro, medido sobre el pool).
Después de eso, Fase 5.

**Modelo** — **Opus** para arrancar: hay que leer desensamblado del camino del
proyectil. Bajar a Sonnet cuando sea cargar datos al `kb/` o escribir el mod.

**Contexto** — chat nuevo. Lo que sigue no necesita nada del chat anterior
salvo direcciones, y todas están en `kb/`.

---

## Lo que ya está resuelto (no volver a buscarlo)

| Qué | Dónde | Confianza |
|---|---|---|
| Vida del jugador | `0x005A8DA8` = jugador `0x005A8AB0` + `0x2F8` | confirmado |
| Daño al jugador | `0x0013BD20` — nop = vida infinita | confirmado |
| Clase del jugador | `0x003DC5F8` (puntero en objeto **`+0x10`**) | confirmado |
| Clase del enemigo | `0x003DCA78` — 32 objetos, pool `0x0058FE90`, paso `0x3C0`, vida `100.0` | confirmado |
| Daño al enemigo | `0x00134654` — nop = enemigos invulnerables | confirmado |
| Método virtual #8 = "recibir daño" | `vtable+0x4C` | confirmado |
| **Cálculo del daño por arma** | `0x0015B118`, fórmula en `0x0015B20C` | confirmado |
| **Tabla de armas** | 17 registros de `0x1E0`, `Power` en bloque+`0x18` | confirmado |
| Cola de daño diferido | global `0x00414AD0`, contador `0x00414CD0` | probable |

## El problema exacto que quedó

Con **`Power = 300` escrito en los 34 campos de la tabla** (17 registros × 2
bloques), pasaron dos cosas a la vez:

- **Sí cambió** el daño que hacen las armas de la **IA**: dos enemigos
  murieron de un solo impacto por fuego amigo (`100 → 0`), y el usuario vio
  la reacción de "arma pesada" al recibir disparos.
- **No cambió** el daño que hace el **jugador**: siguió quitando exactamente
  **25.5** por bala, medido dos veces sobre el mismo enemigo
  (`100 → 74.5 → 49`).

O sea: el proyectil del jugador **no toma su daño del bloque `+0x90` de la
tabla compartida**. Y ese `25.5` no coincide con el `26.0` nominal, lo cual
es una pista y no un ruido.

## Por dónde entrar

Tres hilos, en orden de costo:

1. **La instancia del arma del jugador tiene su propia copia.** El BFS que
   encontró la tabla partió del objeto del jugador (`0x005A8AB0`) a
   profundidad 3 y dio 7 objetos cuyo `+0x0C` es un descriptor. Repetir eso
   **con la tabla escrita en 300** y ver cuáles siguen en 26: los que no
   cambiaron son copias, y ahí está el daño del jugador. Es barato: un
   volcado (3 s) y el script.

2. **Otra rutina.** De los 37 sitios de llamada al método virtual #8, sólo
   seis definen `$f12` cerca; se siguió uno. Los otros cinco están sin mirar:
   `0x0013A834` (`mtc1 $at,$f12`, constante — ¿melee?), `0x00140CD8` (×2),
   `0x001A2440`. Vale la pena hacer el backward-slice de los que quedan.

3. **De dónde sale el `25.5`.** No está guardado como constante en los 32 MB
   (6 apariciones, ninguna con forma de descriptor): se calcula. Si la
   fórmula es la de `0x0015B20C` con `falloff < 1`, el `arg/Range` da la
   diferencia contra 26.0 y eso identifica el descriptor por despeje.

## Herramientas nuevas de esta sesión

- **`herramientas/armas.py`** — `listar` encuentra la tabla por firma en un
  volcado e imprime las 17 armas; `escribir` pone un `Power` en todos los
  registros por PINE guardando los originales; `restaurar` los devuelve.
- **`herramientas/pine.py volcar 0x0 0x2000000`** tarda **~3 s**. Es mucho
  más barato de lo que se venía asumiendo: conviene volcar y trabajar
  offline en vez de leer dirección por dirección.

## Trampas que ya se pagaron

- **No escribir en `0x0042Cxxx`.** Es zona de HUD: los cinco `26.0` de ahí no
  son la tabla, y escribirles mete dos barras negras en pantalla.
- **Una firma de búsqueda sin mínimos realistas no filtra nada.** `0 < x`
  deja pasar floats basura de magnitud `1e-43` y la búsqueda devolvió 402
  falsos positivos. Poner cotas por abajo, no sólo por arriba.
- **No llamar `dis.py` a un script**: colisiona con el módulo `dis` de la
  stdlib y rompe el import de `capstone`.
- `capstone` necesita `CS_MODE_MIPS64 + skipdata=True`; en `MIPS32` devuelve
  cero instrucciones sin avisar (lección 14).

## Estado de la máquina

- ISO montado en `D:`. Desmontar con
  `Dismount-DiskImage -ImagePath "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"`.
- **Parches vivos** (se pierden al recargar el emulador): `0x0013BD20` en nop
  = **vida infinita del jugador PUESTA**. Todo lo demás restaurado: los 34
  `Power` volvieron a su valor original (34/34, 0 discrepancias) y
  `0x00134654` está en `0xE61402F8`.
- `volcados/ee-vivo.bin` es un volcado en vivo de esta sesión (nivel 1, con
  la tabla en `0x01842220`). `volcados/ee-06.bin` es el savestate slot 6.
