#import "../plantilla.typ": *

// =====================================================================
//  ANDAMIO DE LOS MODULOS 2 A 6
//
//  Cada seccion de este archivo se convierte, cuando se escriba, en su
//  propio archivo modulos/mN-<nombre>.typ y se agrega el #include
//  correspondiente en apunte.typ. Este archivo se borra al terminar M6.
//
//  Lo que hay aca NO es relleno: es el plan de contenido ya decidido,
//  con las deducciones y los ejercicios que van en cada modulo, para
//  que la proxima sesion no tenga que volver a disenarlo.
// =====================================================================

#modulo("Señales periódicas e instrumental de laboratorio", [
  #text(fill: c-rojo, weight: "bold")[MÓDULO PENDIENTE DE REDACCIÓN.] A continuación,
  el plan de contenido ya decidido.
])

== Contenido planificado

+ *Qué es una señal.* Señal continua vs. alterna, periódica vs. aperiódica.
+ *Parámetros*: $V_p$, $V_(p p)$, $V_"ef"$, $V_m$, $T$, $f$, $omega$, fase.
  Relaciones $f = 1\/T$ y $omega = 2 pi f$.
+ *Deducciones obligatorias* (son el núcleo del módulo):
  - $V_"ef" = sqrt(1/T integral_0^T v^2(t) dif t)$ como definición energética, y de ahí
    $V_"ef" = V_p\/sqrt(2)$ para la senoidal, $V_"ef" = V_p$ para la cuadrada,
    $V_"ef" = V_p\/sqrt(3)$ para la triangular.
  - $V_m = 2V_p\/pi$ (senoidal rectificada), $V_m = V_p\/2$ (triangular).
  - Factor de forma $V_"ef"\/V_m = 1,11$: de dónde sale y por qué un tester no True RMS
    miente con señales no senoidales (se anticipó en el Módulo 1).
+ *Expresión matemática*: $v(t) = V_p sin(2 pi f t + phi)$. Conversión
  sexagesimal $arrow.l.r$ radianes.
+ *Osciloscopio*: base de tiempo, atenuador vertical, acoplamiento CA/CC/GND, trigger,
  punta x1/x10. Cómo se leen $V_(p p)$ y $T$ contando divisiones.
+ *Generador de funciones de audio*: amplitud, offset, frecuencia, forma de onda.
+ *Filtro pasa bajos RC*: $X_C = 1\/(2 pi f C)$, divisor con $Z$,
  $f_c = 1\/(2 pi R C)$. Lo pide el TP 5, punto 4.

== Ejercicios resueltos previstos

+ Dada $v(t) = 10 sin(2 pi dot 50 t)$: obtener todos los parámetros y graficarla a
  escala (TP 4, punto 8).
+ Configurar el osciloscopio para $V_"ef" = 2,42$ V y $omega = 6280$ 1/s: calcular
  $V_(p p) = 6,84$ V, $f = 1000$ Hz, y elegir Volts/Div y Time/Div (TP 5, punto 1c).
+ Filtro RC de 1 k$Omega$ y 1 $mu$F ($f_c = 159$ Hz) evaluado a 160 Hz, 1,6 kHz y
  1,6 MHz (TP 5, punto 4).

#tp("TP N.º 4 y 5 — I Cuatrimestre")[
  Análisis de señales y manejo del osciloscopio, incluido el filtro pasa bajos RC.
]

#modulo("Electromagnetismo y transformadores de CA", [
  #text(fill: c-rojo, weight: "bold")[MÓDULO PENDIENTE DE REDACCIÓN.]
])

== Contenido planificado

+ Campo magnético, flujo $Phi$, ley de Faraday $e = -N (dif Phi)/(dif t)$, ley de Lenz.
+ Núcleo de hierro laminado: por qué laminado (corrientes de Foucault).
+ *Transformador ideal*: deducción de $V_1\/V_2 = N_1\/N_2 = I_2\/I_1$ a partir de
  Faraday y de la conservación de la potencia.
+ Relación de transformación $n$. Reducción de los 220 V de red.
+ Potencia aparente $S$ [VA] vs. potencia real $P$ [W], factor de potencia, rendimiento.
+ Transformador con *punto medio* (center tap): por qué da dos tensiones en
  contrafase. Es la base del TP 7, parte 3.
+ Pérdidas: en el cobre ($I^2 R$) y en el hierro (histéresis + Foucault).

== Ejercicios resueltos previstos

+ Transformador 220 V / 12 V, secundario de 1 A: calcular $n$, $N_2$ si $N_1 = 1100$,
  la corriente del primario y la potencia aparente.
+ Dimensionar el transformador de la fuente del TP 7 partiendo de la corriente de carga.

#modulo("Diodos semiconductores y rectificación", [
  #text(fill: c-rojo, weight: "bold")[MÓDULO PENDIENTE DE REDACCIÓN.]
])

== Contenido planificado

+ Semiconductores, dopaje N y P, juntura PN, barrera de potencial.
+ *Modelos del diodo*: ideal (llave), de caída fija (0,7 V Si / 0,3 V Ge), y con
  resistencia dinámica. Ecuación de Shockley $I_D = I_S (e^(V_D\/eta V_T) - 1)$ como
  referencia, no para calcular a mano.
+ Curva característica directa e inversa; tensión de ruptura.
+ *LED*: cálculo de la resistencia serie $R = (V_"cc" - V_F)\/I_F$; $V_F$ por color.
+ *Diodo de protección contra inversión de polaridad*: en serie y en antiparalelo
  (crowbar). También el diodo volante (flyback) sobre bobinas — engancha con el M6.
