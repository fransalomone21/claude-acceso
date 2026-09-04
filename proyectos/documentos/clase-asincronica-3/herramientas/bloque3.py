# bloque3.py -- Bloque 4 de la guia (RLC de segundo orden, problemas 8.1 y
# 8.38) y la SEGUNDA PASADA con no idealidades, que la guia pide sobre un
# RL, un RC y un RLC elegidos.

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from asc import Sch                                              # noqa: E402

X = 64


def p8_01(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    r1 = s.sym("res", "R", (176, TOP), "R0", value="{R}")
    s.wire(r1[1], (176, BOT))
    l1 = s.sym("ind", "L", (400, TOP), "R0", value="12.5", value2="Rser=0")
    s.wire(l1[1], (400, BOT))
    c1 = s.sym("cap", "C", (624, TOP), "R0", value="2u")
    s.wire(c1[1], (624, BOT))
    s.rail(TOP, 176, 624)
    s.rail(BOT, 176, 624)
    s.wire((288, BOT), (288, BOT + 48))
    s.tierra((288, BOT + 48))
    s.wire((512, TOP), (512, TOP - 48))
    s.flag((512, TOP - 48), "v")

    s.directiva((X, 400),
                ".tran 0 100m 0 5u",
                ".ic V(v)=1 I(L)=0",
                ".step param R list 1000 1562.5 1250",
                ".meas TRAN alfa   PARAM 1/(2*R*2u)",
                ".meas TRAN omega0 PARAM 1/sqrt(12.5*2u)",
                ".meas TRAN v_min  MIN V(v)",
                ".meas TRAN t_cruce1 WHEN V(v)=0 CROSS=1",
                ".meas TRAN t_cruce3 WHEN V(v)=0 CROSS=3",
                ".meas TRAN Td     PARAM t_cruce3-t_cruce1")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 8.1 (Nilsson y Riedel) -- RAICES Y CLASIFICACION DE UN RLC PARALELO",
            "Actividad asincronica -- Bloque 4: circuitos RLC de segundo orden",
            "=" * 100,
            "Enunciado: R = 1000 ohm, L = 12,5 H y C = 2 uF en un RLC PARALELO.",
            "  a) raices de la ecuacion caracteristica de la respuesta en tension;",
            "  b) clasificar la respuesta; c) que R da una frecuencia amortiguada de 120 rad/s;",
            "  d) las raices para ese R; e) que R da amortiguamiento critico.",
            "  La guia agrega: simular la respuesta natural normalizada con vC(0)=1 V e iL(0)=0, con el",
            "  R original, con el del apartado (c) y con el critico, y superponer las tres.",
        ],
        circuito=[
            "EL CIRCUITO",
            "  Tres elementos en paralelo entre el nodo v y masa: R, L y C. No hay fuente -- es una",
            "  respuesta NATURAL, y el estado inicial entero son las dos condiciones de .ic.",
            "  El valor de R es {R}, entre llaves: eso no es una resistencia de 'R ohm', es una",
            "  REFERENCIA A UN PARAMETRO. Las llaves le dicen a LTspice 'esto se evalua antes de",
            "  simular, buscando un parametro que se llame R'. El parametro lo provee .step.",
            "  Ojo con el nombre: el simbolo se llama R y el parametro tambien se llama R. LTspice lo",
            "  resuelve bien (uno es un nombre de instancia, el otro un parametro), pero si confunde,",
            "  renombrar el parametro a Rp en los dos lugares.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  .step param R list 1000 1562.5 1250",
            "     Corre la simulacion COMPLETA una vez por cada valor de la lista, y superpone las tres",
            "     curvas en el mismo panel con el mismo color. Es lo que pide el apartado de la guia:",
            "     las tres respuestas juntas, no tres archivos.",
            "     Las otras formas son .step param R 100 1000 100 (desde, hasta, paso) y",
            "     .step param R 100 10k 10 (con la palabra dec u oct para barrer en decadas).",
            "     Para saber CUAL curva es cual: boton derecho sobre la traza > Select Steps, o pasar el",
            "     mouse por encima y leer la barra de estado, que dice 'Step Information: R=1250'.",
            "  .ic V(v)=1 I(L)=0",
            "     'Respuesta natural normalizada': 1 V es un valor de referencia elegido para que la",
            "     forma de la curva se lea sin que la escala tape nada. La clasificacion (sobre, sub o",
            "     criticamente amortiguada) NO depende de la amplitud, solo de las raices.",
            "  .tran 0 100m 0 5u",
            "     100 ms alcanza para dos periodos amortiguados del caso subamortiguado (Td = 52,4 ms).",
            "     Paso maximo 5 us = Td/10000, muy por encima de los 100 puntos por periodo que pide el",
            "     criterio de la guia.",
            "  .meas TRAN t_cruce1 WHEN V(v)=0 CROSS=1",
            "     CROSS=n significa 'el n-esimo cruce por ese valor'. Con el primero y el tercero se",
            "     mide un PERIODO amortiguado completo (dos cruces por cero son medio periodo).",
            "     EL PRIMER CRUCE EXISTE EN LOS TRES CASOS -- ver el bloque CONTROL, que es donde esta",
            "     la unica prediccion de este proyecto que salio mal. El que FALLA, y tiene que fallar,",
            "     es t_cruce3: solo la respuesta subamortiguada llega a un tercer cruce. Ese 'measurement",
            "     fail' en el .log no es un error del archivo: es el resultado.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  Para el RLC PARALELO:  alfa = 1/(2*R*C)   y   omega0 = 1/sqrt(L*C)",
            "  omega0 = 1/sqrt(12,5 * 2e-6) = 1/sqrt(25e-6) = 200 rad/s   (para los tres casos)",
            "  a) R = 1000:  alfa = 1/(2*1000*2e-6) = 250 rad/s",
            "     alfa > omega0  ->  s = -alfa +/- sqrt(alfa^2 - omega0^2) = -250 +/- 150",
            "     s1 = -100 1/s     s2 = -400 1/s      (dos reales y distintas)",
            "  b) SOBREAMORTIGUADA: no oscila. Pero OJO, y esto se corrige aca porque la prediccion",
            "     original de esta hoja decia otra cosa: 'no oscila' NO quiere decir 'no cruza el cero'.",
            "     Con vC(0)=1 V e iL(0)=0, la respuesta en tension es",
            "        v(t) = -(1/3)*e^(-100t) + (4/3)*e^(-400t)",
            "     y los dos coeficientes tienen SIGNOS DISTINTOS, asi que hay un cruce por cero en",
            "        t = ln(4)/300 = 4,621 ms,  y despues la tension queda negativa y vuelve a cero por",
            "     abajo. Una respuesta sobreamortiguada puede cruzar el cero UNA vez; lo que no puede es",
            "     cruzarlo dos. La criticamente amortiguada, igual: v(t) = (1 - 200t)*e^(-200t) cruza en",
            "     t = 5 ms exactos. Lo que distingue a la subamortiguada no es que cruce, es que cruza",
            "     INFINITAS veces.",
            "     Esta correccion salio de la simulacion contra la prediccion escrita: los tres t_cruce1",
            "     dieron 4,62 ms, 5,00 ms y 5,36 ms donde la prediccion decia que dos de ellos iban a",
            "     fallar. La cuenta a mano confirmo que la equivocada era la prediccion, no el modelo.",
            "  c) omega_d = 120 rad/s  ->  alfa^2 = omega0^2 - omega_d^2 = 40000 - 14400 = 25600",
            "     alfa = 160 rad/s  ->  R = 1/(2*alfa*C) = 1/(2*160*2e-6) = 1562,5 ohm",
            "  d) s = -160 +/- j120 1/s   (subamortiguada). Periodo amortiguado Td = 2*pi/120 = 52,36 ms",
            "  e) critico: alfa = omega0 = 200  ->  R = 1/(2*200*2e-6) = 1250 ohm ; s = -200 doble",
            "  OJO CON LA DIRECCION: en el RLC PARALELO, R MAS GRANDE es MENOS amortiguamiento",
            "  (alfa = 1/(2RC) baja cuando R sube). Es al reves que en el serie, donde alfa = R/(2L)",
            "  sube con R. Confundir las dos es el error mas comun del bloque, y la simulacion lo",
            "  muestra sin discusion: la curva que oscila es la de R = 1562,5, la MAS grande de las tres.",
            "  Lo que tiene que confirmar la simulacion (VERIFICADO, LTspice 26.0.1):",
            "    R=1000    -> alfa=250; UN cruce por cero en 4,621 ms; t_cruce3 falla; v_min = -0,0992 V",
            "    R=1250    -> alfa=200 = omega0; UN cruce en 5,000 ms; t_cruce3 falla; v_min = -0,1353 V",
            "    R=1562,5  -> alfa=160; oscila; cruces en 5,363 ms y 57,72 ms -> Td = 52,36 ms,",
            "                 que es exactamente 2*pi/120. v_min = -0,1798 V",
            "  El v_min mas negativo es el de la subamortiguada, como corresponde, pero los tres son",
            "  negativos: otra vez, negativo no es sinonimo de oscilante.",
            "",
            "QUE GRAFICAR",
            "  Un solo panel con V(v) [V]: las tres corridas de .step se superponen solas. Ese unico",
            "  grafico ES la respuesta al apartado de la guia -- 'las tres simulaciones deben exhibir de",
            "  manera visible el cambio de regimen, no solo valores numericos distintos'.",
            "  Para separar las tres curvas si se confunden: boton derecho > Select Steps y dejar una",
            "  sola, o pasar el mouse por encima y leer 'Step Information' en la barra de estado.",
            "  Cursores sobre la curva de R=1562,5 en dos cruces por cero consecutivos: la diferencia es",
            "  MEDIO periodo amortiguado (26,18 ms). Es el error de lectura clasico -- dos cruces por",
            "  cero no son un periodo.",
        ],
        )
    g(s, "P8-01_RLC_paralelo_clasificacion.asc")


