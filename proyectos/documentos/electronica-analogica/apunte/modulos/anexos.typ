#import "../plantilla.typ": *

#modulo("Anexos", [
  Material de consulta rápida: código de colores, series de valores comerciales,
  formulario completo de las dos partes, las dos secuencias de lectura posibles,
  símbolos y normas de seguridad del laboratorio.
])

== Código de colores de resistores

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([*Color*], [*1.ª y 2.ª banda* (dígito)], [*3.ª banda* (multiplicador)], [*4.ª banda* (tolerancia)]),
    [Negro],    [0], [$times 1$],          [—],
    [Marrón],   [1], [$times 10$],         [± 1 %],
    [Rojo],     [2], [$times 100$],        [± 2 %],
    [Naranja],  [3], [$times 1$ k],        [—],
    [Amarillo], [4], [$times 10$ k],       [—],
    [Verde],    [5], [$times 100$ k],      [± 0,5 %],
    [Azul],     [6], [$times 1$ M],        [± 0,25 %],
    [Violeta],  [7], [$times 10$ M],       [± 0,1 %],
    [Gris],     [8], [—],                  [—],
    [Blanco],   [9], [—],                  [—],
    [Dorado],   [—], [$times 0,1$],        [± 5 %],
    [Plateado], [—], [$times 0,01$],       [± 10 %],
    [Sin banda],[—], [—],                  [± 20 %],
  ),
  caption: [Código de colores de cuatro bandas],
)

#circuito([Cómo se lee un resistor de cuatro bandas])[
#fig-codigo-colores()
]

#laboratorio[
  Se lee dejando la banda de tolerancia (dorada o plateada) *a la derecha*, o la banda que
  está más separada del grupo. Ante la duda, medir con el tester: es más rápido que
  discutir si el color es marrón o rojo, y los resistores viejos decoloran.
]

=== Series de valores comerciales

Los resistores no existen en cualquier valor: se fabrican en *series normalizadas*, con
valores espaciados de modo que, con su tolerancia, cubran todo el rango sin huecos.

- *E12* (tolerancia ± 10 %): 10 · 12 · 15 · 18 · 22 · 27 · 33 · 39 · 47 · 56 · 68 · 82
- *E24* (tolerancia ± 5 %): la E12 más 11 · 13 · 16 · 20 · 24 · 30 · 36 · 43 · 51 · 62 ·
  75 · 91

Cada valor se repite en todas las décadas: 47 $Omega$, 470 $Omega$, 4,7 k$Omega$,
47 k$Omega$… Por eso un cálculo que da 1433 $Omega$ se resuelve con 1,5 k$Omega$, y uno
que da 881 $Omega$ con 820 $Omega$.

== Formulario de la materia

=== Módulo 1 — Mediciones

$ Delta x = |X_i - X_v| quad quad e = (Delta x)/X_v quad quad e% = e dot 100 $

$ C% = Delta_"MAX"/"Alcance" dot 100 quad quad Delta_"MAX" = plus.minus (C% dot "Alcance")/100 $

$ R_S = (I_m dot R_m)/(I - I_m) = R_m/(n-1) quad quad R_M = V/I_m - R_m $

=== Módulo 2 — Señales

$ f = 1/T quad quad omega = 2 pi f quad quad s(t) = V_p sin(2 pi f t + phi) $

$ V_"ef" = sqrt(1/T integral_0^T v^2(t) dif t) quad quad V_(p p) = 2 V_p $

$ X_C = 1/(2 pi f C) quad quad f_c = 1/(2 pi R C) $

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([], [Senoidal], [Cuadrada], [Triangular]),
    [$V_"ef"$],        [$V_p\/sqrt(2)$], [$V_p$], [$V_p\/sqrt(3)$],
    [$V_m$ (rectif.)], [$2V_p\/pi$],     [$V_p$], [$V_p\/2$],
    [Factor de forma], [1,11],           [1,00],  [1,15],
  ),
  caption: [Valores característicos por forma de onda],
)

=== Módulo 3 — Transformadores

$ e = -N (dif Phi)/(dif t) quad quad V_1/V_2 = N_1/N_2 = I_2/I_1 = n $

