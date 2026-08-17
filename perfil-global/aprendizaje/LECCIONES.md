# Lecciones de proceso -- registro completo

**Generado por `perfil-global/herramientas/aprender.py`. No editar a mano:**
se reescribe entero. Para agregar: `aprender.py agregar`.

Este archivo es el **indice**: una leccion por bloque, con su regla.
La version larga -- el caso concreto, que costo, como se descubrio --
esta en `perfil-global/lecciones-aprendidas/SKILL.md`, y el campo `ref`
dice en que seccion. Las entradas migradas desde esa skill el
2026-08-17 llevan esa fecha, no la del dia en que se aprendieron.

La sintesis que se lee sola al abrir sesion es
`perfil-global/chequeo-de-trabajo.md`.

---

## Antes de creerle a algo

### "No puedo" es una afirmacion sobre el mundo

**Regla:** antes de decir 'no se puede', nombra la evidencia concreta que lo respalda. Si no hay ninguna, buscala primero: la regla de evidencia aplica tambien a las propias capacidades

**Sintoma:** se declaro imposible manejar el debugger sin haber revisado el protocolo ni los puertos que escuchaban

**Costo:** dos respuestas equivocadas y un camino alternativo que estaba a tres minutos  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#1`

### Causalidad y descarte de la alternativa, no solo correlacion

**Regla:** antes de declarar confirmado, nombra en voz alta la segunda explicacion mas probable y disena el test que la mata. Correlacion + intervencion + alternativa descartada = confirmado

**Sintoma:** una correlacion temporal casi perfecta entre una direccion y los eventos de dano

**Costo:** es lo que separa 'probable' de 'confirmado'  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#4`

### Los recuerdos del usuario son pistas, no datos

**Regla:** tratalos como hipotesis de baja confianza: sirven para desempatar finalistas al final, nunca para descartar candidatos al principio

**Sintoma:** 'la vida maxima era ~1200' resulto falso: era ~440 y subiendo

**Costo:** habria descartado la direccion correcta  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#6`

### Un efecto confirmado en UN sentido no confirma el inverso

**Regla:** al anotar un efecto escribi la direccion en la frase, no el parametro suelto. Y preguntate cual es el sentido inverso y si el experimento lo toco: si no lo toco, va como hipotesis

**Sintoma:** se vio el efecto de la tabla de armas sobre el dano que RECIBE el jugador y se anoto como 'la tabla de armas es la tabla de dano'

**Costo:** media sesion buscando por que 'el mismo parametro no obedece'  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#16`

### Alineacion no es causalidad

**Regla:** un candidato estructural perfecto sigue siendo una hipotesis. Antes de creerle, moverlo y medir el efecto. La calidad de la alineacion no es evidencia de causalidad

**Sintoma:** arma_obj+0x0C era el UNICO u32 del objeto que caia dentro de la tabla de armas, alineado a registro, en 10 de 10 objetos

**Costo:** un experimento entero  ·  black  ·  2026-08-17

### Una suposicion sobre QUIEN actua se cuela sin hacer ruido

**Regla:** identifica al actor POR EFECTO antes de tratarlo. Un experimento correcto medido sobre el actor equivocado da un negativo que parece falsacion

**Sintoma:** se eligieron como tiradores los dos enemigos con vida FLT_MAX porque parecia obvio; usaban otro registro y no disparaban

**Costo:** un experimento entero  ·  black  ·  2026-08-17

## Antes de buscar, y al leer un resultado vacio

### El sondeo que da CERO es el mas informativo

**Regla:** disena el primer sondeo para que sea capaz de REFUTAR, no de confirmar. Y cuando de cero, preguntate que premisa acaba de caerse -- salvo que la herramienta no pudiera dar distinto de cero (ver control positivo)

**Sintoma:** un barrido de 32 MB devolvio cero coincidencias donde 'tenia que haber' algo

**Costo:** lo que ahorro: reoriento la busqueda en el mismo comando  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#10`

### Si el espacio de busqueda no se achica, sospecha del parametro