def p8_38(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    c1 = s.sym("cap", "C", (176, TOP), "R0", value="0.5u")
    s.wire(c1[1], (176, BOT))
    r1 = s.sym("res", "R", (176, TOP), "R270", value="{R}")
    s.wire(r1[1], (480, TOP))
    l1 = s.sym("ind", "L", (480, TOP), "R0", value="80m", value2="Rser=0")
    s.wire(l1[1], (480, BOT))
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.wire((176, TOP), (176, TOP - 48))
    s.flag((176, TOP - 48), "vc")
    s.wire((480, TOP), (480, TOP - 48))
    s.flag((480, TOP - 48), "m")

    s.directiva((X, 400),
                ".tran 0 3m 0 20n",
                ".ic V(vc)=20 I(L)=30m",
                ".step param R list 640 800 960",
                ".meas TRAN R_critico PARAM 2*sqrt(80m/0.5u)",
                ".meas TRAN i_0    FIND I(L) AT 0",
                ".meas TRAN didt_0 DERIV I(L) AT 2u",
                ".meas TRAN vc_150us FIND V(vc) AT 150u",
                ".meas TRAN vc_min MIN V(vc)",
                ".meas TRAN vc_1ms FIND V(vc) AT 1m")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 8.38 (Nilsson y Riedel) -- RESPUESTA CRITICAMENTE AMORTIGUADA (RLC SERIE)",
            "Actividad asincronica -- Bloque 4: circuitos RLC de segundo orden",
            "=" * 100,
            "Enunciado: en el circuito de la Figura P8.38 se ajusta la resistencia para obtener",
            "  amortiguamiento critico. La tension inicial del capacitor es 20 V y la corriente inicial",
            "  de la bobina es 30 mA. a) calcular R; b) calcular i y di/dt inmediatamente despues de",
            "  cerrarse el conmutador; c) calcular vC(t) para t>=0.",
            "  Datos: C = 0,5 uF, L = 80 mH. La guia agrega: modificar R en +/-20% y comparar los casos",
            "  subamortiguado, critico y sobreamortiguado.",
        ],
        circuito=[
            "EL CIRCUITO, Y EL SENTIDO DE LA CORRIENTE",
            "  Un lazo SERIE: el capacitor C (nodo vc contra masa), la resistencia R de vc al nodo m, y",
            "  la bobina L de m a masa. El conmutador cerrado se dibuja como el cable que es.",
            "  L esta con el pin A arriba (nodo m) y el pin B a masa, asi que I(L) positiva es la",
            "  corriente que baja por la bobina, que es la misma que sale del borne + del capacitor y",
            "  atraviesa R. Ese es el sentido de la i del enunciado: la que DESCARGA el capacitor.",
            "  Por eso i(0+) = +30 mA y no -30 mA. Si el resultado saliera con el signo cambiado, el",
            "  problema no seria de fisica sino del orden de los nodos de L.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  .ic V(vc)=20 I(L)=30m",
            "     Las DOS condiciones iniciales que un circuito de segundo orden necesita: la tension",
            "     del capacitor y la corriente de la bobina. Con una sola el problema queda indefinido",
            "     -- son justamente las dos que determinan D1 y D2 en la solucion.",
            "  .step param R list 640 800 960",
            "     800 es el critico; 640 es -20% y 960 es +20%, como pide la guia.",
            "  .tran 0 3m 0 20n",
            "     3 ms = 15 constantes de tiempo (1/alfa = 200 us). Paso maximo 20 ns: en el caso",
            "     subamortiguado el periodo amortiguado ronda los 2 ms/... conviene sobrar, y con 20 ns",
            "     hay mas de 100.000 puntos por periodo.",
            "  .meas TRAN didt_0 DERIV I(L) AT 0",
            "     DERIV mide la PENDIENTE de una curva en un instante. Es la forma de contrastar el",
            "     apartado (b) sin derivar a mano una curva en la pantalla.",
            "  .meas TRAN R_critico PARAM 2*sqrt(80m/0.5u)",
            "     La formula del apartado (a) escrita como directiva. No mide nada del circuito: deja el",
            "     numero teorico en el .log, al lado de los medidos, para compararlos de un vistazo.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  Para el RLC SERIE:  alfa = R/(2L)   y   omega0 = 1/sqrt(L*C)",
            "  omega0 = 1/sqrt(0,08 * 0,5e-6) = 1/sqrt(4e-8) = 5000 rad/s",
            "  a) critico es alfa = omega0  ->  R = 2*L*omega0 = 2*0,08*5000 = 800 ohm",
            "     Forma equivalente y mas comoda: R_critico = 2*sqrt(L/C) = 2*sqrt(160000) = 800 ohm",
            "  b) i(0+) = i(0-) = 30 mA   (la corriente de la bobina no puede saltar)",
            "     KVL en el lazo:  vC = i*R + L*di/dt",
            "        20 = 0,03*800 + 0,08*di/dt = 24 + 0,08*di/dt",
            "        di/dt(0+) = -4/0,08 = -50 A/s   <- NEGATIVA: la corriente arranca BAJANDO",
            "     El signo tiene contenido fisico: con 30 mA la caida en R (24 V) ya supera los 20 V",
            "     del capacitor, asi que la bobina tiene que ceder tension y su corriente empieza a caer",
            "     desde el primer instante. No hay pico de corriente.",
            "  c) respuesta criticamente amortiguada:  vC(t) = (D1*t + D2)*e^(-alfa t), alfa = 5000",
            "     vC(0) = D2 = 20",
            "     dvC/dt(0) = -i(0)/C = -0,03/0,5e-6 = -60000 V/s   (la corriente SALE del capacitor)",
            "     dvC/dt(0) = D1 - alfa*D2  ->  D1 = -60000 + 5000*20 = 40000",
            "     vC(t) = (40000*t + 20)*e^(-5000 t) V",
            "     La curva NO tiene maximo interior: dvC/dt(0) = D1 - alfa*D2 = 40000 - 100000 =",
            "     -60000 V/s < 0, asi que arranca en 20 V y BAJA desde el primer instante. El maximo",
            "     esta en t=0. (Buscar el maximo con MAX(V(vc)) devuelve 20 V, que es correcto y no",
            "     informa nada: por eso el .meas de esta hoja pide el valor EN 150 us y no el maximo.)",
            "     Valores de referencia: vC(150 us) = (6+20)*e^(-0,75) = 12,28 V ;",
            "                            vC(1 ms)   = (40+20)*e^(-5)    = 0,4043 V",
            "  +/-20%:  R = 640 -> alfa = 4000 < 5000: SUBAMORTIGUADO, cruza el cero y oscila.",
            "           R = 960 -> alfa = 6000 > 5000: SOBREAMORTIGUADO, vuelve mas LENTO que el critico.",
            "  DOS DETALLES DE MEDICION QUE COSTARON UNA CORRIDA CADA UNO:",
            "  1) di/dt se mide en 2 us y no en 0. DERIV ... AT 0 devuelve 0 en LTspice, porque en el",
            "     primer punto no hay punto anterior con el que armar la diferencia. El valor teorico en",
            "     2 us es (-50 - 500000*2e-6)*e^(-0,01) = -50,49 A/s, y hacia t=0 tiende a -50 A/s.",
            "  2) NO calcular esa derivada a mano como (i(2us)-i(0))/2us. El .ic de una bobina no es",
            "     exacto: LTspice lo impone con una fuente de conductancia grande pero finita, y aca",
            "     deja i(0) = 29,96 mA en vez de 30,00 mA. Ese error de 0,13% es del mismo tamano que",
            "     el cambio real de corriente en 2 us, asi que la diferencia finita da -30 A/s en vez de",
            "     -50 A/s: un 40% de error que no viene de la fisica sino de restar dos numeros casi",
            "     iguales. DERIV usa muchos mas puntos y no se lo come. Regla general: no restar dos",
            "     muestras vecinas de una curva simulada para sacar una pendiente.",
            "  Lo que tiene que confirmar la simulacion (VERIFICADO, LTspice 26.0.1):",
            "    R_critico = 800 ohm    i_0 = 30 mA    didt_0 = -50,5 A/s aprox (en 2 us)",
            "    para R=800: vc_150us = 12,28 V ; vc_1ms = 0,4043 V ; vc_min = +4e-5 V, o sea que NO",
            "                cruza el cero: llega y se queda.",
            "    para R=640: vc_min = -0,430 V -- sobreimpulso hacia abajo, subamortiguada.",
            "    para R=960: vc_1ms = 1,30 V, TRES VECES la del critico. Vuelve mas lento, que es el",
            "                control conceptual de la guia: el critico es el retorno mas rapido sin oscilar.",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  V(vc) [V], las tres corridas superpuestas. Ahi se lee todo: la de 640 se pasa",
            "            de largo, la de 800 toca el cero y se queda, la de 960 llega tarde.",
            "  Panel 2:  I(L) [A], las tres. Cursor en t=0 y en t=10 us sobre la de 800 para estimar la",
            "            pendiente inicial y contrastarla con los -50 A/s del calculo.",
            "  Cuidado con la tentacion de comparar 'cual baja primero' mirando solo el principio: el",
            "  criterio del amortiguamiento critico es el retorno al equilibrio SIN OSCILAR, y eso se",
            "  juzga en la cola, no en los primeros microsegundos.",
        ],
        )
    g(s, "P8-38_RLC_serie_critico.asc")


