# bloque2.py -- Bloques 2 y 3 de la guia: circuitos RL y RC de primer orden.
# Problemas 7.1, 7.4, 7.8, 7.21, 7.23 y 7.25, mas dos hojas de .op que
# resuelven los estados previos (0-) sin simular nada en el tiempo.

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from asc import Sch                                              # noqa: E402
import comun as C                                                # noqa: E402

X = 64


def _integrador(s, expr, x0=960, ytop=144, ybot=304, nodo="wR"):
    """Nodo cuya TENSION es la integral de `expr` en el tiempo.

    Truco estandar de SPICE: una fuente de corriente controlada por la
    expresion cargando un capacitor de 1 F. Con C = 1 F, v = (1/C) int i dt
    = int expr dt, numericamente identico. Sirve para ver la energia
    acumulada COMO CURVA, que es lo que hace falta para poner un cursor
    donde llega al 80% o al 95%. El .meas INTEG da el mismo numero, pero no
    da la curva."""
    b = s.sym("bi", "B_E", (x0, ybot), "R180", value=expr)
    s.wire(b[1], (x0, ytop))
    ce = s.sym("cap", "C_E", (x0 + 160, ytop), "R0", value="1")
    s.wire(ce[1], (x0 + 160, ybot))
    re = s.sym("res", "R_E", (x0 + 320, ytop), "R0", value="1T")
    s.wire(re[1], (x0 + 320, ybot))
    s.rail(ytop, x0, x0 + 320)
    s.rail(ybot, x0, x0 + 320)
    s.wire((x0 + 160, ybot), (x0 + 160, ybot + 48))
    s.tierra((x0 + 160, ybot + 48))
    s.wire((x0 + 80, ytop), (x0 + 80, ytop - 48))
    s.flag((x0 + 80, ytop - 48), nodo)


NOTA_INTEGRADOR = [
    "EL NODO wR: LA ENERGIA DIBUJADA COMO CURVA",
    "  B_E es una fuente de corriente COMPORTAMENTAL (simbolo 'bi', prefijo B): su valor no es un",
    "  numero sino una expresion, y vale en cada instante lo que valga la potencia instantanea.",
    "  Esa corriente carga C_E = 1 F. Como v = (1/C)*int(i dt) y C vale exactamente 1, la tension",
    "  del nodo wR ES la integral de la potencia, o sea la energia en joules, numero por numero.",
    "  R_E = 1 T solo le da al nodo el camino de continua a masa que el netlist exige; con 1 F la",
    "  constante de fuga es de 10^12 s, asi que no descarga nada en la ventana de la simulacion.",
    "  Esta rama NO toca el circuito: la fuente B lee tensiones y corrientes, no carga el nodo.",
    "  Se podria conseguir el mismo numero con .meas INTEG, y de hecho tambien esta puesto. La",
    "  diferencia es que .meas da UN numero y wR da la CURVA, y la guia pide poner un cursor donde",
    "  la energia llega a un porcentaje: para eso hace falta la curva.",
    "  Y UNA TRAMPA QUE COSTO UNA CORRIDA: el nodo wR NECESITA .ic V(wR)=0. Sin eso, el punto de",
    "  reposo inicial resuelve esa rama con la potencia de t=0 entrando a un resistor de 1 T, y wR",
    "  arranca en 10^14 V. El .meas no falla ni avisa: devuelve un numero enorme, del tipo que se",
    "  confunde con un error de unidades. Medido aca: daba 4e14 J donde tenia que dar 80 mJ.",
]


