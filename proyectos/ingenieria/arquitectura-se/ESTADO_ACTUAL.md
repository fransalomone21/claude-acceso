# ESTADO ACTUAL — arquitectura-se

**Fase 7 ABIERTA** (validar ≠ verificar, tipo D): T1 del diagnóstico
**diseñada** el 2026-09-28; **construidos los pasos 1 (medidor), 2 (arranque
partido), 3 (pilares en dos hooks), 4 (núcleo de chequeo en cuatro) y 5 (hook
al paso)**. Falta el 6: validar en 3–5 sesiones reales con 0 cortados y 0
cancelados (los pasos 2, 3 y 4 ya pasaron una; el 5 empieza a contar desde
la próxima sesión, porque instalarlo movió `settings.json`).
**Paso 6, cuenta con el hook al paso: sesión 1 de 3–5 LIMPIA (2026-09-28,
21:32)** — `medir-inyeccion.py --solo despues` = 1 sesión posterior al cambio
del 21:17, 0 cortados y 0 cancelados; `disparos.log` sin una línea ERROR
(1 324 líneas; las 6 claves de `al-paso` salen todas OK, pero las de 21:31:59
son las muestras sintéticas del propio medidor, no disparos reales de esta
sesión). Faltan 2–4.

**Fase 6 CERRADA** el 2026-09-17. Cerró por lo que la cerraba (`PDP.md` §4):
**`chequeo-completo.ps1` en verde, todos los saboteadores corridos, y un
proyecto real migrado a la matriz.** Los tres, medidos:

```
Chequeo OK. Ningun rojo.      7 medidores + 10 saboteadores + 7 de limpieza
```

**Fue la primera fase que tocó archivos vivos**, con rigor **pleno**
(`docs/matriz-cumplimiento.md` §4, aspecto `c`): saboteador antes de dar por
puesta cada pieza, no después. **Abre la fase 7** (validar ≠ verificar).

## Lo que quedó instalado

| Pieza | Estado | Lo que la hace cobrable |
|---|---|---|
| **P2** matriz por proyecto | **cumple** | `medir-matriz.py` + `probar-medidor-matriz.ps1` (6 casos) |
| **P3** rigor por aspecto | **cumple** | `plantillas/PDP.md` §3, y la instancia en el PDP de este proyecto |
| **P4** molde de fase | **cumple** | `medir-fase.py` + `probar-medidor-fase.ps1` (6 casos) |
| **P5** heurísticas al paso | **recortado**, mitad puesta | `hooks/guardia-escapes.ps1` + `probar-guardia-escapes.ps1` (10 casos) |
| **P6** criterio de entrada | **cumple** | `aprender.py --opuesto` + 3 casos en `probar-chequeo-lecciones.ps1` |
| **P7** System 2 / System 3 | **cumple** | `perfil-global/README.md`, sin reescribir la cascada |
| **P1** catálogo derivado | **no aplica — todavía** | difiere, con la resta escrita |
| **P10** medidor de validación | **fase 7** | a propósito |

**Los tres defectos vivos, cerrados:** D12 (el conteo se **deriva**: el
`INDICE.md` pasó solo de 186 a 212), D14 (el chequeo de requisitos dejó de ser
de idioma inglés) y el medidor de desuso (C6 dejó de ser una intención).

**El proyecto migrado es este mismo:** su `PDP.md` lleva el rigor por aspecto
(§3 bis), la columna *Cómo se certifica* con la salida `cancelar` (§4) y la
matriz de cumplimiento (§8). **38 filas, 33 cumple, 2 no aplica, 3 recortado**,
todas las recortadas con su resta escrita.

## Lo que se encontró midiendo, y no estaba en el plan

- **El freno de D12 existía, y su saboteador daba verde sobre el defecto
  vivo.** El patrón de `install.ps1` estaba anclado a la **primera línea** y el
  saboteador rompía el archivo **ahí mismo**; el `186` real vivía en la línea
  19. **Un saboteador escrito por el autor del freno hereda su punto ciego.**
  Es el argumento más fuerte que tiene el proyecto para que **P8 siga declarada
  como hueco sin respuesta** en vez de darse por cubierta con los saboteadores.