**Regla:** todo valor INFERIDO que despues se usa como parametro de busqueda es una hipotesis disfrazada de dato. Preguntate: este numero lo vi, o lo deduje? Y busca la forma de observarlo directamente antes de construir encima

**Sintoma:** una busqueda bien hecha devuelve demasiados candidatos y ningun criterio los separa

**Costo:** dos sesiones desempatando 69 candidatos imposibles de desempatar  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#12`

### Pregunta si el dato es estatico antes de buscarlo como estatico

**Regla:** antes de barrer un binario, contesta si el dato viene horneado o se carga en runtime. Empeza por las cadenas de rutas y de formato. Contenido plausible sin respuesta a la escritura = estas en una copia o un cache, no en la fuente

**Sintoma:** aparecieron cinco lugares en el ejecutable con el valor exacto buscado, rodeados de numeros plausibles, y escribirles no cambio nada

**Costo:** media sesion, un experimento quemado y corrupcion visual en pantalla  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#15`

### Un negativo vale lo que valga el parametro de la busqueda

**Regla:** si la busqueda depende de bytes que cambian entre las dos representaciones (punteros, offsets, padding, endianness, compresion), busca por lo INVARIANTE: la estructura y las relaciones entre campos. Y corre siempre un control positivo

**Sintoma:** 'no esta en el ISO' despues de buscar copiando la ventana de bytes crudos de memoria viva

**Costo:** un callejon dado por cerrado durante dias, tres veces el mismo dia  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#17`

### Busca si la respuesta ya esta escrita antes de inferirla

**Regla:** antes de un trabajo de inferencia largo, gasta diez minutos en descartar que el artefacto ya contenga la respuesta: simbolos, debug info, RTTI, cadenas de esquema, nombres de campo en .rodata. Costo fijo y chico; ahorro de dias

**Sintoma:** el plan era mapear dos estructuras de ~550 campos cruzando estadistica y desensamblado

**Costo:** lo que ahorro: dias de peinar offsets, cambiados por dos chequeos de cinco minutos  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#24`

## Antes de medir

### Un valor derivado se parece muchisimo a su fuente

**Regla:** un valor entero y acotado que acompana a uno continuo es casi siempre el espejo, no el original. Escribi en el continuo

**Sintoma:** dos direcciones se movian en timestamps identicos; una era la vida y la otra los segmentos de la barra del HUD

**Costo:** el emulador a pantalla negra  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#5`

### Un control mal dimensionado fabrica hallazgos

**Regla:** el negativo tiene que tener la misma cantidad de elementos, del mismo rango y en las mismas codificaciones que el real. Y el positivo tiene que ser distintivo: una aguja que esta en todos lados no prueba que el detector funcione

**Sintoma:** el conjunto real se habia expandido a 1644 valores y el de senuelos habia quedado en 600

**Costo:** un 'los valores reales aparecen por encima del ruido' que era mentira  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#20`

### La direccion base de un volcado es parte de la medicion

**Regla:** un volcado sin su direccion base es un archivo de bytes sin significado. Ante un 'esto se movio', revisa el instrumento antes que el mundo: un desplazamiento constante y redondo es casi siempre de la medicion

**Sintoma:** todo aparecia 0x100000 mas abajo y se escribio que 'el heap se corrio entre sesiones'

**Costo:** una hora, un dato falso a punto de quedar commiteado y una herramienta 'arreglada' con una premisa inventada  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#21`

### La metrica equivocada no falsifica: mide otra cosa

**Regla:** antes de medir, escribi POR QUE MECANISMO la variable deberia llegar a la metrica. Si en el camino hay un proceso que domina, la metrica no puede ver el efecto y un negativo no significa nada

**Sintoma:** se midieron impactos por minuto para probar la cadencia de tiro y no dio diferencia

**Costo:** una conclusion negativa a punto de anotarse como falsacion  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#22`

### La ventana de medicion tiene que sobrevivir al modo de falla

