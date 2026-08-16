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