- **Cinco archivos vivos tenían un carácter de control adentro**, invisible en
  cualquier editor: `chequeo-de-trabajo.md` (que **se inyecta en cada
  sesión**), `MAQUINA-NUEVA.md`, `verificar-requisito.py` —donde **apagaba en
  silencio una excepción de R16**— y **dos datos técnicos de BLACK medidos
  contra el ELF y contra la máquina**. Los cinco eran un escape de C en un
  string no-raw. Ahora lo mide la **regla 8** de `verificar-estructura.ps1`
  sobre los 288 archivos que el repo trackea.
- **La lección de ese error ya estaba escrita, con triage `propia`, e
  inyectada en `chequeo-de-trabajo.md` línea 553.** Estuvo en el contexto todo
  el tiempo y el error se cometió **cinco veces igual**. A 95 KB, 1347 líneas y
  154 viñetas, **la inyección dejó de ser entrega** — que es, palabra por
  palabra, lo que Rechtin p. 35 describe como hojear una ferretería. Es P5
  medido en carne propia, y es lo que decidió construir su guardia.
- **Dos saboteadores sanos reportados en rojo** por no cerrar con `exit 0`:
  heredaban el código del último comando nativo, que en un saboteador es por
  construcción uno que **tiene** que fallar.

## 2026-09-26 — D15 y P11: el ciclo de vida que la reforma no trajo

Medido en BLACK, no en este proyecto: la reforma tomó de NASA el tailoring, la
matriz y V&V, pero **no el ciclo de vida de arriba hacia abajo** (Pre-Fase A,
refinamiento sucesivo, programa/proyecto, madurez). BLACK hizo 61 entradas de
detalle y leyó último el arranque que construye sus 37 subsistemas. **P11**
quedó diseñada en `docs/arquitectura.md` §3, con piloto en BLACK y una sección
nueva en `plantillas/naturalezas/ingenieria.md`. El medidor genérico se
difiere hasta que un segundo proyecto la use. **No cambia el criterio de
salida de la fase 7** (P10): son la misma preocupación —construir la cosa
correcta— de los dos lados. P11 elige antes de construir; P10 mide después si
sirvió.

## 2026-09-28 — el diagnóstico medido del método entero

Pedido de Fran desde una sesión de BLACK (109): los problemas de arquitectura
de todo el sistema, medidos, para dedicarles sesiones de reforma.
**[`docs/diagnostico-2026-09-28.md`](docs/diagnostico-2026-09-28.md)**: A1–A11,
el N² de las interfaces (la columna *Sesión* —el único consumidor— tiene una
entrada verificada y cinco rotas) y el camino crítico T1 → T2 → T3 → T4 → T7 →
T9 (~9-16 sesiones, `hipótesis`). **A1 cambia la prioridad de P5:** la
inyección no es que pese mucho, es que **no llega** — el harness muestra 2 KB
de los 129 KB de `chequeo-de-trabajo.md` y de los 12,6 KB de `pilares.md`.
De paso: la cascada mide ahora si todo está **al día** por git
(`probar-cascada.ps1`), y la fila 6 del PDP quedó marcada CERRADA. Al cerrar,
A11 (sesiones paralelas) se vio en vivo: dos sesiones en el mismo árbol a la
vez, y el rojo de una era trabajo en curso de la otra.

## 2026-09-28 (noche) — T1 diseñada: el umbral medido y el arranque que se pierde

