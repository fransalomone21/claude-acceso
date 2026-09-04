# generar.py -- construye los .asc de los doce problemas de la guia
# asincronica (Nilsson y Riedel, caps. 6, 7 y 8) mas la segunda pasada con
# no idealidades.
#
#   python herramientas\generar.py
#
# Todo el texto explicativo vive ADENTRO de cada .asc, como comentarios de
# LTspice. Este archivo es solo el molde: si hay que corregir una
# explicacion, se corrige aca y se vuelve a generar, para que las trece
# hojas no diverjan entre si.

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from asc import Sch                                              # noqa: E402
import comun as C                                                # noqa: E402

SALIDA = Path(__file__).resolve().parent.parent / "ltspice"

PASO = 28          # separacion entre renglones de comentario
X_TXT = 64         # columna donde empieza todo el texto


def documentar(sch, y0, cabecera, circuito, directivas, control,
               extra=None, con_ic=True, con_meas=True):
    """Escribe el bloque de documentacion completo debajo del dibujo.

    El orden es deliberado: primero QUE es, despues COMO esta armado, y
    recien al final los numeros a controlar -- que es el orden en que se
    lee cuando uno abre un archivo que no escribio."""
    y = y0
    secciones = [
        cabecera,
        [""],
        C.COMO_SE_LEE_UNA_DIRECTIVA,
        [""],
        circuito,
        [""],
        directivas,
        [""],
        C.LOS_CUATRO_ANALISIS,
        [""],
        C.COMO_SE_LEE_TRAN,
        [""],
    ]
    if con_ic:
        secciones += [C.COMO_SE_LEE_IC, [""]]
    if con_meas:
        secciones += [C.COMO_SE_LEE_MEAS, [""]]
    secciones += [
        C.COMO_SE_ARMA_UNA_GRAFICA,
        [""],
        C.ORDEN_DE_TRABAJO,
        [""],
        control,
    ]
    if extra:
        secciones += [[""], extra]
    for sec in secciones:
        for linea in sec:
            sch.nota((X_TXT, y), linea)
            y += PASO
    return y


def guardar(sch, nombre):
    ruta = sch.guardar(SALIDA / nombre)
    print("  escrito", ruta.name)


# ==========================================================================
# BLOQUE 1 -- BOBINAS Y CAPACITORES (relaciones constitutivas y energia)
# ==========================================================================

