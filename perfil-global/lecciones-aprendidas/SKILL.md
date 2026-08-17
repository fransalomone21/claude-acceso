---
name: lecciones-aprendidas
description: Registro acumulado de lecciones de proceso (no de codigo) que ya costaron tiempo al menos una vez, mas el protocolo para agregar nuevas. Leer al empezar una tarea de investigacion o debugging. Escribir al cerrar cualquier tarea donde algo fallo por como se trabajo, no por que decia el codigo.
---

# Lecciones aprendidas

Errores de **proceso**, no de código. Cada uno costó tiempo real al menos una
vez. El código roto se arregla y se olvida; estos vuelven a pasar salvo que
estén escritos.

Esto es distinto de la bitácora de un proyecto: la bitácora registra qué pasó
en *ese* proyecto. Esto registra cómo trabajar mejor en *cualquiera*.

## Las tres capas, y cuál dispara sola

Este archivo es **la versión larga**: el caso concreto de cada lección, que es
lo que hace que se reconozca la próxima vez. Es caro de leer entero, así que
no se lee entero.

| Capa | Archivo | Cuándo entra |
|---|---|---|
| Síntesis | `perfil-global/chequeo-de-trabajo.md` | **sola**, hook `SessionStart` |
| Índice | `perfil-global/aprendizaje/lecciones.jsonl` | `aprender.py digesto` |
| Historia | este archivo | cuando una lección aplica y hace falta el caso |

Registrar una lección nueva **no es editar este archivo**:

```
python perfil-global\herramientas\aprender.py agregar --titulo ... \
    --costo ... --sintoma ... --regla ... --grupo ... --proyecto ...
```

Eso escribe el índice desde cualquier carpeta de la máquina. Este archivo se
edita a mano sólo cuando la lección **necesita su historia** para entenderse
—que es el caso de casi todas las de abajo—, y ahí la entrada del índice
apunta acá con su `ref`.

---

## 1. "No puedo" es una afirmación sobre el mundo y necesita evidencia

La regla de evidencia (hipótesis ≠ confirmado) aplica también a las propias
capacidades. Declarar algo imposible sin verificarlo es el mismo error que
declarar una dirección de memoria confirmada sin verla en pantalla.

**Origen:** se afirmó dos veces "no puedo manejar el debugger" sin revisar.
La verificación real (leer la tabla de opcodes del protocolo, buscar
alternativas, chequear qué puertos escuchaban en la máquina) tardó tres
minutos y cambió el mapa: existía un canal que sí lo permitía, sólo que
requería otra build. La respuesta final siguió siendo "no", pero por razones
distintas y con un camino alternativo identificado.

**Cómo aplicarla:** antes de responder "no se puede", nombrá qué evidencia
concreta lo respalda. Si no hay ninguna, buscala primero.

---

## 2. Observar antes que intervenir

Cuando dos métodos responden la misma pregunta, elegir el que **no modifica**
el sistema observado. La intervención se reserva para cuando la observación
ya no alcanza.

**Origen:** para identificar cuál dirección de memoria era la vida del
jugador, escribir valores de prueba era destructivo (crasheó el emulador) y
los breakpoints requerían intervención manual. Muestrear pasivamente los
candidatos mientras el usuario jugaba resolvió la pregunta entera con cero
riesgo.

**Cómo aplicarla:** ante un candidato a modificar, preguntarse primero si
alcanza con mirarlo cambiar.

---

## 3. Reformular la pregunta antes de resolver la difícil

Si un paso parece requerir una capacidad que no tenés, el problema puede
estar en cómo está planteada la pregunta, no en la capacidad que falta.

**Origen:** se estaba resolviendo "cómo pongo un breakpoint" cuando la
pregunta real era "cómo correlaciono un valor con un evento observable". La
segunda tenía una respuesta que ya estaba en la caja de herramientas del
proyecto, sin herramientas nuevas ni riesgo.

**Cómo aplicarla:** cuando aparece un bloqueo, escribir la pregunta un nivel
más arriba de abstracción y ver si se disuelve.

---

## 4. Causalidad y descarte de la alternativa, no sólo correlación

Correlación fuerte da confianza alta, no confirmación. Confirmación es:
intervenir en la causa y ver el efecto, **más** descartar explícitamente la
hipótesis alternativa más plausible.

**Origen:** la correlación temporal entre una dirección y los eventos de daño
era casi perfecta. Lo que la volvió confirmación fueron dos cosas: escribir
en esa dirección y ver que un valor derivado se recalculaba solo, y después
comprobar que la hipótesis rival (que fuera munición de reserva, porque el
HUD mostraba un número casi idéntico) quedaba descartada porque la munición
no se movió.

**Cómo aplicarla:** antes de declarar algo confirmado, nombrá en voz alta la
segunda explicación más probable y diseñá el test que la mata.

---

## 5. Un valor derivado se parece muchísimo a su fuente

Dos valores pueden moverse en los mismos instantes exactos y ser cosas
distintas: uno la fuente, el otro lo que se dibuja. Escribirle a un derivado
puede romper el sistema, porque suele estar acotado a un rango que la fuente
no tiene.

**Origen:** dos direcciones se movían en timestamps idénticos. Una era la
vida (continua, con decimales); la otra, los segmentos de la barra del HUD
(entero, rango 0-8). Escribirle 999 a la segunda crasheó el emulador a
pantalla negra: era un índice de render fuera de rango.