$ S = V_"ef" dot I_"ef" ["VA"] quad quad P = S dot cos phi ["W"] quad quad
  eta = P_"sal"/P_"ent" dot 100 $

=== Módulos 4 y 5 — Diodos y fuentes

$ R_"LED" = (V_"cc" - V_F)/I_F $

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    table.header([], [Media onda], [Punto medio], [Puente]),
    [$V_"cc"$ sin filtro], [$V_p\/pi$], [$2V_p\/pi$], [$2V_p\/pi$],
    [$f_r$],               [50 Hz],     [100 Hz],     [100 Hz],
    [Caída de diodos],     [0,7 V],     [0,7 V],      [1,4 V],
    [PIV por diodo],       [$V_p$],     [$2V_p$],     [$V_p$],
  ),
  caption: [Topologías de rectificación],
)

$ Delta V_r = I_"cc"/(f_r dot C) quad quad C = I_"cc"/(f_r dot Delta V_r) quad quad
  V_"cc" = V_p - (Delta V_r)/2 quad quad r% = (Delta V_r)/V_"cc" dot 100 $

$ I_S = I_Z + I_L quad quad R_(S "máx") = (V_("in mín") - V_Z)/(I_(Z "mín") + I_(L "máx"))
  quad quad P_Z = V_Z dot I_Z $

=== Módulo 6 — Transistores

$ I_E = I_B + I_C quad quad beta = h_"FE" = I_C/I_B quad quad
  I_B = I_C/beta_"forzado" quad quad R_B = (V_"in" - V_"BE")/I_B $

$ V_"BE(on)" approx 0,7 "V" quad quad V_"CE(sat)" approx 0,2 "V" quad quad
  P = V_"CE(sat)" dot I_C $

=== Módulo 7 — Leyes de Kirchhoff

$ sum_k i_k = 0 quad ("nodo o superficie cerrada") quad quad
  sum_k v_k = 0 quad ("lazo") quad quad p = v i quad quad sum_k p_k = 0 $

$ R_"serie" = sum R_k quad quad 1/R_"par" = sum 1/R_k quad quad
  v_2 = V (R_2)/(R_1+R_2) quad quad i_1 = I (R_2)/(R_1+R_2) $

$ "LKC independientes" = n - 1 quad quad "LKT independientes" = b - n + 1 $

$ R_Y = (product "las dos" Delta "que tocan el terminal")/(sum "las tres" Delta)
  quad quad R_Delta = (sum "los tres productos de a pares")/(R_Y "opuesta") $

=== Módulo 8 — Nodos y mallas

$ bold(G) bold(v) = bold(i): quad G_(k k) = sum G "del nodo" k, quad
  G_(k j) = - sum G "entre" k "y" j $
$ i_k = sum I "de las fuentes que entran al nodo" k $

$ bold(R) bold(i) = bold(v): quad R_(k k) = sum R "del perímetro" k, quad
  R_(k j) = - sum R "compartidas" $
$ v_k = sum V "de la malla, positiva la que empuja a favor del giro" $

#table(
  columns: (auto, auto, auto),
  align: (left, left, left),
  table.header([], [*Qué la rompe*], [*Cómo se arregla*]),
  [Nodos], [fuente de tensión flotante],
    [*supernodo*: LKC de la superficie + $v_k - v_j = V_s$],
  [Mallas], [fuente de corriente compartida],
    [*supermalla*: LKT salteando la rama + $i_k - i_j = I_s$],
)

=== Módulo 9 — Teoremas

$ V_"th" = V_"vacío" quad quad I_N = I_"corto" quad quad
  R_"th" = R_N = (V_"vacío")/(I_"corto") = lr((v_t)/(i_t)|)_("indep. anuladas") $

$ R_L = R_"th" quad arrow.r quad p_"máx" = (V_"th"^2)/(4 R_"th"), quad eta = 50% $

$ V_"th"^"Millman" = (sum V_k \/ R_k)/(sum 1\/R_k) quad quad
  R_"th"^"Millman" = 1/(sum 1\/R_k) $

Anular una fuente: tensión $arrow.r$ cortocircuito, corriente $arrow.r$ circuito abierto.
*Las controladas no se anulan nunca.*

=== Módulo 10 — Transitorios