# ==========================================================================
# SEGUNDA PASADA -- NO IDEALIDADES
# ==========================================================================

CIERRE_NO_IDEAL = [
    "LAS CUATRO PREGUNTAS QUE LA GUIA PIDE CONTESTAR EN LA SEGUNDA PASADA",
    "  1. Comparar de nuevo valor inicial, valor final y tau (o la frecuencia amortiguada).",
    "  2. Indicar QUE no idealidad explica la mayor diferencia.",
    "  3. Evaluar si el modelo ideal sigue alcanzando para predecir la respuesta de interes.",
    "  4. Proponer una medicion de laboratorio que estime el parasito dominante.",
    "  Las respuestas de esta hoja estan mas abajo, en el bloque CONCLUSION.",
]


def x1_rl(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    l1 = s.sym("ind", "L1", (176, BOT), "R180", value="8",
               value2="Rser={dcr}")
    s.wire(l1[1], (176, TOP))
    r1 = s.sym("res", "R1", (480, TOP), "R0", value="40")
    s.wire(r1[1], (480, BOT))
    s.rail(TOP, 176, 480)
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.wire((328, TOP), (328, TOP - 48))
    s.flag((328, TOP - 48), "v")

    s.directiva((X, 400),
                ".tran 0 1.2 0 200u",
                ".ic I(L1)=10",
                ".step param dcr list 1u 25",
                ".meas TRAN v_0  FIND V(v) AT 0",
                ".meas TRAN i_0  FIND I(L1) AT 0",
                ".meas TRAN t63  WHEN I(L1)=3.678794",
                ".meas TRAN tau_teorico PARAM 8/(40+dcr)",
                ".meas TRAN error_pct   PARAM 100*(t63-0.2)/0.2")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "SEGUNDA PASADA -- EL RL DEL PROBLEMA 7.4 CON LA RESISTENCIA REAL DEL BOBINADO",
            "=" * 100,
            "La guia pide, al final: elegir un problema RL, uno RC y uno RLC, repetir la simulacion con",
            "  parametros razonables de componentes reales, y decir cual no idealidad explica la mayor",
            "  diferencia. Esta hoja es el RL, y el elegido es el 7.4 (L = 8 H, R = 40 ohm, iL(0)=10 A).",
            "",
            "EL VALOR SUPUESTO, DECLARADO COMO PIDE LA GUIA",
            "  DCR (resistencia de continua del bobinado) = 25 ohm.",
            "  De donde sale: una bobina de 8 H no existe con nucleo de aire. Se hace con nucleo de",
            "  hierro y miles de vueltas de alambre fino, y en los catalogos de choques de filtro de",
            "  linea una de ese orden trae entre 15 y 60 ohm de continua. 25 ohm es el medio de esa",
            "  banda. NO es un dato de hoja de datos: es un supuesto, y por eso esta escrito aca.",
        ],
        circuito=[
            "COMO SE MODELA EL PARASITO: EL CAMPO Rser DEL PROPIO SIMBOLO",
            "  No hace falta agregar una resistencia dibujada en serie. El simbolo de la bobina de",
            "  LTspice tiene un segundo campo, Value2, donde se escriben sus parasitos:",
            "     Rser=<ohm>   resistencia serie del bobinado (la DCR)",
            "     Rpar=<ohm>   perdidas del nucleo, en paralelo",
            "     Cpar=<F>     capacidad entre espiras, en paralelo",
            "  Se llega con boton derecho sobre la bobina > los campos del cuadro de dialogo. En esta",
            "  hoja quedo puesto Rser={dcr}, o sea que el parasito es un PARAMETRO y lo barre .step.",
            "  Es preferible a dibujar la resistencia aparte por dos razones: la corriente que se lee",
            "  con I(L1) sigue siendo la de la bobina, y no aparece un nodo intermedio artificial.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA",
            "  .step param dcr list 1u 25",
            "     Dos corridas superpuestas: la ideal (1 microohm, que es cero a todos los efectos) y la",
            "     real. Se escribe 1u y no 0 por costumbre defensiva: hay elementos de SPICE que se",
            "     quejan de un cero exacto, y un microohm contra 40 ohm es una parte en 40 millones.",
            "  .meas TRAN tau_teorico PARAM 8/(40+dcr)",
            "     La formula, evaluada con el dcr de cada corrida. Al lado del t63 medido, la",
            "     comparacion queda hecha en el propio .log.",
        ],
        control=[
            "CONTROL Y CONCLUSION",
            "  IDEAL:  tau = L/R = 8/40 = 200 ms",
            "  REAL:   la DCR queda EN SERIE con la bobina, y en una respuesta natural el lazo es uno",
            "          solo, asi que las dos resistencias se SUMAN:",
            "          tau = L/(R + DCR) = 8/65 = 123,1 ms   ->  38,5% mas rapido",
            "  Valor inicial: NO cambia. i(0)=10 A lo fija la condicion inicial, y v(0) = 10*40 = 400 V",
            "          sigue siendo el mismo, porque la tension del NODO es la de R1 sola: los 250 V que",
            "          caen en la DCR quedan adentro del simbolo de la bobina y no se ven en V(v).",
            "          Ese es un detalle que enganya: la curva de tension arranca en el mismo lugar y",
            "          solo cambia de pendiente. Si uno mira solo v(0), no se entera de nada.",
            "  Valor final: cero en los dos casos.",
            "  1. Diferencia: tau baja de 200 a 123 ms.  2. La explica la DCR, y no hay otra candidata:",
            "     es la unica no idealidad que entra en el mismo lazo.",
            "  3. EL MODELO IDEAL NO ALCANZA. Un 38% de error en la constante de tiempo no es un ajuste",
            "     fino: si el circuito fuera un temporizador, erraria el tiempo por un tercio.",
            "  4. MEDICION PROPUESTA: medir la bobina con el ohmetro, en continua y desconectada. La DCR",
            "     se lee directo. Es la unica de las tres no idealidades de una bobina que se mide con",
            "     un instrumento de banco comun; Rpar y Cpar piden un puente LCR o un barrido de",
            "     frecuencia buscando la autorresonancia.",
            "",
            "QUE GRAFICAR",
            "  Panel 1: I(L1) [A], las dos corridas superpuestas. La separacion entre las dos curvas ES",
            "           el efecto del parasito, dibujado.",
            "  Panel 2: V(v) [V]. Empiezan las dos en 400 V -- por eso el panel 1 es el que sirve.",
        ] + CIERRE_NO_IDEAL,
        )
    g(s, "X1_no_ideal_RL_con_DCR.asc")