# ==========================================================================
def p7_01(g, doc):
    s = Sch(2000, 2800)
    TOP, BOT = 112, 304

    v1 = s.sym("voltage", "V1", (96, TOP), "R0", value="40")
    s.wire(v1[1], (96, BOT))
    r1 = s.sym("res", "R1", (96, TOP), "R270", value="500")
    s.wire(r1[1], (240, TOP))
    sw = s.sym("sw", "S1", (240, TOP), "R270", value="SW")
    s.wire(sw[1], (400, TOP))
    r2 = s.sym("res", "R2", (400, TOP), "R0", value="2k")
    s.wire(r2[1], (400, BOT))
    r3 = s.sym("res", "R3", (400, TOP), "R270", value="6k")
    s.wire(r3[1], (608, TOP))
    l1 = s.sym("ind", "L1", (608, TOP), "R0", value="400m", value2="Rser=0")
    s.wire(l1[1], (608, BOT))
    s.rail(BOT, 96, 608)
    s.wire((528, BOT), (528, BOT + 48))
    s.tierra((528, BOT + 48))

    s.wire((400, TOP), (400, TOP - 48))
    s.flag((400, TOP - 48), "A")
    s.wire((608, TOP), (608, TOP - 48))
    s.flag((608, TOP - 48), "B")

    s.wire(sw[3], (sw[3][0], 208))          # NC- a masa
    s.tierra((sw[3][0], 208))
    s.wire(sw[2], (sw[2][0], 208))          # NC+ al mando
    s.flag((sw[2][0], 208), "ctl")

    vc = s.sym("voltage", "Vctl", (880, TOP), "R0",
               value="PULSE(1 0 1m 1n 1n 1 2)")
    s.wire(vc[0], (880, TOP - 48))
    s.flag((880, TOP - 48), "ctl")
    s.wire(vc[1], (880, BOT))
    s.tierra((880, BOT))

    s.directiva((X, 400),
                ".tran 0 1.4m 0 50n",
                C.MODELO_SW,
                ".meas TRAN i1_antes  FIND I(R3) AT 0.9m",
                ".meas TRAN i2_antes  FIND I(R2) AT 0.9m",
                ".meas TRAN i1_desp   FIND I(R3) AT 1.00001m",
                ".meas TRAN i2_desp   FIND I(R2) AT 1.00001m",
                ".meas TRAN vB_desp   FIND V(B)  AT 1.00001m",
                ".meas TRAN t63       WHEN I(R3)=1.83940m TD=1.0000001m",
                ".meas TRAN tau       PARAM t63-1m")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 7.1 (Nilsson y Riedel) -- CONMUTACION Y CONTINUIDAD DE LA CORRIENTE DE BOBINA",
            "Actividad asincronica -- Bloque 2: circuitos RL de primer orden",
            "=" * 100,
            "Enunciado: el conmutador estuvo cerrado mucho tiempo y se ABRE en t=0. Determinar i1 e i2",
            "  en 0- y en 0+, sus expresiones para t>=0, y explicar por que i2(0-) es distinta de i2(0+).",
            "  Datos: 40 V, 500 ohm en serie con el conmutador, 2 k en paralelo, y 6 k en serie con 400 mH.",
        ],
        circuito=[
            "EL CIRCUITO, Y LA DECISION DE MODELAR EL CONMUTADOR EN VEZ DE USAR .ic",
            "  Nodos: A (donde se juntan el conmutador, R2 y R3) y B (entre R3 y la bobina).",
            "  i1 = I(R3), la corriente que baja por la rama 6 k + bobina, con el signo positivo de A a B.",
            "  i2 = I(R2), la corriente que baja por los 2 k, con el signo positivo de A a masa.",
            "  Aca el conmutador SE DIBUJA (S1, un interruptor controlado por tension) en vez de cargar",
            "  la condicion inicial con .ic. El motivo es el enunciado: lo que se pregunta es justamente",
            "  la comparacion entre el ANTES y el DESPUES del mismo instante. Con .ic solo existiria el",
            "  despues, y el apartado (e) --por que i2 salta-- se quedaria sin la mitad de la evidencia.",
            "  EL CERO DEL PROBLEMA ES 1 ms DE LA SIMULACION. LTspice no simula tiempos negativos, asi",
            "  que el conmutador se abre en t=1 ms y el milisegundo previo es la carrera de arranque que",
            "  deja al circuito en regimen. 1 ms son 16 constantes de tiempo del estado previo",
            "  (tau_previo = 400 mH / (6k + 2k//500) = 62,5 us), o sea que en 0,9 ms ya no queda nada",
            "  del arranque. Al leer los resultados, restar 1 ms.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  .model SW SW(Ron=1m Roff=1G Vt=0.5 Vh=0)",
            "     Define el modelo del interruptor S1. Ron es lo que vale cerrado (1 mohm contra los",
            "     500 ohm de R1: invisible) y Roff lo que vale abierto (1 Gohm: abierto de verdad).",
            "     Vt es el umbral de la tension de mando y Vh la histeresis. El nombre 'SW' del modelo",
            "     tiene que coincidir con el campo Value del simbolo S1.",
            "  Vctl PULSE(1 0 1m 1n 1n 1 2)",
            "     La tension de mando: arranca en 1 V, cae a 0 V a los 1 ms, con flancos de 1 ns.",
            "     Como Vt = 0,5 V, el interruptor esta CERRADO mientras el mando vale 1 y ABIERTO",
            "     despues. Los dos ultimos numeros (Ton=1 s, Tperiod=2 s) son mas largos que toda la",
            "     simulacion: es la forma de decir 'un solo flanco y listo'.",
            "  .tran 0 1.4m 0 50n",
            "     1,4 ms = 1 ms de arranque + 8 constantes de tiempo del transitorio. Paso maximo 50 ns",
            "     = tau/1000, muy por debajo del tau/100 que pide la guia, porque el instante que",
            "     interesa es un salto y ahi la resolucion se paga barata.",
            "  .meas ... TD=1.0000001m",
            "     TD le dice al .meas 'no empieces a buscar el cruce hasta despues de este instante'.",
            "     Sin eso, WHEN I(R3)=1,8394 mA encontraria primero un cruce durante el arranque.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  ANTES (conmutador cerrado, regimen permanente: la bobina es un cortocircuito)",
            "    2k // 6k = 1,5 k ;  total = 500 + 1500 = 2 k ;  corriente de la fuente = 40/2k = 20 mA",
            "    V(A) = 20 mA * 1,5 k = 30 V ;  V(B) = 0 (la bobina esta en corto)",
            "    i1(0-) = 30/6k = 5 mA        i2(0-) = 30/2k = 15 mA",
            "  DESPUES (conmutador abierto: la fuente y los 500 ohm desaparecen del circuito)",
            "    Queda un lazo unico: bobina + 6 k + 2 k = 8 k.   tau = L/R = 400 mH / 8 k = 50 us",
            "    i1(0+) = i1(0-) = 5 mA        <- ES LA CORRIENTE DE LA BOBINA, y esa no puede saltar",
            "    i2(0+) = -5 mA                <- la MISMA corriente, pero ahora sube por los 2 k",
            "    i1(t) = 5*e^(-20000 t) mA     i2(t) = -5*e^(-20000 t) mA",
            "    V(B) en 0+ = -40 V  (400 mH * di/dt = 0,4 * (-5m/50u) = -40 V)",
            "  POR QUE i2 SALTA Y i1 NO (apartado e):",
            "    La ley de continuidad vale para la corriente de la BOBINA, no para cualquier rama. i1",
            "    es la corriente de la bobina, y por eso es continua. i2 es una corriente de rama",
            "    resistiva: antes la alimentaba la fuente hacia abajo, y despues la alimenta la bobina",
            "    hacia arriba. Nada obliga a que coincidan, y de hecho pasa de +15 mA a -5 mA de golpe.",
            "  Lo que tiene que confirmar la simulacion (restando 1 ms a los tiempos):",
            "    i1_antes = 5 mA    i2_antes = 15 mA    i1_desp = 5 mA    i2_desp = -5 mA",
            "    vB_desp = -40 V    tau = 50 us",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  I(R3) y I(R2) juntas [A]. Es el unico grafico de esta hoja donde dos trazas SI",
            "            van en el mismo eje: tienen la misma unidad y el mismo orden de magnitud, y la",
            "            gracia es ver en el mismo instante que una es continua y la otra salta.",
            "  Panel 2:  V(B) [V], para ver los -40 V del pico inductivo.",
            "  Escala X: acotar a 0,95 ms .. 1,3 ms (boton derecho sobre el eje X). Con el eje completo,",
            "            el salto queda comprimido contra el milisegundo de arranque y no se ve.",
            "  Cursores: 1st en 0,999 ms y 2nd en 1,001 ms sobre I(R2). La diferencia que informa la",
            "            ventanita es el salto de 20 mA, medido y no estimado.",
        ],
        )
    g(s, "P7-01_conmutacion_continuidad_iL.asc")