**[`docs/t1-presupuesto-inyeccion.md`](docs/t1-presupuesto-inyeccion.md)**, en
frío, sin tocar nada vivo. **El umbral es 10 000 caracteres por hook**
(`confirmado` por dos caminos: la constante en el binario de Claude Code
2.1.284 y un censo de 1 235 salidas de hooks sin una excepción); es por hook,
así que partir sirve. `chequeo-de-trabajo.md` llega cortado desde el **22/08**.
**Y el arranque del repo se pierde entero en 13 de las últimas 30 sesiones**:
tarda 58 s contra 60 de timeout (su comentario dice 7 s) y el texto fijo muere
con la medición. `verify-install` decía `[OK] emite 134667 chars`: medía el
efecto sin umbral. **Elegida la D**: núcleo generado de `chequeo` en dos hooks
(las 198 reglas de cabecera, 17,5 K), el detalle **al paso** sólo para los
momentos que discriminan (la sonda sobre 165 sesiones mostró que «creerle» y
«negativo» disparan en el 93–98 % y en la 4.ª llamada: van al núcleo),
`pilares` en dos hooks, el arranque partido con fecha límite interna, y el
medidor `medir-inyeccion.py` con su saboteador **primero**. Al arrancar: de
160 K emitidos y 16 K recibidos a ~45 K emitidos y recibidos. De paso, la línea
`Fase en curso` del PDP seguía en «6 — Migrar» (el hook la lee a ella, no a la
fila): corregida a 7, tipo D, **y medido el efecto** sobre lo que el hook
inyecta.

## 2026-09-28 (noche, 2.ª) — T1 pasos 1 y 2 construidos

- **El medidor** `perfil-global/herramientas/medir-inyeccion.py`, en los
  medidores de `chequeo-completo.ps1`: nació **en rojo sobre el estado de
  hoy**, como pedía el §7 — `pilares` 12 863 y `chequeo` 133 973 (antes) y
  los tres cortes/cancelaciones de las sesiones posteriores al último cambio
  de settings (después); **amarillo** en la apertura (9 592, margen 408). Su
  saboteador `perfil-global/probar-medir-inyeccion.ps1`, **10 de 10** (siete
  del §6 + 10 000 exactos, cortes anteriores al cambio y 5 000 limpio), y
  **saboteado él mismo**: sin umbral y sin leer `hook_cancelled`, da CIEGO.
  `verify-install` dejó de imprimir el número: mide que el hook anda; el
  tamaño tiene un solo medidor.
- **El arranque partido:** `arranque-proyecto.ps1` = sólo el texto (0,5 s,
  timeout 15); `arranque-medicion.ps1` = la capa rápida **en paralelo** con
  `-FechaLimite 40` (nuevo en `chequeo-completo.ps1`): entrega lo que terminó
  y nombra lo que no («SIN MEDIR»), matcher `startup|resume|clear` (no corre
  en compact). Medido: **41 s de pared** contra 56 s en serie. `probar-hooks`
  51 OK, con un caso nuevo (fecha límite 2 s → termina y nombra), roto a
  propósito sin fecha límite: da rojo.
- **Corrige a S3:** `publicar-apuntes -Verificar` es **bimodal corriendo
  solo** (10–11 s o 45–46 s, 5 corridas): la lentitud no era por correr junto
  al otro de Drive. En el arranque su modo lento sale «SIN MEDIR».

## 2026-09-28 (noche, 4.ª) — T1 paso 5: el hook al paso

- **Paso 0, validado:** la primera sesión con pilares y núcleo partidos dio
  `medir-inyeccion --solo despues` = **0 cortados y 0 cancelados** (1 sesión
  posterior al cambio de settings).
- **`perfil-global/hooks/al-paso.py`** (PreToolUse, registrado por
  `install.ps1` desde `Get-Guardias` con `Interprete`/`Decide`/`Timeout`
  nuevos; desinstalable sacando su entrada de `settings.json`): clasifica cada
  llamada por herramienta y entrada, e inyecta las viñetas **enteras** de la
  clave **una vez por sesión** (estado por `session_id` en
  `hooks/al-paso-estado/`, poda a 3 días). **Seis claves** que discriminan
  según S2: `freno`, `fanout`, `gui`, `rclone`, `typst`, `pcsx2`. Emite
  8 441 / 3 799 / 1 532 / 5 242 / 7 029 / 7 350 (tope 9 000 de **stdout**,
  con los escapes del JSON). Queda **fuera** ghidra y gh: la sonda no midió
  si discriminan.
- **`freno` no entra entero:** son 31 viñetas (~18 K) y salen 16; el pie del
  extracto dice cuántas faltan y dónde leerlas. Es el orden de la fuente, no
  un ranking; si pesa, el arreglo es entregar el resto en la segunda llamada de
  la clave (cambio de diseño: vuelve al doc).
