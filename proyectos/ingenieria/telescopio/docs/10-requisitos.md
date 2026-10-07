# Requisitos — borrador de la fase 0

**Versión 0.1, 7 de octubre de 2026.** Estado: **borrador** (NASA Pre-Fase A,
*draft system-level requirements*). No está en línea base: eso pasa en la
revisión de requisitos (SRR) que cierra la fase 1, con Fran como interesado y
con los TBR resueltos.

Escrito con los libros abiertos: `perfil-global/pilares/nucleo-ise.md` §4, el
INCOSE GtWR (`incose-gtwr/reglas.md`), la cátedra de IISE (m17 y m21) y NASA
(`nasa-seh/requisitos.md` §5-14). Se certifica con
`python docs/verificar-requisitos.py`, que corre el chequeo del GtWR sobre
cada enunciado y controla la trazabilidad (cada hijo con un padre que existe,
del nivel de arriba).

## 0. En criollo

Esto es **el papel que define el proyecto**. El modelo 3D, los dibujos y los
planos que vengan son *salidas* del diseño: se comparan contra esta lista,
nunca al revés. Se lee de arriba para abajo: lo que **Fran necesita** (N), lo
que la **misión** tiene que lograr (L0), lo que el **sistema** entero tiene que
hacer y cuán bien (L1), y lo que le toca a cada **parte** (L2): la plataforma
(PLT), la montura (MON), el tren de imagen (CAM) y la operación (OPE).

Cada requisito dice cómo se va a comprobar y si su número ya está firme
(**definido**), es una estimación con su porqué (**TBR**) o falta del todo
(**TBD**). La columna **3D** dice si el modelo v9 ya lo muestra.

Lo que falta para que esta lista sea la definitiva está en §11, y lo que sólo
Fran puede decidir, en §11.1.

## 1. Cómo está escrito

- **Forma:** `Cuando <condición>, el <sujeto> deberá <verbo> <objeto> <calificador>.`
  Un solo «deberá» por oración, voz activa, el sujeto es la parte del nivel.
  **deberá** = obligatorio; **debería** = meta (§8), no se exige.
- **Identificadores:** `N-01` necesidad, `L0-01` misión, `L1-01` sistema,
  `L2-PLT-01` elemento. Cada commit de diseño cita los que cumple.
- **Tipos** (cátedra, seis): funcional · desempeño · restricción · interfaz ·
  ambiental · otros (seguridad, factor humano, reversibilidad).
- **Verificación** (se decide al escribirlo): ensayo · análisis · inspección ·
  demostración.
- **Estado:** definido · TBR · TBD. La marca va en su columna, **nunca en el
  enunciado** (un paréntesis en el enunciado viola R21 del GtWR).
- **Padre:** el requisito del nivel de arriba del que sale. **Asignado** = el
  número del padre se reparte; **derivado** = lo hace aparecer una decisión de
  arquitectura o de diseño (lo dice el rationale, §7).
- **KDR** (*key driving requirements*, NASA: los que más mueven costo o
  calendario): **L1-01, L1-02, L1-15, L1-22**.

## 2. Glosario

Cada término se usa siempre igual (GtWR R4, R36).

| Término | Qué es |
|---|---|
| sistema | el telescopio newtoniano de 200 mm de apertura y 1200 mm de focal, la montura dobson, la plataforma, el tren de imagen y el procedimiento de operación, juntos |
| plataforma | la plataforma ecuatorial VNS: base, mesa, pivote, chapas, rodillos, transmisión, electrónica y programa |
| mesa | la parte de la plataforma que gira con el dobson encima |
| carga giratoria | todo lo que gira: el dobson con el tubo, el tren de imagen y la mesa |
| carrera | el giro de la mesa entre un extremo y el otro; el **centro de la carrera** es la mesa horizontal |
| minutos de giro | el ángulo de la mesa expresado en tiempo sidéreo: 1 min de giro = 15 segundos de arco |
| eje polar | el eje de giro de la plataforma; puesto en estación, paralelo al eje de la Tierra |
| puesta en estación | nivelar la plataforma y alinear el eje polar con el polo celeste sur |
| sub | cada foto individual de la serie que después se apila |
| corrimiento | cuánto se mueve la imagen de una estrella sobre el sensor durante un sub, en segundos de arco |
| redondez | el cociente entre el ancho menor y el ancho mayor de la imagen de una estrella; 1 es un punto perfecto |
| tren de imagen | la cámara o el celular, con su soporte, en el portaocular |
| objeto de cielo profundo | una nebulosa o una galaxia |
| montura | la montura dobson de madera existente, con su caja |

## 3. Necesidades (N) — en el idioma de Fran

Todavía no son verificables tal como están escritas: para eso están los
niveles de abajo.