def p7_01b(g, doc):
    s = Sch(1800, 1800)
    TOP, BOT = 112, 304
    v1 = s.sym("voltage", "V1", (96, TOP), "R0", value="40")
    s.wire(v1[1], (96, BOT))
    r1 = s.sym("res", "R1", (96, TOP), "R270", value="500")
    s.wire(r1[1], (400, TOP))
    r2 = s.sym("res", "R2", (400, TOP), "R0", value="2k")
    s.wire(r2[1], (400, BOT))
    r3 = s.sym("res", "R3", (400, TOP), "R270", value="6k")
    s.wire(r3[1], (608, TOP))
    l1 = s.sym("ind", "L1", (608, TOP), "R0", value="400m", value2="Rser=0")
    s.wire(l1[1], (608, BOT))
    s.rail(BOT, 96, 608)
    s.wire((528, BOT), (528, BOT + 48))
    s.tierra((528, BOT + 48))
    s.wire((400, TOP), (400, TOP - 48))
    s.flag((400, TOP - 48), "A")
    s.wire((608, TOP), (608, TOP - 48))
    s.flag((608, TOP - 48), "B")

    s.directiva((X, 400), ".op")

    doc(s, 560,
        cabecera=[
            "=" * 100,
            "PROBLEMA 7.1, APARTADO (a) -- EL ESTADO PREVIO RESUELTO CON .op, SIN SIMULAR EL TIEMPO",
            "=" * 100,
            "Este archivo es el companero de P7-01. Es el MISMO circuito con el conmutador CERRADO --",
            "  dibujado como un cable, que es lo que es un interruptor cerrado ideal-- y una sola",
            "  directiva: .op. Existe para mostrar cual es la herramienta correcta para una pregunta de",
            "  regimen permanente. Preguntar 'cuanto vale i1 en 0-' es preguntar por el PUNTO DE REPOSO,",
            "  y para eso no hace falta ningun transitorio.",
        ],
        circuito=[
            "EL CIRCUITO",
            "  Identico a P7-01 pero sin S1 ni Vctl: en 0- el conmutador esta cerrado y un interruptor",
            "  cerrado ideal es un cable. Sacarlo del dibujo no es simplificar: es dibujar el circuito",
            "  que efectivamente existe en el instante que se esta analizando.",
        ],
        directivas=[
            "LA UNICA DIRECTIVA: .op -- Y QUE HACE EXACTAMENTE",
            "  .op resuelve el circuito en CONTINUA PERMANENTE. Antes de resolver aplica dos reemplazos,",
            "  que son los mismos que uno hace a mano:",
            "     todo CAPACITOR pasa a ser un circuito abierto  (en continua no circula corriente)",
            "     toda BOBINA pasa a ser un cortocircuito         (en continua no hay caida de tension)",
            "  y despues resuelve el sistema resistivo que queda, por analisis nodal modificado.",
            "  No hay eje de tiempo, no hay paso de integracion y no hay condiciones iniciales: no",
            "  aplica ninguna de las tres cosas. Por eso .op no lleva argumentos.",
            "  DONDE SE LEE EL RESULTADO: al terminar, LTspice abre solo la ventana del SPICE Error Log",
            "  con la tabla completa --una linea por nodo con su tension y una linea por elemento con su",
            "  corriente--. Si se cierra, se vuelve a abrir con Ctrl+L. Ademas, al pasar el mouse por",
            "  encima de un nodo o de un elemento en la hoja, la barra de estado muestra su valor.",
            "  NO SE GRAFICA NADA: un punto de reposo es un numero por variable, no una curva. Si al",
            "  correrlo se abre un panel de formas de onda vacio, no es un error.",
        ],
        control=[
            "CONTROL -- LO QUE TIENE QUE DEVOLVER EL .log",
            "    V(A) = 30 V        V(B) = 0 V  (la bobina en corto pone B a masa)",
            "    I(R3) = i1(0-) = 5 mA          I(R2) = i2(0-) = 15 mA",
            "    I(L1) = 5 mA                   I(R1) = 20 mA  (la corriente total de la fuente)",
            "  Comprobacion cruzada: I(R2) + I(R3) tiene que dar I(R1). 15 + 5 = 20 mA. Si no cierra,",
            "  hay un cable que no toca un pin, y el .op lo delata sin necesidad de mirar ninguna curva.",
            "  El numero que importa para P7-01 es I(L1) = 5 mA: es la unica variable que sobrevive al",
            "  instante de la conmutacion, y es la condicion inicial del transitorio.",
        ],
        con_ic=False, con_meas=False)
    g(s, "P7-01b_estado_previo_con_op.asc")


def p7_04(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    l1 = s.sym("ind", "L1", (176, BOT), "R180", value="8")
    s.wire(l1[1], (176, TOP))
    r1 = s.sym("res", "R1", (480, TOP), "R0", value="40")
    s.wire(r1[1], (480, BOT))
    s.rail(TOP, 176, 480)
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.wire((328, TOP), (328, TOP - 48))
    s.flag((328, TOP - 48), "v")

    _integrador(s, "I=V(v)*I(R1)")

    s.directiva((X, 400),
                ".tran 0 1.2 0 200u",
                ".ic I(L1)=10 V(wR)=0",
                ".meas TRAN v_0   FIND V(v) AT 0",
                ".meas TRAN i_0   FIND I(L1) AT 0",
                ".meas TRAN R_med PARAM v_0/i_0",
                ".meas TRAN t63   WHEN I(L1)=3.678794",
                ".meas TRAN L_med PARAM R_med*t63",
                ".meas TRAN W0    PARAM 0.5*8*i_0*i_0",
                ".meas TRAN t80   WHEN V(wR)=320",
                ".meas TRAN W_int INTEG V(v)*I(R1) FROM 0 TO 0.16094")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 7.4 (Nilsson y Riedel) -- RECONSTRUIR R, tau, L Y LA ENERGIA DESDE LA RESPUESTA",
            "Actividad asincronica -- Bloque 2: circuitos RL de primer orden",
            "=" * 100,
            "Enunciado: en el circuito de la Figura P7.4 (una bobina L en paralelo con una resistencia R,",
            "  respuesta natural) las ecuaciones son v = 400*e^(-5t) V e i = 10*e^(-5t) A. Determinar R,",
            "  tau, L, la energia inicial de la bobina y el tiempo que tarda en disiparse el 80% de ella.",
        ],
        circuito=[
            "EL CIRCUITO, Y UN DETALLE DE ORIENTACION QUE CAMBIA TODOS LOS SIGNOS",
            "  Dos elementos y un nodo: L1 y R1 entre el nodo v y masa. No hay fuente: es una respuesta",
            "  NATURAL, la bobina se descarga sobre la resistencia y nada mas.",
            "  L1 ESTA DIBUJADA GIRADA 180 GRADOS A PROPOSITO. En el netlist, I(Lx) es positiva cuando",
            "  la corriente entra por el pin A (el primer nodo). Con la bobina en la posicion normal el",
            "  pin A queda arriba y la corriente del enunciado --que sube por la bobina y sale hacia la",
            "  resistencia-- saldria como -10 A. Girandola, el pin A queda contra masa, I(L1) sale +10 A",
            "  y coincide con la i del libro. Es exactamente la trampa de la regla 3 del netlist: un",
            "  elemento al reves no da error, da el signo cambiado, que es peor.",
        ] + NOTA_INTEGRADOR,
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  .ic I(L1)=10",
            "     La bobina arranca con 10 A. Es TODO el estado inicial que necesita este problema: no",
            "     hay condicion inicial de capacitor porque no hay capacitor, y no hay conmutador porque",
            "     el enunciado ya entrega la respuesta empezada.",
            "  .tran 0 1.2 0 200u",
            "     1,2 s = 6 constantes de tiempo (tau = 200 ms): a esa altura queda el 0,25% y la curva",
            "     ya es plana. Paso maximo 200 us = tau/1000.",
            "  .meas TRAN t63 WHEN I(L1)=3.678794",
            "     3,678794 A es 10 A dividido e. El instante en que la corriente llega a ese valor ES la",
            "     constante de tiempo, por definicion. Asi se mide tau sin depender de leer un exponente.",
            "  .meas TRAN t80 WHEN V(wR)=320",
            "     320 J es el 80% de los 400 J iniciales. Como V(wR) es la energia ya disipada, el",
            "     instante en que cruza 320 contesta el apartado (e) directamente.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  a) R = v/i = 400/10 = 40 ohm.  Es constante: los dos exponentes son iguales, asi que el",
            "     cociente no depende del tiempo. Ese es el control -- si v/i variara, no seria una",
            "     respuesta natural de un RL simple.",
            "  b) el exponente es -t/tau = -5t  ->  tau = 1/5 = 0,2 s = 200 ms",
            "  c) tau = L/R  ->  L = tau*R = 0,2 * 40 = 8 H",
            "  d) w(0) = 1/2 L i(0)^2 = 0,5 * 8 * 10^2 = 400 J",
            "  e) LA ENERGIA DECAE COMO e^(-2t/tau), NO COMO e^(-t/tau): w es proporcional a i^2, y el",
            "     cuadrado de una exponencial duplica el exponente. Queda el 20% cuando",
            "        e^(-2t/tau) = 0,2  ->  t = (tau/2)*ln(5) = 0,1 * 1,60944 = 160,94 ms",
            "     Ese factor 2 es el error mas repetido del bloque: con e^(-t/tau) daria 321,9 ms, el",
            "     doble, y la curva simulada 'tambien pareceria' confirmarlo si no se mira el numero.",
            "  Lo que tiene que confirmar la simulacion:",
            "    v_0 = 400 V   i_0 = 10 A   R_med = 40 ohm   t63 = 200 ms   L_med = 8 H",
            "    W0 = 400 J    t80 = 160,94 ms    W_int = 320 J",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  I(L1) [A] y, si se quiere ver el cociente constante, V(v)/I(L1) (tiene que ser",
            "            una recta horizontal en 40).",
            "  Panel 2:  V(v) [V].",
            "  Panel 3:  V(wR) [J], la energia disipada acumulada. Cursor donde cruza 320 J: ese cursor",
            "            ES la respuesta del apartado (e), leida sobre la curva como pide la guia.",
            "  Tres paneles y no uno: 400 V, 10 A y 400 J no comparten escala.",
        ],
        )
    g(s, "P7-04_RL_reconstruir_parametros.asc")


