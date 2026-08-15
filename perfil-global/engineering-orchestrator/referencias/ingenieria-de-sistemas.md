# Ingeniería de sistemas — material formal, adaptado

Referencia de consulta. **No se lee entera**: se salta a la sección que
corresponda. El `SKILL.md` tiene el resumen operativo; esto es el detalle.

Fuentes: NASA/SP-2016-6105 Rev2 (*NASA Systems Engineering Handbook*),
NPR 7123.1 (*SE Processes and Requirements*), NPR 7150.2 (*Software
Engineering Requirements*), NASA Software Engineering Handbook (swehb),
y las *Power of Ten* de Holzmann (JPL, 2006).

**Lo más importante de todo el material: NASA dice explícitamente que la
formalidad y profundidad se TAILOREAN según el proyecto.** Aplicar esto como
ceremonia a un proyecto de una persona es malinterpretarlo. Lo que sigue está
filtrado a lo que rinde en proyectos chicos y asistidos por IA.

---

## 1. El motor de SE: 17 procesos comunes

Se aplican **recursivamente**: primero bajando (descomponer el sistema hasta
un nivel implementable), después subiendo (integrar y verificar de la pieza
más chica hacia el sistema entero). Ese "baja y sube" es la idea central.

**Diseño del sistema (1-4)** — bajando:

| # | Proceso |
|---|---|
| 1 | Definición de expectativas de los interesados |
| 2 | Definición de requisitos técnicos |
| 3 | Descomposición lógica |
| 4 | Definición de la solución de diseño |

**Realización del producto (5-9)** — subiendo, desde lo más chico:

| # | Proceso |
|---|---|
| 5 | Implementación |
| 6 | Integración |
| 7 | **Verificación** |
| 8 | **Validación** |
| 9 | Transición |

**Gestión técnica (10-17)** — transversales, corren todo el tiempo:

| # | Proceso |
|---|---|
| 10 | Planificación técnica |
| 11 | Gestión de requisitos técnicos |
| 12 | Gestión de interfaces |
| 13 | Gestión de riesgo técnico |
| 14 | Gestión de configuración |
| 15 | Gestión de datos técnicos |
| 16 | Evaluación técnica |
| 17 | Análisis de decisión |

**Traducción a un proyecto chico:** los 1-9 son "el trabajo"; los 10-17 son
"no perderse haciéndolo". En un proyecto de una persona, los que más rinden
son **11 (requisitos), 13 (riesgo), 14 (configuración = git) y 17 (decisión)**.

---

## 2. Verificación ≠ Validación

La distinción más útil de todo el material, y la que más se confunde:

- **Verificación** — *¿lo construimos bien?* ¿El producto cumple **el
  requisito escrito**? Se verifica contra la especificación.
- **Validación** — *¿construimos lo correcto?* ¿El producto sirve para lo que
  el interesado realmente necesitaba? Se valida contra la necesidad real.

**Se puede verificar perfecto y fallar la validación entera.** Es el modo de
falla más caro que existe: construir con precisión la cosa equivocada.

> **Aplicado a este proyecto (BLACK):** confirmar que `0x005A8DA8` es la vida
> escribiéndole 333.0 y viendo bajar la barra es **verificación**. Preguntar
> "¿el usuario quería tocar la vida, o quería no morir / hacer más daño /
> jugar distinto?" es **validación**. Y el caso de la base `0x005A8D80`:
> estaba *verificada* como "el único puntero a distancia corta" — y era
> falsa. Verificar contra un criterio no valida la premisa del criterio.

Qué debe registrar un resultado de verificación (SWE-030): identificación y
versión de lo verificado, **en qué difiere el entorno de verificación del
real**, resultados por requisito, y **la lista de deficiencias, límites y
restricciones detectadas**. Esa última parte es la que siempre se omite y la
que más vale.

---

## 3. Características de un buen requisito

Un requisito que no cumple esto genera trabajo que después hay que tirar:

- **Verificable** — existe un test/inspección/análisis que dice sí o no. Si no
  se puede verificar, no es un requisito: es un deseo.