| ID | Necesidad | Fuente |
|---|---|---|
| N-01 | Fran necesita una foto propia y apilada de una nebulosa o una galaxia, tomada con el telescopio de 200 mm, donde el objeto se reconozca y las estrellas se vean como puntos. | PDP §1 (la meta, criterio de validación) |
| N-02 | Fran necesita seguir apuntando el telescopio a mano, como hoy. | PDP §2: no es un GoTo |
| N-03 | Fran necesita poner la plataforma en el patio y hacerla andar sin renegar con calibraciones. | trade study, criterio 1, peso 0,4 (Fran, 2026-10-04) |
| N-04 | Fran necesita que la plataforma se construya con las herramientas de la casa y con lo que se pueda encargar afuera, sin una complejidad extrema. | trade study, criterio 2, peso 0,3 (Fran, 2026-10-04) |
| N-05 | Fran necesita conservar la única montura dobson de la casa. | PDP §3, aspecto b |
| N-06 | Fran necesita sacar el equipo al patio, armarlo y guardarlo solo, cada noche. | ConOps, pasos 1 y 2 |
| N-07 | Fran necesita que la noche de fotos funcione sin una notebook. | ConOps, lo que la noche prohíbe |
| N-08 | Fran necesita que el sistema siga sirviendo en una noche mala, con subs cortos. | ConOps, el modo degradado |
| N-09 | Fran necesita que el telescopio se mantenga entero con la plataforma siguiendo sola. | límites en tres capas (Fran, 2026-10-04); Kevin, topes |
| N-10 | Fran necesita sacar las fotos con la cámara Sony y, como plan B, con el celular. | PDP §6, soporte intercambiable (Fran, 2026-10-04) |
| N-11 | Fran necesita pasar más adelante a subs de 2 a 4 min con autoguiado, sin rehacer la plataforma. | PDP §6, la meta partida en dos (Fran, 2026-10-04) |

## 4. Misión (L0) — qué tiene que lograr

| ID | Enunciado | Tipo | Padre | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|
| L0-01 | La misión deberá obtener una imagen apilada propia de un objeto de cielo profundo con el telescopio newtoniano de 200 mm de apertura. | funcional | N-01 | inspección | definido | no |
| L0-02 | La misión deberá obtener la imagen apilada con estrellas de redondez de no menos de 0,8 medida sobre la imagen apilada. | desempeño | N-01 | análisis | TBR | no |
| L0-03 | La misión deberá tomar los subs sin autoguiado. | restricción | N-11 | inspección | definido | no |
| L0-04 | La misión deberá apuntar el telescopio a mano. | restricción | N-02 | inspección | definido | no |
| L0-05 | La misión deberá usar la montura dobson existente. | restricción | N-05 | inspección | definido | sí |
| L0-06 | La misión deberá fabricar cada pieza con las herramientas de la casa o con un servicio contratado de corte o de torneado. | restricción | N-04 | inspección | definido | no |
| L0-07 | La misión deberá operarse por una persona sola en el patio de la casa. | otros: factor humano | N-06 | demostración | definido | no |
| L0-08 | La misión deberá operarse sin computadora durante la noche de fotos. | restricción | N-07 | demostración | definido | no |
| L0-09 | La misión deberá conservar la integridad del telescopio durante el seguimiento sin supervisión. | otros: seguridad | N-09 | ensayo | definido | parcial |
| L0-10 | La misión deberá poner el sistema en estación en el patio sin recalibrar la plataforma en cada noche. | desempeño | N-03 | demostración | definido | parcial |
| L0-11 | La misión deberá obtener subs de 10 s con estrellas puntuales en una noche de alineación polar degradada. | desempeño | N-08 | ensayo | TBR | no |
| L0-12 | La misión deberá tomar los subs con la cámara Sony en foco primario. | interfaz | N-10 | demostración | TBR | no |
| L0-13 | La misión deberá tomar subs con el celular en modo afocal. | interfaz | N-10 | demostración | definido | no |
| L0-14 | La misión deberá dejar en la plataforma una entrada para el autoguiador de una etapa posterior. | interfaz | N-11 | inspección | definido | no |

## 5. Sistema (L1) — qué tiene que hacer y cuán bien

La columna **Asignado a** es la traza hacia abajo: qué parte lo cumple.