**Cómo aplicarla:** un valor entero y acotado que acompaña a uno continuo es
casi siempre el espejo, no el original. Escribí en el continuo.

---

## 6. Los recuerdos del usuario son pistas, no datos

Tratarlos como hipótesis de baja confianza. Sirven para desempatar entre
finalistas al final; no para descartar candidatos al principio.

**Origen:** "la vida máxima era ~1200" resultó falso (era ~440 y subiendo).
Usarlo como filtro fuerte habría descartado la dirección correcta.

**Cómo aplicarla:** agradecé el dato, anotalo como hipótesis, y no lo pongas
en el camino crítico hasta tener con qué contrastarlo.

---

## 7. Instalado no es instalado hasta que se verificó que el sistema lo lee

Copiar un archivo a una ruta no garantiza que la herramienta lo cargue. La
verificación es ver el efecto, no ver el archivo.

**Origen:** un skill quedó "instalado" durante días en
`~/.claude/claude-code-skills/`, una carpeta que Claude Code no lee. El
script de verificación confirmaba que el archivo existía — que era cierto e
inútil. La convención real era `~/.claude/skills/`. El síntoma: el skill
nunca aparecía disponible, y eso se atribuyó a otra cosa.

**Cómo aplicarla:** un verificador tiene que comprobar el **efecto**
(¿aparece en la lista?, ¿responde?), no la **precondición** (¿existe el
archivo?).

---

## 8. Una prueba que no cruza la misma frontera que el uso real no prueba el uso real

Si el uso real atraviesa un límite (un proceso, una consola, una red, un
archivo) y la prueba lo saltea llamando a la función por adentro, lo que se
está probando es la lógica, no la herramienta. Los bugs viven en el límite.

**Origen:** `vigilar.py analizar` fallaba el 100% de las veces desde la línea
de comandos —`UnicodeEncodeError` al imprimir un `Δ` que la página de códigos
de Windows no tiene— mientras su prueba pasaba en verde. La prueba llamaba a
`analizar()` en proceso contra un `StringIO`, que no codifica nada: nunca
tocaba el límite donde estaba el bug. Costó una sesión entera de analizar
CSVs a mano, y el bug quedó anotado como "pendiente" en vez de detectado.

**Cómo aplicarla:** preguntate por dónde entra el usuario y hacé que al menos
una prueba entre por ahí: si se usa por CLI, corré el CLI en un subproceso
con la salida redirigida; si se usa por red, hablale por el socket. Las
pruebas en proceso siguen sirviendo para la lógica — pero no las cuentes como
cobertura del comando.

---

## 9. Sondear es secuencial; paralelizar antes de sondear es tirar plata

El fan-out sirve cuando hay superficie **ancha e independiente** que cubrir.
No sirve cuando cada paso decide cuál es el paso siguiente — que es la forma
normal de una investigación. Y nunca sirve mandar a investigar lo que ya está
en el contexto: cada agente arranca en frío y vuelve a derivarlo.

**Origen:** se lanzaron 10 agentes (~500k tokens) a investigar en paralelo el
entorno de debugging de un emulador. La mitad de las preguntas ya estaban
contestadas en la conversación, y una se resolvía con dos comandos locales.
Lo que efectivamente destrabó el problema fueron **cuatro comandos
secuenciales**, donde cada resultado redirigió al siguiente y el primero mató
la hipótesis de trabajo. Un fan-out habría corrido los cuatro contra la
hipótesis equivocada.

**REINCIDENCIA (2026-08-15, tarde):** volvió a pasar. 11 agentes, ~100k
tokens, para construir un cliente de un protocolo **cuyo fuente ya se había
leído en esa misma sesión**. Se abortó a mitad y se hizo directo: el cliente
salió en un solo archivo, y los cuatro comandos siguientes localizaron la
rutina que llevaba dos sesiones sin aparecer. La lección estaba escrita y no
se consultó: **una skill de consulta no se dispara sola.**

**Cómo aplicarla:** antes de paralelizar, contestá dos preguntas. ¿Esto ya lo
sé? ¿El paso 2 depende del resultado del paso 1? Si la primera es sí o la
segunda es sí, es secuencial. Sondeo barato primero, herramienta después,
paralelismo sólo si queda superficie ancha.

**Y el mecanismo, porque la disciplina sola falló dos veces:** el chequeo se
inyecta ahora por hook `UserPromptSubmit` en cada prompt
(`perfil-global/recordatorio-transversal.md`). Ver lección 11.

---

## 10. El sondeo que da CERO es el más informativo

Un resultado vacío no es un intento fallido: es una hipótesis muerta, y matar
la hipótesis equivocada temprano vale más que confirmar diez detalles de la
correcta. Por eso el primer sondeo debe ser el que **puede** dar cero.

**Origen:** se dio por sentado que un dato con dirección fija se direcciona
por absoluto, y se planificó todo alrededor de buscar esa instrucción. El
primer barrido devolvió cero coincidencias en 32 MB. Ese cero reveló que
"dirección fija" significaba otra cosa —un objeto que el cargador siempre
pone en el mismo lugar, alcanzado por puntero— y reorientó la búsqueda hacia
lo que sí funcionó, en el mismo comando.

**Cómo aplicarla:** diseñá el primer sondeo para que sea capaz de refutar,
no de confirmar. Y cuando dé cero, no lo trates como "no encontré": preguntate
qué premisa acaba de caerse.