- **Inequívoco** — una sola interpretación posible.
- **Necesario** — si se saca, algo se rompe. Si no, sacalo.
- **Alcanzable** — técnicamente posible dentro de costo y plazo.
- **Completo** — no depende de contexto no escrito.
- **Consistente** — no contradice a otro.
- **Atómico** — una sola cosa por requisito ("y" suele delatar dos).
- **Independiente de la implementación** — dice *qué*, no *cómo*.

Regla práctica: si no podés escribir el test junto al requisito, el requisito
todavía no está listo.

---

## 4. Gestión de riesgo: probabilidad × consecuencia

Riesgo = **probabilidad** de que pase × **consecuencia** si pasa. Se
clasifica en una matriz (típicamente 5×5) y se trata según dónde cae:

| Estrategia | Cuándo |
|---|---|
| **Mitigar** | reducir probabilidad o consecuencia |
| **Aceptar** | consecuencia tolerable, se documenta y se sigue |
| **Vigilar** | probabilidad baja hoy, puede subir; se define el disparador |
| **Evitar** | cambiar el plan para que el riesgo no exista |

Lo que hace útil a un registro de riesgos no es la lista: es que cada entrada
tenga **un disparador observable** ("si pasa X, actuamos") y **un dueño**.

> **Aplicado:** "escribir en memoria puede colgar el emulador" — probabilidad
> media, consecuencia media (se pierde la partida, nada permanente). Mitigado
> con savestate previo + probar el mecanismo en una dirección inocua. Eso ya
> se venía haciendo; ahora tiene nombre y se puede auditar.

---

## 5. Márgenes y reservas

NASA nunca planifica al 100% de la capacidad: deja **margen** técnico (masa,
potencia, memoria) y **reserva** de cronograma y presupuesto, y los consume
deliberadamente a medida que baja la incertidumbre.

**Traducción a un proyecto asistido por IA:** el presupuesto de tokens y el
de contexto son recursos con margen. Planificar una sesión que usa el 100%
del contexto garantiza que el resumen se lleve puesto justo lo que no se
puede aproximar (direcciones, offsets, valores de registros). Dejar margen no
es desperdicio: es lo que permite absorber el problema difícil cuando aparece.

---

## 6. Revisiones como puertas de decisión

Las revisiones de ciclo de vida (MCR, SRR, PDR, CDR, TRR, ORR...) no son
presentaciones: son **puertas con criterios de entrada y salida**, donde se
decide si se sigue, se corrige o se cancela.

La secuencia responde una pregunta por puerta:

| Puerta | Pregunta que contesta |
|---|---|
| MCR | ¿La misión vale la pena y es factible? |
| SRR | ¿Entendemos y acordamos los requisitos? |
| PDR | ¿El diseño preliminar puede cumplirlos? |
| CDR | ¿El diseño detallado está listo para construir? |
| TRR | ¿Estamos listos para ensayar? |
| ORR | ¿Estamos listos para operar? |

**Traducción:** en un proyecto chico esto colapsa a 2-3 puertas reales, pero
la idea que hay que conservar es la de **criterio de salida explícito**. El
proyecto BLACK ya lo tiene sin llamarlo así: "una fase = un chat, y no se
pasa a la siguiente sin cerrar la anterior" es exactamente una puerta. Lo que
le falta es escribir el criterio de salida *antes* de empezar la fase.

---

## 7. Análisis de decisión (trade studies)

Antes de una decisión con consecuencias, formular **alternativas candidatas**
y evaluarlas contra criterios explícitos y ponderados — no elegir la primera
que funciona.

Mínimo viable, y sirve igual: escribir las 2-3 alternativas reales, los
criterios que importan, y **por qué perdieron las que perdieron**. El valor
está tanto en el registro de las descartadas como en la elegida: evita
volver a evaluarlas en tres meses.

Conecta con la regla del proyecto: *"los callejones sin salida se anotan"*.

---

## 8. Gestión de configuración

Saber en todo momento **qué versión de qué** está en juego, y que un cambio
no invalide silenciosamente lo demás. Es git, pero también:

