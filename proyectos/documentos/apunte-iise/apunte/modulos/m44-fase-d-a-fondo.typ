#import "../plantilla.typ": *

#modulo(
  "Fase D a fondo: integrar, ensayar y lanzar",
  [Decir qué hace la Fase D y qué revisiones la cruzan; recorrer la
   integración de un satélite real (el GPM) y la del instrumento del JWST;
   leer críticamente la especificación de un componente comprado (el tanque
   que se desintegra al reingresar); explicar qué evalúan la ORR y la FRR y
   qué es un _waiver_.],
  clave: "fase-d-a-fondo",
)

#lectura[
  Clase 12, diapositivas 1 a 24.
]

== La última fase de la construcción

#definicion("Fase D (ensamble, integración, ensayos y lanzamiento)")[
  La fase que ensambla el sistema, lo integra, lo ensaya y lo lanza
  #diapo(12, 4). Los componentes ya verificados se juntan, se interfacean y
  se interconectan siguiendo lo planificado en el plan AIT/AIV, para formar
  un sistema integrado; al final de la fase, el sistema integrado está
  verificado, validado y puesto en operación. Su propósito: construir los
  subsistemas —incluidos los de operación— e integrarlos para crear el
  sistema, *mientras se desarrolla confianza* en que se van a cumplir los
  requerimientos de sistema #diapo(12, 20).
]

En el ciclo de vida de NASA #diapo(12, 3), la Fase D es la tercera de la
Implementación, entre el KDP-D y el KDP-E. La empieza la SIR —la última
revisión de la Fase C, módulo #M("fase-c-a-fondo")— y la cruzan la TRR, la
ORR y la FRR, hasta el lanzamiento. Después vienen la PLAR y la CERR, ya en
operación.

#cuidado[
  El glosario de la misma lámina tiene dos errores #diapo(12, 3): define la
  TRR como «_Tech. Readiness Review_» y la PLAR como otra «_Operational
  Readiness Review_». En el manual de NASA la TRR es la _Test Readiness
  Review_ (alistamiento para los ensayos) y la PLAR, la _Post-Launch
  Assessment Review_ (la evaluación posterior al lanzamiento). Esos dos
  nombres son del manual, no de la lámina; si cae en un parcial, conviene
  decir de dónde sale cada uno.
]

Las actividades, en detalle #diapo(12, 5):

- integrar los componentes en bloques, hasta el sistema completo,
  verificando las conectividades;
- la V&V de las capacidades, los desempeños y las interfaces del sistema
  contra los requerimientos;
- los #t[ensayos ambientales] que simulan el lanzamiento (vibraciones,
  acústica) y el espacio (vacío térmico, en frío y calor extremos), con las
  funciones y ciertos desempeños verificados adentro;
- completar los planes y procedimientos de la puesta en marcha y las
  operaciones;
- entrenar al personal de operaciones para todos los eventos de la vida en
  el espacio;
- verificar *todas las interfaces externas* —el sitio de lanzamiento, las
  antenas de tierra—, ensayadas y listas para operar #diapo(12, 6).

Y después: integrar el sistema al lanzador, lanzarlo, ponerlo en órbita, y
en la puesta en marcha establecer una *línea de base operacional* que
verifique que el sistema cumple sus requerimientos de alto nivel y los
interesados, sus objetivos #diapo(12, 7). La lámina lo dice con una idea
que conviene guardar: lo ensayamos en tierra y *pensamos* que va a operar
en el espacio como necesitan los interesados; vamos hacia una verificación
y validación *en órbita* #diapo(12, 4).

== El GPM: cuando los elementos convergen

#figure(
  placement: auto,
  image("../figuras/c12-p008.png", width: 80%),
  caption: [El observatorio central de la misión de medición global de la precipitación (GPM): paneles solares, antena de alta ganancia, módulo de propulsión y ruedas de reacción, el radiómetro de microondas (GMI) y el radar de precipitación de doble frecuencia (DPR), en banda Ka (35,5 GHz) y Ku (13,6 GHz) #diapo(12, 8).],
)

