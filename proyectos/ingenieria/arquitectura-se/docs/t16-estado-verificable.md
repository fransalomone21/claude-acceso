# T16 — el estado se prueba: requisitos con resultado, y la prueba que corre al entrar

**2026-10-16, sesión de T16.** Fila 1c-c de la lluvia §6 (dueño del orden). Defectos: **DA-039** (la traza corre en
un solo sentido: nada cierra requisito → evidencia) y **DA-053** (el estado entre sesiones es prosa: no hay pasa/falla
legible por máquina ni prueba del producto al arrancar). Requisitos: **L1-11, L2-MVR-01..10, L2-CAS-01..02** en
[`10-requisitos.md`](10-requisitos.md) §7 (el dueño; acá no se copian). Primer cliente: el telescopio (Fran, encuesta
2026-10-12 noche: «lo más urgente de los grandes»).

## 1. Qué estaba roto, medido

- **El telescopio tiene 76 requisitos** (15 L0, 30 L1, 31 L2; `verificar-requisitos.py`) con columna *Verificación* y
  **ningún lugar que diga cuáles se cumplen**. La columna es intención, no registro (DA-039).
- **El modelo pasó de v9 a v10.5 en cuatro días** (2026-10-04 a 10-08) y nada re-verificó los requisitos que el modelo
  ya calcula (vuelco, empujón, carga, altura de la mesa). Se re-verificaban a mano, en la sesión que cambiaba el modelo,
  y quedaban escritos en el *rationale* como prosa.
- **Caso vivo, encontrado al diseñar esto:** el rationale de L1-21 dice que el dobson apoya a **24,6 cm** del piso
  (v10); el punto de diseño v10.5 del modelo da **26,5 cm** [cálculo, `computeVNS` con los valores por defecto de
  `06-modelo-3d.html`, `probable`]. El requisito (≤ 30 cm) se sigue cumpliendo; el número escrito quedó viejo y nada
  lo vio. Es exactamente la clase de deriva que esta pieza ataca.
- **El arranque mide el método, nunca el producto** (DA-053: `arranque-medicion.ps1` corre la capa rápida de
  `chequeo-completo`; un solo proyecto de 22 tiene `abrir-sesion.ps1`).

## 2. La pregunta de marco

*¿Qué tendría que ser verdad para que esto sea el problema equivocado?* Que el cuello del telescopio no sea saber qué
se cumple sino las mediciones de Fran (centro de masa, prueba de foco). Lo es, y esta pieza no lo destraba. Pero las
dos cosas no compiten: la matriz hace visible **qué falta medir y quién lo mide** (los ensayos y demostraciones quedan
«sin resultado» hasta que entra su evidencia), y la prueba al entrar ataja la otra falla del proyecto, la deriva del
diseño contra sus requisitos. Nada de esto depende de un valor de Fran: la forma de la prueba es técnica y se decidió
sin preguntarle.

## 3. La decisión central: la columna pasa/falla es una VISTA, no una columna a mano

«Los requisitos nacen con columna pasa/falla» se puede leer como agregar una columna *Resultado* a cada tabla del
documento de requisitos. **No se hace**: sería un dato con dos dueños (lo que la prueba dice y lo que alguien tipeó), la
falla que T20 prohíbe (N-06). La columna vive en la **Matriz_De_Verificación** (`matriz-verificacion.md`), que genera
el medidor y nunca se edita a mano. El documento de requisitos sigue siendo el dueño del enunciado, del método y del
criterio (el número del enunciado); la prueba es la dueña del resultado.

Es la matriz del apéndice D de NASA (`nasa-seh/matrices.md`, SEH p. 201-202) recortada a lo que una persona usa:
ID, nivel, método, resultado, grado y la evidencia. De la tabla D-1 se toman dos ideas: el criterio de éxito se evalúa
en los **extremos de tolerancia** (por eso la prueba del telescopio corre la envolvente entera, no el punto medio), y
*Results* guarda un **puntero a la evidencia objetiva**, no un «OK».

## 4. Verificado y predicho — la distinción que hace honesto al pasa/falla

Una cuenta del modelo **verifica** un requisito cuyo método es **análisis**: para ése, la cuenta es la verificación
(NASA, Tabla 4.2-2: el método se decide al escribirlo). Para un requisito de **ensayo, inspección o demostración**, la
misma cuenta sólo **predice**: dice que el diseño debería cumplir, no que el objeto cumple. Sin esta separación la
matriz se llenaría de PASA sobre una plataforma que no existe.

| Grado en la matriz | De dónde sale | Grado del perfil |
|---|---|---|
| verificado | Línea_De_Resultado de un requisito de análisis, o una entrada del Registro_De_Evidencias (cualquier método) | `confirmado` |
| predicho | Línea_De_Resultado de un requisito de ensayo, inspección o demostración | `probable` |
| sin resultado | nada todavía | — |

El Registro_De_Evidencias **gana** sobre la prueba (L2-MVR-03): una medición del objeto pesa más que una cuenta.

## 5. Las piezas

