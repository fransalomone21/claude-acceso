# 14 — Diseño del mod COOP (Fase B)

Escrito el 2026-09-28 (93), con el mod ya fabricado en su mayor parte: este documento **no inventa**, fija
lo que el pnach hace, dónde lo hace y con qué se mide. La fuente del código es `herramientas/coop_mod.py`
(`programas()`); este documento es su **plano**, y `coop_diseno.py verificar` mide que no se separen.

La meta (PDP §3, M2): **dos jugadores en pantalla dividida en la misma PS2 emulada**, cada uno con su mando,
desde el menú de PCSX2 (un bloque de pnach), en toda la campaña.

## 1. Requisitos y cómo se verifica cada uno

| # | Requisito | Método | Estado (bitácora) |
|---|---|---|---|
| R1 | J2 se construye en la carga de **cualquier nivel de la campaña**, sin Python ni PINE | `campana_coop.py`: FASE 2 y ESTADO 3 por nivel | City Streets (88); la campaña, (93e) |
| R2 | J2 camina y mira con el mando del puerto que J no usa | `coop_mod.py manos 2` (metros); Fran con dos mandos | (88), (90c) |
| R3 | La pantalla se parte: J a la izquierda, J2 a la derecha, cada uno con su cámara y sin aplastar | captura por mitades, con control | (84), (89) |
| R4 | J2 se ve como un personaje desde J (títere) y el títere no tapa la vista de J2 | captura + contador de la pasada 2 | (85), (88), (93b) |
| R5 | J2 dispara, hace daño y recarga | RAM (cargador, reserva, estado), con control | (85), (91), (93) |
| R6 | Cargas seguidas sin cuelgue (salir y entrar a niveles) | `campana_coop.py` carga cada nivel desde el anterior | (87), (93c) |
| R7 | Nada del coop se pisa con otro componente ni con otro mod de `mods/` | `coop_diseno.py verificar` = 0, su saboteador en rojo | este documento |

## 2. Componentes

Cada uno con su gancho, su memoria y cómo se entrega. **Entrega: todo por pnach** (bloque `COOP - jugador 2
(B3)`, `mods/coop.toml` generado por `coop_mod.py toml`, instalado por `coop_mod.py instalar`); nada en el ISO.
Los datos no van en el pnach: nacen del `.bss` en cero.

- **Alta de J2 (envoltorio del cargador).** Gancho `0x00128EA4` (`jal 0x00129090` → envoltorio). Copia J como
  molde, construye a J2 con la aparición de J (`FUN_0012BD98`, `FUN_00139C68`), lo registra
  (`FUN_0016E660`) y, si nació en la misma x que J, **lo corre 1 m** (93c: encimados, la colisión cae).
- **Por cuadro.** Gancho `0x00129574` (`jal 0x0013BAC8` → stub): espera 30 cuadros, prepara el control 2 (el
  puerto que J no usa, (90c)), el cabeceo (88c), lo enlaza y le ata el controlador de colisión
  (`FUN_0025C210`); después, cada cuadro, el update de J2, **la recarga** (93) y **el títere** (88).
- **Desarme.** Gancho `0x00129E38` (`jal 0x0012BFC8` → baja): suelta el controlador de J2 y lo saca de la
  lista al salir del nivel (87).
- **Pantalla dividida.** Tres ganchos a `FUN_001297E0` → stub de la pantalla: dos pasadas con sub-raster de
  media anchura, la vista de J2 calculada en el stub, la proporción a la mitad (84)–(89).
- **Filtro del tinte.** Gancho `0x00129AD0` → filtro: el tinte a pantalla completa no se dibuja por mitad (89b);
  la llamada única del final queda en `nop` (90b).
- **Visibilidad por pasada.** El callback de dibujo de la escena (`lui/addiu` en `0x001298F8/0x00129900`) →
  filtro: la pasada 1 no dibuja a J2, la 2 no dibuja al títere (93b).

### Política de los riesgos medios (PDP §4, punto 2)

- **IA frente a J2 (B4, `ia`).** Leído en frío (93d): cada bando guarda **un** jugador (`bando+0x10` y la
  ranura 3 de la escuadra, `FUN_00172618`/`FUN_00172C00`, escritos una vez al armar el nivel con el jugador 0,
  `FUN_00172830`), y la lista de proximidad de un agente (`FUN_0018B190`) es el jugador 0 más los 16 agentes
  de `ia+0x2B00`. J2 no está en ninguna: **los enemigos no saben que J2 existe** (`probable`). **Política
  v1: se acepta** — J2 no es blanco, J sí; es lo más barato y no rompe nada. La alternativa (sumar a J2 a la
  lista de `FUN_0018B190` y alternar `bando+0x10`) queda como mejora si Fran lo pide.