El ejemplo de la clase es la misión GPM, con un radar muy especial hecho
por la agencia espacial japonesa, JAXA, que se integra en esta fase
#diapo(12, 7). La lámina lo cuenta como *uno de los momentos más
emocionantes del proyecto*: se trabaja años para llegar al AIT, y ahí los
elementos convergen. Lo que se busca es que se cumplan todas las
conectividades: mecánicas, eléctricas, térmicas, de cableado (_harness_),
de tierras #diapo(12, 7). Las fotos de la integración del GPM
#diapo(12, 14) #diapo(12, 15) #diapo(12, 16) muestran la escala: un
satélite entero en una sala limpia, rodeado de gente con mamelucos.

#posta[
  Un radar de JAXA en un satélite de NASA es una interfaz entre dos
  organizaciones, y en la Fase D se ve si el documento de control de
  interfaces de la Fase B estaba bien: el conector entra o no entra. Es el
  ICD del módulo #M("familia-de-requerimientos-e-interfaces") a escala
  real, con la diferencia de que acá un error ya no se arregla con una
  revisión de papel.
]

== Leer la especificación de lo que se compra: el tanque que se desintegra

El GPM llevó el *primer tanque de combustible diseñado para desintegrarse
al reingresar*, para mejorar la eficiencia de la misión y mitigar la basura
espacial: un recipiente de presión de compuesto de fibra de carbono (CFRP)
con un revestimiento interno de aluminio #diapo(12, 10). El revestimiento
es lo bastante delgado para desintegrarse en el reingreso, el conjunto lo
bastante liviano para cumplir las restricciones de peso y lo bastante
rígido para sobrevivir al lanzamiento; y cuando el programa cambió tarde,
el compuesto permitió rehacer el bobinado en vez de rehacer las
herramientas de una construcción de aluminio o titanio #diapo(12, 13).

#figure(
  table(
    columns: (1.4fr, 2fr),
    align: (left, left),
    stroke: 0.4pt + luma(180),
    inset: 4.5pt,
    [Medio], [hidracina],
    [Presión de carga], [400 psi (27,5 bar)],
    [Volumen de agua], [772 L],
    [Diámetro (en la interfaz)], [1180 mm],
    [Longitud], [1176 mm],
    [Masa], [45,1 kg como máximo],
    [Temperatura de operación], [de 2 °C a 50 °C],
    [Además], [revestimiento de aluminio con compuesto de carbono; dispositivo de manejo de propelente por tensión superficial; faldón de compuesto integral; diseñado y calificado según AIAA S-081A; interfaz con insertos de acero inoxidable],
  ),
  caption: [La especificación del tanque, tal como la publica el proveedor #diapo(12, 11).],
)

#deduccion("lo que le falta a una especificación, visto desde tus requerimientos")[
  La lámina hace la pregunta y la contesta #diapo(12, 11): *¿qué falta en
  estas especificaciones? Las cargas mecánicas que soporta.* Y agrega otra:
  *¿es un componente calificado? Verificar los niveles de calificación.*
  Las dos salen de lo que ya vimos. Una hoja de datos es una
  #t[especificación]: dice cómo está hecho el tanque, no si cumple *tus*
  requerimientos (módulo #M("subsistemas-drivers-y-presupuestos")). Para
  saberlo, cada requerimiento tuyo —las cargas del lanzador, por ejemplo—
  tiene que encontrar su número en la hoja; el que no lo encuentra es una
  pregunta al proveedor. Y que diga «calificado según AIAA S-081A» no
  alcanza: hay que verificar que los niveles de esa #t[calificación] cubran
  los de *tu* lanzamiento (módulo #M("modelos-y-ensayos")).
]

#clave[
  El tanque es también un ejemplo de algo que el trabajo práctico pide en
  LEO: pensar el *fin de vida* desde el diseño. Que el tanque se
  desintegre al reingresar es una decisión de mitigación de basura
  espacial tomada en el material, no en las operaciones.
]

== Integrar también la tierra: la ORR

La integración no es sólo el satélite: también los componentes de tierra
—cómo se manejan los datos científicos, cómo se opera el instrumento y la
plataforma, los procedimientos de los operadores—, y todo eso se ensaya en
tierra antes del lanzamiento #diapo(12, 17).