def p7_08(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    l1 = s.sym("ind", "L1", (176, TOP), "R0", value="8m", value2="Rser=1u")
    s.wire(l1[1], (176, BOT))
    r1 = s.sym("res", "R1", (400, TOP), "R0", value="8")
    s.wire(r1[1], (400, BOT))
    l2 = s.sym("ind", "L2", (624, TOP), "R0", value="2m", value2="Rser=1u")
    s.wire(l2[1], (624, BOT))
    s.rail(TOP, 176, 624)
    s.rail(BOT, 176, 624)
    s.wire((288, BOT), (288, BOT + 48))
    s.tierra((288, BOT + 48))
    s.wire((512, TOP), (512, TOP - 48))
    s.flag((512, TOP - 48), "b")

    _integrador(s, "I=V(b)*I(R1)")

    s.directiva((X, 400),
                ".tran 0 1.5m 0 100n",
                ".ic I(L1)=10 I(L2)=0 V(wR)=0",
                ".meas TRAN io_0    FIND I(R1) AT 0",
                ".meas TRAN v_0     FIND V(b)  AT 0",
                ".meas TRAN t63     WHEN I(R1)=-3.678794",
                ".meas TRAN W0      PARAM 0.5*8m*100",
                ".meas TRAN W_disip FIND V(wR) AT 1.5m",
                ".meas TRAN t95     WHEN V(wR)=0.076",
                ".meas TRAN n_taus  PARAM t95/t63",
                ".meas TRAN i8_fin  FIND I(L1) AT 1.5m",
                ".meas TRAN i2_fin  FIND I(L2) AT 1.5m")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 7.8 (Nilsson y Riedel) -- DESCARGA RL Y BALANCE DE ENERGIA",
            "Actividad asincronica -- Bloque 2: circuitos RL de primer orden",
            "=" * 100,
            "Enunciado: el conmutador estuvo en la posicion a mucho tiempo y en t=0 pasa a b. Calcular",
            "  io(t) para t>=0, la energia total entregada a la resistencia de 8 ohm, y cuantas",
            "  constantes de tiempo tarda en entregarse el 95% de esa energia.",
            "  Circuito original: fuente de 12 A con 150 ohm en paralelo, 30 ohm hasta el conmutador, la",
            "  bobina de 8 mH colgando del polo, y del lado b la resistencia de 8 ohm con 2 mH en paralelo.",
        ],
        circuito=[
            "EL CIRCUITO QUE SE SIMULA, Y POR QUE ES SOLO LA MITAD DEL DIBUJO DEL LIBRO",
            "  Despues de la conmutacion, la fuente, los 150 ohm y los 30 ohm quedan DESCONECTADOS: no",
            "  participan del transitorio. Lo unico que sobrevive del estado previo es la corriente de la",
            "  bobina de 8 mH, y eso entra por .ic. Simular el circuito completo con un conmutador aca",
            "  no agregaria informacion y traeria un problema: un conmutador que abre ANTES de cerrar",
            "  interrumpe la corriente de una bobina, que es una derivada infinita.",
            "  El estado previo esta resuelto aparte, con .op, en P7-08b.",
            "  Quedan tres elementos en paralelo entre el nodo b y masa: L1 = 8 mH (la que traia los",
            "  10 A), R1 = 8 ohm, y L2 = 2 mH (descargada).",
            "  io es I(R1): la corriente que BAJA por los 8 ohm, que es el sentido que marca el libro.",
        ] + NOTA_INTEGRADOR,
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  .ic I(L1)=10 I(L2)=0",
            "     Dos condiciones iniciales en una sola directiva, separadas por espacios. L1 arranca con",
            "     los 10 A que traia y L2 con cero, porque hasta la conmutacion estaba en un lazo abierto.",
            "  .tran 0 1.5m 0 100n",
            "     1,5 ms = 7,5 constantes de tiempo (tau = 200 us). Paso maximo tau/2000.",
            "  .meas TRAN t63 WHEN I(R1)=-3.678794",
            "     El valor de cruce lleva SIGNO MENOS. io arranca en -10 A, asi que su valor a un tau es",
            "     -10/e = -3,678794 A. Escribirlo positivo haria fallar la medicion, y el .log diria",
            "     simplemente 'measurement fail': una alarma muda que conviene reconocer.",
            "  .meas TRAN W0 PARAM 0.5*8m*100",
            "     Energia magnetica inicial calculada, no medida, para tenerla al lado de la disipada.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  ESTADO PREVIO (ver P7-08b): con la bobina en corto, V(nodo) = 12 A * (150//30) = 300 V,",
            "    y la corriente por los 30 ohm es 300/30 = 10 A. Esa es iL(0-) = iL(0+) = 10 A.",
            "  DESPUES: dos bobinas en paralelo se combinan como resistencias en paralelo,",
            "    Leq = 8m*2m/(8m+2m) = 1,6 mH  ->  tau = Leq/R = 1,6 mH / 8 ohm = 200 us",
            "    v(0+) = -8 ohm * 10 A = -80 V     io(0+) = -10 A",
            "    io(t) = -10*e^(-5000 t) A",
            "  a) io(t) = -10*e^(-t/200us) A",
            "  b) Energia entregada a los 8 ohm = integral de i^2*R = 100*8/(2*5000) = 80 mJ",
            "     Y el balance cierra asi: la energia inicial es 1/2*8mH*10^2 = 400 mJ, pero NO se",
            "     disipa toda. Cuando la tension llega a cero queda una corriente circulando entre las",
            "     dos bobinas: la integral de v dt vale -80/5000 = -16 mWb, con lo que",
            "        i8(inf) = 10 - 16m/8m = +8 A      i2(inf) = 0 - 16m/2m = -8 A",
            "     y la energia ATRAPADA es 1/2*8m*64 + 1/2*2m*64 = 256 + 64 = 320 mJ.",
            "        400 mJ - 320 mJ = 80 mJ, que es justo lo que se disipo. El balance cierra.",
            "     Ojo: el control que enuncia la guia --'toda la energia inicial termina en la",
            "     resistencia'-- vale para una red que TERMINA con iL=0. Esta no: dos bobinas ideales en",
            "     paralelo dejan una corriente circulando para siempre. Es el caso analogo a la carga",
            "     atrapada del 7.21, del otro lado de la dualidad.",
            "  c) 95% de los 80 mJ: 1-e^(-2t/tau) = 0,95 -> t = (tau/2)*ln(20) = 299,6 us = 1,50 tau",
            "  Lo que tiene que confirmar la simulacion:",
            "    io_0 = -10 A   v_0 = -80 V   t63 = 200 us   W_disip = 80 mJ",
            "    t95 = 299,6 us   n_taus = 1,50   i8_fin = 8 A   i2_fin = -8 A",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  I(R1) [A] -- io, de -10 A a cero.",
            "  Panel 2:  I(L1) e I(L2) juntas [A] -- se ve como una cae de 10 a 8 y la otra baja de 0 a",
            "            -8, y como se quedan ahi. Es la imagen de la energia atrapada.",
            "  Panel 3:  V(wR) [J] -- la energia entregada a la resistencia. Cursor en 76 mJ (el 95%).",
            "  Panel 4:  V(b) [V] -- el pico de -80 V.",
        ],
        )
    g(s, "P7-08_RL_descarga_balance_energia.asc")