$ i_C = C (dif v)/(dif t) quad quad v_L = L (dif i)/(dif t) quad quad
  w_C = 1/2 C v^2 quad quad w_L = 1/2 L i^2 $

$ v_C (0^+) = v_C (0^-) quad quad i_L (0^+) = i_L (0^-) $

$ x(t) = x(infinity) + [x(0^+) - x(infinity)] e^(-t\/tau) quad quad
  tau = R_"th" C quad "o" quad tau = L/R_"th" $

$ omega_0 = 1/sqrt(L C) quad quad alpha = R/(2L) "(serie)" quad "o" quad
  alpha = 1/(2 R C) "(paralelo)" quad quad zeta = alpha/omega_0 = 1/(2Q) $

$ alpha > omega_0 arrow.r "sobreamortiguado" quad quad
  alpha = omega_0 arrow.r "crítico" quad quad
  alpha < omega_0 arrow.r "subamortiguado" $
$ "en el caso subamortiguado:" quad omega_d = sqrt(omega_0^2 - alpha^2) quad quad
  "SP" = e^(-pi zeta \/ sqrt(1 - zeta^2)) $

$ T_d = (2 pi)/(omega_d) quad quad
  alpha = 1/T_d ln (x_1 - x_infinity)/(x_2 - x_infinity) quad ("decremento logarítmico") $

$ R_"crít"^"serie" = 2 sqrt(L/C) quad quad quad
  R_"crít"^"paralelo" = 1/2 sqrt(L/C) $

Las tres formas de la respuesta natural de segundo orden, cada una con dos constantes:

$ "sobre:" A_1 e^(s_1 t) + A_2 e^(s_2 t) quad quad
  "crítico:" (D_1 t + D_2) e^(-alpha t) quad quad
  "sub:" e^(-alpha t)(B_1 cos omega_d t + B_2 sin omega_d t) $

Las dos condiciones que las determinan:
$ (dif v_C)/(dif t) bar.v_(0^+) = (i_C (0^+))/(C) quad quad quad
  (dif i_L)/(dif t) bar.v_(0^+) = (v_L (0^+))/(L) $

Energía: se conserva en $L$ y $C$, se disipa en $R$, y decae al *doble* de velocidad que
la variable de estado.

$ w(t) = w(0) thin e^(-2t\/tau) quad quad
  integral_0^infinity p_R dif t = w_L (0) + w_C (0) quad quad
  t_(f %) = tau/2 ln 1/(1-f) $

Fracciones útiles: $80 %$ de la energía a $0,80 tau$; $95 %$ a $1,50 tau$.

Inductancia mutua: $ v_2 = plus.minus M (dif i_1)/(dif t) quad quad
  k = M/sqrt(L_1 L_2) <= 1 quad quad
  L_"eq"^"serie" = L_1 + L_2 plus.minus 2M $

=== Módulo 11 — Fasores y potencia

$ overline(Z)_R = R quad quad overline(Z)_L = j omega L quad quad
  overline(Z)_C = 1/(j omega C) quad quad
  overline(Z) = R + j X = |Z| angle theta $

Fasor en *valor de pico*: $overline(V) = V_m angle phi$ para
$v(t) = V_m cos(omega t + phi)$, con $V_"ef" = V_m \/ sqrt(2)$.

$ P = 1/2 V_m I_m cos theta ["W"] quad quad
  Q = 1/2 V_m I_m sin theta ["VAr"] quad quad S = 1/2 V_m I_m ["VA"] $

$ S = sqrt(P^2 + Q^2) quad quad "f.d.p." = cos theta = P/S $

$ "en eficaz, las mismas tres sin el" 1/2: quad P = V_"ef" I_"ef" cos theta quad
  Q = V_"ef" I_"ef" sin theta quad S = V_"ef" I_"ef" $