+ *Topologías de rectificación*, con la forma de onda y las tres fórmulas de cada una:
  - Media onda: $V_"cc" = V_p\/pi$, $f_"ripple" = f_"red"$, PIV $= V_p$.
  - Onda completa con punto medio: $V_"cc" = 2V_p\/pi$, $f_"ripple" = 2f_"red"$,
    PIV $= 2V_p$.
  - Puente de Graetz: $V_"cc" = 2V_p\/pi$, $f_"ripple" = 2f_"red"$, PIV $= V_p$,
    con la caída de *dos* diodos ($V_p - 1,4$ V).
+ Lectura del datasheet del *1N4007*: $V_"RRM"$, $I_F$, $I_"FSM"$, $V_F$, $I_R$,
  $t_"rr"$, $C_j$ (tabla del TP 6, punto 3).

== Ejercicios resueltos previstos

+ Rectificador de media onda, 12 V#sub[ef] sobre 1 k$Omega$: $V_p$, $V_"cc"$,
  corriente de pico y potencia en la carga (TP 7, parte 1).
+ LED rojo con 330 $Omega$: hallar la tensión de alimentación que da 20 mA
  (TP 6, punto 2).

#modulo("Fuentes de alimentación lineales", [
  #text(fill: c-rojo, weight: "bold")[MÓDULO PENDIENTE DE REDACCIÓN.]
])

== Contenido planificado

+ *Anatomía de la fuente*: transformador $arrow.r$ rectificador $arrow.r$ filtro
  $arrow.r$ regulador $arrow.r$ carga. Forma de onda a la salida de cada etapa.
+ *Filtro capacitivo*: el capacitor como reservorio. Deducción del ripple a partir de
  $i = C (dif v)/(dif t)$ suponiendo descarga lineal:
  $ Delta V_r = I_"cc" / (f_r dot C) $
  con $f_r = 50$ Hz en media onda y $f_r = 100$ Hz en onda completa. De ahí
  $C = I_"cc"\/(f_r dot Delta V_r)$ y $V_"cc" = V_p - Delta V_r\/2$.
+ Ripple porcentual $r = Delta V_r\/V_"cc" dot 100$. Factor de rizado.
+ *Regulador con diodo zener* (no está en el temario original, pero *sí en el TP 8*):
  cálculo de $R_S$, corriente mínima de mantenimiento, $I_(Z "máx")$, potencia disipada
  en $R_S$ y en el zener. Componente del TP: *1N4733* (5,1 V).
+ Mención de los reguladores integrados de tres patas (78xx/79xx) como cierre.

== Ejercicios resueltos previstos

+ Puente de Graetz, 12 V#sub[ef], carga de 1 k$Omega$, $C = 100 mu$F: calcular $V_p$,
  $V_"cc"$, $Delta V_r$ y el ripple porcentual. Repetir en media onda y comparar
  (TP 7, partes 1 y 2 — el factor 2 en $f_r$ es el punto pedagógico).
+ Dimensionar $R_S$ del zener 1N4733 para 5,1 V con carga de 1 k$Omega$, verificando
  $I_Z >= 5$ mA y la potencia del zener (TP 8).

#tp("TP N.º 7 y 8 — II Cuatrimestre")[
  Fuentes de alimentación (media onda, puente, fuente doble con punto medio) y fuente
  regulada con zener. Son los dos TPs más largos de la materia.
]

#modulo("Transistores BJT en conmutación", [
  #text(fill: c-rojo, weight: "bold")[MÓDULO PENDIENTE DE REDACCIÓN.]
])

== Contenido planificado

+ Estructura NPN y PNP, las tres zonas de trabajo: corte, activa y saturación.
+ Por qué en conmutación solo interesan *corte* y *saturación*: en ambas la potencia
  disipada es mínima ($I approx 0$ o $V_"CE" approx 0$).
+ Relaciones: $I_E = I_B + I_C$, $beta = I_C\/I_B$, $V_"CE(sat)" approx 0,2$ V,
  $V_"BE(on)" approx 0,7$ V.
+ *Diseño del circuito de base*: partir de la carga, hallar $I_C$, aplicar un
  $beta$ forzado (típicamente $beta_"forzado" = 10$, o sea sobreexcitar por 3 a 10 veces)
  y despejar
  $ R_B = (V_"in" - V_"BE") / I_B quad "con" quad I_B = I_C / beta_"forzado" $
+ *Actuador con relé*: bobina, corriente de bobina, contactos NA/NC, y el
  *diodo volante* en antiparalelo (1N4148 o 1N4007) — sin él se destruye el transistor.
+ *Lectura de datasheet*: BC547 / 2N2222 / TIP31. Cómo se leen $h_"FE"$ (y por qué se
  toma el peor caso), $I_(C "máx")$, $V_"CEO"$, $P_"tot"$, y el encapsulado.

== Ejercicios resueltos previstos

+ Excitar un relé de 12 V cuya bobina consume 60 mA desde una salida lógica de 5 V con
  un BC547: verificar que $I_C$ está dentro de lo admisible, calcular $R_B$ con
  $beta_"forzado" = 10$, y verificar la potencia disipada.
+ Leer el datasheet del BC547 y justificar por qué se usa $h_"FE"$ mínimo y no típico
  para diseñar.

#modulo("Anexos", [
  #text(fill: c-rojo, weight: "bold")[PENDIENTE.]
])

== Contenido planificado

+ Código de colores de resistores y series normalizadas E12 / E24.
+ Formulario completo de la materia, de una carilla.
+ Resumen de las tres topologías de rectificación en una sola tabla comparativa.
+ Tabla de $V_F$ típica por color de LED.
+ Símbolos de circuito usados en el apunte.
+ Guía de seguridad eléctrica en el laboratorio (trabajo con 220 V).