| ID | Enunciado | Tipo | Padre | Asignado a | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|---|
| L1-01 | Mientras la plataforma sigue el cielo, el sistema deberá mantener el corrimiento de cada estrella en no más de 2 segundos de arco durante cada sub de 30 s. | desempeño | L0-02 | PLT, MON, OPE | ensayo | TBR | no |
| L1-02 | El sistema deberá seguir el cielo durante no menos de 60 min por carrera sin intervención del operador. | desempeño | L0-01 | PLT | ensayo | definido | sí |
| L1-03 | Cuando el operador pulsa el botón de rebobinado, el sistema deberá volver la mesa al comienzo de la carrera en no más de 5 minutos. | funcional | L0-01 | PLT | demostración | TBR | no |
| L1-04 | Cuando la mesa llega al final de la carrera, el sistema deberá detener el giro de la mesa. | otros: seguridad | L0-09 | PLT | ensayo | definido | sí |
| L1-05 | El sistema deberá seguir el cielo con la electrónica de la plataforma como único control. | restricción | L0-08 | PLT | inspección | definido | parcial |
| L1-06 | El sistema deberá operar no menos de 4 horas por noche con la energía de una batería portátil. | desempeño | L0-08 | PLT | ensayo | TBR | no |
| L1-07 | El sistema deberá llevar el tubo en la montura dobson existente. | restricción | L0-05 | MON | inspección | definido | sí |
| L1-08 | Mientras la plataforma sigue el cielo, el sistema deberá permitir el apuntado manual del tubo en altura y en azimut. | funcional | L0-04 | MON | demostración | definido | sí |
| L1-09 | El sistema deberá seguir el cielo a una latitud de 34,5 grados sur con una tolerancia de 1 grado. | ambiental | L0-01 | PLT, OPE | análisis | TBR | sí |
| L1-10 | El sistema deberá operar con una temperatura del aire entre -5 y 35 grados Celsius. | ambiental | L0-01 | PLT, CAM | análisis | TBR | no |
| L1-11 | El sistema deberá operar con una humedad relativa de no más de 95 %. | ambiental | L0-01 | PLT, CAM | inspección | TBR | no |
| L1-12 | El sistema deberá mantener el seguimiento con ráfagas de viento de no más de 40 km/h. | ambiental | L0-09 | PLT | análisis | TBR | no |
| L1-13 | El sistema deberá resistir un empuje lateral de no menos de 59 N en la boca del tubo sin levantar un apoyo de la mesa. | otros: seguridad | L0-09 | PLT | análisis | TBR | sí |
| L1-14 | El sistema deberá tener un ángulo de vuelco de no menos de 22 grados en cada dirección horizontal. | otros: seguridad | L0-09 | PLT | análisis | TBR | sí |
| L1-15 | El sistema deberá ubicar el centro de masa de la carga giratoria a no más de 1 cm del eje polar. | desempeño | L0-02 | PLT, MON | ensayo | TBR | sí |
| L1-16 | Cada pieza del sistema que se transporta por separado deberá pesar no más de 20 kg. | otros: factor humano | L0-07 | PLT | inspección | TBR | parcial |
| L1-17 | El sistema deberá quedar listo para el primer sub en no más de 20 min desde la salida del depósito. | otros: factor humano | L0-10 | OPE | demostración | TBR | no |
| L1-18 | El sistema deberá quedar en estación sobre un piso con un desnivel de no más de 3 cm entre apoyos. | desempeño | L0-10 | PLT | demostración | TBR | sí |
| L1-19 | El sistema deberá acumular no menos de 30 min de exposición por objeto en una noche. | desempeño | L0-01 | PLT, OPE | demostración | TBR | no |
| L1-20 | El sistema deberá mantener la base del dobson fija a la mesa en cada posición de la carrera. | otros: seguridad | L0-09 | PLT | ensayo | definido | parcial |
| L1-21 | El sistema deberá recibir la montura del dobson con una elevación de no más de 30 cm desde el piso. | otros: factor humano | L0-07 | PLT | inspección | TBR | sí |
| L1-22 | El sistema deberá formar la imagen del telescopio en foco sobre el sensor de la cámara Sony en foco primario. | funcional | L0-12 | CAM | ensayo | TBD | no |
| L1-23 | El sistema deberá formar la imagen en foco sobre el celular detrás del ocular de 25 mm. | funcional | L0-13 | CAM | ensayo | definido | no |
| L1-24 | Cuando el operador cambia el ocular por el tren de imagen, el sistema deberá mantener el apuntado del tubo. | funcional | L0-02 | MON, CAM | demostración | definido | no |
| L1-25 | El sistema deberá aceptar correcciones de seguimiento de un autoguiador externo. | interfaz | L0-14 | PLT | demostración | definido | no |
| L1-26 | Con un error de alineación polar de no más de 30 minutos de arco, el sistema deberá mantener el corrimiento de cada estrella en no más de 2 segundos de arco durante cada sub de 10 s. | desempeño | L0-11 | PLT, OPE | análisis | TBR | no |

## 6. Elementos (L2)

### 6.1 Plataforma (PLT)