**Salvedad, y no es menor:** antes de leer un cero como hallazgo, asegurate de
que la herramienta *podía* dar distinto de cero. Un cero puede ser una
hipótesis muerta o puede ser la herramienta rota, y desde afuera se ven
idénticos. Ver lección 14.

---

## 11. Una regla que depende de recordarla no es una regla: es una intención

Escribir una lección no la instala. Si cumplirla depende de que el ejecutor
decida consultarla, va a fallar exactamente cuando más falta hace: bajo apuro,
que es cuando se toman los atajos caros.

**Origen:** la lección 9 estaba escrita, era precisa, y se violó igual dos
sesiones seguidas. La segunda vez el usuario lo señaló: *"eso pasa porque no
implementaste bien las skills, deben ser transversales"*. Tenía razón —
además se descubrió que `skipWorkflowUsageWarning: true` estaba silenciando el
aviso de costo del propio sistema. Había un freno y estaba desconectado.

**Cómo aplicarla:** cuando una lección se repite, no la reescribas más fuerte
— eso es subir el volumen de algo que ya nadie escucha. Convertila en
mecanismo. Escala, de menos a más confiable:

| Nivel | Mecanismo | Se dispara |
|---|---|---|
| 1 | Skill de consulta | sólo si alguien la invoca |
| 2 | Línea en `CLAUDE.md` | si se leyó el archivo |
| 3 | **Hook** (`SessionStart`, `UserPromptSubmit`) | siempre — **si está bien cableado** |
| 4 | Permiso denegado / validación | imposible saltearlo |

El "si está bien cableado" no es una salvedad retórica: el primer hook que se
escribió con esta tabla no disparó ni una vez, y nadie se enteró hasta que el
usuario lo reclamó. Un hook roto es *peor* que no tener hook, porque figura
como resuelto. Ver lección 13.

Y antes de agregar un freno, **revisá si ya existe uno desactivado**. Silenciar
un aviso es la forma más barata de romper un sistema de seguridad.

**Elegir el evento por frecuencia, que es lo que fija el costo:**

| Evento | Dispara | Sirve para |
|---|---|---|
| `SessionStart` | una vez por sesión | protocolos de apertura; puede ser largo |
| `UserPromptSubmit` | en cada prompt | chequeos cortos; cada línea se paga N veces |

Los archivos inyectados van en **ASCII**: la consola de Windows los lee como
cp1252 y los acentos salen como mojibake — el mismo bug que documenta
`salida.py` en el proyecto BLACK.

---

## 12. Cuando el espacio de búsqueda no se achica, sospechá del parámetro

Si una búsqueda bien hecha devuelve demasiados candidatos y ningún criterio
los desempata, el problema puede no estar en el desempate sino en que se está
buscando lo que no es. Antes de invertir en filtrar, verificá la premisa que
generó la búsqueda.

**Origen:** dos sesiones tratando de desempatar 69 candidatos a "instrucción
que escribe la vida". El desempate era imposible porque la búsqueda usaba el
offset `+0x28`, derivado de una base de struct que se había **inferido** por
escaneo de punteros y era falsa. La base real (`0x005A8AB0`, offset `+0x2F8`)
se obtuvo leyendo el **registro base en vivo** al disparar un watchpoint. Con
el parámetro corregido, la misma búsqueda pasó de 69 candidatos a 8 y la
rutina apareció en el desensamblado de los dos primeros.

**Cómo aplicarla:** todo valor *inferido* que después se usa como parámetro de
búsqueda es una hipótesis disfrazada de dato. Marcalo como tal y buscá la
forma de **observarlo directamente** antes de construir encima. Preguntá:
"¿este número lo vi, o lo deduje?".

Corolario práctico: para anclar una estructura, un watchpoint de **lectura**
sobre un campo conocido es mejor entrada que uno de escritura — dispara solo
(el HUD lee cada frame), no necesita provocar nada, y el registro base al
pausar da la respuesta directa.

Segundo corolario: **un filtro que sólo acota por arriba no filtra.** Buscando
registros con "alcance y daño positivos y menores que 20000" salieron 402
falsos positivos, porque basura binaria leída como flotante da números
diminutos (`1e-43`) que pasan cualquier prueba de signo. Con cotas por abajo
realistas —un arma no tiene alcance de un centímetro— quedaron los 17 reales.
Cuando definas un rango de plausibilidad, escribí las dos cotas y justificá
las dos.

---

## 13. El comando que le das a otro programa lo ejecuta el shell de ÉL

Cuando escribís un comando dentro de un archivo de configuración —un hook, un
paso de CI, un `command:` de YAML— no lo corre tu terminal: lo corre el
programa que lee esa configuración, con el shell que ese programa elija. Toda
sintaxis específica de un shell es una bomba de tiempo, y el fallo es
silencioso porque nadie ve el comando ejecutarse.

**Origen:** el hook `SessionStart` que obliga a abrir cada sesión con
Fase/Modelo/Contexto quedó instalado y **nunca disparó**. El comando era:

```
powershell -NoProfile -Command "Get-Content -Raw -ErrorAction SilentlyContinue
((Join-Path $env:USERPROFILE '.claude\apertura-proyecto.md'))"
```

