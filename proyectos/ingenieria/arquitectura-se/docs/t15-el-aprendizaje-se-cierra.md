# T15 — el aprendizaje se cierra

Fila 3 de la lluvia §6 (dueña del orden). Cierra cuatro defectos: **DA-044** (la lección `propia` que no llega),
**DA-042** (la recurrencia invisible), **DA-050** (el fan-out sin su costo) y **DA-047** (la caja negra en %TEMP%).
Requisitos: L1-13..16 y sus L2 en [`10-requisitos.md`](10-requisitos.md) §9 (0 VIOLA del GtWR extrayendo la columna
Requisito). Sesión `fc3d285a`, 2026-10-16.

## 1. La pregunta de marco

*¿Qué tendría que ser verdad para que T15 sea el problema equivocado?*

1. **Que las lecciones que llegan igual se repitan.** Es lo que pasó: «17 lectores en paralelo» estaba impresa en la
   salida de la cascada de la sesión `de44da9d` y el workflow de 8 agentes salió igual. Si eso es la regla, arreglar
   la *llegada* (DA-044) compra poco y lo que vale es medir si una lección *funciona* (DA-042). No vuelve equivocado a
   T15: cambia el orden de valor dentro de él — **DA-042 primero**, DA-044 segundo.
2. **Que %TEMP% no se purgue nunca.** DA-047 es `probable`: hay 77 cajas negras desde el 2026-10-02, ninguna perdida.
   El arreglo es barato y el día que Storage Sense limpie se pierde justo la evidencia que valida los defectos; se
   hace, sin venderlo como más de lo que es.
3. **Que el costo del fan-out ya no decida nada**, porque desde el 2026-10-12 la regla es «inline, sin fan-out». Pero
   el guardia sigue siendo el único punto donde se decide, y el día que Fran pida un workflow la decisión se toma ahí.

Nada de esto depende de lo que Fran quiere salvo una cosa, que se le preguntó al cerrar: **si la caja negra de una
sesión en la nube tiene que sobrevivir** (muere con el contenedor; para guardarla habría que commitearla en un repo
privado). **Decidido por Fran el 2026-10-17: no.** Alcanza con el informe de la auditoría commiteado; queda como
límite declarado (L1-16, rationale).

## 2. Lo medido antes de diseñar

| Qué | Medido | Qué decide |
|---|---|---|
| Lecciones `propia` / `foldeada` | 162 / 199 de 396; **ninguna** guarda a qué viñeta llegó | el ancla no existe: hay que crearla |
| Rastro textual en el chequeo (4-gramas de regla + título contra las 222 viñetas) | `propia`: 135 con 10+, 11 con 3-9, 16 con menos de 3; `foldeada`: 101 / 55 / 43 | el solapamiento no prueba la llegada (el chequeo es síntesis reescrita) pero con 10+ el contenido está: alcanza para anclar las heredadas como `inferido` |
| Recurrencias conocidas por 4-gramas del síntoma | #381↔#192: 0; #28↔#192: 0 | ese detector nacía ciego |
| Las mismas por tf-idf (título + síntoma + regla) | 0,28 y 0,13, cada una primera en su lista | L2-APR-11 usa tf-idf, umbral 0,12 (TBR) |
| La caja negra | `%TEMP%\claude-cascada`, 77 `.jsonl`, la más vieja del 2026-10-02; guarda comandos completos | va fuera del repo público: `~/.claude/caja-negra/` |
| Costo de un agente | 8 agentes = 35 % de la ventana de 5 h (wf_3f865b1e); 17 = 100 % (2026-09-16) | Costo_Por_Agente = 4-6 % (TBR) |

## 3. Las piezas

### 3.1 El renglón (DA-044; L2-APR-01..05)

- Campo nuevo `renglon` en `lecciones.jsonl`: el comienzo literal de la viñeta (25 caracteres o más), comparado en
  minúsculas y con espacios colapsados contra el **comienzo** de cada viñeta (el parser es el de `nucleo-chequeo.py`,
  importado, no copiado: una sola definición de «viñeta»).
- `agregar --triage propia|foldeada` exige `--renglon` y que la viñeta exista **ya** en el chequeo: se invierte el
  orden, primero la viñeta y después la lección. `triage N propia|foldeada` exige lo mismo.
- `sin-triage` (la capa rápida de `chequeo-completo`, «triage de lecciones») da ROJO por: lección sin triage (lo de
  antes), renglón que ya no está en el chequeo, heredadas por encima del tope, y lección con nivel por debajo del
  exigido (3.2).