- **Muerte de J2 (B5, `flujo`).** Sin fuego amigo (85) y sin ser blanco de la IA, a J2 sólo lo mata el
  entorno. Lo que hace el juego con la vida de J2 en 0 se mide en (93f). Política v1: si J2 muere, reaparece
  junto a J (misma alta que la carga).
- **Disparadores (B6, `disparadores`).** Leído en (73): las zonas disparadoras prueban **sólo la posición del
  jugador 0** (`juego+0x1C0`). **Política v1: J abre el camino** — puertas, oleadas y el fin del nivel los
  dispara J; J2 acompaña. Mejora posible: traer a J2 junto a J si queda lejos.

## 3. Memoria y ganchos

Lo que sigue lo lee `herramientas/coop_diseno.py`: cada fila es un rango `[desde, hasta)`, su tipo y su
fuente (una entrada de bitácora `(NN)` o un archivo de `kb/`). **Los rangos de código tienen que coincidir
con los de `coop_mod.py`**: si el código crece y este plano no, el verificador lo marca.

```coop-rangos
# nombre                    | desde      | hasta      | tipo   | fuente
J2 (el jugador 2)           | 0x0046CDF0 | 0x0046D6B0 | datos  | (79)
datos del mod               | 0x0046D780 | 0x0046D7D4 | datos  | (86)
por cuadro                  | 0x0046D800 | 0x0046D9E0 | codigo | (86)
envoltorio                  | 0x0046DA00 | 0x0046DBB4 | codigo | (93c)
armas de J2                 | 0x0046DBC0 | 0x0046DBE0 | datos  | (86)
desarme                     | 0x0046DD00 | 0x0046DD90 | codigo | (87)
elegir titere               | 0x0046DE00 | 0x0046DE64 | codigo | (93h)
titere elegido              | 0x0046DEF0 | 0x0046DEF4 | datos  | (93h)
aislar bandera              | 0x0046DEF4 | 0x0046DEF8 | datos  | (93l)
aislar vista FP             | 0x0046DF00 | 0x0046E02C | codigo | (93l)
aislar evento FP            | 0x0046E070 | 0x0046E0B0 | codigo | (93m)
aislar contadores           | 0x0046E040 | 0x0046E070 | datos  | (93l)
pantalla                    | 0x0046F800 | 0x0046FAD4 | codigo | (89b)
filtro del tinte            | 0x0046FB00 | 0x0046FB20 | codigo | (89b)
ocultar por pasada          | 0x0046FB20 | 0x0046FBB8 | codigo | (93b)
ocultar datos               | 0x0046FBF0 | 0x0046FC00 | datos  | (93b)
pantalla datos              | 0x0046FC00 | 0x0046FC98 | datos  | (88e)
falso 1 (sólo pruebas)      | 0x00472000 | 0x004720F0 | datos  | (77)
falso 2 (sólo pruebas)      | 0x00472100 | 0x004721F0 | datos  | (86)
gancho por cuadro           | 0x00129574 | 0x00129578 | gancho | (86)
gancho del cargador         | 0x00128EA4 | 0x00128EA8 | gancho | (86)
gancho del desarme          | 0x00129E38 | 0x00129E3C | gancho | (87)
gancho del tinte            | 0x00129AD0 | 0x00129AD4 | gancho | (89b)
gancho callback lui         | 0x001298F8 | 0x001298FC | gancho | (93b)
gancho callback addiu       | 0x00129900 | 0x00129904 | gancho | (93b)
gancho vista FP 0           | 0x001D6E78 | 0x001D6E80 | gancho | (93l)
gancho vista FP 1           | 0x001D7360 | 0x001D7368 | gancho | (93l)
gancho vista FP 2           | 0x001D7500 | 0x001D7508 | gancho | (93l)
gancho vista FP 3           | 0x001D73D8 | 0x001D73E0 | gancho | (93l)
gancho vista FP 4           | 0x001D6F90 | 0x001D6F98 | gancho | (93l)
gancho evento FP            | 0x001E80C0 | 0x001E80C8 | gancho | (93m)
```

Los tres ganchos de la escena (`pd.SITIOS`) los compara el verificador contra `pantalla_dividida.py`
directamente: están en esa fuente, no en esta tabla, y se exige que no caigan en ningún rango de arriba.

## 4. Interfaz con los otros mods

Los otros bloques de `mods/` (`auto-apuntado`, `dano-x2`, `mira-*`, `zona-muerta-cero`) escriben datos o
instrucciones sueltas en el ELF. `coop_diseno.py` lee todas sus `direccion = ...` y exige que **ninguna**
caiga en un rango del coop. Los tres de mira se prenden sólo con mouse (90e); con dos mandos quedan apagados.