def p6_01():
    """6.1 -- bobina de 20 mH excitada por un pulso triangular de corriente."""
    s = Sch(2000, 2600)
    TOP, BOT = 112, 304

    i1 = s.sym("current", "I1", (176, BOT), "R180",
               value="PWL(0 0 5m 0.25 10m 0 20m 0)")
    l1 = s.sym("ind", "L1", (480, TOP), "R0", value="20m", value2="Rser=1u")

    s.wire(i1[1], (176, TOP))
    s.rail(TOP, 176, 480)
    s.wire(l1[1], (480, BOT))
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.flag((328, TOP), "iL")

    s.directiva((X_TXT, 400),
                ".tran 0 15m 0 5u",
                ".ic I(L1)=0",
                ".meas TRAN iL_pico   MAX I(L1)",
                ".meas TRAN vL_sube   AVG V(iL) FROM 1m TO 4m",
                ".meas TRAN vL_baja   AVG V(iL) FROM 6m TO 9m",
                ".meas TRAN p_en_4ms  FIND V(iL)*I(L1) AT 4m",
                ".meas TRAN p_en_6ms  FIND V(iL)*I(L1) AT 6m",
                ".meas TRAN w_max     MAX 0.5*20m*I(L1)*I(L1)")

    documentar(
        s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 6.1 (Nilsson y Riedel) -- BOBINA DE 20 mH CON UN PULSO TRIANGULAR DE CORRIENTE",
            "Actividad asincronica: Bobinas, capacitores y circuitos RL, RC y RLC -- Bloque 1",
            "=" * 100,
            "Enunciado: se aplica a una bobina de 20 mH el pulso triangular de la Figura P6.1:",
            "  i = 0 para t<0;  i sube de 0 a 250 mA entre 0 y 5 ms;  baja de 250 mA a 0 entre 5 y 10 ms;",
            "  i = 0 para t>10 ms.  Hay que escribir i(t) por tramos y deducir v(t), p(t) y w(t).",
        ],
        circuito=[
            "EL CIRCUITO, Y POR QUE ESTA ARMADO ASI",
            "  Un solo nodo con nombre, 'iL', y la masa. La fuente I1 inyecta el pulso hacia el nodo y la",
            "  bobina L1 lo devuelve a masa: quedan los dos unicos elementos que pide el enunciado.",
            "  I1 esta rotada 180 grados A PROPOSITO. En SPICE la corriente positiva de una fuente I va",
            "  del nodo + al nodo - POR ADENTRO de la fuente, asi que una fuente con el + arriba DRENA",
            "  corriente del nodo. Al girarla, el + queda contra masa y la fuente INYECTA hacia arriba,",
            "  que es lo que dibuja el enunciado. Es el mismo cuidado que pide la regla 3 del netlist.",
            "  L1 va del nodo iL (pin A) a masa (pin B): asi I(L1) positiva es la corriente que baja por",
            "  la bobina, o sea exactamente la i del enunciado, y V(iL) es vL con el convenio pasivo.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  PWL(0 0 5m 0.25 10m 0 20m 0)",
            "     PieceWise Linear: pares (tiempo, valor) unidos por rectas. Se lee 'vale 0 en t=0,",
            "     0,25 A en 5 ms, 0 otra vez en 10 ms, y sigue en 0 hasta 20 ms'. Entre dos pares",
            "     interpola en linea recta: por eso un pulso triangular son tres pares y nada mas.",
            "     PWL es la fuente correcta aca; PULSE serviria para un escalon o una cuadrada.",
            "  .tran 0 15m 0 5u",
            "     Hasta 15 ms para ver los tres tramos mas la cola en cero. Paso maximo 5 us = 1/1000",
            "     del tramo mas corto (5 ms): sobra, y hace falta, porque los quiebres del triangulo son",
            "     justo donde la tension salta y un paso grande los redondea.",
            "  .ic I(L1)=0",
            "     La bobina arranca descargada, como dice el enunciado (i=0 para t<0).",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  Tramo 0 a 5 ms:   i = 50*t A   (0,25 A / 5 ms = 50 A/s)",
            "                    v = L di/dt = 20 mH * 50 A/s = +1 V, CONSTANTE",
            "                    p = v*i = 50*t W          -> en 4 ms: p = +0,2 W  (absorbe)",
            "                    w = 1/2 L i^2 = 25*t^2 J  -> en 5 ms: w = 625 uJ",
            "  Tramo 5 a 10 ms:  i = 0,5 - 50*t A",
            "                    v = 20 mH * (-50 A/s) = -1 V, CONSTANTE",
            "                    p = v*i                   -> en 6 ms: p = -0,2 W  (entrega)",
            "  t > 10 ms:        i = 0, v = 0, p = 0, w = 0. La bobina devolvio todo lo que guardo.",
            "  Lo que tiene que confirmar la simulacion (control de la guia):",
            "    iL_pico  = 250 mA     vL_sube = +1 V      vL_baja = -1 V",
            "    p_en_4ms = +0,2 W     p_en_6ms = -0,2 W   w_max   = 625 uJ",
            "  Y sobre todo: la tension es CONSTANTE en cada tramo de pendiente constante, y salta de",
            "  +1 V a -1 V de golpe en 5 ms. En una bobina la que no puede saltar es la CORRIENTE; la",
            "  tension salta todo lo que haga falta.",
            "",
            "QUE GRAFICAR EN ESTE ARCHIVO (cuatro paneles, uno por magnitud)",
            "  Panel 1:  I(L1)              corriente [A]  -- el triangulo de entrada",
            "  Panel 2:  V(iL)              tension  [V]  -- dos escalones, +1 y -1",
            "  Panel 3:  V(iL)*I(L1)        potencia [W]  -- rampa positiva y despues negativa",
            "  Panel 4:  0.5*20m*I(L1)*I(L1)  energia [J] -- sube hasta 625 uJ y vuelve a cero",
            "  Los cuatro NO van en el mismo eje: la energia vale microjoules y la potencia decimas de",
            "  watt, y en un eje comun una de las dos queda pegada al cero. Add Plot Pane, uno por uno.",
            "  Cursores a los dos lados de 5 ms sobre V(iL): ahi se ve el salto de tension entero.",
        ],
    )
    guardar(s, "P6-01_bobina_pulso_triangular.asc")