| ID | Enunciado | Tipo | Padre | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|
| L2-PLT-01 | La plataforma deberá girar la mesa sobre un eje paralelo al eje polar terrestre. | funcional | L1-01 | análisis | definido | sí |
| L2-PLT-02 | La plataforma deberá mantener el corrimiento de la imagen causado por la plataforma en no más de 1,5 segundos de arco en cada intervalo de 30 s. | desempeño | L1-01 | ensayo | TBR | no |
| L2-PLT-03 | La plataforma deberá girar la mesa a la velocidad sidérea con un error medio de no más de 0,2 % medido sobre 10 minutos. | desempeño | L1-01 | ensayo | TBR | parcial |
| L2-PLT-04 | La plataforma deberá apoyar en el piso en tres puntos regulables en altura con un recorrido de no menos de 3 cm. | restricción | L1-18 | inspección | definido | sí |
| L2-PLT-05 | La plataforma deberá ajustar la altura del eje polar respecto del centro de masa de la carga giratoria en un rango de no menos de 12 cm sin cortar piezas. | desempeño | L1-15 | demostración | TBR | parcial |
| L2-PLT-06 | Cuando la mesa alcanza 45 min de giro desde el centro de la carrera, el programa de la plataforma deberá detener el motor. | otros: seguridad | L1-04 | ensayo | definido | sí |
| L2-PLT-07 | Cuando la mesa alcanza 48 min de giro desde el centro de la carrera, el fin de carrera deberá cortar el movimiento del motor con independencia del programa. | otros: seguridad | L1-04 | ensayo | definido | sí |
| L2-PLT-08 | La plataforma deberá detener la mesa con un tope mecánico a 51 min de giro desde el centro de la carrera. | otros: seguridad | L1-04 | ensayo | definido | sí |
| L2-PLT-09 | Cuando se corta el cable de un fin de carrera, la plataforma deberá detener el motor. | otros: seguridad | L1-04 | ensayo | definido | no |
| L2-PLT-10 | La plataforma deberá entregar en la mesa un par de giro de no menos de 2 veces el par de una ráfaga de 40 km/h sobre el tubo. | desempeño | L1-12 | análisis | TBR | no |
| L2-PLT-11 | La plataforma deberá aceptar órdenes de corrección de velocidad por una entrada de autoguiado ST-4. | interfaz | L1-25 | demostración | TBR | no |
| L2-PLT-12 | La plataforma deberá fijar la base del dobson a la mesa en 3 puntos con uniones de ajuste a mano. | interfaz | L1-20 | inspección | definido | no |
| L2-PLT-13 | La plataforma desarmada deberá dar piezas de no más de 125 cm de largo. | otros: factor humano | L1-16 | inspección | TBD | parcial |

### 6.2 Montura (MON)

| ID | Enunciado | Tipo | Padre | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|
| L2-MON-01 | La montura deberá mantener el desplazamiento angular del tubo en no más de 0,5 segundos de arco durante cada sub de 30 s con la mesa en movimiento. | desempeño | L1-01 | análisis | TBR | no |
| L2-MON-02 | Con la mesa inclinada 11 grados, la montura deberá retener el tubo en altura con el freno de altura ajustado. | funcional | L1-01 | demostración | definido | no |
| L2-MON-03 | Con la mesa inclinada 11 grados, la montura deberá retener el tubo en azimut con el freno de azimut ajustado. | funcional | L1-01 | demostración | definido | no |
| L2-MON-04 | La montura deberá mantener la separación de las paredes en el eje de altura con una variación de no más de 0,5 mm al ajustar el freno de altura. | desempeño | L1-01 | ensayo | TBR | no |
| L2-MON-05 | Cada modificación de la montura deberá desmontarse con herramientas de mano. | otros: reversibilidad | L1-07 | inspección | definido | no |
| L2-MON-06 | Con el tren de imagen montado, la montura deberá sostener el tubo en cada altura entre 15 y 90 grados con el freno de altura suelto. | funcional | L1-24 | demostración | TBR | no |

### 6.3 Tren de imagen (CAM)

| ID | Enunciado | Tipo | Padre | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|
| L2-CAM-01 | El soporte de cámara deberá montar la cámara Sony en foco primario sobre el portaocular de 1,25 pulgadas. | interfaz | L1-22 | inspección | TBR | no |
| L2-CAM-02 | El soporte de cámara deberá montar el celular detrás del ocular de 25 mm sobre la base del soporte de la cámara Sony. | interfaz | L1-23 | inspección | definido | no |
| L2-CAM-03 | El tren de imagen deberá pesar no más de 1 kg sobre el portaocular. | restricción | L1-24 | inspección | TBR | no |
| L2-CAM-04 | El tren de imagen deberá disparar cada sub sin contacto del operador con el telescopio. | funcional | L1-01 | demostración | definido | no |

### 6.4 Operación (OPE)

| ID | Enunciado | Tipo | Padre | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|
| L2-OPE-01 | El procedimiento de puesta en estación deberá alinear el eje polar a no más de 7 minutos de arco del polo celeste sur. | desempeño | L1-01 | ensayo | TBR | no |
| L2-OPE-02 | El procedimiento de puesta en estación deberá alinear el eje polar sin ver el polo celeste sur. | funcional | L1-01 | demostración | definido | no |
| L2-OPE-03 | Con las marcas del piso, el procedimiento de puesta en estación deberá repetir la alineación polar en no más de 2 minutos. | desempeño | L1-17 | demostración | TBR | no |
| L2-OPE-04 | Las marcas del piso deberán conservar la posición de cada apoyo con un error de no más de 1 mm después de la lluvia. | ambiental | L1-17 | inspección | TBR | no |

## 7. Rationale

Razón, supuestos, relación con el ConOps y, si fija una solución, por qué
(NASA, caja *Rationale*). Grado de cada número entre corchetes.

**Misión**

- **L0-01** — Es la meta del PDP §1 y el criterio de validación: sin la foto,
  un diseño perfecto falla. «Propia»: tomada y apilada por Fran.
- **L0-02** — Traduce «las estrellas son puntos y no rayas» a un número. La
  redondez la mide un programa de apilado (Siril la informa por estrella). 0,8
  es el umbral usual de «redonda a la vista» [criterio, a confirmar con la
  primera foto]. TBR.