| Pieza | Qué hace | Requisitos |
|---|---|---|
| `matriz-verificacion.py` (raíz) | lee el Documento_De_Requisitos, corre cada Prueba_De_Requisitos, lee el Registro_De_Evidencias y arma la matriz. Subcomandos: `aviso <p>` (la cascada), `ver <p>`, `escribir <p>` (la vista), `registrar <p> <ID> pasa\|falla --evidencia "..."`, `--verificar` (chequeo-completo), `--autotest` | L2-MVR-01..10 |
| `cascada.ps1` | después del aviso de la lluvia, `matriz-verificacion.py aviso <p>`: el conteo por nivel, cada FALLA y cada cambio contra la vista escrita | L2-CAS-01, -02 |
| `.claude/cascada.json` | el proyecto declara `"pruebas": ["node docs/probar-requisitos.js"]`; corre desde la carpeta del proyecto | — |
| telescopio `docs/probar-requisitos.js` | evalúa sobre el punto de diseño del modelo y la envolvente; imprime una Línea_De_Resultado por requisito; `--sabotaje` | primer cliente |
| `chequeo-completo.ps1` | medidor `matriz de verificacion` (`--verificar`) y saboteadores (`--autotest`, `probar-t16.py`, el `--sabotaje` del telescopio) | — |

**El protocolo es una línea de texto** (`REQ <ID> PASA|FALLA <detalle>`), no una biblioteca: cualquier proyecto lo
cumple en su lenguaje (node en el telescopio, python en BLACK). Lo que no es una Línea_De_Resultado se ignora; una
prueba que no imprime ninguna, o que sale con código distinto de 0, es ROJO (falla cerrado, L2-MVR-07/08).

**Qué es ROJO y qué no.** ROJO es la integridad de la cadena: un ID que no existe (en la prueba o en la evidencia),
una evidencia sin puntero, una prueba que revienta o calla, y —sólo en `--verificar`— la vista escrita desactualizada
contra el resultado de hoy (una copia que difiere de su fuente, T20). **Una FALLA de diseño no es ROJO**: en Pre-Fase A
el diseño incumple requisitos legítimamente, y un rojo permanente dejaría de discriminar (chequeo-de-trabajo: un aviso
que salta siempre). La FALLA se imprime al entrar, que es donde decide.

## 6. La prueba del telescopio — una sola fuente para cada número

`docs/probar-requisitos.js` **no copia ningún dato**: el punto de diseño (v10.5) lo lee de los valores por defecto de
los controles y de `MESA` en `06-modelo-3d.html` (el dueño del diseño vigente); la envolvente del 300 la lee del
glosario de `10-requisitos.md`; y **el criterio de cada requisito lo lee de su propio enunciado** («no menos de 22
grados»). Si cambia el enunciado o la forma del modelo, la prueba revienta (código 2) en vez de seguir comparando
contra un número viejo. Las únicas constantes son dos supuestos con su fuente: el 12" más liviano de la envolvente
(40 kg, `docs/14` §3) y el centro de masa más bajo del 200 sin medir (58 cm, rationale de L1-15).

| Requisito | Método | Qué calcula | Grado |
|---|---|---|---|
| L1-13 empujón ≥ 59 N | análisis | `empujeMesa` en el peor caso de la envolvente | verificado |
| L1-14 vuelco ≥ 22° | análisis | `vuelco` en el peor caso | verificado |
| L1-30 carga ≤ 62 kg | análisis | la masa del dobson más pesado de la envolvente más la mesa | verificado |
| L1-21 elevación ≤ 30 cm | inspección | la cara de arriba de los rieles | predicho |
| L1-02 carrera ≥ 60 min | ensayo | los minutos de giro de la carrera de diseño | predicho |

Los otros 71 quedan **sin resultado**: los ensayos de la plataforma armada, las mediciones de Fran y lo que el modelo no
calcula (la pista, la transmisión, el tren de imagen). La V de NASA se ve en el conteo: L0 no tiene nada (se valida
con la foto); L1 tiene lo que el concepto ya permite calcular; L2 espera el diseño preliminar.

## 7. Cómo se prueba (regla 3: cada alarma se rompe a propósito)

- `matriz-verificacion.py --autotest`: un proyecto sintético en una carpeta temporal; un control por requisito
  MVR-01..10 y los rojos de MVR-04..08, cada uno exigido **por su motivo**.
- `probar-t16.py`: tres mutantes del medidor (todo como análisis → cae MVR-02; sin el chequeo de ID → cae MVR-04; sin
  mirar el código de salida → cae MVR-07); cada uno tiene que hacer caer SU caso del autotest.
- `node docs/probar-requisitos.js --sabotaje` en el telescopio: con la base angosta y los rodillos juntos, L1-13 y
  L1-14 tienen que salir FALLA. Una prueba que siempre dice PASA no prueba.
- El efecto real: `cascada.ps1 telescopio` imprime el conteo y las FALLA al entrar (L2-CAS-01/02).

## 8. Lo que T16 no cubre (a propósito, y dónde va)

- **La auditoría no lo pregunta todavía**: una pregunta «¿la sesión que cambió el diseño regeneró la matriz?» la cubre
  hoy el rojo de vista desactualizada en `chequeo-completo`. Si eso no alcanza, va a la auditoría.
- **BLACK y arquitectura-se no tienen Prueba_De_Requisitos**: la cascada les informa «0 con resultado». BLACK primero
  necesita su documento de requisitos (T13); arquitectura-se tiene autotests por requisito y podría emitir Líneas de
  Resultado desde ellos (follow-up chico).
- **Los TBR**: un requisito TBR verificado por análisis pasa contra su valor estimado; la matriz no lo distingue de uno
  definido. La columna Estado del documento sigue siendo el dueño de eso.
- **Las mediciones de Fran** entran por `registrar` con su evidencia (la foto, la planilla), la registra la sesión
  cuando Fran manda la evidencia: nunca por suposición (lo de Fran, con evidencia).