def p7_08b(g, doc):
    s = Sch(1800, 1600)
    TOP, BOT = 112, 304
    i1 = s.sym("current", "I1", (176, BOT), "R180", value="12")
    s.wire(i1[1], (176, TOP))
    r150 = s.sym("res", "R150", (400, TOP), "R0", value="150")
    s.wire(r150[1], (400, BOT))
    r30 = s.sym("res", "R30", (400, TOP), "R270", value="30")
    s.wire(r30[1], (624, TOP))
    l1 = s.sym("ind", "L1", (624, TOP), "R0", value="8m", value2="Rser=1u")
    s.wire(l1[1], (624, BOT))
    s.rail(TOP, 176, 400)
    s.rail(BOT, 176, 624)
    s.wire((288, BOT), (288, BOT + 48))
    s.tierra((288, BOT + 48))
    s.wire((400, TOP), (400, TOP - 48))
    s.flag((400, TOP - 48), "n1")

    s.directiva((X, 400), ".op")

    doc(s, 560,
        cabecera=[
            "=" * 100,
            "PROBLEMA 7.8 -- EL ESTADO PREVIO (t < 0) RESUELTO CON .op",
            "=" * 100,
            "Companero de P7-08. Es el circuito con el conmutador en la posicion a, o sea la fuente de",
            "  12 A, los 150 ohm, los 30 ohm y la bobina de 8 mH. Una sola directiva: .op.",
            "  Contesta la unica pregunta que el transitorio necesita del pasado: cuanto vale iL(0-).",
        ],
        circuito=[
            "EL CIRCUITO",
            "  I1 = 12 A inyectando al nodo n1 (girada 180 grados para inyectar y no drenar), R150 de n1",
            "  a masa, R30 de n1 a la bobina, y la bobina a masa.",
            "  Del lado b no hay nada dibujado: en la posicion a esa rama esta desconectada, y una rama",
            "  desconectada no se dibuja atada por un lado, se saca.",
        ],
        directivas=[
            "LA UNICA DIRECTIVA: .op",
            "  Reemplaza la bobina por un cortocircuito y resuelve el circuito resistivo que queda. Es",
            "  literalmente el mismo paso que uno hace a mano al escribir 'en regimen la bobina es un",
            "  cable'. El resultado sale en el SPICE Error Log (Ctrl+L).",
            "  Notar que aca .op es EXACTO, no aproximado: en continua permanente una bobina ideal tiene",
            "  cero volt entre bornes, y eso no es una simplificacion del simulador sino la definicion.",
        ],
        control=[
            "CONTROL -- LO QUE TIENE QUE DEVOLVER EL .log",
            "  Con la bobina en corto, los 30 ohm quedan de n1 a masa, en paralelo con los 150:",
            "     150 // 30 = 25 ohm      V(n1) = 12 A * 25 ohm = 300 V",
            "     I(R30) = 300/30 = 10 A       I(R150) = 300/150 = 2 A       suma = 12 A, la de la fuente",
            "     I(L1)  = 10 A   <- ESTE es el numero que P7-08 carga con .ic",
            "     V del nodo entre R30 y L1 = 0 V (la bobina esta en corto)",
        ],
        con_ic=False, con_meas=False)
    g(s, "P7-08b_estado_previo_con_op.asc")


