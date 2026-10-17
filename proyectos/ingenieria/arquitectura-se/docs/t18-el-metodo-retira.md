# T18 — el método también retira

**Sesión `ecd2332b`, 2026-10-17.** Fila 5 de la lluvia §6. Defecto: **DA-041** (el método sólo tiene flujos de
entrada). Requisitos: L1-17, L1-18, L2-RET-01..10, L2-NUC-01..03 en [`10-requisitos.md`](10-requisitos.md) §10.
Decisión de Fran (encuesta, lluvia §7): **sensor de uso + núcleo**, aviso en el cuadro, un freno nunca sale solo.

## 1. La pregunta de marco

*¿Qué tendría que ser verdad para que esto sea el problema equivocado?*

1. **Que «sin uso» no se pueda medir.** Se midió antes de preguntar: la caja negra de la puerta y el hook al paso
   registran disparos; las 379 lecciones y la memoria no. Resuelto con un **spike** (§2): el Transcript guarda todo lo
   que le llegó a la sesión, así que es un sensor que ya existe y no pide un hook nuevo (DA-041 en contra de sí mismo:
   el remedio de un método que sólo suma no puede ser otra capa).
2. **Que «sin uso» no signifique «sin valor».** Es el riesgo grande, y no se resuelve: se acota. Un renglón del núcleo
   que evita un error sin que nadie lea la viñeta entera se ve idéntico a uno que no sirve (Meadows: el freno que
   nunca salta). Por eso el retiro es un **experimento reversible**, no un borrado: la viñeta sigue en el chequeo (Grep
   y el hook al paso la siguen trayendo), vuelve sola si alguien la usa o si su lección se repite (T15), y sale de a
   10 por pasada para poder atribuir una recurrencia a un retiro.
3. **Que el stock que importa sea otro.** El núcleo es 28 505 de ~92 000 caracteres fijos; la memoria y el perfil son
   el resto. Fran eligió el núcleo para la primera versión; la memoria queda para la siguiente, con este mismo sensor.

## 2. El spike, medido el 2026-10-17

Sobre 130 Transcript de la PC (713 MB, desde el 2026-08-14) y los 36 informes de `.claude/auditorias/`:

| Medida | Valor |
|---|---|
| Viñetas en el núcleo | 222 (28 505 caracteres por sesión) |
| Nunca le llegaron enteras a una sesión | 37 |
| Con 20 Sesión_Auditada o más sin uso desde su alta (git blame) | **95** |
| Tiempo del barrido completo | ~9 s (con caché, sólo lo nuevo) |
| Prefijo único más corto | 30 caracteres (se usa 40 como clave) |
| Primera línea de viñeta más corta | 59 caracteres (la huella de detección es 58) |

**Lo que el spike no vio, y se midió construyendo:** el spike contó los 36 informes por fecha; el medidor, que exige
el Transcript de cada sesión auditada, encontró **18**. La app de escritorio **borra** el Transcript de cada sesión
eliminada (153 archivos `*.desktop-released.json` con `"reason": "delete"` en la carpeta del proyecto). Las 18 que
faltan tienen caja negra pero no Transcript. De ahí L2-RET-11: lo leído se conserva en el Registro_De_Usos. Y es un
defecto más ancho que T18 (DA nuevo): `medir-costo.py` y `medir-inyeccion.py` también leen Transcripts que desaparecen.

Contaminación vista en el spike: su propia salida imprimía 80-90 caracteres de cada viñeta, y eso es un «uso». De ahí
la separación clave (40) / huella (58): lo que la herramienta escribe es siempre más corto que lo que detecta.

## 3. Qué es un uso, y qué no

Un **Uso_De_Viñeta** es la Huella_De_Viñeta (58 caracteres normalizados) dentro de:

- el **resultado de una herramienta** en el Transcript (Read, Grep, Bash: el texto normalizado, sin los prefijos de
  número de línea `   12\t`, `ruta:12:`), **salvo** si la llamada nombra `chequeo-nucleo` (el núcleo contiene la
  cabecera de cada viñeta, de 61 caracteres o más: leerlo no es usar);
- el **contexto que agrega un hook PreToolUse** (el hook al paso entrega viñetas enteras);
- y la **fecha de cada Recurrencia** de la lección cuyo renglón abre la viñeta (T15): si el error volvió, la regla
  hacía falta.

No cuentan: la inyección de SessionStart (no se lee: es el núcleo) ni los recordatorios por turno.

## 4. La ventana

Una **Sesión_Auditada** es una sesión con informe en `.claude/auditorias/` (nombre `AAAA-MM-DD-<sid8>.md`) **y** su
Transcript leído, en el disco o en el Registro_De_Usos; su fecha es la del primer renglón del Transcript. Una viñeta está **vencida** si tiene 20
Sesión_Auditada o más con fecha posterior a su Referencia_De_Viñeta = máx(último uso, alta por `git blame`, última
vuelta). Contar sólo las auditadas con Transcript es el denominador honesto: en la nube (un Transcript) nunca se llega
a 20 y no se retira nada (L2-RET-06), en vez de verlo todo sin uso.