- **L0-03** — La meta se partió en dos (PDP §6, 2026-10-04): esta misión es la
  foto sin guiar; el autoguiado es un proyecto después. Por eso los subs son
  cortos.
- **L0-04** — PDP §2: no es un GoTo. El apuntado manual es lo que Fran hace
  hoy y no se quiere perder.
- **L0-05** — PDP §2 y §3: la dobson se reforma, no se reemplaza, y no hay
  otra. Cierra la puerta a una montura nueva a propósito (R31: la solución es
  la necesidad del interesado).
- **L0-06** — Criterio 2 del trade study (Fran: «no extremadamente complejo»).
  El corte láser y el torneado se contratan porque son las dos piezas de
  precisión (`docs/13` §4); lo demás es herrería de la casa.
- **L0-07**, **L0-08** — ConOps: Fran saca el equipo solo, y «nada de
  notebook obligatoria».
- **L0-09** — Pedido de Fran (tres capas de tope) y de Kevin (topes para el
  motor). La plataforma va a quedar siguiendo una hora sin nadie al lado.
- **L0-10** — Criterio 1 del trade study, el de más peso (0,4): «que yo pueda
  poner la plataforma donde quiera y hacerla andar». Se cumple con tres apoyos
  y marcas en el piso, no recalibrando cada noche.
- **L0-11** — ConOps, modo degradado: «si sólo sirve con la alineación
  perfecta, en la práctica no sirve». Lo cuantifica L1-26. TBR.
- **L0-12**, **L0-13** — Decisión de Fran del 2026-10-04: soporte
  intercambiable. La Sony es el camino principal; el celular es el plan B del
  riesgo R1 (que el tubo no llegue a foco). L0-12 queda TBR porque depende de
  la prueba de foco (P0).
- **L0-14** — PDP §2: «se deja la entrada prevista en el firmware». Cuesta
  casi nada hoy y evita rehacer la electrónica para la segunda meta.

**Sistema**

- **L1-01** (**KDR**) — El requisito que fija la precisión de todo lo demás
  (`docs/13` §2). Supuestos: escala de 0,67 segundos de arco por píxel (Sony
  ZV-E10 a 1200 mm, `hipótesis` hasta confirmar la cámara) y 2 segundos de
  arco como lo que ya borronea el aire de una noche común [criterio]. Los 30 s
  salen de la decisión del 2026-10-04 (subs de 20 a 30 s sin guiar); **Fran
  todavía tiene que elegir 30 o 60 s** (paso 4 de `docs/11`): con 60 s cada
  número de abajo se reparte a la mitad. Se reparte entre la plataforma (1,5),
  la montura (0,5) y la alineación polar (1), sumados en cuadratura porque son
  independientes: 1,9 segundos de arco [cálculo].
- **L1-02** (**KDR**) — Criterio de salida de la fase 4 del PDP («60 min de
  carrera sin intervenir») y ConOps paso 8. Fija el largo de las chapas. El
  diseño da 90 min (±45), con margen.
- **L1-03** — ConOps paso 8: rebobinar por botón. 5 min es lo que Fran está
  dispuesto a perder entre carreras [estimación de la sesión]. TBR.
- **L1-04** — Que la chapa nunca se salga del rodillo (N-09). Lo cumplen las
  tres capas de L2-PLT-06 a 08 más el corte por cable de L2-PLT-09.
- **L1-05** — ConOps: el seguimiento anda solo, con la placa y una batería.
- **L1-06** — Una noche de fotos son tres o cuatro carreras. TBR hasta medir
  el consumo del motor en el banco (paso 6 de `docs/11`).
- **L1-07** — Baja L0-05 al sistema: el tubo va en la montura actual.
- **L1-08** — Baja L0-04. Con la plataforma andando, el dobson se sigue
  moviendo a mano en sus dos ejes para apuntar.
- **L1-09** — La geometría del VNS depende de la latitud: las chapas se cortan
  para 34,5 grados (`geometria-vns.js`, `phi: 34.5`). Un grado de diferencia se
  compensa con las patas. TBR: **si la plataforma viaja a un cielo oscuro
  lejos, la tolerancia cambia** (pregunta para Fran, §11.1).
- **L1-10**, **L1-11** — Noches del conurbano bonaerense, con rocío. La
  electrónica va en caja; la cámara se protege como hoy [estimación]. TBR.
- **L1-12** — Es la ráfaga con que se dimensionó el motor (`docs/09`, sección
  Motor) [estimación propia]. Con viento la foto sale mal igual; lo que se pide
  es que la mesa no pierda el paso y siga en hora cuando para.
- **L1-13** — «La plataforma no tiene que ser más fácil de volcar que el
  dobson solo» (`docs/13` §8): el dobson solo aguanta unos 6 kg de empujón en
  la boca, 59 N [cálculo, `probable`]. TBR hasta medir el dobson solo.
- **L1-14** — El umbral con que ya juzga el modelo v9 (verde desde 22 grados).
  Su origen no estaba escrito: queda TBR hasta la fase 1. El v9 da 24,1 grados
  al sur y de costado [cálculo, `geometria-vns.js` con los valores del modelo].