def p7_21(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    c1 = s.sym("cap", "C1", (176, TOP), "R0", value="1u")
    s.wire(c1[1], (176, BOT))
    r1 = s.sym("res", "R1", (176, TOP), "R270", value="25k")
    s.wire(r1[1], (480, TOP))
    c2 = s.sym("cap", "C2", (480, TOP), "R0", value="4u")
    s.wire(c2[1], (480, BOT))
    rf = s.sym("res", "Rfuga", (704, TOP), "R0", value="1G")
    s.wire(rf[1], (704, BOT))
    s.wire((480, TOP), (704, TOP))
    s.rail(BOT, 176, 704)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.wire((176, TOP), (176, TOP - 48))
    s.flag((176, TOP - 48), "v1")
    s.wire((560, TOP), (560, TOP - 48))
    s.flag((560, TOP - 48), "v2")

    _integrador(s, "I=(V(v1)-V(v2))*I(R1)")

    s.directiva((X, 400),
                ".tran 0 300m 0 10u",
                ".ic V(v1)=40 V(v2)=0 V(wR)=0",
                ".meas TRAN i_0     FIND I(R1) AT 0",
                ".meas TRAN t63     WHEN I(R1)=0.588600m",
                ".meas TRAN v1_fin  FIND V(v1) AT 300m",
                ".meas TRAN v2_fin  FIND V(v2) AT 300m",
                ".meas TRAN W0      PARAM 0.5*1u*40*40",
                ".meas TRAN W_atrap PARAM 0.5*1u*v1_fin*v1_fin+0.5*4u*v2_fin*v2_fin",
                ".meas TRAN W_disip FIND V(wR) AT 300m")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 7.21 (Nilsson y Riedel) -- CONMUTACION, ENERGIA Y CARGA ATRAPADA",
            "Actividad asincronica -- Bloque 3: circuitos RC de primer orden",
            "=" * 100,
            "Enunciado: el conmutador estuvo en a mucho tiempo y en t=0 pasa a b. Calcular i, v1 y v2",
            "  para t>=0+, la energia almacenada en el capacitor en t=0, y la energia atrapada mas la",
            "  disipada en los 25 k si el conmutador se queda en b indefinidamente.",
            "  Datos: 40 V y 3,3 k del lado a; 1 uF (v1); 25 k; 4 uF (v2).",
        ],
        circuito=[
            "EL CIRCUITO QUE SE SIMULA",
            "  En la posicion a, la fuente de 40 V carga C1 a traves de los 3,3 k hasta 40 V, y C2 queda",
            "  descargado. Eso deja el estado inicial completo: v1(0)=40 V, v2(0)=0. En la posicion b la",
            "  fuente y los 3,3 k desaparecen y queda C1 -- 25 k -- C2, que es lo que esta dibujado.",
            "  Rfuga de 1 G NO ES PARTE DEL PROBLEMA: v1 y v2 se conectan a masa unicamente a traves de",
            "  capacitores, y todo nodo necesita camino de continua a la referencia. 1 G contra 25 k es",
            "  una parte en 40.000, y la constante de fuga que introduce es de 1G*0,8uF = 800 s, contra",
            "  los 20 ms del transitorio: cuatro ordenes de magnitud de separacion.",
            "  Un capacitor real, ademas, tiene fuga: el modelo con Rfuga es MAS realista, no menos.",
        ] + NOTA_INTEGRADOR,
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  .ic V(v1)=40 V(v2)=0",
            "     Las dos condiciones iniciales de tension. Es la forma correcta de entrar a la posicion",
            "     b sin dibujar el conmutador ni el estado previo: lo unico que cruza el instante t=0",
            "     son las dos tensiones de capacitor, y las dos estan puestas.",
            "  .tran 0 120m 0 10u",
            "     300 ms = 15 constantes de tiempo (tau = 20 ms). Con 6 tau NO alcanza y esta medido: a",
            "     los 120 ms todavia quedaban 99 mV de diferencia entre v1 y v2, y las tensiones finales",
            "     leian 8,08 V y 7,98 V en vez de 8,00 V. Un valor ASINTOTICO se mide donde la asintota",
            "     ya se alcanzo, y 6 tau (0,25% restante) no es suficiente para tres cifras.",
            "  .meas TRAN W_atrap PARAM ...",
            "     Suma las dos energias finales, 1/2 C v^2 en cada capacitor, usando las tensiones",
            "     medidas. No es una simulacion nueva: es aritmetica sobre resultados anteriores.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  Dos capacitores en SERIE (desde el punto de vista del lazo): Ceq = 1*4/(1+4) = 0,8 uF",
            "  tau = R*Ceq = 25 k * 0,8 uF = 20 ms",
            "  i(0+) = (v1(0)-v2(0))/R = 40/25k = 1,6 mA        i(t) = 1,6*e^(-50 t) mA",
            "  v1(t) = 8 + 32*e^(-50 t) V        v2(t) = 8 - 8*e^(-50 t) V",
            "  Control cruzado: v1 - v2 = 40*e^(-50t), y esa diferencia dividida 25 k tiene que dar i.",
            "  b) w(0) = 1/2 * 1 uF * 40^2 = 800 uJ  (C2 esta descargado y no aporta)",
            "  c) LA CARGA QUEDA ATRAPADA. En regimen la corriente es cero, asi que no hay caida en los",
            "     25 k y los dos capacitores quedan a la MISMA tension. La carga total se conserva:",
            "        q_total = 1 uF * 40 V = 40 uC, repartida en 1+4 = 5 uF  ->  v_final = 8 V",
            "     Energia atrapada = 1/2*1u*8^2 + 1/2*4u*8^2 = 32 + 128 = 160 uJ",
            "     Energia disipada en los 25 k = 800 - 160 = 640 uJ",
            "  El 80% de la energia se fue en calor aunque la corriente final sea cero y aunque los dos",
            "  capacitores sean ideales. Ese es el punto del problema: en una red capacitiva, 'el",
            "  transitorio termino' no quiere decir 'no quedo energia'.",
            "  Lo que tiene que confirmar la simulacion:",
            "    i_0 = 1,6 mA   t63 = 20 ms   v1_fin = v2_fin = 8 V",
            "    W0 = 800 uJ    W_atrap = 160 uJ    W_disip = 640 uJ",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  V(v1) y V(v2) juntas [V] -- misma unidad y misma escala: se ve como una baja de",
            "            40 y la otra sube de 0 hasta encontrarse en 8 V. Cursor sobre el cruce.",
            "  Panel 2:  I(R1) [A] -- la exponencial de corriente.",
            "  Panel 3:  V(wR) [J] -- la energia disipada, que se aplana en 640 uJ y no en 800 uJ. La",
            "            distancia entre esa meseta y los 800 uJ ES la energia atrapada, dibujada.",
        ],
        )
    g(s, "P7-21_RC_energia_atrapada.asc")