$ Q_C = P (tan theta - tan theta') quad arrow.r quad C = (Q_C)/(omega V_"ef"^2)
  quad ("corrección del" cos phi) $

$ omega_0 = 1/sqrt(L C) quad quad Q_"serie" = (omega_0 L)/R quad quad
  "BW" = f_0/Q quad quad V_L = V_C = Q dot V $

$ overline(Z)_L = overline(Z)_"th"^* quad arrow.r quad
  P_"máx" = (V_(m,"th")^2)/(8 R_"th") = (V_("ef","th")^2)/(4 R_"th")
  quad ("máxima transferencia en alterna") $

=== Módulo 12 — Bode y filtros

$ A_"dB" = 20 log_10 (V_2/V_1) = 10 log_10 (P_2/P_1) quad quad
  -3 "dB" arrow.r 1/sqrt(2) "en tensión", 1/2 "en potencia" $

$ "Pasa bajos": overline(H) = 1/(1 + j omega\/omega_c) quad quad
  "Pasa altos": overline(H) = (j omega\/omega_c)/(1 + j omega\/omega_c) quad quad
  f_c = 1/(2 pi R C) $

Polo simple: $-20$ dB/déc y $-90 degree$. Cero simple: $+20$ dB/déc y $+90 degree$.
En el quiebre: $-3$ dB y $-45 degree$.

$ v_"cuad" (t) = (4V)/pi sum_(n "impar") 1/n sin(n omega t) quad quad
  t_r = 2,2 tau approx (0,35)/(f_c) $

=== Módulo 13 — Cuadripolos y AO

$ bold(z): V = bold(z) I quad quad bold(y): I = bold(y) V quad quad
  bold(h): (V_1, I_2) "de" (I_1, V_2) quad quad bold(A B C D): "cascada" $

Recíproco $arrow.r z_12 = z_21$. Transistor en emisor común: $h_(f e) = beta$.

*Reglas de oro del AO* (realimentación negativa, sin saturar):
$v_+ = v_-$ y $i_+ = i_- = 0$.

$ "Inversor": v_s = -(R_2)/(R_1) v_e quad quad
  "No inversor": v_s = (1 + (R_2)/(R_1)) v_e quad quad
  "Seguidor": v_s = v_e $

$ "Integrador": v_s = -1/(R C) integral v_e dif t quad quad
  "Derivador": v_s = -R C (dif v_e)/(dif t) quad quad
  G dot "BW" = "GBW" $

=== Módulo 15 — Simulación con SPICE

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    table.header([*Directiva*], [*Para qué*]),
    [`.op`], [punto de reposo en continua],
    [`.dc V1 0 5 0.01`], [barrido de continua: característica $v$–$i$],
    [`.tran 0 <tstop> 0 <tmax>`],
      [transitorio. `tmax` $<= tau\/100$, y $<= T_d\/100$ si oscila],
    [`.ac dec 100 10 1Meg`], [respuesta en frecuencia: Bode],
    [`.ic V(vc)=3V`], [tensión inicial de un capacitor],
    [`.ic I(L1)=50mA`], [corriente inicial de un inductor],
    [`.step param R list 10 100 2k`], [barre el parámetro `{R}` y superpone las curvas],
    [`.meas TRAN e INTEG V(r)*I(r)`], [integra: energía disipada],
    [`.meas TRAN t WHEN V(o)=3.16`], [el instante en que la curva cruza un valor],
  ),
  caption: [Las directivas que hacen falta para los transitorios],
)

Fuentes: `PULSE(V1 V2 Tdelay Trise Tfall Ton Tperiod)` —sin `Tperiod`, un solo escalón—,
`PWL(t1 v1 t2 v2 ...)` lineal por tramos, `SIN(Voff Vamp Freq)`, y `AC 1` para el `.ac`.

Parásitos: `Rser`, `Cpar` en el inductor; `RSer`, `Rpar`, `Lser` en el capacitor.

*Los cinco controles* de toda curva simulada: $x(0^+)$, $x(infinity)$, $tau$ (o $alpha$ y
$omega_d$), la continuidad de $i_L$ y $v_C$, y el balance de energía.

== La guía asincrónica de bobinas, capacitores y RL/RC/RLC