Correcto en PowerShell. Pero el harness lo pasa por Git Bash, y bash expande
`$env` —una variable que no existe— antes de que PowerShell vea nada: la ruta
llegaba como `:USERPROFILE\.claude\...`. Resultado: `exit 1`, **stdout de cero
bytes y stderr vacío**. El `-ErrorAction SilentlyContinue` remató el asunto
convirtiendo el error en silencio.

Costó días de sesiones abiertas sin el protocolo, y el usuario tuvo que
señalarlo. El commit que lo introdujo decía "verificado […] ejecutando el
comando del hook: sale limpio" — verificado en PowerShell, que es justamente
el único shell donde no falla.

**Cómo aplicarla:**

1. Un comando de configuración no puede contener sintaxis de ningún shell:
   nada de `$VAR`, `$env:VAR`, `%VAR%`, comillas anidadas ni sustitución. Sólo
   un ejecutable, una **ruta absoluta entre comillas** y argumentos simples.
   Toda la lógica va adentro de un script, donde ya nadie la reinterpreta.
2. **Nunca silencies errores en un hook.** `-ErrorAction SilentlyContinue` y
   `2>/dev/null` convierten "está roto" en "no dijo nada", que es idéntico a
   "funcionó y no tenía nada que decir".
3. Si el efecto no es observable, hacelo observable. El lanzador escribe una
   línea en `~/.claude/hooks/disparos.log` cada vez que corre: es la única
   forma de contestar "¿disparó?" sin adivinar.
4. Probalo con el shell del otro programa, no con el tuyo.

**Trampa encontrada al arreglarlo:** en Windows 11, `Get-Command bash.exe`
resuelve a `WindowsApps\bash.exe`, que es **WSL** — un Linux real que no ve
`C:/Users/...` y contesta "No such file or directory" a cualquier ruta de
Windows. El harness usa Git Bash (`MINGW64`). Probar en el bash equivocado da
un rojo tan falso como el verde que se estaba tratando de arreglar; verificá
con `uname -s`.

---

## 14. Un cero sólo vale si la herramienta podía dar distinto de cero

Antes de interpretar un barrido vacío, corré la misma herramienta contra un
caso donde ya sabés la respuesta. Sin ese control positivo, "no hay nada" y
"la herramienta no funciona" son indistinguibles — y la segunda se disfraza
de hallazgo, que es la peor forma de estar equivocado.

**Origen:** para decidir qué clase de entidad era la de los enemigos, se
desensambló el mismo método virtual de ocho clases contando cuáles escribían
en el campo de vida. **Las ocho dieron cero stores.** Leído como dato, eso
significaba "esa ranura de la vtable no es la rutina de daño" y tiraba abajo
la hipótesis entera. Era un bug: `capstone` en `CS_MODE_MIPS32` se corta en la
primera instrucción propia del R5900 —que aparece en el prólogo de casi toda
función— y devuelve **cero instrucciones sin lanzar ningún error**. Con
`CS_MODE_MIPS64` + `skipdata=True` las mismas ocho funciones se
desensamblaron enteras y dos escribían en el campo de vida, que era la
respuesta buscada. Lo que lo destapó fue desensamblar una dirección cuyo
contenido ya se conocía de una sesión anterior: salió bien, y la
contradicción delató la herramienta.

**Cómo aplicarla:** cuando montes un barrido, elegí de antemano un caso
positivo conocido y metelo en la misma corrida. Si el control no aparece en
los resultados, lo que falló es el instrumento y todavía no sabés nada del
problema. Vale para grep con la regex mal escrita, para un filtro de fechas
que descarta todo, y para cualquier parser que degrade en silencio en vez de
tirar excepción.

**Corolario:** una herramienta con un filtro incorporado lleva adentro una
hipótesis, y filtra según *esa* hipótesis, no según la tuya. En el mismo
proyecto, un buscador de instrucciones traía un filtro "sólo las que tengan
una resta flotante cerca" — razonable, y excluía exactamente las dos que
importaban. El conjunto de candidatos con el que se venía trabajando desde
hacía dos sesiones nunca había sido el conjunto real. Cuando un resultado
filtrado te esté costando caro, mirá qué decidió la herramienta por vos.

---

## 15. Preguntá si el dato es estático antes de buscarlo como estático

Antes de barrer un binario buscando una tabla de configuración, contestá una
pregunta más barata: **¿este dato viene horneado en el ejecutable, o se carga
en tiempo de ejecución desde otro lado?** Las dos formas se buscan distinto y
en lugares distintos, y confundirlas no te da un resultado peor: te da un
resultado *falso* que además parece bueno.

**Origen:** se buscó la tabla de armas de un juego dentro del ejecutable y de
su BSS. Aparecieron cinco lugares con el valor de daño exacto ya confirmado
por otra vía, rodeados de números plausibles. Se les escribió un valor nuevo
en memoria viva y **no cambió ningún daño**; encima esa zona resultó ser del
HUD y aparecieron dos barras negras en pantalla. Media sesión, un experimento
quemado y una corrupción visual. La tabla se cargaba **por nivel, desde un
archivo, al heap** — o sea que su dirección cambia entre partidas y no podía
estar en ningún volcado estático. Y el dato que lo decía estaba **a la vista
desde el principio**: una cadena de formato con la ruta del archivo
(`.../Stg_%04u/Guns%s.bin`) que ya se había leído y anotado, sin sacarle la
conclusión.