def p6_02():
    """6.2 -- corriente obtenida a partir de la tension, bobina de 200 uH."""
    s = Sch(2000, 2600)
    TOP, BOT = 112, 304

    v1 = s.sym("voltage", "V1", (176, TOP), "R0",
               value="PWL(0 5m 2m 5m 2.000001m 0 6m 0)")
    l1 = s.sym("ind", "L1", (480, TOP), "R0", value="200u", value2="Rser=1u")

    s.rail(TOP, 176, 480)
    s.wire(v1[1], (176, BOT))
    s.wire(l1[1], (480, BOT))
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.flag((328, TOP), "vs")

    s.directiva((X_TXT, 400),
                ".tran 0 4m 0 1u",
                ".ic I(L1)=0",
                ".meas TRAN iL_1ms  FIND I(L1) AT 1m",
                ".meas TRAN iL_2ms  FIND I(L1) AT 2m",
                ".meas TRAN iL_fin  FIND I(L1) AT 4m",
                ".meas TRAN pend    DERIV I(L1) AT 1m")

    documentar(
        s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 6.2 (Nilsson y Riedel) -- LA CORRIENTE SE OBTIENE INTEGRANDO LA TENSION",
            "Actividad asincronica: Bobinas, capacitores y circuitos RL, RC y RLC -- Bloque 1",
            "=" * 100,
            "Enunciado: la tension en bornes de la bobina de 200 uH de la Figura P6.2(a) es la de la",
            "  Figura P6.2(b): vs = 5 mV entre t=0 y t=2 ms, y 0 fuera de ese intervalo. La corriente",
            "  de la bobina es cero para t<=0. Hay que deducir i(t) para t>=0 y dibujarla.",
        ],
        circuito=[
            "EL CIRCUITO",
            "  La fuente de tension V1 esta DIRECTAMENTE en bornes de la bobina: el enunciado no da un",
            "  circuito, da una forma de onda de tension impuesta, y eso en SPICE es exactamente una",
            "  fuente de tension ideal en paralelo con el elemento.",
            "  V1 va del nodo vs (pin +) a masa, y L1 tambien: los dos elementos del nodo. El nodo tiene",
            "  camino de continua a masa por la bobina, asi que no hay nodo flotante.",
        ] + C.NOTA_RSER_POR_DEFECTO + [
            "  ESTE archivo es el caso donde ese miliohm manda: despues de los 2 ms la fuente vale 0 V,",
            "  o sea que es un cortocircuito, y la bobina queda descargandose contra su propia Rser.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  PWL(0 5m 2m 5m 2.000001m 0 6m 0)",
            "     Cuatro pares: 5 mV ya en t=0, sigue en 5 mV hasta 2 ms, cae a 0 en 1 ns y se queda.",
            "     El 2.000001m no es un capricho: PWL une los pares con RECTAS, asi que dos pares con el",
            "     mismo tiempo serian una division por cero. Un flanco de 1 ns es la forma de escribir",
            "     'instantaneo' sin romper el integrador.",
            "     OJO: aca el flanco vertical es inofensivo porque cae SOBRE una fuente de tension. Si",
            "     el flanco fuera de CORRIENTE contra una bobina, seria una derivada infinita y el",
            "     simulador se atragantaria ('Timestep too small').",
            "  .tran 0 4m 0 1u   -- hasta el doble del pulso, para ver que despues i se queda quieta.",
            "  .ic I(L1)=0       -- i(0)=0, que es el dato del enunciado.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  i(t) = i(0) + (1/L) * integral de v dt",
            "  0 <= t <= 2 ms:  i = (5 mV / 200 uH) * t = 25*t A   -> pendiente 25 A/s (o 25 mA/ms)",
            "                   en 1 ms: i = 25 mA;  en 2 ms: i = 50 mA",
            "  t > 2 ms:        v = 0  ->  di/dt = 0  ->  i se queda CLAVADA en 50 mA para siempre.",
            "  Lo que tiene que confirmar la simulacion:",
            "    iL_1ms = 25 mA    iL_2ms = 50 mA    iL_fin = 50 mA    pend = 25 A/s",
            "  Control conceptual de la guia: una discontinuidad FINITA de vL cambia la PENDIENTE de",
            "  iL, pero no produce ningun salto de corriente. En 2 ms la tension cae de golpe y la",
            "  corriente ni se entera: sigue valiendo 50 mA, solo deja de subir.",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  V(vs)   [V]  -- el rectangulo de 5 mV",
            "  Panel 2:  I(L1)   [A]  -- la rampa que se aplana en 50 mA",
            "  Dos paneles y no uno: 5 mV y 50 mA en el mismo eje dejan la tension pegada al cero.",
            "  Cursor 1 en t=2 ms sobre I(L1) y cursor 2 en t=4 ms: la diferencia tiene que ser CERO.",
            "  Ese cero es la demostracion de que la corriente no salto.",
        ],
    )
    guardar(s, "P6-02_bobina_tension_a_corriente.asc")