Los doce problemas de la actividad asincrónica de *Teoría de Circuitos* —capítulos 6, 7 y
8 de Nilsson y Riedel— se resuelven todos con material de los módulos 10 y 15. Esta tabla
dice, para cada uno, *dónde está la herramienta* y *cuál es el control que lo cierra*. Los
enunciados, las figuras y los valores se toman del libro.

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    table.header([*Problema*], [*Qué pide, y con qué se hace*], [*El control*]),

    [*6.1*],
      [$i(t)$ triangular en una bobina: escribir $v_L$, $p_L$ y $E_L$ por tramos.
       M10, «Las relaciones $v$–$i$, vistas». Simulación con `PWL`.],
      [$v_L$ constante en cada tramo de pendiente constante, y *nula* donde la corriente
       no cambia.],

    [*6.2*],
      [El camino inverso: integrar $v_L$ por tramos para obtener $i_L$, con
       $i_L (0) = 0$. Misma sección.],
      [Un salto finito de $v_L$ cambia la *pendiente* de $i_L$, nunca su valor.],

    [*6.17*],
      [Pulso de corriente en un capacitor: $v_C$, $p_C$ y $E_C$. El dual del 6.1.],
      [La pendiente de $v_C$ es $i_C\/C$; con $i_C = 0$ la tensión se queda donde estaba.],

    [*6.25*],
      [Capacitancia equivalente vista desde dos bornes. M10, «Asociación».
       Verificación por simulación con una senoidal de 1 V y 1 kHz.],
      [$C_"eq" = |I_"in"|\/(2 pi f |V_"in"|)$ tiene que dar lo mismo que la reducción
       serie-paralelo, y para *cualquier* frecuencia en el modelo ideal.],

    [*7.1*],
      [Conmutación en un RL: corrientes en $0^-$ y en $0^+$, y por qué una corriente de
       rama puede saltar. M10, «Condiciones iniciales».],
      [$i_L (0^+) = i_L (0^-)$ aunque las otras corrientes salten.],

    [*7.4*],
      [Reconstruir $R$, $tau$, $L$ y la energía inicial a partir de $v(t)$ e $i(t)$
       dadas. Tiempo para disipar el $80 %$ de la energía.],
      [La energía decae como $e^(-2t\/tau)$: el $80 %$ está en $0,80 tau$, no en
       $1,6 tau$.],

    [*7.8*],
      [Descarga RL y balance de energía completo; cuántos $tau$ para el $95 %$.
       M10, «Energía: quién la guarda y quién la quema».],
      [La energía disipada total tiene que ser igual a $1/2 L i_L^2 (0)$. El $95 %$ cae en
       $1,50 tau$.],

    [*7.21*],
      [Conmutación RC con energía *atrapada*: energía inicial, atrapada y disipada.],
      [El balance sólo cierra si se cuenta la energía que queda encerrada en los
       capacitores aislados.],

    [*7.23*],
      [Identificar $R$, $C$ y $tau$ desde $v(t)$ e $i(t)$; energía disipada a 60 ms.],
      [$v(t)\/i(t)$ es *constante e igual a $R$* durante toda la respuesta natural.],

    [*7.25*],
      [Energía disipada en una descarga RC y tiempo para el $75 %$, con dos llaves que
       conmutan a la vez.],
      [Como $w_C prop v_C^2$, el porcentaje se calcula sobre el *cuadrado* de la
       exponencial.],

    [*8.1*],
      [Raíces y clasificación de un RLC paralelo; qué $R$ hacen falta para cada régimen.
       M10, «El RLC paralelo» y «Diseño inverso».],
      [Las tres simulaciones tienen que mostrar tres *formas* distintas, no sólo tres
       números distintos.],

    [*8.38*],
      [Respuesta críticamente amortiguada: $R$, $i(0^+)$, $dif i\/dif t (0^+)$ y
       $v_C (t)$. M10, «Las dos constantes».],
      [Una sola cruzada por cero. Con $R$ movido $plus.minus 20 %$ tienen que aparecer los
       otros dos regímenes.],
  ),
  caption: [Los doce problemas, con la sección que los resuelve y su control],
)

#clave[
  *Lo que la guía pide y no está en ningún problema en particular*: la segunda pasada con
  no idealidades (M10, «Los componentes reales»; M15, «Los parásitos en el modelo») y el
  criterio de simulación —paso $<= tau\/100$, y al menos 100 puntos por período
  amortiguado— que está en M15, «El paso de integración».
]

== Dos órdenes de lectura