**Regla:** pregunta que puede TERMINAR la ventana antes de tiempo y desactivalo, aunque sea artificialmente. Un instrumento puede usar una variable del sistema para algo distinto de lo que el sistema la usa

**Sintoma:** el jugador murio a los 55 s de la condicion A y la condicion B midio un numero quieto

**Costo:** un A/B entero: 60 s midiendo una pantalla de derrota  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#23`

### Marcar la tabla para que diga que fila usa

**Regla:** si no sabes que entrada de una tabla indexada se esta usando, escribile a cada entrada un valor UNICO y observable y deja que el efecto te nombre la fila. No supone nada sobre quien actua

**Sintoma:** se sabe donde esta la tabla pero no que fila esta usando el sistema, y adivinar quien actua ya habia hecho fallar un experimento

**Costo:** lo que ahorro: destrabo un experimento en una corrida de 25 s  ·  black  ·  2026-08-17

### Un mod ya aplicado puede aplastar el discriminador

**Regla:** antes de medir, cheque que la variable que vas a leer todavia VARIE entre las condiciones. Un cambio anterior puede haber igualado justo lo que ibas a usar de senal

**Sintoma:** un parche previo habia igualado los 17 valores que se iban a usar como senal, asi que cambiar la condicion no cambiaba nada

**Costo:** una corrida perdida  ·  black  ·  2026-08-17

### Un costo recurrente y uno unico no se suman en el mismo total

**Regla:** Antes de sumar costos, escribi al lado de cada uno CADA CUANTO se paga. Lo que se paga por turno se multiplica por la cantidad de turnos; recien ahi se comparan. El factor limitante puede ser el sumando mas chico del cuadro.

**Sintoma:** Un cuadro de medicion prolijo que suma cuatro archivos y da un TOTAL redondo. El archivo mas grande salta a la vista y parece obviamente el problema a atacar. El mas chico ni se mira.

**Costo:** casi una fase entera apuntada al archivo equivocado  ·  perfil  ·  2026-08-17

## Antes de confiar en una herramienta

### Instalado no es instalado hasta que se verifico el efecto

**Regla:** un verificador tiene que comprobar el EFECTO (aparece en la lista? responde?), no la PRECONDICION (existe el archivo?)

**Sintoma:** el verificador confirmaba que el archivo estaba en su ruta -- cierto e inutil: la carpeta no era la que lee la herramienta

**Costo:** dias con un skill que no existia para el sistema  ·  perfil  ·  2026-08-17  ·  ver `lecciones-aprendidas#7`

### Una prueba que no cruza la misma frontera que el uso real no prueba nada

**Regla:** preguntate por donde entra el usuario y haces que al menos una prueba entre por ahi. Si se usa por CLI, corre el CLI en un subproceso; si se usa por red, hablale por el socket. Los bugs viven en el limite

**Sintoma:** la herramienta fallaba el 100% de las veces desde la linea de comandos y su prueba pasaba en verde

**Costo:** una sesion entera analizando CSVs a mano por un bug que la prueba no podia ver  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#8`

### El comando que le das a otro programa lo ejecuta el shell de EL

**Regla:** un comando de configuracion no puede contener sintaxis de ningun shell: solo un ejecutable, una ruta absoluta entre comillas y argumentos simples. Nunca silencies errores en un hook. Y probalo con el shell del otro programa, no con el tuyo

**Sintoma:** exit 1, stdout de cero bytes y stderr vacio: identico a 'funciono y no tenia nada que decir'

**Costo:** dias de sesiones abiertas sin el protocolo, con el hook figurando como instalado  ·  perfil  ·  2026-08-17  ·  ver `lecciones-aprendidas#13`

### Un cero solo vale si la herramienta podia dar distinto de cero

**Regla:** cuando montes un barrido, elegi de antemano un caso positivo conocido y metelo en la misma corrida. Si el control no aparece, lo que fallo es el instrumento y todavia no sabes nada del problema

**Sintoma:** las ocho funciones desensambladas dieron cero stores, sin ningun error