def x2_rc(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    c1 = s.sym("cap", "C1", (176, TOP), "R0", value="10u",
               value2="Rser=0.5 Rpar={rfuga}")
    s.wire(c1[1], (176, BOT))
    r1 = s.sym("res", "R1", (480, TOP), "R0", value="4k")
    s.wire(r1[1], (480, BOT))
    s.rail(TOP, 176, 480)
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.wire((328, TOP), (328, TOP - 48))
    s.flag((328, TOP - 48), "v")

    s.directiva((X, 400),
                ".tran 0 200m 0 20u",
                ".ic V(v)=48",
                ".step param rfuga list 1G 10Meg 100k",
                ".meas TRAN v_0  FIND V(v) AT 0",
                ".meas TRAN t368 WHEN V(v)=17.66127",
                ".meas TRAN tau_teorico PARAM 10u*(4k*rfuga)/(4k+rfuga)",
                ".meas TRAN error_pct PARAM 100*(t368-0.04)/0.04")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "SEGUNDA PASADA -- EL RC DEL PROBLEMA 7.23 CON ESR Y CORRIENTE DE FUGA",
            "=" * 100,
            "El RC elegido para la segunda pasada es el 7.23 (R = 4 k, C = 10 uF, vC(0) = 48 V).",
            "",
            "LOS VALORES SUPUESTOS, DECLARADOS COMO PIDE LA GUIA",
            "  ESR (resistencia serie equivalente) = 0,5 ohm. Tipico de un electrolitico de aluminio de",
            "     10 uF / 63 V a 100 Hz. Sale de las hojas de datos, donde figura como tan(delta) o como",
            "     ESR a 120 Hz.",
            "  Rpar (fuga) = tres escenarios:",
            "     1 G     -- el ideal, para tener la referencia.",
            "     10 Meg  -- un electrolitico NUEVO. Las hojas de datos dan la fuga como",
            "                I <= 0,01*C*V (con C en uF y V en volt), que aca da 4,8 uA a 48 V, o sea",
            "                una resistencia equivalente de 48/4,8u = 10 Mohm.",
            "     100 k   -- el mismo capacitor ENVEJECIDO o caliente. La fuga de un electrolitico sube",
            "                con la temperatura y con las horas de servicio, y dos ordenes de magnitud",
            "                no es un caso extremo. Contesta directamente la pregunta de la guia sobre",
            "                temperatura y envejecimiento.",
        ],
        circuito=[
            "COMO SE MODELAN LOS PARASITOS DEL CAPACITOR",
            "  Igual que con la bobina, van en el campo Value2 del propio simbolo:",
            "     Rser=<ohm>   la ESR, en serie",
            "     Rpar=<ohm>   la fuga, en paralelo",
            "     Lser=<H>     la inductancia de los terminales (importa en conmutacion rapida, no aca)",
            "  Se llega con boton derecho sobre el capacitor. En esta hoja quedo",
            "  'Rser=0.5 Rpar={rfuga}': la ESR fija y la fuga como parametro barrido.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA",
            "  .step param rfuga list 1G 10Meg 100k    tres corridas superpuestas.",
            "  .meas TRAN tau_teorico PARAM 10u*(4k*rfuga)/(4k+rfuga)",
            "     La formula del paralelo escrita a mano. Sirve de control del control: si el t63 medido",
            "     y este tau_teorico no coinciden, el que esta mal es el modelo, no la medicion.",
        ],
        control=[
            "CONTROL Y CONCLUSION",
            "  La ESR NO HACE NADA ACA, y vale la pena entender por que antes de simular: esta en SERIE",
            "  con el capacitor, dentro de un lazo donde ya hay 4000 ohm. 0,5 sobre 4000,5 es un 0,012%.",
            "  La ESR importa cuando la resistencia del lazo es COMPARABLE a ella -- una fuente",
            "  conmutada, un desacople, una descarga sobre pocos ohm-- y este circuito no es ese caso.",
            "  La fuga esta en PARALELO con R1, asi que la R efectiva es el paralelo de las dos:",
            "     rfuga = 1 G     ->  R_ef = 3999,98 ohm   ->  tau = 40,000 ms   (referencia)",
            "     rfuga = 10 Meg  ->  R_ef = 3998,4 ohm    ->  tau = 39,984 ms   (-0,04%)",
            "     rfuga = 100 k   ->  R_ef = 3846,2 ohm    ->  tau = 38,462 ms   (-3,8%)",
            "  1. Diferencia: el valor inicial y el final no se mueven; lo unico que cambia es tau.",
            "  2. La explica la FUGA, no la ESR. Y solo se hace visible en el escenario envejecido.",
            "  3. EL MODELO IDEAL ALCANZA para el capacitor nuevo: 0,04% esta muy por debajo de la",
            "     tolerancia del propio capacitor, que en un electrolitico es de -20/+80%. Ese es el",
            "     punto que conviene no pasar por alto: el parasito es CHICO comparado con la",
            "     TOLERANCIA del componente nominal. Perseguir el 0,04% mientras el valor de C puede",
            "     estar 20% corrido es optimizar la parte equivocada.",
            "     Para el capacitor envejecido ya no alcanza: 3,8% es del orden de la tolerancia de una",
            "     resistencia del 5% y empieza a competir con ella.",
            "  4. MEDICION PROPUESTA: cargar el capacitor a 48 V, desconectarlo de todo y cronometrar",
            "     cuanto tarda en caer a 17,7 V con un voltimetro de alta impedancia (y RESTANDO el",
            "     efecto del propio voltimetro, que con 10 Mohm es del mismo orden que la fuga que se",
            "     quiere medir: ese es el error clasico de esta medicion). La ESR no se mide asi; se",
            "     mide con un medidor de ESR o leyendo tan(delta) en un puente LCR a 100 Hz.",
            "",
            "QUE GRAFICAR",
            "  Un panel con V(v) [V], las tres corridas. Las de 1 G y 10 Meg quedan una encima de la",
            "  otra --y eso ES el resultado: el parasito nominal no se ve--; la de 100 k se despega.",
            "  Para ver la de 10 Meg hay que graficar la DIFERENCIA, no la curva. Add Trace con la",
            "  expresion no alcanza (LTspice no resta entre pasos de .step directamente): la via",
            "  practica es leer los tres t63 del .log, que es justamente para lo que estan.",
        ] + CIERRE_NO_IDEAL,
        )
    g(s, "X2_no_ideal_RC_con_fuga.asc")