- **L1-15** (**KDR**) — Si el centro de masa no cae en el eje, el motor tiene
  que sostener el desbalance y la velocidad cambia con la posición de la mesa.
  La altura del centro de masa es lo que fija la forma de las chapas, y hoy
  vale 63 cm con un rango de 58 a 69 **sin medir** [`probable`]. 1 cm es una
  estimación de la sesión; se verifica con CAL-1 (la mesa queda quieta en cinco
  posiciones con la correa sacada). TBR.
- **L1-16** — Lo que Fran ya carga hoy: el tubo pesa 19,2 kg y la montura 19,7
  [`probable`, pesadas del 5/10]. Ninguna pieza nueva pesa más que eso.
- **L1-17** — ConOps: la noche tiene que arrancar sin ceremonia. 20 min es
  estimación de la sesión. TBR (pregunta para Fran, §11.1).
- **L1-18** — Criterio 1 del trade study: «en donde quiera». Tres apoyos
  regulables absorben el desnivel del patio. 3 cm es estimación. TBR.
- **L1-19** — Un objeto de cielo profundo brillante (M42, la Laguna, Carina) se
  reconoce con media hora de exposición total a f/6 [criterio]. TBR.
- **L1-20** — Con la mesa inclinada al final de la carrera, un dobson suelto
  se desliza. Lo baja L2-PLT-12.
- **L1-21** — ConOps paso 1: el dobson se sube a la mesa sin levantarlo
  entero. La montura sin el tubo pesa unos 20 kg y se levanta poco; el tubo se
  pone después. El v9 deja la cara de arriba de la mesa a 22,6 cm del piso
  [cálculo]: cumple con margen. 30 cm es estimación de la sesión. TBR.
- **L1-22** (**KDR**) — Riesgo R1: la falla clásica del newtoniano es que el
  portaocular no tiene recorrido hacia adentro y la cámara no llega a foco.
  **TBD** hasta la prueba P0 (diez minutos de día). Es compuerta antes de
  mandar a cortar las chapas (`docs/07`, Aparcado).
- **L1-23** — El plan B de R1: el celular detrás del ocular siempre llega a
  foco, porque enfoca él.
- **L1-24** — ConOps paso 6: cambiar del ocular a la cámara no puede
  desbalancear el tubo al punto de que se corra (riesgo R7).
- **L1-25** — Baja L0-14.
- **L1-26** — Un error de 30 minutos de arco en el eje polar corre la estrella
  unos 0,13 segundos de arco por segundo: 1,3 en un sub de 10 s [cálculo]. TBR.

**Plataforma**

- **L2-PLT-01** — Derivado de la arquitectura (plataforma ecuatorial, PDP §6):
  es la única forma de seguir sin rotación de campo.
- **L2-PLT-02** — Asignado de L1-01: 1,5 segundos de arco para la plataforma
  entera (velocidad, error periódico de polea y rodillo, micropasos, flexión
  de la estructura). El presupuesto fino es el entregable de la fase 1.
- **L2-PLT-03** — Derivado de L2-PLT-02: 0,2 % de error medio corre la estrella
  0,9 segundos de arco en 30 s, y deja lugar al error periódico. Coincide con
  la aceptación de CAL-2 (`docs/11`). La variación propia del VNS (±0,48 %) se
  corrige en el programa con una tabla.
- **L2-PLT-04** — Derivado de la arquitectura VNS (pivote y dos rodillos):
  tres puntos no renguean en ningún piso.
- **L2-PLT-05** — Decisión de Fran del 2026-10-04 (diseño adaptable): el
  centro de masa todavía está entre 58 y 69 cm, y la diferencia se cubre con
  suplementos y ranuras, no cortando. 12 cm cubre ese rango. TBR hasta medir.
- **L2-PLT-06** a **L2-PLT-08** — Pedido de Fran del 2026-10-04: tres capas
  independientes (programa, fin de carrera, talón). Los minutos salen de
  `geometria-vns.js` (`runMin` 45, `swMin` 3, `stopMin` 6).
- **L2-PLT-09** — Derivado: un freno que falla abierto cuando se corta un cable
  no es un freno. Por eso los fines de carrera son normalmente cerrados
  (FAB-6).
- **L2-PLT-10** — El motor de 4 kg·cm da 6,5 veces [cálculo, `docs/09`]; 2
  veces es el margen usual de un paso a paso contra la pérdida de pasos
  [criterio]. TBR.
- **L2-PLT-11** — ST-4 es la entrada de autoguiado más común en monturas y
  autoguiadores; se fija para no rehacer la electrónica. TBR hasta elegir el
  autoguiador.
- **L2-PLT-12** — Pedido de Kevin (bujes, bulones y mariposas) con la cantidad
  que propuso: **tres** puntos, que no renguean, como los apoyos. A mano,
  porque de noche no se busca una llave. **El modelo v9 tiene cuatro: no
  cumple.**