def p7_23(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    c1 = s.sym("cap", "C1", (176, TOP), "R0", value="10u")
    s.wire(c1[1], (176, BOT))
    r1 = s.sym("res", "R1", (480, TOP), "R0", value="4k")
    s.wire(r1[1], (480, BOT))
    s.rail(TOP, 176, 480)
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.wire((328, TOP), (328, TOP - 48))
    s.flag((328, TOP - 48), "v")

    _integrador(s, "I=V(v)*I(R1)")

    s.directiva((X, 400),
                ".tran 0 200m 0 20u",
                ".ic V(v)=48 V(wR)=0",
                ".meas TRAN v_0    FIND V(v) AT 0",
                ".meas TRAN i_0    FIND I(R1) AT 0",
                ".meas TRAN R_med  PARAM v_0/i_0",
                ".meas TRAN t368   WHEN V(v)=17.66127",
                ".meas TRAN C_med  PARAM t368/R_med",
                ".meas TRAN W0     PARAM 0.5*10u*v_0*v_0",
                ".meas TRAN W60ms  INTEG V(v)*I(R1) FROM 0 TO 60m",
                ".meas TRAN cociente FIND V(v)/I(R1) AT 100m")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 7.23 (Nilsson y Riedel) -- IDENTIFICAR R, C Y tau DESDE LA RESPUESTA MEDIDA",
            "Actividad asincronica -- Bloque 3: circuitos RC de primer orden",
            "=" * 100,
            "Enunciado: en el circuito de la Figura P7.23 (C en paralelo con R, respuesta natural) las",
            "  ecuaciones son v = 48*e^(-25t) V e i = 12*e^(-25t) mA. Determinar R, C, tau, la energia",
            "  inicial del capacitor y la energia disipada 60 ms despues de que la tension empieza a caer.",
        ],
        circuito=[
            "EL CIRCUITO",
            "  C1 y R1 entre el nodo v y masa. Sin fuente: respuesta natural pura, el capacitor se",
            "  descarga sobre la resistencia.",
            "  Aca la orientacion no da problema: C1 y R1 estan los dos con el pin A arriba, asi que",
            "  I(R1) positiva es la corriente que BAJA por la resistencia, que es la i del enunciado, y",
            "  V(v) es la v del enunciado. Este es el caso comodo; el 7.4 es el que obliga a girar un",
            "  elemento, y conviene comparar los dos.",
            "  El nodo v tiene camino de continua a masa por R1, asi que no hace falta ninguna Rfuga.",
        ] + NOTA_INTEGRADOR,
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  .ic V(v)=48        la tension inicial del capacitor, que es todo el estado del circuito.",
            "  .tran 0 200m 0 20u  200 ms = 5 tau (tau = 40 ms). Paso maximo tau/2000.",
            "  .meas TRAN t368 WHEN V(v)=17.66127",
            "     17,66127 V es 48/e. Ese es el 36,8% que nombra la guia, y el instante del cruce ES tau.",
            "     Medirlo asi --por el cruce del 36,8%-- es exactamente lo que se hace con los cursores",
            "     en la pantalla de un osciloscopio: el .meas lo hace con mas cifras, no distinto.",
            "  .meas TRAN cociente FIND V(v)/I(R1) AT 100m",
            "     El control de la guia: v/i tiene que valer R durante TODA la respuesta natural, no",
            "     solo en t=0. Medirlo en 100 ms (2,5 tau) y no en 0 es lo que lo convierte en control.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  a) R = v/i = 48 V / 12 mA = 4 kohm  (y es constante en el tiempo: mismo exponente arriba",
            "     y abajo)",
            "  c) el exponente es -t/tau = -25t  ->  tau = 1/25 = 40 ms",
            "  b) tau = R*C  ->  C = tau/R = 40 ms / 4 k = 10 uF",
            "  d) w(0) = 1/2 C v(0)^2 = 0,5 * 10 uF * 48^2 = 11,52 mJ",
            "  e) energia disipada hasta t: w(0)*(1 - e^(-2t/tau)). Otra vez el factor 2, porque wC es",
            "     proporcional a v^2.  En 60 ms: 2t/tau = 3, e^(-3) = 0,049787",
            "        W(60 ms) = 11,52 mJ * (1 - 0,049787) = 10,946 mJ   (el 95,02% del total)",
            "  Lo que tiene que confirmar la simulacion:",
            "    v_0 = 48 V   i_0 = 12 mA   R_med = 4000 ohm   t368 = 40 ms   C_med = 10 uF",
            "    W0 = 11,52 mJ   W60ms = 10,946 mJ   cociente = 4000 ohm",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  V(v) [V], con cursor en 17,66 V para leer tau sobre la curva.",
            "  Panel 2:  I(R1) [A].",
            "  Panel 3:  V(v)/I(R1) -- tiene que salir una RECTA HORIZONTAL en 4000. Es el grafico que",
            "            demuestra el control de la guia de un vistazo. Si la recta se dobla al final,",
            "            no es fisica: es ruido numerico de dividir dos numeros que van a cero.",
            "  Panel 4:  V(wR) [J], la energia disipada, con cursor en 60 ms.",
        ],
        )
    g(s, "P7-23_RC_identificar_R_C_tau.asc")


