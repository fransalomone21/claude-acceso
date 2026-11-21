# DA-145 y DA-146 — los sistemas ajenos: afuera primero, y nada sin predicción ni respaldo

**2026-11-21.** Estado: **construido e instalado** (la puerta, el catálogo, `cascada.ps1` y `.claude/cascada.sh`);
falta validarlo con 3 sesiones auditadas (L1-05). Requisitos: [`10-requisitos.md`](10-requisitos.md) §17 (N-14, N-15,
L0-14, L0-15, L1-35, L1-36, L2-PTA-56..65, L2-VER-14/15, L2-CAS-14; 0 VIOLA del GtWR sobre los 17 enunciados).

## 1. El caso

El 2026-11-21, en la PC de casa, una sesión clasificada `-Suelta` («música de batalla del Sparking ZERO») cambió el
juego cuatro veces —apartar el DLC, pisar su audio, rearmar su tabla— antes de una sola búsqueda externa. Dos veces el
juego dio «falta contenido descargable» y el guardado de la familia se reescribió con el juego alterado; el respaldo se
hizo recién después del primer error. Cuando Fran pidió buscar, la comunidad ya lo tenía resuelto (Kuro's Music
Manager y el pack de entradas extra). Fran: «te dije mil veces que investigues primero siempre». La regla existía en
tres lugares —el libro (§2b: spike con predicción escrita), la naturaleza `ingenieria` (riesgo: guardar el estado
reversible antes) y la memoria «evidencia al principio»— y ninguna capa la exigía en el paso.

## 2. La pregunta de marco: ¿el problema es la clasificación o la falta de una puerta?

**Qué tendría que ser verdad para que fuera la clasificación**: que, con la sesión en la clase correcta, algo ya
hubiera exigido la búsqueda. Se midió en las cajas negras (`~/.claude/caja-negra/`), no de memoria:

| Medición | Resultado |
|---|---|
| Sesiones que tocaron juegos o emuladores (marcas sobre las decisiones de la puerta, todas las cajas) | 33 |
| De las 15 con más acciones sobre esas marcas | 9 `-Suelta` (78, 51, 42 acciones las tres primeras); el resto black, ps2-casa, dbz-niveles |
| La sesión del caso (`e2c4c1ff`) | declaró **dbz-niveles con necesidad `ninguna`** y 20 s después se reclasificó `-Suelta` «fuera de dbz-niveles» |
| Lo que exige la necesidad `investigar` | lecturas (la skill de lecciones, viñetas del chequeo); el «respaldo antes» es una línea de `herramientas`, sin freno |

Las dos clases dejaban pasar el cambio: con proyecto declarado tampoco había nada que pidiera la búsqueda ni el
respaldo. **Por eso el arreglo va por el ROL de la acción (toca un sistema ajeno), en cualquier clase**, no por la
clasificación. Que `-Suelta` aguante sesiones de horas es real y tiene su registro: **DA-143** («un pedido suelto que
crece a varias sesiones no tiene casa versionada»); este freno lo deja sin efecto para los sistemas ajenos, no para el
resto.

## 3. El diseño

- **Qué es un sistema ajeno**: el catálogo lo declara (`sistemas_ajenos` en `.claude/cascada.json`, su dueño): cada
  sistema con sus **marcas** (patrones). Hoy: `sparking-zero`, `rpcs3`, `pcsx2`, `bluestacks` y el genérico
  `juegos-pc` (las carpetas de juegos, `steamapps`, los scripts que abren el juego y le mandan teclas). El genérico
  cuenta sólo si la acción no tocó uno específico: el Sparking vive en `C:\Games` y se le pide su declaración, no dos.
- **Dónde se miran las marcas** (L2-PTA-60..62): la ruta de un Write o un Edit **fuera** del repo (los documentos de
  BLACK nombran PCSX2 en su ruta y no son el sistema); cada tramo de un comando que no sea un registro del método (git,
  un eco, `aprender.py`, `defectos.py`, `auditar-sesion.py`, `uso-lecturas.py`, `retiro.py`), y **adentro de lo que
  viaja en base64**: la sesión del caso mandaba los cambios a la PC por `ssh ... -EncodedCommand`. Una lectura pura
  (`Get-ChildItem`, `Get-Content`) pasa antes, como siempre.
- **Qué exige** (L2-PTA-56..58): la declaración del sistema con la cascada, antes de la primera acción:
  `.\cascada.ps1 -Sistema <id> -Investigacion <md> -Prediccion "..." -Respaldo "..."`. Se registra en PreToolUse
  (L2-PTA-63) y la última de cada sistema reemplaza a la anterior (así se corrige).
- **La investigación se mide como objeto**, no se le cree a la sesión (regla 3): un `.md` **dentro de claude-acceso**
  (lo de afuera no viaja a la otra máquina ni queda; y un freno que falla cerrado sólo puede exigir lo que un repo
  versiona), con **2 o más direcciones web distintas** y una sección **`## Conclusión`** con 80 caracteres o más. Los
  mínimos son dato del catálogo (`minimos`).
- **La salida explícita** (L2-PTA-65): `-SinBusqueda "motivo"` en lugar de `-Investigacion`, para lo que no tiene nada
  que buscar afuera (copiar un juego, ordenar carpetas). Queda en el registro de excepciones de la cascada
  (`sistema:<id>`), a la vista de la auditoría, como `-Excepcion`. La predicción y el respaldo se exigen igual.