def p6_17():
    """6.17 -- capacitor de 0,25 uF excitado por un pulso de corriente."""
    s = Sch(2000, 2600)
    TOP, BOT = 112, 304

    i1 = s.sym("current", "I1", (176, BOT), "R180",
               value="PWL(0 0 5u 0.4 20u 0.4 20.000001u -0.3 50u 0 60u 0)")
    c1 = s.sym("cap", "C1", (480, TOP), "R0", value="0.25u")

    s.wire(i1[1], (176, TOP))
    s.rail(TOP, 176, 480)
    s.wire(c1[1], (480, BOT))
    s.rail(BOT, 176, 480)
    s.wire((328, BOT), (328, BOT + 48))
    s.tierra((328, BOT + 48))
    s.flag((328, TOP), "vc")

    s.directiva((X_TXT, 400),
                ".tran 0 60u 0 10n",
                ".ic V(vc)=0",
                ".meas TRAN v_5us   FIND V(vc) AT 5u",
                ".meas TRAN v_20us  FIND V(vc) AT 20u",
                ".meas TRAN v_30us  FIND V(vc) AT 30u",
                ".meas TRAN v_50us  FIND V(vc) AT 50u",
                ".meas TRAN q_30us  PARAM 0.25u*v_30us",
                ".meas TRAN w_50us  PARAM 0.5*0.25u*v_50us*v_50us")

    documentar(
        s, 900,
        cabecera=[
            "=" * 100,
            "PROBLEMA 6.17 (Nilsson y Riedel) -- CAPACITOR DE 0,25 uF CON UN PULSO DE CORRIENTE",
            "Actividad asincronica: Bobinas, capacitores y circuitos RL, RC y RLC -- Bloque 1",
            "=" * 100,
            "Enunciado: se aplica a un capacitor de 0,25 uF el pulso de corriente de la Figura P6.17,",
            "  con tension inicial cero. Hay que calcular la carga en t = 30 us, la tension en",
            "  t = 50 us y cuanta energia deja el pulso almacenada en el capacitor.",
            "  El pulso: sube en rampa de 0 a 400 mA entre 0 y 5 us; se queda en 400 mA hasta 20 us;",
            "  ahi SALTA a -300 mA; sube en rampa de -300 mA a 0 entre 20 y 50 us; y queda en 0.",
        ],
        circuito=[
            "EL CIRCUITO",
            "  Fuente de corriente I1 inyectando al nodo vc, y el capacitor C1 de vc a masa. Igual que",
            "  en el 6.1, I1 va rotada 180 grados para que inyecte y no drene.",
            "  ATENCION: este nodo NO tiene camino de continua a masa (un capacitor es un circuito",
            "  abierto en continua). Funciona igual porque .ic le fija la tension inicial y la fuente de",
            "  corriente le impone la evolucion, pero es el caso limite del que avisa la regla del",
            "  netlist: si en vez de .ic se dejara el nodo suelto, LTspice tiraria 'This node is floating'.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  PWL(0 0 5u 0.4 20u 0.4 20.000001u -0.3 50u 0 60u 0)",
            "     Seis pares, uno por quiebre del dibujo. El par doble en 20 us (0.4 y despues -0.3 un",
            "     nanosegundo mas tarde) es como se escribe una DISCONTINUIDAD en PWL: dos pares casi",
            "     al mismo tiempo con valores distintos. Aca si es un salto de corriente, pero contra un",
            "     CAPACITOR, y en un capacitor la que no puede saltar es la tension: la corriente si.",
            "  .tran 0 60u 0 10n",
            "     10 ns de paso maximo = 1/500 del tramo mas corto (5 us). Hace falta esa finura para",
            "     que el quiebre de 20 us no se coma medio paso.",
            "  .ic V(vc)=0   -- 'la tension inicial en el condensador es cero'.",
            "  .meas ... PARAM  -- las dos ultimas lineas no miden nada nuevo: hacen la cuenta q = C*v y",
            "     w = 1/2 C v^2 con resultados de mediciones anteriores. Es la forma de que el .log",
            "     traiga directamente la respuesta del enunciado y no haya que pasar por la calculadora.",
        ],
        control=[
            "CONTROL -- LOS NUMEROS CALCULADOS A MANO ANTES DE SIMULAR",
            "  v(t) = (1/C) * integral de i dt, o sea: la PENDIENTE de v es i/C, y v es el area",
            "  acumulada de la corriente dividida por C.",
            "  Carga acumulada (area bajo el pulso de corriente):",
            "    0 a 5 us   triangulo:  q = 1/2 * 5 us * 0,4 A          = 1 uC   -> v(5 us)  =  4 V",
            "    5 a 20 us  rectangulo: q = 15 us * 0,4 A = 6 uC, total = 7 uC   -> v(20 us) = 28 V",
            "    20 a 30 us trapecio:   q = 10 us * (-0,3 - 0,2)/2 = -2,5 uC     -> q(30 us) = 4,5 uC",
            "                                                                    -> v(30 us) = 18 V",
            "    20 a 50 us triangulo:  q = 1/2 * 30 us * (-0,3) = -4,5 uC       -> q(50 us) = 2,5 uC",
            "                                                                    -> v(50 us) = 10 V",
            "  Respuestas del enunciado:  q(30 us) = 4,5 uC ;  v(50 us) = 10 V ;",
            "                             w = 1/2 * 0,25 uF * 10^2 = 12,5 uJ",
            "  Lo que tiene que confirmar la simulacion:",
            "    v_5us = 4 V   v_20us = 28 V   v_30us = 18 V   v_50us = 10 V",
            "    q_30us = 4,5 uC    w_50us = 12,5 uJ",
            "  Control conceptual de la guia: la pendiente de vC es i/C, y cuando i=0 (despues de 50 us)",
            "  la tension se queda QUIETA en 10 V. Y en el salto de corriente de 20 us la tension no",
            "  salta: solo cambia de pendiente, de +1,6 V/us a -1,2 V/us.",
            "",
            "QUE GRAFICAR",
            "  Panel 1:  I(C1)                 corriente [A] -- el pulso de entrada, tal cual el dibujo",
            "  Panel 2:  V(vc)                 tension  [V]  -- sube a 28 V y baja a 10 V",
            "  Panel 3:  V(vc)*I(C1)           potencia [W]  -- positiva mientras carga, negativa despues",
            "  Panel 4:  0.5*0.25u*V(vc)*V(vc) energia  [J]  -- de 0 a 98 uJ y de vuelta a 12,5 uJ",
            "  Cursores a los dos lados de 20 us sobre V(vc): confirman que NO hay salto de tension,",
            "  solo un codo. Ese es el control que pide la guia.",
        ],
    )
    guardar(s, "P6-17_capacitor_pulso_corriente.asc")


