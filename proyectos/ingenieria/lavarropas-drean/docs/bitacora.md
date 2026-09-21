# Bitácora — lavarropas-drean

## 2026-09-21 — apertura del proyecto, fase 0

**Qué se hizo.** Se identificó el equipo por las etiquetas fotografiadas, se
leyó la evidencia de las fotos del interior, se ordenaron las causas candidatas
del ruido y se escribió la guía de diagnóstico y reparación.

**Cómo se ordenaron las causas.** El dato que más discrimina no es el timbre
del ruido sino **su evolución**: creció de a poco durante meses. Eso separa de
entrada dos familias enteras —lo que aparece de golpe (objeto atrapado, pieza
suelta) queda abajo, y lo que se desgasta queda arriba— antes de haber tocado
nada. Por eso la tabla de lectura de la guía cruza *cómo suena* con *cuándo
apareció*, y no sólo lo primero.

**Lo que no se pudo confirmar, y por qué se dejó explícito.** Las medidas de
rodamiento del **Next 6.06** no se consiguieron de fuente: existe el kit
publicado para "Next 6.06 / 6.08 / 6.09" pero la tienda no resuelve por DNS, y
yoreparo devuelve 403. Lo que sí se leyó (6203 + 6204 + retén 25×47×8/11,5) es
de la línea **Blue / Excellent 6.06**. Se dejó escrito con esa advertencia en
vez de presentarlo como del Next, y la guía manda leer el número grabado en el
aro antes de comprar.

Eso además resultó ser **mejor consejo, no una limitación**: llevar el rulemán
viejo a una casa de rulemanes sale menos que el kit armado, porque un 6203-2RS
y un 6204-2RS son rodamientos estándar. La restricción de evidencia empujó
hacia el procedimiento más barato — que es el patrón habitual y conviene
recordarlo.

**Decisión de formato.** La guía va en Markdown, no en PDF. Se lee en el
celular al lado de la máquina; compilar un PDF agrega un paso y no cambia el
uso. Si más adelante quieren imprimirla, ahí se compila.

## 2026-09-21 (tarde) — dos datos medidos, y una divergencia que duró una hora

**Lo que midió Fran, y lo que cambió.**

- **T4 negativo: el motor gira bien.** Primera causa descartada por evidencia, y
  la primera mitad del criterio de salida de la fase 1.
- **No hay hueco allen en la punta del eje.** La fijación de la polea es una
  *tuerca* sobre rosca macho. La guía decía "tornillo allen" — salió de la foto
  del sellador verde, que es compatible con las dos cosas, y se escribió la
  interpretación como si fuera el dato.
- **Corregido también un error de orden**, que se descubrió por la pregunta
  «¿dónde está el retén?»: la guía decía que al sacar la polea queda a la vista
  el retén. No: queda a la vista el rulemán exterior. El retén es la última
  pieza del lado del agua y no se alcanza sin abrir el bidón. El paso del eje
  pasó de D a F, después de sacar el tambor, que es cuando de verdad se puede
  mirar.

**La divergencia, que es la lección del día.** Al compilar el PDF quedaron dos
copias del mismo procedimiento —`guia-reparacion.md` y `guia.typ`— y las
correcciones de arriba entraron **sólo en el PDF**. El markdown siguió diciendo
"tornillo allen" y "con la polea afuera queda a la vista el retén" durante el
mismo turno en que se corregía el otro. El sistema ya tiene la regla escrita
("un dato que vive en dos lados diverge") y aun así se creó la segunda copia sin
notarlo, porque cambiar de formato no se siente como duplicar.

Arreglado dejando *una* fuente: `guia.typ` y su PDF. El `.md` quedó como archivo
de fuentes y punteros, que es información que el PDF no lleva a propósito.

## 2026-09-21 — apertura del proyecto, fase 0 (continuación)

**Lo que quedó explícitamente sin resolver.** Si el bidón de este modelo se
abre o viene soldado por ultrasonido. Es el dato que más mueve el presupuesto
(de ~$20.000 a bidón completo), y se contesta mirando el perímetro del bidón
durante 30 segundos. Buscarlo por web hubiera costado varias consultas más para
un dato que la máquina, que está abierta, contesta gratis. **Medir donde está
el objeto le gana a leer sobre el objeto** — y acá el objeto estaba a mano.