- **Falla cerrado** (L2-PTA-64): sin la clave en el catálogo, la puerta usa sus propios sistemas; `"exigida": false`
  la apaga a la vista y `--verificar` da ROJO (L2-VER-14), igual que una marca que no compila (L2-VER-15).
- **La cascada lo dice al declarar** (L2-CAS-14): `cascada.ps1` y `cascada.sh` con `-Sistema` imprimen qué le falta a
  la declaración (`cascada_puerta.py --ajeno`), antes de la primera negación.

**Por qué en la puerta y no en un hook nuevo**: la puerta ya tiene el estado por sesión, la caja negra, el registro en
PreToolUse y el lanzador que falla cerrado; y su archivo es la salida de reparación (`REPARACION`). Un módulo aparte
que la puerta importara, roto, la haría reventar sin que nada dejara editarlo.

## 4. La V: cada requisito contra su resultado

Autotest de la puerta, **caso 29** (18 casos, 7 mutantes vistos en su caso, cada uno con su caso sano en verde en la
misma corrida), sobre un catálogo sintético (un sistema `juego-x` y un genérico) para que el caso no dependa del dato
vivo. Autotest entero: BIEN.

| Requisito | Resultado | Evidencia |
|---|---|---|
| L1-35, L2-PTA-56 | verificado | caso 29: `-Suelta` y el cambio sin declarar → niega; mutante «sin el freno» visto |
| L2-PTA-57 | verificado | caso 29: investigación sin conclusión, con una sola fuente y fuera del repo → niega cada una con su motivo; mutante «cualquier archivo vale» visto |
| L1-36, L2-PTA-58 | verificado | caso 29: sin `-Prediccion` y sin `-Respaldo` → niega; mutante «sin predicción pasa» visto |
| L2-PTA-59 | verificado | caso 29: declaración completa → pasa; `-SinBusqueda` completa → pasa |
| L2-PTA-60 | verificado | caso 29: el cambio en base64 por ssh → niega; mutante «sin decodificar» visto |
| L2-PTA-61 | verificado | caso 29: `aprender.py agregar` que nombra el juego → pasa |
| L2-PTA-62 | verificado | caso 29: Write fuera del repo en la carpeta del juego → niega; Write adentro del repo con el juego en la ruta → pasa |
| L2-PTA-63 | verificado | caso 29: mutante «la declaración no se registra» visto (el control pasa a negar) |
| L2-PTA-64 | verificado | caso 29: catálogo sin la clave → niega con los sistemas de la puerta; mutante «la clave ausente apaga» visto; `exigida: false` → pasa |
| L2-PTA-65 | verificado | caso 29: `-SinBusqueda` queda en el registro de excepciones con `sistema:<id>` |
| L2-VER-14, 15 | verificado | caso 29: freno apagado y marca que no compila → `--verificar` en rojo; catálogo sano → sin rojos de ajenos |
| L2-CAS-14 | demostrado | `cascada.ps1 -Sistema` con una investigación sin conclusión imprime las dos faltas; con la completa, «declaración completa»; `cascada.sh -Sistema ... -SinBusqueda` igual, código 0 |

El mismo caso mide además que **otro sistema declarado no libera el que se toca**, que **una carpeta de juegos sin
sistema específico** cae en el genérico, y que **la clase no importa**: con un proyecto declarado con necesidad
`ninguna` (como dbz-niveles en el caso real) niega igual; mutante «sólo mira la suelta» visto.

**Efecto por la frontera real**: (1) en esta misma sesión, con la puerta instalada, un comando que sólo nombraba
`C:\Games\...` fue negado por `juegos-pc` (la puerta vieja lo dejaba pasar: discrimina); (2) el lanzador corrido como lo
corre la app (Git Bash, `CLAUDE_PROJECT_DIR`, estado aislado): `-Suelta` → cambio sobre el Sparking niega → declaración
sin predicción ni respaldo, niega con las dos faltas → completa, pasa.

## 5. Límites declarados

1. **El respaldo se lee, no se mide**: la copia vive en la PC de casa y la puerta no la puede ver sin demorar cada
   acción. Lo que se exige es que esté escrito antes; la auditoría puede cruzarlo después.
2. **La investigación se mide por forma** (fuentes y conclusión), no por relevancia: un archivo de otro tema con dos
   links pasaría. Es el sensor más débil que todavía obliga a hacer la búsqueda y escribirla.
3. **Las marcas son una lista** (exclusión por enumeración): un juego nuevo fuera de `C:\Games` o un script que toca la
   PC sin nombrarla no se ven. Se agrega al catálogo; el genérico de las carpetas de juegos cubre lo común.
4. **El texto que sólo habla** de un sistema en un comando que no es un registro del método (un `python -c` con
   "PCSX2" adentro) se niega: falso positivo de la clase del guardia por patrón, con salida declarada (`-SinBusqueda`).
5. **Una declaración por sesión y sistema**: después de la primera, los cambios siguientes pasan. Un spike nuevo con
   otra predicción se declara de nuevo por disciplina, no por freno.
6. **Corre BLACK también** (PCSX2): sus sesiones declaran una vez su sistema con su documento de investigación. Es lo
   que DA-091 pedía (los ports a PC aparecieron tarde).