- **Las heredadas**: `aprender.py anclar` (una vez) ancla las que comparten 10+ 4-gramas con una viñeta, con
  `renglon_origen: inferido`. Las otras quedan como Lección_Heredada, contadas contra `TOPE_HEREDADAS` (el valor
  medido al construir); el tope sólo baja.

### 3.2 La recurrencia (DA-042; L2-APR-06..11)

- `aprender.py repite N --evidencia "..." --costo "..." [--proyecto p]` agrega a la lección `recurrencias: [{fecha,
  proyecto, evidencia, costo}]` y fija `nivel_exigido` = el siguiente al nivel actual (sin nivel cuenta como parche;
  `meta` exige `meta` otra vez, y eso es de Fran). **La subida es automática**: la sesión decide cómo, no si.
- `aprender.py subir N --nivel X --arreglo "<commit o ruta>"` rechaza X por debajo del exigido; guarda
  `arreglos: [{fecha, nivel, arreglo}]`.
- `agregar` con un título repetido ya no dice «no se duplica»: muestra `repite N`. Y siempre lista hasta 3 lecciones
  parecidas (tf-idf ≥ 0,12) como posible recurrencia. Informa, no frena.
- `buscar` y las fichas muestran «se repitió N veces».

### 3.3 El costo al lado de la decisión (DA-050; L2-GFO-01..05)

El guardia sigue devolviendo `ask` (L2-GFO-05: T15 no cambia la decisión del freno, regla 6) y suma al texto: los
agentes contados en el script (`agent(` en `script`, o en el archivo de `scriptPath`; Agent y Task cuentan 1), el
costo estimado `N × 4-6 %` de la ventana de 5 h, y las dos mediciones de donde sale. Sin script legible (un workflow
guardado por nombre) dice «desconocido». El hook no ve el uso del plan: muestra el costo, no lo que queda.

### 3.4 La caja negra fuera de %TEMP% (DA-047; L2-PTA-18/19, L2-LAN-01, L2-AUD-03)

- `ESTADO_DIR` de la puerta pasa a `~/.claude/caja-negra/` (con `CASCADA_ESTADO_DIR` para las pruebas, como antes).
- **El orden del freno vivo** (L2-PTA-19): esta misma sesión declaró y leyó en `%TEMP%`. `archivo_estado()` copia la
  caja de la sesión desde el Directorio_Legado la primera vez que no la encuentra; sin eso, al instalar el cambio la
  puerta negaría todo. `--verificar` (cada arranque) migra el resto.
- El lanzador no puede importar la puerta (puede estar rota): repite la ruta, y su autotest la compara con la de la
  puerta (una copia con verificador, T20).
- La auditoría deja de armar la ruta: usa `archivo_estado()` de la puerta.
- **Límite declarado**: en la nube `~` muere con el contenedor; persiste el informe de la auditoría, commiteado.

## 4. Verificación (el plan de V&V de T15)

| Pieza | Prueba | Mutante que tiene que dar rojo |
|---|---|---|
| renglón | autotest nuevo de `aprender.py` (repo sintético en temporal) | sin el chequeo de `--renglon`; sin la comparación en `sin-triage` |
| recurrencia | ídem | `repite` que no sube `nivel_exigido`; `sin-triage` que no mira el exigido |
| parecidas | ídem, con los pares #381/#192 y #28/#192 copiados al registro sintético | — (control positivo) |
| guardia | `probar-guardia-fanout.ps1`, casos nuevos: workflow con 3 `agent(`, Agent, guardado por nombre | guardia sin la cuenta |
| caja negra | autotest de la puerta (caso 20): ruta fuera de `gettempdir()`, migración del legado | ruta en el temporal; sin la copia |
| lanzador | su autotest: misma ruta que la puerta | — |
| saboteador de T15 | `probar-t15.py`: corre cada mutante sobre una copia y exige el rojo **por su motivo** | — |

**Efecto real** (L1-14, L1-16): registrar con `repite` una recurrencia de verdad (DA-058: «una acción sobre un archivo
con freno, con UNA llamada», #351, repetida en las sesiones de T16 y T17) y ver el rojo en `chequeo-completo` hasta
subirla; vaciar a mano la copia legada de esta sesión y ver que la auditoría la lee igual.

## 5. Lo que no entra

- Escribir las viñetas de las heredadas sin ancla: es síntesis, una por una; queda como deuda con tope.
- Que el núcleo inyectado muestre las recurrencias: cambia el presupuesto de inyección (T1); se mide antes.
- Leer el uso real del plan desde el hook: el hook no tiene la API de la app.