**Cómo aplicarla:** cuando busques una tabla de parámetros, empezá por las
cadenas de rutas y de formato del binario. Una ruta a un archivo de datos, un
nombre de sección de config, o un mensaje de error sobre un archivo que falta,
te dicen que el dato **se carga** — y entonces buscarlo en el ejecutable es
tiempo tirado. El síntoma de haberse equivocado en esto es característico:
encontrás candidatos que *parecen* perfectos por su contenido y no responden
cuando los tocás. Contenido plausible sin respuesta a la escritura = estás en
una copia, un caché o algo homónimo, no en la fuente.

**Corolario:** el mismo error tiene una versión más general. Un valor puede
existir en varios lugares a la vez —la fuente, una copia por instancia, un
caché de render— y todos muestran el número correcto. El único que importa es
el que, al escribirlo, cambia el comportamiento. Ver también la lección 5.

---

## 16. Un efecto confirmado en UN sentido no confirma el sentido inverso

Cuando un parámetro parece simétrico —atacante/víctima, entrada/salida,
lectura/escritura— una intervención sólo prueba la dirección que efectivamente
ejercitó. Anotar la otra como confirmada es inventar evidencia, y se paga con
media sesión buscando por qué "el mismo parámetro no obedece".

**Origen:** se escribió un valor alto en los 34 campos de daño de la tabla de
armas de un juego. El efecto se vio y fue real: el **jugador** empezó a
recibir el daño de un arma pesada. Eso se anotó como "la tabla de armas es la
tabla de daño, confirmada por efecto". Pero el daño que el jugador **hacía**
siguió clavado en 25.5 por bala, y eso quedó registrado como una anomalía a
explicar. No era una anomalía: el daño de salida nunca había salido de esa
tabla. Sale de una tabla distinta, por **zona de impacto**, multiplicada por
100 — y la función que lo calcula ignora por completo el daño que le llega.
El experimento había probado "arma → daño recibido por el jugador" y la ficha
lo generalizó a "arma → daño". En el medio se atribuyeron a fuego amigo dos
muertes de enemigos que nadie vio ocurrir.

**Cómo aplicarla:** al anotar un efecto, escribí la dirección en la frase, no
el parámetro suelto: no "Power controla el daño" sino "Power controla el daño
que **recibe** el jugador". Y antes de cerrar, preguntate cuál es el sentido
inverso y si el experimento lo tocó. Si no lo tocó, va como hipótesis. Vale
igual para "el cliente puede escribir" ⇏ "el cliente puede leer", y para "la
migración sube" ⇏ "la migración baja".

**Corolario:** cuando la evidencia de un efecto es un cambio que el
observador **no vio suceder** —un contador que bajó, un objeto que apareció
muerto— eso es un estado final, no un efecto observado. La causa quedó
inferida. Anotalo como lo que es.

---

## 17. Un negativo vale lo que valga el parámetro de la búsqueda

Una búsqueda que no encuentra nada prueba dos cosas a la vez, y hay que
separarlas: o la cosa no está, o la buscaste mal. Si el resultado negativo se
anota como "no está" y encima se archiva como callejón cerrado, nadie lo vuelve
a mirar — y el dato estaba ahí todo el tiempo.

**Origen — el mismo día, tres veces.**

1. Se buscó una tabla de datos dentro de los archivos de un juego copiando la
   **ventana de bytes crudos** que rodeaba al dato en memoria viva. Cero
   coincidencias, en nueve archivos. Se anotó "la tabla no está en el ISO" y
   quedó como callejón cerrado durante días. Estaba: la ventana arrancaba con
   tres punteros al heap, que en el archivo son offsets chicos. Buscando por
   **firma estructural** —los campos invariantes, no los bytes— apareció en el
   primer intento, con el conteo y el paso exactos.
2. Una herramienta de referencias cruzadas devolvía "NADA" para una dirección
   que **sí** estaba referenciada. Su ventana de búsqueda eran 8 instrucciones
   y el par que armaba la dirección estaba a 9.
3. La misma herramienta no podía encontrar 561 globales del programa porque se
   direccionan por registro base (`$gp`) y ella buscaba otro patrón. Nunca
   había avisado de esa limitación.

**Cómo aplicarla:** antes de anotar un negativo, contestá "¿con qué parámetro
lo busqué, y qué asume ese parámetro?". Si la búsqueda depende de bytes que
pueden cambiar entre las dos representaciones (punteros, offsets, padding,
endianness, compresión), buscá por lo **invariante**: la estructura, las
relaciones entre campos, los valores que tienen significado. Y corré siempre un
**control positivo** — buscá algo que sabés que está. Si el control tampoco
aparece, el negativo no vale nada.

**Corolario para herramientas:** una herramienta que puede devolver un falso
negativo tiene que decirlo en su propia salida o en su `--help`. "NADA" sin
mencionar el radio de búsqueda es una respuesta que miente.

---

## 18. "Succeeded" no es un resultado: es la herramienta contándote de sí misma

Cuando una herramienta elige sola un parámetro crítico —el target, el
dialecto, la codificación, el esquema— esa elección es **una hipótesis suya**,
no un dato. Y si se equivoca, no falla: hace el trabajo entero sobre la
premisa equivocada y te reporta éxito, con código de salida 0.

**Origen:** se instaló Ghidra con la extensión de PlayStation 2 para
decompilar el ejecutable de un juego. El análisis terminó con
`INFO REPORT: Analysis succeeded`, exit code 0, 29 segundos. Perfecto.

