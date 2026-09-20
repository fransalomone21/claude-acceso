#import "../plantilla.typ": *

#modulo(
  "La necesidad de la Ingeniería de Sistemas, en dos ejemplos",
  [Explicar con el margen extra del Saturno V y la falla del espejo del
   Hubble por qué hace falta ingeniería de sistemas incluso cuando cada
   disciplina individual trabaja bien; y distinguir el nivel del ingeniero
   especialista del nivel del ingeniero de sistemas.],
  clave: "necesidad-de-la-is",
)

#lectura[
  Clase 4, diapositivas 2 a 19.
]

== Saturno V: el margen que hizo posible el Apollo

Los diseños originales de la primera y segunda etapa del Saturno V cumplían
*todos* los requerimientos con cuatro motores. El equipo de Von Braun, en el
Marshall Space Flight Center, agregó un *quinto motor* a cada una de esas dos
etapas para tener más margen #diapo(4, 6).

#clave[
  La misión Apollo *no hubiera sido posible* sin ese margen de desempeño
  extra: los módulos de comando/servicio y el módulo lunar crecieron de masa
  en cada misión sucesiva, y ese quinto motor —que en el papel *no hacía
  falta*— fue lo que absorbió ese crecimiento. El margen adicional también
  permitió más contenido científico en las misiones posteriores de Apollo
  #diapo(4, 6).
]

#posta[
  Este es el primer argumento del módulo, y vale tenerlo como ancla: pensar
  el sistema en su *ciclo de vida completo* —no sólo el requerimiento del día
  uno— es lo que hace que un margen "innecesario" termine siendo la
  diferencia entre una misión posible y una imposible. Los márgenes se
  desarrollan a fondo en la unidad 5.
]

== El espejo del Hubble: cuando cada parte funciona y el sistema falla

#deduccion("qué salió mal, paso a paso")[
  Poco después de lanzado, el Hubble mostraba imágenes distorsionadas. Las
  pruebas confirmaron que el espejo primario tenía una *aberración esférica*:
  el error de manufactura era *diez veces mayor* que lo que especificaba el
  contrato #diapo(4, 12).

  El espejo lo fabricó Perkin-Elmer. La investigación encontró que el
  *Reflective Null Corrector* (RNC) —el conjunto óptico que se usa para
  *medir* el espejo primario mientras se pule— estaba mal construido: el
  espaciado entre sus dos espejos y su lente estaba fuera de especificación,
  y eso desvió todo el pulido del espejo primario #diapo(4, 12).

  El defecto clave: Perkin-Elmer *nunca verificó las dimensiones del RNC en
  sí*. Confiaron en un solo instrumento de medición para certificar la
  precisión del espejo — un *punto único de falla*. Hubo señales del
  problema durante la manufactura y se ignoraron #diapo(4, 13).
]

#cuidado[
  El costo: unos *US\$ 20 millones* para reparar la aberración esférica —el
  espejo no estaba diseñado para reemplazarse, así que la solución (la
  misión COSTAR) fue el equivalente óptico de un anteojo correctivo: espejos
  de relevo en brazos móviles que corrigen la luz antes de que llegue al
  espejo primario #diapo(4, 13). La causa raíz que señala el propio informe
  de la NASA: *el proyecto falló en dos puntos de gestión, calidad y
  comunicación* — no en óptica.
]

#posta[
  El caso Hubble es el argumento más nítido del módulo: *cada disciplina
  individual —óptica, manufactura— puede estar trabajando con excelencia
  técnica, y el sistema fallar igual*, si nadie verifica el instrumento que
  verifica, o si una señal de alarma no se comunica a quien puede actuarla.
  Ésa es, literalmente, la razón de ser de la ingeniería de sistemas.
]

== El nivel del especialista, y por qué no alcanza solo

No todos los ingenieros de un proyecto trabajan al nivel del sistema
completo. Hay ingenieros muy específicos, en equipos chicos, que dominan una
disciplina y mejoran su producto a partir de su propia experiencia
#diapo(4, 14):

- Cómo construir el aislamiento térmico multicapa (*MLI*) del exterior de un
  vehículo — externo e interno, para formas complejas como tuberías, tanques
  y válvulas, con mantas de hasta 3 m² #diapo(4, 15).
- El diseño de las baterías de un _spacecraft_ — un grupo de ingenieros
  dedicado sólo a eso.
- La protección térmica de los tanques de propulsión, para evitar que la
  hidracina se congele — una tarea tan delicada que cargarla exige ropa de
  protección especial #diapo(4, 17) #diapo(4, 18).

#clave[
  Estos especialistas son *indispensables* — nadie reemplaza su
  conocimiento de dominio. Lo que hace falta *además* de ellos es alguien que
  vea cómo el aislamiento térmico, las baterías y la protección de tanques
  *interactúan* entre sí y con el resto del sistema — que es exactamente el
  #t[pensamiento holístico] de la unidad 2, ahora aplicado a un caso real. Un
  sistema hecho de partes excelentes por separado no está garantizado: eso
  es, otra vez, el argumento del Hubble.
]

Pero cuando un sistema como éste queda emparentado con uno *mayor y cada vez
más complejo* —una estación espacial completa, por ejemplo— el problema deja
de ser sólo de coordinación entre subsistemas de un mismo vehículo: se
convierte en el tema del módulo siguiente #diapo(4, 19).
