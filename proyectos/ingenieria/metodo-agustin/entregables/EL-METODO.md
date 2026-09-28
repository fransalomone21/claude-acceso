# El método — para Matías y Agustín

**Versión del 2026-09-27.** La armó Fran con Claude, y es la misma forma de
trabajar que usa él todos los días, **sin sus proyectos adentro**. Es un solo
archivo a propósito: lo pueden leer de corrido, subirlo a un chat de Claude o
ponerlo como instrucciones de un Proyecto.

---

## 0. Qué es esto, en dos párrafos

Matías, Agustín: Claude es muy bueno haciendo cosas y muy malo **acordándose**
de lo que se hizo. Cada chat arranca de cero, y un chat largo se degrada: se
olvida lo del principio, repite errores y reporta como hecho lo que solo
supuso. Este método existe para eso. No hace que Claude sea más inteligente:
hace que **no pierda el hilo** y que **no se mienta**.

Se apoya en tres ideas. Todo lo demás sale de ahí:

1. **La memoria vive afuera del chat**, en archivos que ustedes guardan: el
   plan del proyecto, dónde quedamos y qué falta. El chat es descartable.
2. **Nada está hecho hasta que se vio el efecto.** "Lo escribí" no es "anda".
   Lo que no se midió se anota como hipótesis, con esa palabra.
3. **Cuánto rigor le ponen lo deciden ustedes**, según el proyecto, su
   complejidad y el presupuesto de su plan de Claude. Para eso está el dial de
   la sección 2.

---

## 1. La primera vez — paso a paso

### Si usan el plan gratis de claude.ai (Matías, por ahora)

1. Abran un chat nuevo en claude.ai.
2. Adjunten **este archivo** y peguen el bloque de la **sección 11** como
   primer mensaje, completando el proyecto y lo que quieren hoy.
3. Claude va a abrir cada respuesta con dos cuadros (sección 5). El primero
   es para ustedes: dice qué hizo, qué descubrió y qué les toca hacer.