**Costo:** una hipotesis correcta a punto de ser descartada por un bug de la herramienta  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#14`

### "Succeeded" no es un resultado: es la herramienta contandote de si misma

**Regla:** cuando una herramienta elige sola un parametro critico (target, dialecto, codificacion, esquema), esa eleccion es una hipotesis SUYA. Haces que imprima que eligio, busca el numero absurdo, y mira los mensajes que descartaste como ruido

**Sintoma:** 'Analysis succeeded', exit code 0, 29 segundos... y 1 funcion en 2,6 MB de codigo

**Costo:** una sesion entera a punto de construirse sobre un desensamblado vacio  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#18`

### El cwd de una herramienta de shell persiste entre llamadas

**Regla:** el directorio de trabajo sobrevive de una invocacion a la otra aunque el resto del estado del shell no. Despues de cualquier cd, o usas rutas absolutas o volves a fijar el cwd en la misma linea. Un 'no such file or directory' sobre algo que existe es el sintoma

**Sintoma:** una ruta relativa que funciono en la llamada anterior de golpe no existe, sin que nada la haya movido

**Costo:** dos comandos fallidos y un 'no such file or directory' que parecia un archivo borrado  ·  general  ·  2026-08-17

### Un documento largo se lee con la herramienta de leer, no por stdout del shell

**Regla:** Si el contenido lo vas a leer vos, no lo pases por stdout del shell: escribilo a archivo y abrilo con la herramienta de lectura, que es la que esta hecha para eso y no tiene tope. El shell es para producir el archivo, no para transportarlo. Si igual vas a imprimir, dimensiona el tramo por debajo del tope antes del primer intento, no despues del primer rebote.

**Sintoma:** Corres un comando que imprime un tramo del documento y en vez del texto te vuelve 'Output too large (61.2KB). Full output saved to: ...'. Lo abris con la herramienta de leer, funciona, y repetis el ciclo en el tramo siguiente sin darte cuenta de que cada tramo esta costando dos llamadas en vez de una.

**Costo:** cinco viajes de ida y vuelta en una sola sesion de lectura  ·  general  ·  2026-08-17

### El costo en tokens no se estima por caracteres sobre cuatro

**Regla:** Texto que vas a leer VOS: medi la razon real chars/token en el primer tramo chico y dimensiona el resto con esa. El texto cortado en lineas cuesta ~2,3 chars/token contra ~3,5 de prosa corrida, asi que reflowealo ANTES de medir. Y cada herramienta de lectura tiene su propio tope, distinto del tope del stdout del shell.

**Sintoma:** escribi un tramo del tamano que habia calculado a mano y la herramienta de leer lo rechazo por el DOBLE de tokens de los estimados; parecia que el archivo se habia generado mal

**Costo:** dos viajes de mas y un tramo reextraido y partido en dos  ·  perfil  ·  2026-08-17

## Como se trabaja

### Observar antes que intervenir

**Regla:** cuando dos metodos responden la misma pregunta, elegi el que NO modifica el sistema observado. La intervencion se reserva para cuando la observacion ya no alcanza

**Sintoma:** para identificar una direccion se empezo escribiendole valores de prueba

**Costo:** un emulador crasheado antes de darse cuenta  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#2`

### Reformula la pregunta antes de resolver la dificil

**Regla:** si un paso parece requerir una capacidad que no tenes, escribi la pregunta un nivel mas arriba de abstraccion y fijate si se disuelve

**Sintoma:** se estaba resolviendo 'como pongo un breakpoint' cuando la pregunta real era otra

**Costo:** el tiempo de perseguir una capacidad que no hacia falta  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#3`

### Sondear es secuencial; paralelizar antes de sondear es tirar plata

**Regla:** antes de paralelizar contesta dos preguntas: esto ya lo se? el paso 2 depende del resultado del paso 1? Si alguna es si, es secuencial. Sondeo barato primero, paralelismo solo si queda superficie ancha e independiente

**Sintoma:** se lanzaron 10 agentes a investigar en paralelo lo que ya estaba contestado en la conversacion