## 5. Las piezas

| Pieza | Qué hace | Requisitos |
|---|---|---|
| `perfil-global/herramientas/retiro.py` | `uso` (informe), `pasar` (retira hasta 10 vencidas, devuelve las usadas), `volver <clave>`, `listar`, `--verificar` (el medidor), `--autotest` | RET-01..10 |
| `perfil-global/aprendizaje/retiradas.jsonl` | registro de eventos (`retira`, `vuelve`, `pasada`), sólo se agrega; el estado sale de releerlo | RET-01, RET-05, RET-10 |
| `nucleo-chequeo.py` | omite las retiradas y lo dice en el pie del núcleo; registro ilegible = error | NUC-01..03 |
| `chequeo-completo.ps1` | `retiro.py --verificar` en la capa rápida; `probar-t18.py` en los saboteadores | RET-07..09 |
| Registro_De_Usos `~/.claude/aprendizaje/usos.json` | por Transcript (ruta, tamaño, mtime) el inicio y los usos ya contados; **no se poda** cuando la app borra el archivo; si cambia el juego de huellas se re-escanea lo que sigue en disco. Medido: 8 s la primera vez, 0,4 s después | RET-11 (y el costo del arranque, N-03) |

**El medidor** da ROJO si: una retirada tiene un uso posterior al retiro (vuelta pendiente, RET-08); hay vencidas y la
última pasada es anterior a la última Sesión_Auditada (RET-07); o con 20 auditadas leídas no encontró un solo uso
(sensor ciego, RET-09). Sin vencidas, verde: no pide nada.

**El flujo:** el arranque muestra el rojo → la sesión corre `retiro.py pasar` → copia el aviso en «Hice» del cuadro →
`install.ps1` regenera el núcleo → commit en perfil-global. Volver una: `retiro.py volver "<clave>"`.

**Se desinstala solo:** sacar la línea del medidor de `chequeo-completo.ps1` y vaciar `retiradas.jsonl` (o borrarlo:
sin registro, el generador incluye todo). La fuente nunca se tocó.

## 6. Entradas del mecanismo, y su prueba (mutation testing: el denominador primero)

| Entrada | Caso en rojo | Control |
|---|---|---|
| Transcript (formato) | sin usos con 20 auditadas → ROJO sensor ciego (RET-09) | Read real con prefijos de línea → uso |
| Transcript (lectura del núcleo) | leer `chequeo-nucleo.md` no es uso | Grep de una línea (59 caracteres) sí lo es |
| Hook PreToolUse | — | el contexto del hook al paso cuenta como uso |
| Auditorías | menos de 20 con Transcript → pasada retira 0 (RET-06) | 20 exactas → retira |
| Alta (git blame) | viñeta nueva sin uso no vence | viñeta vieja sin uso vence |
| Lecciones (recurrencia) | retirada con recurrencia posterior → vuelve (RET-05) y ROJO hasta pasar (RET-08) | — |
| Registro | ilegible → generador falla (NUC-03); retirada → fuera del núcleo (NUC-01) y pie (NUC-02) | vacío → núcleo igual al de antes |
| Tope | 15 vencidas → retira 10, las de más sesiones sin uso (RET-02/03) | — |
| Salida propia | la clave impresa (40) no es uso: la pasada siguiente no la devuelve | — |

Mutantes (`probar-t18.py`, 12, todos vistos en su caso el 2026-10-17), cada uno juzgado sólo si su caso pasó sano en
la misma corrida (lección T20): sin el tope; orden invertido; sin vueltas; sin el rojo de la pasada; sin el rojo de la
vuelta; sin la recurrencia; sin el sensor ciego; sin excluir el núcleo; clave tan larga como la huella; el generador
que ignora el registro; el registro ilegible ignorado; la poda de los Transcript borrados. **Equivalente, declarado:**
sacar el piso de sesiones de la pasada no cambia nada (con menos de 20 leídas ninguna viñeta llega a 20 sin uso).

## 7. Lo que no cubre (declarado)

- **La prevención silenciosa** (§1.2): se acota con la vuelta automática y el tope, no se mide.
- **La memoria, el perfil, los hooks y los medidores** no entran en esta versión. Los frenos con impacto escrito
  nunca salen solos (regla 6): T18 no los toca.
- **Las 18 sesiones auditadas cuyo Transcript la app ya borró** no cuentan para la ventana (su caja negra trae las
  lecturas pero no los Grep ni el hook al paso: contarlas subcontaría usos y retiraría de más). La ventana arranca en
  18 de 20 y se llena con las sesiones que vienen.
- **En la nube** no se retira (falta la historia de Transcript); el registro viaja en perfil-global, así que lo
  retirado en la PC sí llega.
- Un `grep` en Bash que muestra sólo una línea de continuación de la viñeta no la cuenta (falta la huella): subcuenta,
  que el retiro reversible absorbe.