Salvo que había elegido `MIPS:LE:64:64-32R6addr` —MIPS Release 6, una ISA
distinta de la del procesador real— y el resultado era **1 función en 2,6 MB
de código**. Los `ERROR Pcode error` en el log parecían ruido de fondo y eran
el síntoma. Forzando el procesador correcto: **9842 funciones**.

En la misma instalación, antes, había pasado la versión suave del mismo error:
la extensión se descomprimió en `Extensions/Ghidra/` en vez de
`Ghidra/Extensions/`. Las dos carpetas existen, ninguna dio error, y la
extensión simplemente no se cargó (lección 7).

Lo que destapó las dos cosas fue el mismo chequeo: decompilar una función
cuyo comportamiento **ya estaba confirmado por otra vía** y buscar la
constante que tenía que aparecer. Tres minutos de trabajo que evitaron
construir una sesión entera sobre un desensamblado vacío.

**Cómo aplicarla:**

1. Cuando montes una herramienta nueva, tu primer uso no es el trabajo real:
   es un **caso cuya respuesta ya conocés**. Si no tenés ninguno, conseguilo
   antes de confiar en el primero de verdad.
2. Preguntá qué eligió la herramienta y **hacelo imprimir**. `succeeded` no
   dice nada; `Using Language/Compiler: r5900:LE:32` sí. Si la salida no te
   dice qué configuración usó, esa es la primera pregunta.
3. Buscá el **número absurdo**. 1 función en 2,6 MB, 0 filas en una tabla
   poblada, 3 ms para algo que debería tardar un minuto. Un resultado
   plausible-pero-chico es más peligroso que un error.
4. Mirá los mensajes que descartaste como ruido. `ERROR` repetido en un
   proceso "exitoso" es una contradicción, no un detalle.

Es la misma familia que la 14 (un cero sólo vale si la herramienta podía dar
distinto de cero) y la 7 (instalado no es instalado hasta que se verificó el
efecto). La diferencia: acá la herramienta no calla — **afirma que salió
bien**, que es mucho más difícil de dudar.

**El caso barato que le pasa a todo el mundo: la codificación.** En la misma
sesión, un reemplazo de texto en tres archivos Markdown se hizo con
`Get-Content -Raw | ... | Set-Content -Encoding utf8`. Salió sin un solo
error. Y corrompió los tres: PowerShell 5.1 **lee** con la codificación ANSI
del sistema, así que los bytes UTF-8 de cada acento se interpretaron como dos
caracteres cp1252 y `-Encoding utf8` los escribió de nuevo, ahora
doble-codificados. `á` quedó como `Ã¡`, mil veces por archivo, más un BOM
regalado.

Fue reversible —decodificar UTF-8, re-codificar cp1252— pero sólo porque se
notó **en el mismo turno**. Commiteado, se hubiera vuelto ruido permanente en
el historial.

La regla práctica: **un editor de texto no es un pipeline de shell.** Para
buscar y reemplazar en un archivo con contenido no-ASCII, usá una herramienta
que preserve bytes (el editor del agente, `python` con `encoding=` explícito,
`sed` en un entorno UTF-8), nunca un round-trip por el shell. Y si tenés que
usarlo igual, el control positivo es una línea: contar cuántos acentos y
cuántos `Ã` hay antes y después.

## 19. El repo es la memoria del proyecto, no la de la máquina

**Qué pasó.** El runbook decía "PCSX2-MCP: no se instaló, la decisión es de
Fran". Fran lo bajó y lo descomprimió en `Descargas` el 2026-08-15, junto con
el instalador de Node que hace falta. Durante varias sesiones seguidas, cada
una leyó el runbook, repitió "no está instalado" y siguió de largo. La
herramienta estaba a un `dir` de distancia. Lo cortó Fran, no la sesión:
*"si está instalado en descargas y por muchas sesiones lo ignoraste, que no
vuelva a pasar"*.

**Por qué es de proceso y no de código.** La regla 2 del perfil —"el repo es
la memoria"— es correcta y se aplicó bien. El error fue extenderla de más: el
repo recuerda **lo que decidimos**, no **lo que hay en el disco**. Un archivo
markdown no puede enterarse de que apareció una carpeta nueva. Y como el
documento sonaba autoritativo y estaba actualizado, nadie fue a mirar.

Es la 7 al revés. La 7 dice "instalado no es instalado hasta que verificaste
el efecto". Ésta dice lo simétrico y menos obvio: **"no instalado" tampoco es
"no instalado" hasta que miraste.** Un negativo escrito en un documento
envejece igual que un positivo, y envejece peor: nadie lo revisa porque cierra
con lo que uno ya cree.

**Cómo aplicarla:**

1. **El estado del entorno se mide, no se lee.** Cualquier proyecto que
   dependa de instrumental externo necesita un comando que mire la máquina y
   lo devuelva. En BLACK es `herramientas/inventario.py`, y corre al abrir la
   sesión, antes que nada.
2. Ese comando tiene que tener una categoría explícita para lo que se nos
   escapó: **"bajado pero sin incorporar"**. Un chequeo binario
   presente/ausente no la habría encontrado, porque PCSX2-MCP no estaba
   instalado — estaba *disponible*, que es distinto y más fácil de perder.