- **L2-PLT-13** — Kevin: «desarmada entra en el baúl». **TBD**: falta saber si
  la plataforma viaja en auto, y el tamaño del baúl (§11.1).

**Montura**

- **L2-MON-01** — Asignado de L1-01: 0,5 segundos de arco para la montura
  (flexión de las paredes y juego de los ejes con la mesa girando).
- **L2-MON-02**, **L2-MON-03** — ConOps paso 3: la mesa se inclina hacia el
  final de la carrera y un eje suelto deja correr el tubo. La mesa se inclina
  9,3 grados a los 45 min y 10,5 en el talón [cálculo, `geometria-vns.js`]; 11
  cubre el peor caso. Depende sólo de la latitud y del giro, no del centro de
  masa: está definido.
- **L2-MON-04** — Riesgo R4, confirmado: las paredes flexan (37 cm abajo, 36
  arriba) y apretar el eje las cierra. 0,5 mm es estimación. TBR.
- **L2-MON-05** — Baja L1-07 y el PDP §3 (aspecto b): no hay otra montura,
  así que todo lo que se le agregue tiene que poder sacarse. Agujeros para
  bulones, sí; cortar madera, no.
- **L2-MON-06** — Baja L1-24: con 0,5 kg más en el portaocular el tubo se
  rebalancea corriéndolo 1 o 2 cm en la caja (`docs/11`). 15 grados es la
  altura más baja útil sobre el horizonte del patio [estimación]. TBR.

**Tren de imagen**

- **L2-CAM-01** — El portaocular parece helicoidal de 1,25 pulgadas
  [`hipótesis`, fotos 59 a 63]. TBR hasta mirarlo.
- **L2-CAM-02** — Decisión de Fran: dos adaptadores sobre una misma base.
- **L2-CAM-03** — La Sony con el soporte pesa unos 0,5 kg; 1 kg deja margen
  para un celular grande y una Barlow. TBR.
- **L2-CAM-04** — ConOps: nada de tocar el telescopio durante un sub; tocarlo
  mueve la imagen mucho más de 2 segundos de arco.

**Operación**

- **L2-OPE-01** — Asignado de L1-01: un error de 7 minutos de arco corre la
  estrella 0,9 segundos de arco en 30 s [cálculo]. Coincide con CAL-4 (no más
  de 3 píxeles en 60 s).
- **L2-OPE-02** — Derivado del hemisferio sur: σ Octantis es de magnitud 5,4
  y está a 1° 8' del polo (`docs/04`). Por eso el método de deriva.
- **L2-OPE-03** — ConOps paso 2: la primera vez media hora, después dos
  minutos con las marcas. TBR.
- **L2-OPE-04** — 1 mm de error en una pata a 1,2 m de distancia mueve el eje
  unos 3 minutos de arco [cálculo]: menos de la mitad del presupuesto de
  L2-OPE-01. TBR.

## 8. Metas (debería) y lo que a propósito no es requisito

Una meta se persigue pero no se exige: fallarla no es fallar el proyecto
(cátedra, m17).

| ID | Meta | Fuente |
|---|---|---|
| M-01 | La plataforma debería mostrar en una pantalla el tiempo de carrera que queda. | Kevin, 2026-10-05; se decide en la fase 3 |
| M-02 | La plataforma debería comunicarse por Bluetooth con el celular. | Kevin, 2026-10-05; fase 3 |
| M-03 | La plataforma debería llevar una carga de 60 kg cambiando sólo las chapas y la mesa. | Fran, 2026-10-07: «quizás algún 300 mm»; las tres puertas abiertas de `docs/13` §7 |

**No son requisitos, y está escrito para que nadie los agregue de contrabando:**

- **El costo.** Fran: «si puedo gastar más plata en algo, no importa» (peso
  0,1). No hay un tope; se cotiza y se decide.
- **GoTo, catálogo, búsqueda.** PDP §2.
- **Fotos de planetas.** PDP §2: no manda ninguna decisión.
- **Un telescopio de 12".** Sin modelo no hay requisito verificable (PDP §6);
  queda como meta M-03.

## 9. Del diseño al requisito — qué decisión cumple qué

La traza para el otro lado: cada decisión del concepto v9 (PDP §6, `docs/13`)
tiene que apuntar a un requisito. **Una decisión que no apunta a ninguno es un
huérfano**: o falta el requisito, o sobra la decisión.