4. **Antes de que el chat se haga largo** (o cuando Claude diga "conviene
   chat nuevo"), pídanle: *"Escribí el ESTADO_ACTUAL y el mensaje de retome"*.
   Guárdenlos en un Google Doc del proyecto: **esa es la memoria**.
5. El próximo chat arranca pegando ese mensaje de retome. No hace falta
   contarle todo de nuevo.

Con el plan gratis los mensajes son limitados: pidan cosas concretas y no
peguen documentos enteros en cada mensaje. Usen el nivel **Liviano** del dial.

### Si tienen un plan pago con Proyectos

Igual que arriba, pero una sola vez: creen un **Proyecto** en claude.ai, peguen
el bloque de la sección 11 en las **instrucciones del Proyecto** y suban este
archivo, más el PDP y el ESTADO_ACTUAL de lo que estén haciendo, como
**archivos del Proyecto**. Cada chat nuevo dentro del Proyecto ya los ve.
Cuando cambie el ESTADO_ACTUAL, reemplacen el archivo.

### Si usan Claude Code (Agustín)

Claude Code corre en la computadora, lee y escribe archivos y ejecuta
comandos. Ahí el método se vuelve **automático**: la memoria es un repositorio
git, las reglas se cargan solas en cada sesión (`CLAUDE.md`) y hay scripts que
miden el estado en vez de leerlo. Fran está preparando el **núcleo instalable**
(reglas, skills, hooks y verificadores, sin sus datos): cuando esté, se clona
de GitHub y se instala con un comando. Hasta entonces, este archivo como
`CLAUDE.md` en la raíz del repo ya funciona como nivel **Medio**.

---

## 2. El dial — cuánto método usar

**No todo proyecto merece todo el método.** Un CV no necesita verificadores;
un sistema que puede romper algo irreversible, sí. El rigor se elige **por
aspecto del proyecto**, con dos preguntas:

- **¿Se puede deshacer?** Si equivocarse se arregla gratis, el rigor es
  mínimo. Si es de un solo tiro (algo que se publica, se manda, se borra o se
  compra), el rigor es pleno.
- **¿Cuánto no sé?** Si el terreno es conocido, se hace directo. Si es
  desconocido, se va en pasos cortos, midiendo cada uno.

| Nivel | Para qué | Qué se usa | Costo |
|---|---|---|---|
| **Liviano** | tareas de una o dos sesiones; plan gratis | los dos cuadros · hipótesis ≠ confirmado · mensaje de retome guardado en un Doc | casi nada |
| **Medio** | proyectos de semanas | lo anterior + PDP con fases y criterio de salida · ESTADO_ACTUAL + HANDOFF · lecciones aprendidas | un rato al abrir y al cerrar cada sesión |
| **Completo** | sistemas técnicos, cosas irreversibles, datos personales; Claude Code | lo anterior + repo git · cascada de lectura · verificadores que se prueban rompiéndolos (saboteadores) · frenos automáticos | tokens y tiempo de mantenimiento |

**El presupuesto manda sobre la exhaustividad.** Si están cerca del límite de
su plan: nada de agentes en paralelo, trabajo en un solo hilo, y primero
guardar el estado (ESTADO_ACTUAL + retome) antes de ampliar lo que se hace.
Un modelo más grande, más esfuerzo o más agentes son el **escalón más bajo**
de mejora (sección 3): si el problema es que Claude no sabe algo, un Claude
más caro tampoco lo va a saber.

**Se puede subir o bajar a mitad de proyecto.** Si un proyecto Liviano empieza
a pedir que se repitan explicaciones, pásenlo a Medio. Si uno Completo cuesta
más mantenerlo que hacerlo, bajen un escalón y anoten por qué.

---

## 3. Las ideas de fondo

Salen de cuatro libros: Meadows (sistemas), Hunt & Thomas (*The Pragmatic
Programmer*), Saltzer & Schroeder (diseño de protecciones) y Leveson
(seguridad). No hace falta leerlos: esto es lo que se usa de cada uno.

**Antes de intervenir, ubicá la intervención en la escala.** De menos a más
efecto: *parámetros* (qué modelo, cuánto esfuerzo, cuántos agentes) <
estructura < **flujos de información** < **reglas** < **metas**. Casi toda la
atención se va a los parámetros, que son lo que menos mueve la aguja.

**Una regla que se incumple no se escribe más fuerte: se le agrega la
información que falta.** Casas idénticas, mismo precio de la luz: las que
tenían el medidor a la vista en la entrada gastaron 30 % menos que las que lo
tenían en el sótano. Poner la regla en mayúsculas no cambia nada; poner el
medidor donde se ve, sí.

**Antes de arreglar un fallo, fijate cuántas veces pasó.** Un fallo aislado se
arregla; uno que se repite es un problema de estructura, y arreglarlo de a un
caso no termina nunca.

**Cambiar al actor no cambia nada si recibe la misma información.** Si Claude
abre la sesión sin saber qué se decidió ayer, un Claude mejor abre la sesión
sin saber qué se decidió ayer. Por eso la memoria está afuera.

**En un sistema con retardo, reaccionar más rápido y más fuerte empeora las
cosas.** Lo que se cambió ayer recién actúa mañana: se corrige de a una
fracción.

**Un éxito que no sabés explicar es una coincidencia que todavía no se
descubrió.** Si algo empezó a andar después de tocar varias cosas, sacar lo
que no entendés es más barato ahora que después.

**Un verificador que nunca falló está sin verificar.** Un test, un chequeo o
un script que siempre dice "OK" puede estar diciendo OK sin mirar. Se lo rompe
a propósito una vez y se mira que se ponga en rojo.

**Huellas de cascos son caballos, no cebras.** Antes de culpar a la
herramienta, sospechá de lo tuyo. Si los parches no funcionan, lo que está mal
es el modelo mental, no falta otro parche.

**"Esto cuesta mucho más de lo que debería" es una señal, no una queja.** Hay
que parar y preguntar: ¿hay un camino más fácil?, ¿estoy resolviendo el
problema o algo periférico?, ¿tiene que hacerse así?, ¿tiene que hacerse?

**Lo irreversible es otro riesgo.** Lo que se puede deshacer se prueba rápido;
lo que no, se prueba antes en algo inofensivo. Y lo que se instala solo tiene
que poder desinstalarse solo.

**Un freno se diseña por permiso, no por prohibición.** Una lista de lo
prohibido siempre tiene agujeros; medir el objeto que se quiere proteger, no.
Y un freno que molesta con falsas alarmas termina desactivado: bajar las
falsas alarmas también es seguridad.

---

## 4. Las reglas

1. **Evidencia graduada.** Todo lo que se afirma lleva su grado:
   `hipótesis`, `probable` o `confirmado`. Confirmado es *intervine y vi el
   efecto*. Nada se reporta un escalón más arriba de lo que se midió.
2. **El éxito también se audita** (ver sección 3).
3. **Toda alarma se prueba rompiéndola.** Y verificar es ver el **efecto**,
   nunca la precondición: "moví el archivo a la carpeta privada" no es "el
   archivo es privado". Hay que mirar el permiso.
4. **La memoria es lo guardado.** Nada existe si no quedó escrito en el
   proyecto (repo o Doc). El chat es efímero.
5. **Checkpoint antes de parar:** actualizar ESTADO_ACTUAL y HANDOFF, y
   guardar (commit y push, o el Doc). Sin eso, la próxima sesión arranca de
   cero.
6. **Cambios mínimos.** No se arregla lo que no se pidió ni se diseña para
   requisitos imaginarios. Un freno molesto no se saca sin preguntar contra
   qué fue diseñado.
7. **Ubicá la intervención en la escala** antes de proponerla (sección 3).
8. **El modelo y el esfuerzo se eligen por tipo de trabajo**, y se declaran
   (sección 10).
9. **El presupuesto del plan gana** sobre cualquier pedido de exhaustividad.
10. **Dos cuadros arriba de toda respuesta** (sección 5).
11. **Se decide, no se pregunta**, lo técnico. Se pregunta lo que es de
    ustedes: metas, prioridades, qué importa más.
12. **Si hace falta chat nuevo, el mensaje de retome sale en esa misma
    respuesta**, listo para pegar.

---

## 5. Los dos cuadros

Cada respuesta de Claude arranca con dos bloques. El primero es para ustedes y
tiene un **tope de 19 líneas**. Las seis líneas van siempre, aunque digan
"nada": una línea que desaparece obliga a adivinar si se omitió o si no
aplicaba.

```
PARA VOS
  Cómo venimos  : (hasta 3 líneas, en criollo) cuánto falta para la META
                  del proyecto, a ojo y en rango, y de dónde sale el número
  Hice          : qué cambió en el mundo, no qué pasos di
  Cómo seguimos : (hasta 6 líneas)
    Tramo  : en qué fase estamos, hasta cuándo, y qué la cierra
    Hacés  : lo que estás ejecutando hoy, con los números
    Cambió : qué cambió de eso desde la vez anterior ("nada" si nada)
  Descubrí      : solo lo que cambia una decisión ("nada nuevo")
  Pendiente     : lo que queda para otra sesión ("nada")
  Hacé vos      : 1) lo que Claude NO puede hacer solo — porque <qué pasa
                     si no se hace>   ("nada" si no hay)
```

El segundo es lo que la sesión declara sobre sí misma:

```
Fase     : cuál es, y qué la cierra (un resultado verificable)
Modelo   : el que corresponde a este tramo, y por qué
Esfuerzo : bajo/medio/alto, con o sin agentes en paralelo, y por qué
Contexto : seguir acá | conviene chat nuevo, y por qué
```

Tres cosas que se suelen escribir mal:

- **"Hacés" lleva los números, no un puntero.** "Ver el plan, sección 3" ya
  falló: la línea existe justo para cuando no se abre el documento.
- **"Cómo venimos" va en criollo** y contra la meta, no contra la fase. Si
  no hay base para estimar, lo dice: "no sé, el plan no parte la meta en
  fases" también es respuesta.
- **"Hacé vos" solo lleva lo que Claude no puede hacer.** Pedirles lo que
  Claude puede hacer solo es usarlos de secretarios.

---

## 6. Un proyecto: carpeta, plan y memoria

**Un proyecto, una carpeta** (o un Doc por proyecto, en el nivel Liviano). Nace
de un **PDP** (Plan de Desarrollo de Proyecto), que se escribe antes de
empezar:

1. **El problema.** Qué se resuelve, para quién, y cómo se va a saber que
   sirvió.
2. **Qué NO es.** Lo que queda afuera, escrito. Es lo que frena que el
   proyecto crezca solo.
3. **Rigor por aspecto:** la tabla del dial (sección 2), una fila por parte
   del proyecto.
4. **Las fases.** Cada una con su **criterio de salida**, que es un resultado
   verificable ("el CV entra en una A4 y lo aprobó el dueño") y nunca una
   cantidad de trabajo ("revisar el CV"). Un sistema medido por esfuerzo
   produce esfuerzo.
5. **Riesgos**, cada uno con el síntoma observable que avisa que está pasando.
6. **Decisiones**, con las alternativas descartadas y por qué perdieron. Es lo
   que evita rediscutir lo mismo en cada sesión.
7. **Verificación.** Cómo se comprueba cada entregable.

Y dos archivos vivos:

- **`ESTADO_ACTUAL`:** qué está confirmado y qué es hipótesis, hoy.
- **`HANDOFF`:** qué quedó a medias, qué **no** hay que volver a intentar y
  los datos que no se pueden aproximar (números, rutas, versiones).

"Waterfall en las puertas, ágil adentro": las fases se cierran con un
criterio fijo, pero adentro de cada fase se itera como haga falta.

### Las tres clases de proyecto

Cada una tiene su riesgo propio y cinco cosas que no se negocian.

**Ingeniería**: un sistema técnico que no se conoce del todo, donde hay una
realidad externa que te puede contradecir.
- Confirmado = intervine y vi el efecto.
- Todo dato lleva su versión: lo que vale para una versión es una trampa en
  la siguiente.
- Se anota apenas se confirma, no al cerrar.
- El éxito también se audita.
- Nada de volcados crudos en el chat: van a un archivo.
- Además: **primero lo de arriba** (de qué partes está hecho el sistema) y
  recién después el detalle. Y antes de una fase larga, las dos preguntas:
  **verificar** (¿hace lo que dice el requisito?) y **validar** (¿sirve para
  lo que hacía falta?).

**Documentos**: un apunte, un informe, una guía, un CV.
- El destinatario está escrito: quién lo lee y qué ya sabe.
- El resultado se mira, no se supone: que compile no es que esté bien.
- Toda afirmación tiene fuente.
- Las decisiones de contenido se registran.
- Se genera desde una fuente versionada, no se edita el PDF a mano.
- La trampa propia: un documento mal armado "compila igual". El riesgo no es
  equivocarse, es **no enterarse**.

**Seguimiento**: algo real que evoluciona (entrenamiento, dieta, un trámite
largo).
- Reaccionar de a una fracción: el sistema tiene retardo.
- Un punto no es una tendencia.
- El período de prueba se declara antes de empezarlo.
- Se mide siempre igual.
- Los datos personales no salen de la máquina ni del repo privado.
- La trampa propia: confundir **cumplir el plan** (esfuerzo) con **que el
  número se mueva** (resultado).

---

## 7. La cascada: qué leer al abrir una sesión

Cada archivo que Claude lee cuesta contexto, y el contexto es lo que después
falta para pensar el problema difícil. Por eso se baja **solo hasta donde la
tarea pida**:

| Nivel | Qué | Cuándo |
|---|---|---|
| 0–1 | las ideas y las reglas (este archivo) | siempre |
| 2 | la lista de proyectos y dónde está cada uno | siempre |
| 3 | lo que pide la clase de proyecto (sección 6) | al entrar a un proyecto |
| 4 | el contrato del proyecto: qué leer según la tarea | al entrar a un proyecto |
| 5 | `ESTADO_ACTUAL` y `HANDOFF` | al retomar |
| 6 | el detalle que la tarea concreta pida | solo si hace falta |

En el plan gratis esto es simple: se adjunta este archivo y se pega el
mensaje de retome, que ya trae lo de los niveles 4 y 5.

---

## 8. Lecciones aprendidas

Cuando algo falla por **cómo** se trabajó (no por lo que decía el código o el
libro), se anota una lección con estos campos:

- **Título**, y cuánto **costó** (horas, sesiones).
- **Síntoma, escrito como se veía antes de entenderlo.** Es la única forma de
  reconocerlo la próxima vez, y es por donde se va a buscar.
- **Regla**: qué se hace distinto desde ahora.
- **Opuesto**: la regla dada vuelta. **Tiene que sonar tonto.** El opuesto de
  "si puede fallar, fallará" es "si puede fallar, no fallará", que es un
  disparate. Si el opuesto suena razonable, no es una lección: es una
  preferencia, y no entra.

Antes de pelearse con un problema, se busca si ya pasó.

---

## 9. Frenos y saboteadores (nivel Completo)

Un **freno** es algo que impide un error sin depender de que alguien se
acuerde: un permiso de solo lectura, un hook que bloquea un comando
peligroso, un script que mide el estado al abrir la sesión.

Un **saboteador** es el script que rompe cada freno a propósito y exige
verlo en rojo. **También** controla que lo legítimo siga pasando: un freno con
falsas alarmas se termina sacando.

Tres preguntas por cada sabotaje, porque las tres fallan en verde: ¿**llegó**
al código?, ¿**cambió** el estado?, ¿el cambio **se vio** en algo observable?

Antes de escribir un freno se escriben dos líneas: la **pérdida** (qué se
pierde si falla) y el **peligro**, como estado del objeto ("el archivo deja de
coincidir con el original"), no como acción de alguien ("alguien corre
borrar").

---

## 10. Modelo y esfuerzo — dos perillas distintas

| Trabajo | Modelo | Por qué |
|---|---|---|
| diseñar, decidir arquitectura, la primera hipótesis en terreno desconocido | el más capaz (Opus) | el error se paga caro después |
| ejecutar un plan ya decidido | el intermedio (Sonnet) | no hace falta pensar el qué, solo el cómo |
| lo mecánico: correr, copiar, reportar | el más chico (Haiku) | cuesta mucho menos y alcanza |

El **esfuerzo** (cuánto piensa antes de responder, y si reparte en agentes en
paralelo) es **otra perilla**: amplitud barata con muchos agentes no es lo
mismo que profundidad en un solo hilo. Se declaran las dos.

En el plan gratis casi no se elige: el equivalente es **cuánto le piden por
mensaje**. Tareas chicas y concretas rinden más que un "revisá todo".

**Nunca usen un modelo o un modo que cobre por fuera de su plan** sin haberlo
decidido antes: sale del mismo balde que después falta.

---

## 11. El bloque para pegar

Péguenlo como primer mensaje de un chat, o como instrucciones de un Proyecto.
Completen lo que está entre corchetes.

```
Trabajo con un método. Respetá esto en toda la conversación:

1. Arriba de cada respuesta, dos bloques de código:
   PARA VOS (máx. 19 líneas): Cómo venimos (en criollo, cuánto falta para
   la meta, a ojo y en rango) / Hice (qué cambió, no qué pasos diste) /
   Cómo seguimos (Tramo, Hacés con números, Cambió) / Descubrí (solo lo que
   cambia una decisión) / Pendiente / Hacé vos (solo lo que no podés hacer
   vos, con su consecuencia). Las seis líneas siempre, aunque digan "nada".
   Y debajo: Fase (y qué la cierra) / Modelo / Esfuerzo / Contexto (seguir
   acá o chat nuevo).
2. Todo lo que afirmes lleva su grado: hipótesis, probable o confirmado.
   Confirmado es solo lo que se midió o se vio.
3. Lo técnico lo decidís vos. Lo que es mío (metas, prioridades, qué
   importa más) me lo preguntás.
4. Cambios mínimos: no toques lo que no pedí.
5. Cuando el chat se esté haciendo largo, decímelo y dame en esa misma
   respuesta el ESTADO_ACTUAL y un mensaje de retome listo para pegar
   (qué leer, fase y qué la cierra, qué ya está resuelto, primer paso).
6. Nivel del método para este proyecto: [Liviano | Medio | Completo].

Proyecto: [nombre y de qué se trata]
Meta: [cómo sé que terminó]
Dónde quedamos: [pegar el último mensaje de retome, o "arranca de cero"]
Hoy quiero: [la tarea concreta]
```

---

## 12. Glosario corto

- **PDP:** el plan del proyecto (sección 6).
- **Criterio de salida:** el resultado verificable que cierra una fase.
- **ESTADO_ACTUAL / HANDOFF:** dónde quedamos / qué quedó a medias.
- **Mensaje de retome:** el texto que arranca el chat siguiente sin perder
  nada.
- **Cascada:** el orden en que se lee al abrir una sesión, y hasta dónde.
- **Freno / saboteador:** lo que impide un error / lo que prueba que el freno
  frena.
- **Hipótesis / probable / confirmado:** los tres grados de la evidencia.
- **Fan-out:** repartir el trabajo en varios agentes en paralelo. Caro; solo
  si el trabajo es ancho, independiente y el plan lo banca.