def p6_25():
    """6.25 -- capacidad equivalente medida por la corriente de entrada."""
    s = Sch(2400, 2800)
    Y1, Y2, Y3, Y4 = 112, 208, 304, 400
    XA, XM, XP = 176, 496, 800
    GND = 480

    # --- fuente y terminal a --------------------------------------------
    v1 = s.sym("voltage", "V1", (96, Y1), "R0", value="AC 1")
    s.wire(v1[0], (XA, Y1))
    s.wire(v1[1], (96, GND))
    s.tierra((96, GND))

    # --- la red de ocho capacitores -------------------------------------
    c8 = s.sym("cap", "C8", (XA, Y1), "R270", value="8u")
    s.wire(c8[1], (XM, Y1))
    c16 = s.sym("cap", "C16", (XA, Y2), "R270", value="16u")
    s.wire(c16[1], (XM, Y2))
    s.wire((XA, Y1), (XA, Y2))                       # columna del nodo a

    c5 = s.sym("cap", "C5", (XA, Y3), "R270", value="5u")
    s.wire(c5[1], (XM, Y3))
    c12 = s.sym("cap", "C12", (XA, Y4), "R270", value="12u")
    s.wire(c12[1], (XM, Y4))
    s.wire((XA, Y3), (XA, Y4))                       # columna del nodo b
    s.wire((XA, Y4), (XA, GND))
    s.tierra((XA, GND))

    s.wire((XM, Y1), (XM, Y3))                       # columna del nodo m
    c16b = s.sym("cap", "C1_6", (XM, Y3), "R0", value="1.6u")
    s.wire(c16b[1], (XM, Y4))                        # llega al nodo n

    c4 = s.sym("cap", "C4", (XM, 160), "R270", value="4u")
    s.wire(c4[1], (XP, 160))
    c6 = s.sym("cap", "C6", (XP, 160), "R0", value="6u")
    s.wire(c6[1], (XP, Y4))
    s.wire((XP, 160), (XP, 64))          # stub para la etiqueta del nodo p
    s.wire((XP, Y4), (XM, Y4))

    s.flag((XA, Y1), "a")
    s.flag((XM, Y2), "m")
    s.flag((XM, Y4), "n")
    s.flag((XP, 64), "p")

    # --- caminos de continua (ver la nota) -------------------------------
    for k, (nombre, xx) in enumerate([("m", 1120), ("n", 1280), ("p", 1440)]):
        r = s.sym("res", f"Rfuga{k+1}", (xx, Y2), "R0", value="1G")
        s.flag((xx, Y2), nombre)
        s.wire(r[1], (xx, GND))
        s.tierra((xx, GND))

    # --- el capacitor equivalente, para contrastar -----------------------
    v2 = s.sym("voltage", "V2", (1760, Y1), "R0", value="AC 1")
    ceq = s.sym("cap", "Ceq", (1920, Y1), "R0", value="6u")
    s.wire(v2[0], (1920, Y1))
    s.wire(v2[1], (1760, GND))
    s.wire(ceq[1], (1920, GND))
    s.rail(GND, 1760, 1920)
    s.tierra((1840, GND))
    s.flag((1920, Y1), "aref")

    s.directiva((X_TXT, 560),
                ".ac list 1k",
                ".options meascplxfmt=polar",
                ".meas AC i_red  FIND mag(I(V1)) AT 1k",
                ".meas AC i_ref  FIND mag(I(V2)) AT 1k",
                ".meas AC ceq_medida PARAM i_red/(2*pi*1k)",
                ".meas AC error_pct  PARAM 100*(i_red-i_ref)/i_ref")

    documentar(
        s, 1000,
        cabecera=[
            "=" * 100,
            "PROBLEMA 6.25 (Nilsson y Riedel) -- CAPACIDAD EQUIVALENTE ENTRE LOS TERMINALES a Y b",
            "Actividad asincronica: Bobinas, capacitores y circuitos RL, RC y RLC -- Bloque 1",
            "=" * 100,
            "Enunciado: calcular la capacidad equivalente respecto de los terminales a y b del circuito",
            "  de la Figura P6.25. La guia pide ademas medirla en el simulador: excitar la red con una",
            "  senoidal de 1 V a 1 kHz, medir el modulo de la corriente de entrada y estimar",
            "  Ceq = |Iin| / (2*pi*f*|Vin|); repetir con el capacitor equivalente y superponer.",
        ],
        circuito=[
            "EL CIRCUITO, NODO POR NODO",
            "  a  terminal de entrada (el + de V1).      b = masa (el otro terminal).",
            "  m  nodo central: le llegan C8 y C16 desde a, C5 desde b, C1_6 hacia n y C4 hacia p.",
            "  n  nodo inferior: le llegan C12 desde b, C1_6 desde m y C6 desde p.",
            "  p  nodo de la derecha, entre C4 y C6.",
            "  Las tensiones iniciales que trae el dibujo del libro (10 V, 15 V, 5 V, 3 V) NO se cargan:",
            "  para la capacidad equivalente son irrelevantes, porque .ac es un analisis de pequena",
            "  senal y la carga previa no cambia la impedancia de un capacitor lineal.",
            "  LOS TRES Rfuga DE 1 G NO SON PARTE DEL PROBLEMA. Estan porque m, n y p se conectan al",
            "  resto SOLO por capacitores, y en continua un capacitor es un circuito abierto: sin ellos",
            "  el sistema queda con una incognita de mas y LTspice aborta con 'This node is floating'.",
            "  1 G contra los ~26 ohm que presenta la red a 1 kHz es un error de una parte en 40 millones,",
            "  y ademas es un modelo mas honesto: un capacitor real TIENE fuga.",
        ],
        directivas=[
            "LAS DIRECTIVAS DE ESTA HOJA, UNA POR UNA",
            "  AC 1  (en el campo Value de V1 y V2)",
            "     No es 1 voltio de continua: es la amplitud del fasor de prueba para el analisis .ac.",
            "     Con amplitud 1 la corriente medida ES la admitancia, y la cuenta de Ceq se simplifica.",
            "  .ac list 1k",
            "     Analisis en frecuencia sobre una lista de frecuencias -- aca una sola, 1 kHz. Las otras",
            "     formas son .ac dec <puntos por decada> <f1> <f2> (la de un Bode) y .ac oct / .ac lin.",
            "     Para medir una capacidad alcanza una frecuencia: se elige 'list' y no 'dec'.",
            "  mag(I(V1))",
            "     En .ac todo resultado es un COMPLEJO. mag() saca el modulo; ph() sacaria la fase. Sin",
            "     mag(), el .meas devolveria un numero sin sentido claro.",
            "  I(V1) es la corriente que entra por el borne + de la fuente. Su modulo es |Iin|.",
            "  .options meascplxfmt=polar",
            "     SIN esta linea, un .meas sobre un analisis .ac imprime el resultado EN DECIBELES:",
            "     i_red saldria como '-28,4734 dB' en vez de '37,699 mA', y ceq_medida como",
            "     '-104,437 dB' en vez de '6 uF'. Los dos numeros son el mismo --10^(-104,437/20) da",
            "     6,00e-6-- pero un capacitor informado en dB es una invitacion a copiar mal el dato.",
            "     El formato por defecto se llama 'bode'; las otras dos opciones son 'polar' (modulo y",
            "     angulo en unidades lineales, que es la que esta puesta) y 'cartesian' (real e",
            "     imaginaria). Esta trampa aparecio corriendo este mismo archivo.",
        ],
        control=[
            "CONTROL -- LA REDUCCION HECHA A MANO ANTES DE SIMULAR",
            "  Paso 1: C8 y C16 estan las dos entre a y m -> PARALELO -> 8 + 16 = 24 uF",
            "  Paso 2: C4 (m-p) y C6 (p-n) estan en SERIE entre m y n -> 4*6/(4+6) = 2,4 uF",
            "  Paso 3: eso queda en paralelo con C1_6 (m-n) -> 1,6 + 2,4 = 4 uF entre m y n",
            "  Paso 4: C12 (b-n) en SERIE con esos 4 uF -> 12*4/(12+4) = 3 uF entre b y m",
            "  Paso 5: eso en paralelo con C5 (b-m) -> 5 + 3 = 8 uF entre b y m",
            "  Paso 6: los 24 uF (a-m) en SERIE con los 8 uF (m-b) -> 24*8/(24+8) = 6 uF",
            "  RESULTADO:  Ceq(a-b) = 6 uF",
            "  A 1 kHz con 1 V de amplitud eso da |Iin| = 2*pi*1000*6e-6*1 = 37,699 mA.",
            "  Lo que tiene que confirmar la simulacion:",
            "    i_red = i_ref = 37,699 mA     ceq_medida = 6 uF     error_pct = 0",
            "  Control de la guia: la equivalencia tiene que conservar la corriente de entrada a",
            "  CUALQUIER frecuencia en el modelo ideal. Para verlo, cambiar la directiva por",
            "  '.ac dec 20 10 100k' y dibujar mag(I(V1)) y mag(I(V2)) superpuestas: tienen que quedar",
            "  una encima de la otra en las cuatro decadas. Si se separan en un extremo, el que se",
            "  aparta es Rfuga, no la reduccion.",
            "",
            "QUE GRAFICAR",
            "  Con .ac list 1k no hay nada que graficar: los dos numeros salen del .log (Ctrl+L).",
            "  Con .ac dec 20 10 100k, un solo panel con mag(I(V1)) y mag(I(V2)); eje Y en escala",
            "  logaritmica (boton derecho sobre el eje > Logarithmic), porque la corriente barre tres",
            "  ordenes de magnitud. Ahi la superposicion es la verificacion visual de la equivalencia.",
        ],
        con_ic=False,
    )
    guardar(s, "P6-25_capacidad_equivalente.asc")


if __name__ == "__main__":
    print("Generando los .asc en", SALIDA)
    p6_01()
    p6_02()
    p6_17()
    p6_25()
    import bloque2, bloque3                                      # noqa: E402
    bloque2.todos(guardar, documentar, X_TXT)
    bloque3.todos(guardar, documentar, X_TXT)
    print("Listo.")