| Decisión de diseño | Cumple | Comentario |
|---|---|---|
| VNS con pivote al norte y chapas al sur | L2-PLT-01, L2-PLT-04, L1-09 | arquitectura elegida |
| chapas de acero de 1/4" cortadas a láser | L2-PLT-02, L2-PLT-03 | el canto es una de las dos piezas de precisión |
| rodillo motriz torneado; rodillo loco de cuatro 608 | L2-PLT-02, L2-PLT-03 | la otra pieza de precisión |
| correa GT2 20:80 | L2-PLT-02 | sin juego; el término más grande del error periódico |
| NEMA 17 de 4 kg·cm + TMC2209 | L2-PLT-10, L1-03 | |
| ESP32 | L1-05, L2-PLT-06, M-01, M-02 | la elección de placa la empujan las metas de Kevin |
| tres capas de tope (45, 48, 51 min) | L2-PLT-06 a 08 | |
| fines de carrera normalmente cerrados | L2-PLT-09 | |
| rodillos a 50 cm | L1-13 | 6,9 kg contra 6 del dobson solo |
| base triangular de 1,2 m | L1-14, L2-PLT-04 | |
| tubo 20 × 20 con planchuela de canto en la viga sur y el brazo | L2-PLT-02, L1-16 | la flexión entra en el error de la plataforma |
| viga sur abulonada | L2-PLT-13 | TBD: el baúl |
| poste de 10 cm en el pivote | L2-PLT-13 | acorta la base; sin el baúl medido, es un huérfano a medias |
| rótula de amortiguador en el pivote | L2-PLT-02 | cero juego |
| suplementos bajo el dobson y ranuras en los largueros | L2-PLT-05 | |
| bulones con buje y mariposa para el dobson | L2-PLT-12 | **el v9 tiene 4; el requisito pide 3** |
| eje a unos 54 cm sobre la mesa | L1-15 | sale de 63 cm sin medir |
| soporte de cámara intercambiable | L2-CAM-01, L2-CAM-02 | |

**Huérfanos de hoy:** ninguno entero. El poste del pivote queda a medias
(acorta la base, pero el requisito del baúl es TBD), y la **cantidad de
bulones del dobson del modelo contradice a L2-PLT-12**.

## 10. Qué representa el modelo 3D v9

La columna **3D** de las tablas, explicada. El modelo es demostrativo: muestra
la forma; **ningún número del modelo es para cortar** (PDP §6, 2026-10-07).

| Lo muestra | Requisitos |
|---|---|
| el eje polar a 34,5 grados y la mesa girando con el reloj de la carrera | L2-PLT-01, L1-02, L1-09 |
| las tres capas de tope (leva y microswitches, talones) | L1-04, L2-PLT-06 a 08 |
| las tres patas regulables | L2-PLT-04, L1-18 |
| el suplemento bajo el dobson y el centro de masa | L1-15; L2-PLT-05 a medias (el control llega a 5 cm) |
| el panel: vuelco, empujón de costado, altura de la mesa | L1-13, L1-14, L1-21 |
| la viga sur abulonada | L2-PLT-13 a medias |
| el dobson y la montura actuales | L0-05, L1-07, L1-08 |
| la fijación del dobson | L1-20 a medias: **4 bulones, el requisito pide 3** |

No lo muestra: el tren de imagen, los frenos de la montura, el error de
seguimiento, la electrónica más allá del motor, la operación.

## 11. Lo que falta definir, y quién lo cierra

| Qué | Requisitos | Lo cierra |
|---|---|---|
| la altura del centro de masa, medida por dos métodos | L1-15, L2-PLT-05 y los derivados | **Fran y Kevin**: el vuelco (hA, hB, A, B, W) y la altura del eje |
| ¿llega a foco la Sony? | L1-22, L0-12, L2-CAM-01 | **Fran**: la prueba P0, diez minutos de día |
| 30 o 60 s por sub | L1-01 y todo lo asignado | **Fran**: una decisión |
| ¿viaja en auto? ¿qué baúl? | L2-PLT-13, L1-09 | **Fran** (§11.1) |
| los números estimados por la sesión (rebobinado, autonomía, desnivel, tiempo de armado, marcas, frenos) | los TBR | la sesión, en la fase 1, con las mediciones del banco y del vuelco |
| la altura de la mesa (22,6 cm) y su inclinación al final (10,5 grados) | L1-21, L2-MON-02, L2-MON-03 | **hecho**, del modelo, el 2026-10-07 |

### 11.1 Preguntas para Fran (de valor, no técnicas)

1. **¿30 s o 60 s por foto?** Fija toda la precisión (L1-01).
2. **¿La plataforma se queda en el patio, o viaja en auto a un cielo oscuro?**
   Si viaja: ¿qué auto, o cuánto mide el baúl? Fija L2-PLT-13 y la tolerancia
   de latitud (L1-09).
3. **¿Cuánto tiempo de armado te parece bien, del depósito al primer sub?**
   Hoy dice 20 min (L1-17).

## 12. Validación del conjunto (NASA, seis pasos)

| Paso | Estado |
|---|---|
| 1. ¿Bien escritos? | `verificar-requisitos.py`: el GtWR sin VIOLA y la traza completa |
| 2. ¿Técnicamente correctos? | revisados por la sesión que los escribió; **falta un revisor que no los escribió** (Kevin, o una sesión de revisión) |
| 3. ¿Satisfacen al interesado? | **pendiente: Fran**, en la SRR de la fase 1 |
| 4. ¿Factibles, como conjunto? | las cuentas de `docs/13` dicen que sí [`probable`]; el presupuesto de error de la fase 1 lo cierra |
| 5. ¿Verificables? | cada uno tiene su método |
| 6. ¿Redundantes o sobreespecificados? | el chequeo del GtWR busca duplicados (R30); lo que fija una solución dice por qué en el rationale |