- **Falla abierto a propósito** (no decide, inyecta): cualquier error termina en
  silencio y queda en `disparos.log`. Su primera versión falló abierto en las
  seis claves por un BOM (PowerShell 5.1 lo antepone al pipe) y **sólo el log
  lo delató**: por eso el saboteador exige el *texto* y no `exit 0`.
- **`probar-al-paso.ps1`, 20 de 20**, en `chequeo-completo`: efecto por clave,
  la viñeta entera llega, una vez por sesión (y sus dos controles), no dispara
  en Read / `ls` / `.md`, fuente ausente, stdin roto, **tres mutaciones del
  hook** (sin tope, sin marcar, todo es clave) que ponen en rojo su caso, y el
  medidor (control verde, clave > 10 000, fuente vacía).
- **`medir-inyeccion`** corre ahora una entrada sintética por clave (la declara
  el hook con `--muestras`) y da FAIL si una clave pasa 10 000 o no emite.
  `verify-install` comprueba registro y efecto (`additionalContext` ante un
  Write a `hooks/`, silencio ante Read).
- **Confirmado en sesión real** (no sólo en frío): el `settings.json` se
  recargó en caliente y el primer `rclone` de la sesión trajo las 7 viñetas
  como `PreToolUse:Bash hook additional context`; el segundo, nada.

## Lo que FALTA, para la fase 7

- **T1, validar (paso 6)** según `docs/t1-presupuesto-inyeccion.md` §7:
  **pasos 1 a 5 hechos** (pilares 7 940 + 4 791; núcleo 6 831 / 3 732 / 7 790
  / 7 764; hook al paso en 6 claves). Falta 0 cortados y 0 cancelados en 3–5
  sesiones reales, que la mitad «después» del medidor cuenta sola; como
  instalar el paso 5 movió `settings.json`, la cuenta arranca de nuevo en la
  próxima sesión. Riesgo nuevo: un momento de `chequeo-de-trabajo.md` que
  pase ~8 900 de cabeceras no entra en ningún hook (el corte es por momento);
  lo atrapa el medidor.
- Después, el resto del camino crítico del diagnóstico (T2 → T3 → T4 → T7 →
  T9).

- **P10, el medidor de validación** — *timely / affordable / predictable /
  comprehensive* (SEH p. 165-166), contra el costo por fase ya registrado acá
  abajo. Es lo que cierra la fase 7.
- **P1, el catálogo derivado**, diferido con su resta escrita en la matriz.
- **La mitad de P5 que falta:** partir `chequeo-de-trabajo.md` — la primera
  condición ya está (se inyecta el núcleo, 26 K en vez de 134 K, y llega
  entero); la segunda, **la lección del paso en curso adentro**, es el hook al
  paso (T1 paso 5).
- **`ingenieria-de-sistemas.md`** con las 4 correcciones de `arquitectura.md`
  §8, y la pregunta abierta: ¿sigue haciendo falta, o el catálogo P1 más las
  cuatro fichas ya lo reemplazan?
- **Migrar los otros 7 PDP.** `medir-fase.py` los cuenta: hoy **1 en verde, 7
  sin migrar**, y ese número tiene que bajar.

## Coste

- **Fase 0:** 2,07 M tokens de subagentes y un límite de 5 h en 6,6 minutos.
  **La matriz lo reclasificó de tailoring a error**, con la resta escrita.
- **Fases 1-5:** inline, entre 7 y 12 puntos del límite de 5 h cada una.
- **Fase 6:** inline, sin un solo subagente, **cero PDF extraídos**. Los tres
  defectos vivos, cinco piezas instaladas, **cinco saboteadores nuevos**, dos
  medidores nuevos, una regla de estructura nueva, un guardia nuevo y ocho
  lecciones, por **~31 puntos** del límite de 5 h (dos ventanas: 39→55 % y
  9→17 %+) y **4** del semanal (82 % → 86 %), medidos al cerrar.
  **Sexta fase seguida sin fan-out.**