#definicion("ORR — Revisión de Alistamiento Operativo")[
  La primera de las dos revisiones técnicas del final de la Fase D: el
  equipo de revisión evalúa cuán maduro está el sistema, incluidos los
  elementos que hacen posible operarlo, y si está listo para operar
  #diapo(12, 17). Revisa que las lecciones aprendidas del desarrollo estén
  capturadas y pasadas al equipo de operaciones, con las restricciones de
  operación; que los _waivers_ estén abordados y aprobados y las anomalías
  documentadas; que el equipo, el _hardware_, el _software_, el personal y
  los procedimientos estén en su lugar; y que las acciones de la SIR estén
  cerradas #diapo(12, 18).
]

#definicion("waiver (licencia o dispensa)")[
  La aprobación formal para seguir adelante con un requerimiento que no se
  pudo verificar en la integración, cuando el análisis confirma que la
  misión puede continuar. Puede dejar restricciones documentadas para que
  los operadores las tengan en cuenta #diapo(12, 18).
]

#ejemplo("los propulsores que dan el 95 %", nivel: "a-fondo")[
  En los ensayos de integración, los propulsores no cumplieron con su
  desempeño. ¿Qué se hace? La lámina contesta que, en la mayoría de los
  casos, se puede vivir con eso: dan el 95 % del requerido; los análisis
  tienen que confirmar que la misión puede seguir, y entonces se firma el
  _waiver_ para continuar, con las restricciones que haga falta para que
  los operadores las tengan en cuenta #diapo(12, 18).
]

#posta[
  Un _waiver_ no es «aprobar igual»: es dejar escrito que un requerimiento
  no se cumplió, por qué se acepta y qué cambia en la operación. Es el
  margen de la unidad 5 usado de verdad: si el requerimiento tenía margen,
  el 95 % entra; si no lo tenía, el que paga es el operador, que hereda la
  restricción.
]

== La FRR: el Go / No Go

#definicion("FRR — Revisión de Alistamiento para el Vuelo")[
  La segunda revisión técnica, muy cerca del lanzamiento: evalúa si el
  _spacecraft_ está listo para el vuelo, si todo el _hardware_ y el
  _software_ pasaron la V&V, si las restricciones operacionales están
  identificadas —«sabemos de los problemas que tiene el satélite»— y si
  todas las interfaces externas están verificadas. *Da el Go / No Go para
  el lanzamiento* #diapo(12, 19). Establece que lo que se construyó es lo
  del _baseline_ #diapo(12, 20).
]

Sus criterios de entrada y de éxito los da la clase 13, y están en el
módulo #M("riesgo-frr-y-fase-e").

== El JWST: ensayar como se vuela

El cierre de la clase es el telescopio James Webb #diapo(12, 21)
#diapo(12, 22) #diapo(12, 23) #diapo(12, 24): el telescopio ensamblado en la
sala limpia de Goddard, la secuencia de AIT de un instrumento (de montar el
GSE en la sala limpia a entregar el telescopio para integrar los
instrumentos, pasando por barridos de vibración, vibración y acústica
protoflight y metrología antes y después de cada ambiental), y el flujo de
integración del módulo criogénico con sus hitos de revisión, la *PER*
(revisión previa a los ensayos ambientales) y la *PSR* (revisión previa al
envío).

#figure(
  placement: auto,
  image("../figuras/c12-p024.png", width: 62%),
  caption: [La cámara A del Johnson Space Center recibe el conjunto óptico del JWST. Con su envolvente enfriada por helio, da el ambiente para la verificación térmica sin la plataforma del satélite: «_test as you fly_» #diapo(12, 24).],
)

#deduccion("por qué «ensayar como se vuela»")[
  _Test as you fly_ es la #t[validación del sistema] llevada al ensayo: no
  alcanza con verificar cada requerimiento por separado; hay que poner el
  sistema en un ambiente lo más parecido posible al de la misión y ver qué
  hace. Para un telescopio que trabaja a temperaturas criogénicas, eso
  exige una cámara enfriada con helio del tamaño de un edificio. El costo de
  esa cámara es el costo de no tener una segunda oportunidad en órbita.
]