- **Línea base (baseline)**: un estado congelado y etiquetado contra el cual
  se miden los cambios.
- Todo dato técnico lleva **de qué versión del sistema es válido**.

> **Aplicado:** la regla de BLACK *"las direcciones son de una versión;
> NTSC-U y PAL no comparten nada"* es gestión de configuración pura. Y que
> `pnach.py` se niegue a compilar sin `version_activa` es un control de
> configuración **automatizado** — el nivel más confiable, el que no depende
> de que alguien se acuerde.

---

## 9. Clasificar por criticidad para tailorear el rigor

NPR 7150.2 clasifica el software (Clases A a F) según uso, criticidad para la
misión, dependencia humana, complejidad e inversión. Un componente marcado
**safety-critical** por análisis de peligros es Clase D o superior. **A cada
clase le corresponde un conjunto distinto de requisitos**: no se le pide lo
mismo a un script de análisis que al software de vuelo.

**Ésta es la idea que hace que todo lo demás sea aplicable sin ahogarse:**
el rigor se gradúa según lo que se pierde si falla.

Escala práctica para un proyecto propio:

| Nivel | Qué es | Rigor |
|---|---|---|
| **Crítico** | si falla se pierde trabajo irrecuperable o plata | revisión humana obligatoria, test antes de correr, sin automatizar |
| **Importante** | si falla cuesta horas | test, evidencia registrada, reversible |
| **Descartable** | si falla se vuelve a correr | directo, sin ceremonia |

Antes de aplicar cualquier proceso de este documento, preguntar en qué nivel
está lo que se está haciendo. La mayor parte del trabajo es "descartable" y
no debe pagar el costo de los otros dos.

---

## 10. Power of Ten (Holzmann, JPL) — código

Diez reglas para código crítico en C, diseñadas específicamente para que un
**analizador estático** pueda verificarlas (a diferencia de las guías de
estilo, que no son chequeables por herramienta). Adoptadas en el software de
vuelo del Mars Science Laboratory (~3 M de líneas).

1. **Control de flujo restringido** — sin `goto`, `setjmp`/`longjmp`, ni
   recursión directa o indirecta.
2. **Todo bucle con cota superior demostrable** estáticamente.
3. **Sin asignación dinámica de memoria** después de la inicialización.
4. **Funciones cortas** — ~60 líneas, que entren en una página impresa.
5. **Densidad de aserciones** — mínimo dos por función, sobre condiciones
   anómalas, con recuperación explícita.
6. **Datos en el ámbito más chico posible.**
7. **Validar parámetros recibidos y chequear valores de retorno** no-void.
8. **Preprocesador limitado** a includes y macros simples.
9. **Punteros: un solo nivel de indirección**, sin punteros a función.
10. **Compilar con todas las advertencias, cero warnings, análisis estático
    diario** — desde el día uno.

**Qué se lleva a otros lenguajes:** la 2 (cotas demostrables), la 5
(aserciones sobre lo anómalo, no sobre lo esperado), la 6, la 7 y sobre todo
la **10** — el principio general es *preferir reglas que una herramienta
pueda chequear antes que reglas que dependan de la disciplina de quien
escribe*. Es la lección 11 de `/lecciones-aprendidas` aplicada al código.

---

## Fuentes

- NASA Systems Engineering Handbook, NASA/SP-2016-6105 Rev2 —
  <https://www.nasa.gov/wp-content/uploads/2018/09/nasa_systems_engineering_handbook_0.pdf>
- NPR 7123.1 — SE Processes and Requirements, y "The Common Technical
  Processes and the SE Engine" —
  <https://www.nasa.gov/reference/2-1-the-common-technical-processes-and-the-se-engine/>
- NPR 7150.2 / NASA Software Engineering Handbook —
  <https://swehb.nasa.gov/>
- SWE-030 Verification Results —
  <https://swehb.nasa.gov/display/7150/SWE-030+-+Verification+Results>
- G. Holzmann, *The Power of Ten — Rules for Developing Safety Critical
  Code*, IEEE Computer, 2006 — <https://spinroot.com/gerard/pdf/P10.pdf>