def p7_25(g, doc):
    s = Sch(2200, 2800)
    TOP, BOT = 112, 304

    v1 = s.sym("voltage", "V1", (96, TOP), "R0", value="120")
    s.wire(v1[1], (96, BOT))
    r1 = s.sym("res", "R1", (96, TOP), "R270", value="1.8k")
    s.wire(r1[1], (240, TOP))
    s1 = s.sym("sw", "S1", (240, TOP), "R270", value="SW")
    s.wire(s1[1], (400, TOP))
    c1 = s.sym("cap", "C1", (400, TOP), "R0", value="3.33333u")
    s.wire(c1[1], (400, BOT))
    r2 = s.sym("res", "R2", (624, TOP), "R0", value="12k")
    s.wire(r2[1], (624, BOT))
    s.wire((400, TOP), (624, TOP))
    # S2 va HORIZONTAL (R270) igual que S1: en R0 sus dos pines de mando
    # quedan uno encima del otro en la misma columna, y el stub vertical de
    # cada uno los cortocircuita. Medido: con S2 en R0 el circuito nunca
    # cargaba y el log avisaba "Node nc_01 is floating".
    s2 = s.sym("sw", "S2", (848, TOP), "R270", value="SW")
    s.wire((624, TOP), (848, TOP))
    r3 = s.sym("res", "R3", s2[1], "R0", value="68k")
    s.wire(r3[1], (928, BOT))
    s.rail(BOT, 96, 928)
    s.wire((512, BOT), (512, BOT + 48))
    s.tierra((512, BOT + 48))
    s.wire((464, TOP), (464, TOP - 48))
    s.flag((464, TOP - 48), "vc")

    for sw in (s1, s2):
        s.wire(sw[3], (sw[3][0], sw[3][1] + 48))
        s.tierra((sw[3][0], sw[3][1] + 48))
        s.wire(sw[2], (sw[2][0], sw[2][1] + 48))
        s.flag((sw[2][0], sw[2][1] + 48), "ctl")

    vc = s.sym("voltage", "Vctl", (1120, TOP), "R0",
               value="PULSE(1 0 50m 1n 1n 1 2)")
    s.wire(vc[0], (1120, TOP - 48))
    s.flag((1120, TOP - 48), "ctl")
    s.wire(vc[1], (1120, BOT))
    s.tierra((1120, BOT))

    s.directiva((X, 400),
                ".tran 0 300m 0 20u",
                C.MODELO_SW,
                ".meas TRAN vc_antes FIND V(vc) AT 49m",
                ".meas TRAN W0       PARAM 0.5*3.33333u*vc_antes*vc_antes",
                ".meas TRAN W_12ms   INTEG V(vc)*I(R2) FROM 50m TO 62m",
                ".meas TRAN pct_12ms PARAM 100*W_12ms/W0",
                ".meas TRAN t75      WHEN V(vc)=51 TD=50m",
                ".meas TRAN dt75     PARAM t75-50m",
                ".meas TRAN t63      WHEN V(vc)=37.526 TD=50m")

    doc(s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 7.25 (Nilsson y Riedel) -- ENERGIA DISIPADA EN UNA DESCARGA RC",
            "Actividad asincronica -- Bloque 3: circuitos RC de primer orden",
            "=" * 100,
            "Enunciado: los dos conmutadores operan conjuntamente y estuvieron cerrados mucho tiempo",
            "  antes de abrirse en t=0. a) Cuantos microjulios se disipan en los 12 k 12 ms despues de",
            "  abrirse. b) Cuanto tarda en disiparse el 75% de la energia inicialmente almacenada.",
            "  Datos: 120 V, 1,8 k, C = 10/3 uF, 12 k, 68 k.",
        ],
        circuito=[
            "EL CIRCUITO, Y POR QUE ACA SI SE DIBUJAN LOS CONMUTADORES",
            "  S1 corta la rama de la fuente (120 V + 1,8 k) y S2 corta la rama de los 68 k. Los dos van",
            "  al MISMO mando, Vctl: 'operan conjuntamente' quiere decir literalmente eso, un solo",
            "  control para los dos. Dibujarlos hace visible la carga previa, que es de donde sale el",
            "  dato de 102 V que el enunciado no da hecho.",
            "  EL CERO DEL PROBLEMA ES 50 ms DE LA SIMULACION. Con los conmutadores cerrados la",
            "  constante de tiempo es 1,8k//(12k//68k) * C = 1,53 k * 3,333 uF = 5,1 ms, asi que 50 ms",
            "  son casi 10 tau y en 49 ms la carga previa ya esta completa. Restar 50 ms a los tiempos.",
            "  C1 vale 3,33333u y no '10/3u' porque el campo Value de un simbolo no evalua fracciones.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  Vctl PULSE(1 0 50m 1n 1n 1 2)   un solo flanco de bajada a los 50 ms: los dos",
            "     interruptores se abren en el mismo instante, que es lo que pide el enunciado.",
            "  .tran 0 300m 0 20u",
            "     50 ms de carga + 250 ms de descarga (algo mas de 6 tau, con tau = 40 ms).",
            "  .meas TRAN W_12ms INTEG V(vc)*I(R2) FROM 50m TO 62m",
            "     La energia disipada EN LOS 12 k en la ventana pedida. Los limites van en tiempo de",
            "     simulacion, no de problema: 50 ms a 62 ms es '0 a 12 ms' del enunciado.",
            "  .meas TRAN t75 WHEN V(vc)=51 TD=50m",
            "     51 V es la MITAD de 102 V, y la mitad de tension es un CUARTO de energia: cuando la",
            "     tension cae a la mitad ya se disipo el 75%. Es la forma de medir un porcentaje de",
            "     energia con un cursor de tension, sin integrar nada.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  ANTES (los dos conmutadores cerrados, capacitor abierto en regimen):",
            "     12k // 68k = 10,2 k ;  vC = 120 * 10,2/(1,8+10,2) = 102 V",
            "  DESPUES (los dos abiertos): el capacitor solo ve los 12 k.",
            "     tau = 12 k * (10/3) uF = 40 ms      vC(t) = 102*e^(-25 t) V",
            "     w(0) = 1/2 * (10/3) uF * 102^2 = 17,34 mJ",
            "  a) W(12 ms) = 17,34 mJ * (1 - e^(-2*12/40)) = 17,34 * (1 - 0,548812) = 7,8236 mJ",
            "     o sea 7823,6 uJ, que es el 45,12% del total.",
            "  b) 75% disipado -> queda el 25% -> e^(-2t/tau) = 0,25 -> t = (tau/2)*ln(4)",
            "        t = 20 ms * 1,386294 = 27,73 ms",
            "     Comprobacion por tension: queda el 25% de la energia cuando la tension cae a la mitad",
            "     (102 -> 51 V), y eso pasa en tau*ln(2) = 40*0,6931 = 27,73 ms. Los dos caminos dan lo",
            "     mismo, que es la forma de saber que el factor 2 esta bien puesto.",
            "  Lo que tiene que confirmar la simulacion:",
            "    vc_antes = 102 V   W0 = 17,34 mJ   W_12ms = 7,824 mJ   pct_12ms = 45,1%",
            "    dt75 = 27,73 ms    t63 (medido desde 50 ms) = 40 ms",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  V(vc) [V] -- se ve la carga hasta 102 V y despues la descarga. Cursores en",
            "            51 V (75% de energia) y en 37,5 V (una constante de tiempo).",
            "  Panel 2:  I(R2) [A] y I(R3) [A] juntas -- se ve como I(R3) se corta de golpe al abrirse",
            "            S2 mientras I(R2) sigue. Util para entender que 'conjuntamente' cambia dos",
            "            cosas a la vez.",
            "  Escala X acotada a 45 ms .. 150 ms para que la descarga ocupe la pantalla.",
        ],
        )
    g(s, "P7-25_RC_energia_disipada.asc")


def todos(g, doc, x_txt):
    global X
    X = x_txt
    p7_01(g, doc)
    p7_01b(g, doc)
    p7_04(g, doc)
    p7_08(g, doc)
    p7_08b(g, doc)
    p7_21(g, doc)
    p7_23(g, doc)
    p7_25(g, doc)