3. Cuando un documento diga que algo falta, **verificalo antes de repetirlo**.
   Repetir un negativo ajeno es propagarlo sin costo aparente, y el costo real
   es que se vuelve verdad por repetición.
4. Si el usuario bajó algo a mano, es porque lo quiere usado. Un ítem en
   `Descargas` con el nombre de una herramienta del runbook es una instrucción,
   no ruido.

**Lo que costó:** varias sesiones sin una capacidad que ya estaba pagada. Y
peor: el mismo error tapaba `PCSX2SaveStateImporter.java`, que venía adentro
de la extensión de Ghidra desde el día que se instaló, estaba documentado en
el propio runbook como "el primer experimento de la sesión que viene", y
tampoco se usó. Dos herramientas útiles paradas por la misma causa.

---

## 20. Un control mal dimensionado fabrica hallazgos

**Origen.** Buscando LBAs hardcodeados en un ejecutable, el conjunto real se
expandió con los vecinos ±1 —1644 valores— y el de señuelos quedó en 600. La
herramienta informó "los valores reales aparecen POR ENCIMA del ruido" y era
mentira: por valor, las dos tasas eran idénticas. Con los dos conjuntos en
1644, la señal desaparecía.

En la misma corrida, el control positivo tampoco probaba nada: la aguja se
sacaba de un offset fijo y ahí había `0x00000000`, que aparece miles de veces.
"Aguja encontrada" era verdad y era inútil.

**Cómo aplicarla.** Un control vale sólo si es simétrico con lo que compara:

- el **negativo** tiene que tener **la misma cantidad de elementos, del mismo
  rango, buscados en las mismas codificaciones**. Si expandís el conjunto real,
  expandí el señuelo;
- el **positivo** tiene que ser **distintivo**: no nulo, pocas apariciones. Una
  aguja que está en todos lados no prueba que el detector funcione.

Y el corolario: cuando el rango de lo que buscás coincide con el rango de algo
abundante en el material —ahí, los LBA caían justo en el rango de direcciones
del `.text`—, sin señuelos del mismo rango no estás midiendo nada.

## 21. La dirección base de un volcado es parte de la medición

**Origen.** Se volcó la RAM con `pine.py volcar 0x00100000 ...` y se analizó
con herramientas que asumen que el byte 0 del archivo es la dirección 0. Todo
apareció `0x100000` más abajo. Se llegó a escribir en el `kb` que "el heap se
corrió entre sesiones" y a *arreglar* otra herramienta con esa premisa falsa.
No se había movido nada.

**Lo que costó:** una hora, un dato falso a punto de quedar commiteado, y una
herramienta modificada con una justificación inventada.

**Cómo aplicarla.** Un volcado sin su dirección base es un archivo de bytes sin
significado. Anotala junto al archivo, y si una herramienta la asume, que
**avise sola** cuando no se cumple (`pine.py volcar` ahora lo hace). Y ante un
"esto se movió": antes de creerle al mundo, revisá el instrumento — un
desplazamiento constante y redondo es casi siempre de la medición.

## 22. La métrica equivocada no falsifica: mide otra cosa con cara de resultado

**Origen.** Para probar si un campo era la cadencia de tiro enemiga se midieron
**impactos por minuto**. No dio diferencia, y la conclusión iba a ser "no es la
cadencia". Mirando la pantalla, Fran señaló que los enemigos disparan, **se
cubren y recargan**: o sea que el volumen total lo gobierna el ciclo de
cobertura, no el tiempo entre balas. Separando los intervalos en dos
poblaciones —huecos cortos dentro de la ráfaga, huecos largos entre ráfagas— el
efecto apareció con 555 dispersiones de separación y varianza de ±0.04 ms.

**Cómo aplicarla.** Antes de medir, escribí **por qué mecanismo** la variable
debería llegar a la métrica. Si en el camino hay un proceso que domina, la
métrica no puede ver el efecto, y un negativo no significa nada. Preguntale al
que mira el sistema funcionando qué está pasando: esa observación vale más que
otra corrida.

## 23. La ventana de medición tiene que sobrevivir al modo de falla

**Origen.** Un A/B de 60 s por condición sobre "el jugador bajo fuego": murió a
los 55 s de la condición A, y la condición B entera midió una pantalla de
derrota. Sesenta segundos de un número quieto, y el experimento entero perdido.

**Cómo aplicarla.** Preguntá qué puede **terminar** la ventana antes de tiempo
y desactivalo, aunque sea artificialmente. Acá se resolvió inflando la vida a
un millón: **la vida dejó de ser la vida y pasó a ser un contador de impactos**.
De paso desapareció el ruido de la regeneración. Un instrumento puede usar una
variable del sistema para algo distinto de lo que el sistema la usa.

## 24. Buscá si la respuesta ya está escrita antes de inferirla

**Origen.** Con el objetivo de mapear dos estructuras de ~550 campos, el plan
era peinar offsets cruzando estadística y desensamblado. Fran lo cortó con una
imagen: *antes de buscar el reloj grano por grano en la playa, fijate si no lo
tenés puesto*. Dos chequeos de cinco minutos cambiaron el rumbo: el ejecutable
**no** traía DWARF (`.debug_str` medía 1 byte) pero **sí** traía RTTI, y de ahí
salieron 182 clases con nombre y jerarquía, mecánicamente.