def x3_rlc(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    c1 = s.sym("cap", "C", (176, TOP), "R0", value="0.5u",
               value2="Rser={esr}")
    s.wire(c1[1], (176, BOT))
    r1 = s.sym("res", "R", (176, TOP), "R270", value="800")
    s.wire(r1[1], (480, TOP))
    l1 = s.sym("ind", "L", (480, TOP), "R0", value="80m",
               value2="Rser={dcr}")
    s.wire(l1[1], (480, BOT))
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.wire((176, TOP), (176, TOP - 48))
    s.flag((176, TOP - 48), "vc")
    s.wire((480, TOP), (480, TOP - 48))
    s.flag((480, TOP - 48), "m")

    s.directiva((X, 400),
                ".tran 0 3m 0 20n",
                ".ic V(vc)=20 I(L)=30m",
                ".param esr=table(k,0,1u,1,0.2)",
                ".param dcr=table(k,0,1u,1,6)",
                ".step param k list 0 1",
                ".meas TRAN R_total   PARAM 800+esr+dcr",
                ".meas TRAN alfa      PARAM (800+esr+dcr)/(2*80m)",
                ".meas TRAN omega0    PARAM 1/sqrt(80m*0.5u)",
                ".meas TRAN vc_max    MAX V(vc)",
                ".meas TRAN vc_1ms    FIND V(vc) AT 1m",
                ".meas TRAN R_crit_real PARAM 2*sqrt(80m/0.5u)-esr-dcr")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "SEGUNDA PASADA -- EL RLC DEL PROBLEMA 8.38 CON DCR Y ESR",
            "=" * 100,
            "El RLC elegido es el 8.38 (C = 0,5 uF, L = 80 mH, R = 800 ohm ajustada para amortiguamiento",
            "  critico, vC(0) = 20 V, iL(0) = 30 mA).",
            "",
            "LOS VALORES SUPUESTOS, DECLARADOS COMO PIDE LA GUIA",
            "  DCR de la bobina de 80 mH = 6 ohm. Una bobina de 80 mH con nucleo de ferrita y unos",
            "     cuantos cientos de vueltas de alambre de 0,3 mm ronda ese valor; los choques de 100 mH",
            "     de catalogo declaran entre 3 y 15 ohm.",
            "  ESR del capacitor de 0,5 uF = 0,2 ohm. Un film de poliester de ese valor esta por debajo",
            "     del ohm a las frecuencias de interes (aca omega0/2pi = 796 Hz).",
            "  Los dos son supuestos, no hojas de datos, y por eso estan escritos.",
        ],
        circuito=[
            "COMO SE MODELAN LOS PARASITOS, Y POR QUE ESTA VEZ SE SUMAN",
            "  Otra vez el campo Value2 de cada simbolo: Rser={dcr} en la bobina y Rser={esr} en el",
            "  capacitor. Y aca hay una diferencia importante con el caso RC: este circuito es un LAZO",
            "  SERIE, asi que las tres resistencias --la de diseno, la DCR y la ESR-- estan en serie y",
            "  se SUMAN directamente. En el RC del X2 la fuga estaba en PARALELO y por eso apenas movia",
            "  la aguja. La misma clase de parasito pesa distinto segun donde caiga en la topologia.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  .param esr=table(k,0,1u,1,0.2)",
            "     table() elige un valor segun otro parametro: 'si k vale 0, esr vale 1u; si k vale 1,",
            "     esr vale 0,2'. Es la forma de barrer DOS parasitos a la vez con un solo .step, porque",
            "     .step param ... list barre un parametro por vez. k=0 es el caso ideal y k=1 el real.",
            "  .step param k list 0 1     dos corridas: ideal y real.",
            "  .meas TRAN R_crit_real PARAM 2*sqrt(80m/0.5u)-esr-dcr",
            "     El valor al que habria que BAJAR la resistencia de diseno para que el circuito real",
            "     vuelva a ser criticamente amortiguado. Es la correccion de diseno, calculada por el",
            "     propio archivo.",
        ],
        control=[
            "CONTROL Y CONCLUSION",
            "  IDEAL (k=0):  R_total = 800 ohm ;  alfa = 800/(2*0,08) = 5000 = omega0  ->  CRITICO",
            "  REAL  (k=1):  R_total = 800 + 6 + 0,2 = 806,2 ohm",
            "                alfa = 806,2/0,16 = 5038,75 rad/s ;  omega0 = 5000 rad/s",
            "                alfa > omega0  ->  YA NO ES CRITICO: es SOBREAMORTIGUADO.",
            "                Las raices dejan de ser dobles y pasan a ser reales y distintas:",
            "                s = -5038,75 +/- sqrt(5038,75^2 - 5000^2) = -5038,75 +/- 621,5",
            "                s1 = -4417 1/s     s2 = -5660 1/s",
            "  Cuanto se nota en la curva: vc_1ms pasa de 0,404 V (ideal) a alrededor de 0,44 V. Es una",
            "  diferencia del 9% en la cola, y CERO en el valor inicial y en el final.",
            "  1. Diferencia: el REGIMEN cambia de categoria, aunque la curva casi no se mueva.",
            "  2. La explica la DCR de la bobina: aporta 6 de los 6,2 ohm de exceso. La ESR es el 3% del",
            "     total del parasito y podria ignorarse sin cambiar la conclusion.",
            "  3. EL MODELO IDEAL ALCANZA PARA PREDECIR LA CURVA Y NO ALCANZA PARA GARANTIZAR EL DISENO.",
            "     Esa es la conclusion util de esta hoja, y es mas fina que un si o un no: si lo que se",
            "     quiere es saber cuanto vale vC en 1 ms, el modelo ideal yerra un 9% y sirve. Si lo que",
            "     se quiere es AFIRMAR que el circuito esta criticamente amortiguado --por ejemplo",
            "     porque hay una especificacion de 'sin sobreimpulso'-- el modelo ideal miente: el",
            "     circuito real esta del otro lado de la frontera.",
            "     Y el amortiguamiento critico es una condicion de MEDIDA CERO: cualquier tolerancia lo",
            "     rompe. En la practica no se disena para el critico exacto, se disena levemente",
            "     sobreamortiguado, y esta hoja muestra por que.",
            "  4. MEDICION PROPUESTA: medir la DCR de la bobina con el ohmetro (desconectada, en",
            "     continua). Y para separarla del resto: excitar el lazo con una cuadrada de amplitud",
            "     chica y medir el DECREMENTO LOGARITMICO de la respuesta con R de diseno reducida a",
            "     proposito hasta que oscile. De dos picos consecutivos sale alfa, y de alfa sale la R",
            "     total del lazo: la diferencia contra 800 ohm es la suma DCR+ESR, medida por efecto.",
            "",
            "QUE GRAFICAR",
            "  Panel 1: V(vc) [V], las dos corridas. Van a parecer la misma curva: ESE es el hallazgo.",
            "           Un cambio de regimen puede no verse a simple vista.",
            "  Panel 2: I(L) [A], las dos.",
            "  Y la comprobacion que SI se ve: cambiar R de 800 a 640 y volver a correr. Con k=0 aparece",
            "  el sobreimpulso; con k=1 aparece mas chico. Ahi el parasito se nota, porque cerca del",
            "  critico la forma es muy sensible y lejos no.",
        ] + CIERRE_NO_IDEAL,
        )
    g(s, "X3_no_ideal_RLC_con_DCR_ESR.asc")


def todos(g, doc, x_txt):
    global X
    X = x_txt
    p8_01(g, doc)
    p8_38(g, doc)
    x1_rl(g, doc)
    x2_rc(g, doc)
    x3_rlc(g, doc)