**Costo:** ~500k tokens la primera vez, ~100k la reincidencia dos sesiones despues  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#9`

### Una regla que depende de recordarla no es una regla: es una intencion

**Regla:** cuando una leccion se repite no la reescribas mas fuerte: convertila en mecanismo. Escala: skill de consulta < linea en CLAUDE.md < hook < permiso denegado. Y antes de agregar un freno, revisa si ya existe uno desactivado

**Sintoma:** 'ya lo tenemos documentado' y el error vuelve a pasar exactamente bajo apuro

**Costo:** la leccion 9 estaba escrita, era precisa, y se violo dos sesiones seguidas  ·  perfil  ·  2026-08-17  ·  ver `lecciones-aprendidas#11`

### El presupuesto del plan gana sobre la instruccion de exhaustividad

**Regla:** con el contexto ya cargado en el hilo principal, hacerlo inline es mas barato Y mas certero que doce agentes arrancando en frio. Y asegurar el resultado en el repo pasa al frente de seguir investigando

**Sintoma:** ultracode pedia orquestacion multiagente y el usuario estaba al 83% del limite de 5 horas

**Costo:** se evito: se cancelo un fan-out de 12 agentes al 83% del limite  ·  black  ·  2026-08-17

### Un mecanismo de captura que vive en un proyecto captura un solo proyecto

**Regla:** una leccion de proceso es, por definicion, la que va a volver a pasar en OTRO proyecto: no puede guardarse adentro de uno. El instrumental que implementa una regla global vive donde vive la regla, y su fuente de verdad es el repo, no ~/.claude

**Sintoma:** aprender.py funcionaba perfecto y el registro tenia 5 lecciones, todas del mismo proyecto, mientras la skill global se editaba a mano

**Costo:** todo lo aprendido fuera de BLACK desde que existe la herramienta: cero entradas  ·  perfil  ·  2026-08-17  ·  ver `lecciones-aprendidas#25`

### Antes de adoptar un metodo de afuera, audita cual parte ya corre

**Regla:** audita item por item contra lo que YA corre y clasifica cada uno: ya esta / esta pero roto / es nuevo / no aplica y por que. Adoptar lo que ya tenias duplica mecanismos y el duplicado se paga en cada respuesta; descartar sin auditar tira lo unico que era nuevo

**Sintoma:** un documento externo bien escrito propone una arquitectura completa y suena toda nueva

**Costo:** se evito: 4 de 5 ideas centrales ya estaban implementadas y una habria duplicado el cuadro de fase en cada respuesta  ·  perfil  ·  2026-08-17  ·  ver `lecciones-aprendidas#26`

## La maquina

### El repo es la memoria del proyecto, no la de la maquina

**Regla:** el estado del entorno se MIDE, no se lee. Un documento no puede enterarse de que aparecio una carpeta nueva. Hace falta una categoria explicita para 'bajado pero sin incorporar', y cuando un documento diga que algo falta, verificalo antes de repetirlo

**Sintoma:** el runbook decia 'no se instalo' y cada sesion lo leia, lo repetia y seguia de largo

**Costo:** varias sesiones sin dos herramientas que ya estaban bajadas y pagadas  ·  black  ·  2026-08-17  ·  ver `lecciones-aprendidas#19`

### El tool Bash es Git Bash: no correr powershell -Command con $env: adentro

**Regla:** Para correr PowerShell con sintaxis $env: o $variable, usar el tool PowerShell dedicado, nunca el tool Bash envolviendo 'powershell -Command "..."' -- el tool Bash es Git Bash (POSIX sh), y parsea el string antes de pasarlo

**Sintoma:** Copy-Item $env:USERPROFILE\... via el tool Bash tira 'no se encuentra la ruta :USERPROFILE\...' -- el shell POSIX del tool Bash expande $env como variable bash vacia ANTES de que powershell -Command reciba el string

**Costo:** un llamado perdido  ·  perfil  ·  2026-08-17

---

Total: 36 lecciones, 0 exitos auditados.