**Cómo aplicarla.** Antes de arrancar un trabajo de inferencia largo, gastá
diez minutos en descartar que el artefacto ya contenga la respuesta: símbolos,
información de depuración, RTTI, cadenas de esquema, tablas de reflexión,
nombres de campo en `.rodata`. El costo es fijo y chico; el ahorro, si acierta,
es de días. Y si no acierta, cerraste un callejón con evidencia en vez de
sospecharlo.

> Nota honesta sobre este caso: el RTTI resultó ser de una biblioteca de
> terceros **linkeada pero muerta** —0 de 182 metaclases inicializadas—, así
> que sirvió como mapa de diseño y no como manija de runtime. El chequeo siguió
> valiendo la pena: costó minutos y cerró dos hipótesis con medición.

---

## 25. Un mecanismo de captura que vive en un proyecto captura un solo proyecto

Una lección de proceso es, **por definición**, la que va a volver a pasar en
otro proyecto — el punto 3 del protocolo de acá abajo. O sea: exactamente la
clase de cosa que no puede guardarse adentro de uno.

**Origen:** `aprender.py` se escribió en `black/herramientas/` y funcionaba
perfecto: registro append-only, digesto para abrir sesión, sin duplicados. Y
justamente porque funcionaba, el problema tardó en verse. Al revisarlo, el
registro tenía **cinco lecciones, las cinco del mismo proyecto y del mismo
día**, mientras esta skill —la global, la que se lee en cualquier repo— se
seguía editando a mano, que es el nivel 1 de la tabla de la lección 11: el que
sólo dispara si alguien se acuerda. Todo lo aprendido fuera de BLACK desde
que la herramienta existe: cero entradas. No porque no hubiera lecciones, sino
porque no tenían dónde caer.

Y había un segundo error adentro del primero: el registro vivía en
`black/kb/`. Correcto para BLACK, pero la versión global tenía la tentación de
escribir en `~/.claude/`, que **no se commitea**. Un registro de aprendizaje
que vive sólo en la máquina se pierde con la máquina.

**Cómo aplicarla:** el instrumental que implementa una regla global vive donde
vive la regla, no en el proyecto donde apareció por primera vez. Y su fuente de
verdad es el repo; lo instalado en `~/.claude/` es una copia, con un puntero de
vuelta al repo (`origen.txt`) para que escribir desde cualquier carpeta siga
cayendo donde se respalda.

**Corolario general:** cuando construyas una herramienta para un proceso,
preguntate si el proceso es de *este* proyecto o de *cómo trabajás*. Si es lo
segundo y la herramienta quedó adentro del proyecto, ya sabés cuál va a ser el
síntoma: la herramienta anda bien y el registro está casi vacío.

---

## 26. Antes de adoptar un método traído de afuera, auditá qué parte ya corre

Un documento externo bien escrito propone una arquitectura completa y suena
toda nueva. Adoptarla entera duplica lo que ya tenías —y el duplicado se paga
en cada respuesta, para siempre—; descartarla entera tira lo poco que era
nuevo. Las dos salidas fáciles son caras.

**Origen:** un documento de "pipeline metadev" de 116 líneas, escrito con
otro modelo, proponía nueve mecanismos para el proyecto. Auditados uno por uno
contra lo que ya corría: **cinco ya estaban implementados** (bucle de
contexto = `ESTADO_ACTUAL`/`HANDOFF`/`kb`; bucle de metacognición =
`aprender.py` + esta skill; system prompt duro = `CLAUDE.md` global + hooks;
limpieza de historial = el cuadro de fase y su mensaje de retome;
autorregulación de esfuerzo = `enrutador-modelo`), **uno estaba pero
incompleto**, **dos eran nuevos y se adoptaron**, y **uno había que
rechazarlo con razón**: un bloque de telemetría al final de cada respuesta que
era, campo por campo, el cuadro de fase que ya va al principio — Hito Técnico
= Fase, Calibración = Modelo, Saturación = Contexto, Payload = mensaje de
retome. Agregarlo habría costado un bloque duplicado en **cada** respuesta a
cambio de nada.

**Cómo aplicarla:** auditá ítem por ítem y clasificá cada uno en cuatro
cajones, por escrito: *ya está* (dónde) · *está pero roto o a medias* (qué
falta) · *es nuevo* (dónde se implementa) · *no aplica* (por qué). El cajón
que más se saltea es el segundo, y es el que importa: "ya está" dicho sin
mirar es la forma más barata de dejar algo roto marcado como resuelto — la
lección 19 al revés.

**Y guardá la auditoría, no sólo la conclusión.** Si el documento vuelve a
aparecer en seis meses —o lo trae otra persona— la pregunta va a ser la misma,
y sin la tabla se rehace el trabajo entero. Acá quedó en
`perfil-global/referencias/`, junto al documento original.

---

## Protocolo para agregar una lección

Una entrada nueva entra sólo si cumple las tres:

1. **Costó tiempo real**, no es una precaución teórica.
2. **Es de proceso, no de código.** Un bug arreglado va a la bitácora del
   proyecto; cómo se llegó a trabajar mal va acá.
3. **Va a volver a pasar** en otro proyecto, no sólo en este.

Formato: título en imperativo o afirmación corta · **Origen** (el caso
concreto, con lo que costó) · **Cómo aplicarla** (qué hacer distinto la
próxima vez).

Si una lección nueva contradice una vieja, no se agrega al final: se corrige
la vieja. Este archivo no es historial.
