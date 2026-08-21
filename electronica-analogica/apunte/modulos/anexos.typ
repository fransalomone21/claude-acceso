#import "../plantilla.typ": *

#modulo("Anexos", [
  Material de consulta rápida: código de colores, series de valores comerciales,
  formulario completo de la materia, símbolos y normas de seguridad del laboratorio.
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