El apunte se puede recorrer de dos maneras, según para qué se lo use.

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header(
      [*Orden de la materia (E.E.S.T. N.º 1)*],
      [*Orden de Teoría de Circuitos (UNSAM)*],
    ),
    [*1.* Mediciones y expansión de rango], [*7.* Elementos, convenciones y Kirchhoff],
    [*2.* Señales periódicas e instrumental], [*8.* Nodos, supernodos, mallas, supermallas],
    [*3.* Electromagnetismo y transformadores], [*9.* Teoremas de circuitos],
    [*4.* Diodos y rectificación], [*10.* Transitorios (natural y forzada)],
    [*5.* Fuentes lineales y zener], [*11.* Fasores y régimen permanente senoidal],
    [*6.* BJT en conmutación y relés], [*12.* Bode, filtrado y señales poliarmónicas],
    [*7 a 15.* Fundamentos de análisis de circuitos], [*13.* Cuadripolos],
    [], [*14.* El amplificador operacional],
    [], [*15.* Simulación con SPICE],
    [], [*1 a 6.* como aplicación y laboratorio],
  ),
  caption: [El mismo material, en las dos secuencias],
)

*Por qué la Parte I no se reordenó.* Los módulos 1 a 6 siguen el orden del temario y de
las guías de trabajos prácticos de la cátedra, y cada uno cierra con el TP que le
corresponde: alterar esa secuencia rompería la correspondencia con el laboratorio, que es
lo que le da sentido al curso de la escuela. La Parte II, en cambio, está ordenada
íntegramente según la secuencia de *Teoría de Circuitos*, que es autónoma y no depende de
los prácticos.

*Cómo se cruzan.* Los temas de la Parte II que la Parte I ya toca de manera aplicada se
cruzan por referencia y no se repiten: el valor eficaz y el osciloscopio están en el
Módulo 2 y se retoman en el 11 y el 12; el transformador del Módulo 3 reaparece en la
potencia aparente del 11; el filtro capacitivo del Módulo 5 es el transitorio del 10; y el
$beta$ del transistor del Módulo 6 es el $h_(f e)$ del 13. El Módulo 15 va al final
porque es el único que no aporta teoría propia: es el banco de pruebas de los catorce
anteriores, y se puede leer en cualquier momento a partir del 10. Quien dicte la materia en el
orden de la escuela puede usar la Parte II como fundamento al que volver; quien la use
para preparar Teoría de Circuitos, leerla de corrido y tomar la Parte I como banco de
ejemplos reales.

== Símbolos usados en el apunte

#circuito([Símbolos de circuito])[
#fig-tabla-simbolos()
]

== Seguridad en el laboratorio

#atencion[
  *La red mata.* No es una frase hecha: 220 V a través del pecho producen fibrilación
  ventricular con corrientes del orden de los 30 mA — menos de lo que consume el relé del
  Módulo 6. Y la piel húmeda baja la resistencia del cuerpo varias veces.
]

Reglas que no se negocian:

+ *Nunca* se modifica un circuito con la alimentación conectada. Se desenchufa, se
  modifica, se revisa, se enchufa.
+ El *primario* del transformador y todo lo que esté antes de él es zona de 220 V: sus
  conexiones van aisladas y firmes, nunca con cables sueltos apoyados en el protoboard.
+ Se trabaja con *una sola mano* cuando hay tensión de red presente, y la otra fuera del
  banco. Así se evita que la corriente atraviese el tórax de un brazo al otro.
+ *No* se trabaja con las manos húmedas, ni sobre superficies metálicas o mojadas.
+ Antes de tocar un capacitor de filtro grande, *descargarlo*: puede conservar la carga
  varios minutos después de desenchufar la fuente, y con 300 V almacenados el golpe es
  serio.
+ Verificar la *polaridad de los electrolíticos* antes de energizar. Un electrolítico al
  revés explota y puede lastimar los ojos.
+ Comprobar con el tester que la fuente entrega la tensión esperada *antes* de conectar
  el circuito, no después.
+ Ante cualquier olor a quemado, humo o calentamiento anormal: *cortar la alimentación
  primero*, investigar después.

#laboratorio[
  Rutina de verificación antes de energizar cualquier montaje: (1) polaridad de la fuente,
  (2) polaridad de los electrolíticos, (3) orientación de los diodos, (4) que no haya
  puentes accidentales entre las filas del protoboard, (5) función y borne correctos en
  el multímetro. Treinta segundos de revisión evitan la mayoría de los componentes
  quemados del año.
]
