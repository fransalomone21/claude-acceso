// =====================================================================
//  Anexo A — Guía de ejercicios: disparadores y respuestas
//  Los 40 enunciados de fuentes/GUIA-ENUNCIADOS.md, en fichas de práctica.
// =====================================================================

#import "../plantilla.typ": *

#anexo("A", "Guía de ejercicios — disparadores y respuestas", [
  Los enunciados de `fuentes/GUIA-ENUNCIADOS.md`, organizados en las mismas
  cinco secciones que la guía de la cátedra. Cada ficha dice qué conceptos,
  ecuaciones o módulos aplicar y da la *respuesta final sola* — nunca el
  desarrollo: eso ya está en los cuadros verdes de cada módulo. La idea es
  resolver primero y mirar la ficha después, no al revés.
])

Los enunciados de acá van resumidos; el texto completo de la guía, con las
figuras que hagan falta, está en `fuentes/GUIA-ENUNCIADOS.md`. Una respuesta
marcada _"ya resuelto en tal módulo"_ tiene su desarrollo completo adentro
del apunte, mirado en el render; una marcada _(cuenta propia de este anexo)_
se calculó para esta ficha con las herramientas citadas y no tuvo esa
segunda mirada — si algo no cierra al resolverlo, sospechar primero de la
ficha, no del módulo.

#subtitulo-anexo("A.1 — Vectores (Ej. 9 a 15)")

#disparador(
  [Ej. 9 — velocidad en polares],
  [Con $R$ el módulo del vector posición, $theta$ su ángulo, y $hat(r)$,
  $hat(theta)$ los versores polares: escribir la velocidad de un punto en
  coordenadas polares.],
  resuelve: [derivar $bold(r) = r hat(r)$ con $dot(hat(r)) = dot(theta) hat(theta)$ — sección 1.6 del módulo #M("vectores").],
  [$bold(v) = dot(r) hat(r) + r dot(theta) hat(theta)$.],
)

#disparador(
  [Ej. 10 — el cohete visto por el radar],
  [Un cohete se lanza verticalmente desde $B$. Un radar en $A$, a distancia
  horizontal fija $b$, lo sigue con ángulo de elevación $theta$. Determinar
  la velocidad del cohete en términos de $b$, $theta$ y $dot(theta)$.],
  resuelve: [geometría $r = b\/cos theta$ + velocidad en polares (#M("vectores")). Ya resuelto entero como ejemplo a fondo.],
  [$v = (b dot(theta))\/cos^2 theta$ — control: coincide con derivar $y = b tan theta$ directamente.],
)

#disparador(
  [Ej. 11 — cosenos directores de $bold(A) = (1,-1,3)$],
  [Hallar los cosenos directores.],
  resuelve: [$abs(bold(A)) = sqrt(11)$, cosenos $= A_i \/ abs(bold(A))$ (#M("vectores")). Ya resuelto como ejemplo.],
  [$cos alpha = 0,302$, $cos beta = -0,302$, $cos gamma = 0,905$.],
)

#disparador(
  [Ej. 12 — cosenos directores, vector paralelo al eje $Z$],
  [Hallar los cosenos directores de los vectores paralelos al eje $Z$.],
  resuelve: [caso trivial de la definición — ya resuelto como parte del ejemplo de arriba.],
  [$(0,0,1)$ o $(0,0,-1)$ según el sentido.],
)

#disparador(
  [Ej. 13 — versor perpendicular a $bold(A)=(0,1,5)$ y $bold(B)=(-3,0,2)$],
  [Hallar el versor perpendicular a los dos.],
  resuelve: [$bold(A) times bold(B)$ y normalizar (#M("vectores")). Ya resuelto como ejemplo — hay *dos* respuestas válidas, opuestas entre sí.],
  [$hat(n) approx (0,130;thin -0,972;thin 0,194)$ (o su opuesto).],
)

#disparador(
  [Ej. 14 — proyección de $bold(B)=(2,5,-1)$ sobre $bold(A)=(1,0,-3)$],
  [Hallar la proyección de $bold(B)$ sobre $bold(A)$.],
  resuelve: [$"proy"_bold(A) bold(B) = (bold(A) dot bold(B)) \/ abs(bold(A))$ (#M("vectores")). Ya resuelto como ejemplo.],
  [escalar $approx 1,581$; vectorial $(0,5;thin 0;thin -1,5)$.],
)

#disparador(
  [Ej. 15 — seis productos con $bold(A)=(2,0,-3)$, $bold(B)=(-1,5,2)$, $bold(C)=(0,-4,1)$],
  [Calcular: i) $bold(A) dot (bold(B) times bold(C))$; ii) $bold(A) times (bold(B) times bold(C))$;
  iii) $(bold(A) times bold(B)) times bold(C)$; iv) $bold(A) times (bold(A) times bold(B))$;
  v) $(bold(A) dot bold(B))(bold(A) times bold(B))$; vi) $(bold(A) times bold(B)) times (bold(A) times bold(C))$.],
  resuelve: [producto mixto (determinante) y BAC$-$CAB (#M("vectores"), @vec-dobles). El punto del ejercicio es que ii) y iii) *no* coinciden: el producto vectorial no es asociativo.],
  [i) $14$ — ii) $(3,-47,2)$ — iii) $(39,-15,-60)$ — iv) $(-3,-65,-2)$ — v) $(-120,8,-80)$ — vi) $(28,0,-42)$. _(cuenta propia de este anexo)_],
)

#subtitulo-anexo("A.2 — Conservación de cantidad de movimiento (Ej. 1 a 9, más tres adicionales)")

#disparador(
  [Ej. 1 — la astronauta y la herramienta (S&Z 8.16)],
  [Una astronauta de 68,5 kg arroja una herramienta de 2,25 kg a 3,20 m/s
  respecto de la estación. ¿Con qué rapidez se mueve la astronauta?],
  resuelve: [conservación de $bold(P)$ con $bold(P)=0$ antes y después (#M("cantidad-movimiento")). Ya resuelto, y otra vez desde el CM en #M("centro-de-masa").],
  [$v_a = -0,105$ m/s (sentido contrario al de la herramienta).],
)

#disparador(
  [Ej. 2 — choque oblicuo de dos asteroides (S&Z 8.31)],
  [Dos asteroides de igual masa chocan oblicuamente: $A$ iba a 40,0 m/s, se
  desvía 30,0° y $B$ (en reposo) sale a 45,0° del otro lado. Rapidez de cada
  uno después, y fracción de energía disipada.],
  resuelve: [conservación vectorial de $bold(P)$, dos ejes (#M("cantidad-movimiento")). Ya resuelto, y auditado otra vez desde el CM en #M("centro-de-masa").],
  [$v_A = 29,3$ m/s, $v_B = 20,7$ m/s; se disipa el $19,6%$ de $K$.],
)

#disparador(
  [Ej. 3 — el calamar (S&Z 8.19)],
  [Mismo mecanismo que el Ej. 1, con otro disfraz en la parte (a); la parte
  (b) pide la energía cinética que genera la propulsión.],
  resuelve: [(a) #M("cantidad-movimiento") — (b) #M("trabajo-energia").],
  [sin dato numérico transcripto acá — el planteo es igual al del Ej. 1.],
)

#disparador(
  [Ej. 4 — unidad de maniobra del astronauta (S&Z 8.61)],
  [De $a = 0,029$ m/s² y $M = 180$ kg, hallar el empuje y el caudal del gas
  expulsado a $v_r = 490$ m/s.],
  resuelve: [empuje $f=M a$ despejado al revés, caudal $mu = f\/abs(v_r)$ (#M("cohete")).],
  [$f = 5,22$ N; $mu = 1,07 times 10^(-2)$ kg/s (0,053 kg en 5 s).],
)

#disparador(
  [Ej. 5 — S&Z 8.63],
  [Ecuación de Tsiolkovsky sin gravedad, despejando la razón de masas.],
  resuelve: [#M("cohete").],
  [sin dato numérico transcripto acá.],
)

#disparador(
  [Ej. 6 — Beer 14.94],
  [Cohete de 1200 kg (1000 kg de combustible), consume 12,5 kg/s a 4000 m/s
  relativos, lanzado verticalmente. Aceleración al despegar y al agotarse
  el combustible.],
  resuelve: [empuje $f=mu abs(v_r)$ constante, $a=(f-M g)\/M$ con $M$ inicial y final (#M("cohete")). Ya resuelto.],
  [$a_"despegue" = 31,9$ m/s²; $a_"final" = 240$ m/s² ($approx 24 g$).],
)

#disparador(
  [Ej. 7 y 8 — una etapa contra dos, mismos kilos (Beer 14.97/14.98)],
  [Nave de 540 kg, mismo $mu=225$ kg/s y $abs(v_r)=3600$ m/s en los dos
  casos: (a) una etapa de 19 Mg; (b) dos etapas de 9,5 Mg. Rapidez máxima
  en cada caso.],
  resuelve: [ecuación de Tsiolkovsky aplicada tramo por tramo, sin olvidar la cubierta que se desprende (#M("cohete")). Ya resuelto.],
  [una etapa: $V_f = 7,93$ km/s. Dos etapas: $V_f = 9,24$ km/s — 1,31 km/s más, mismo combustible.],
)

#disparador(
  [Ej. 9 — Beer 14.99],
  [Pide la *altura* alcanzada en el Ej. 7: hay que integrar $V(t)$ otra vez.],
  resuelve: [#M("cohete").],
  [sin dato numérico transcripto acá.],
)

#disparador(
  [Adicional 1 — separación de dos etapas en inercia],
  [Tercera (400 kg) y cuarta (200 kg) etapa viajan juntas a 18 000 km/h;
  una carga las separa y la cuarta queda a 18 060 km/h. Velocidad de la
  tercera, y velocidad relativa entre las dos.],
  resuelve: [conservación de $bold(P)$ con las dos masas en movimiento (#M("cantidad-movimiento")). Ya resuelto.],
  [$v_3 = 17 thin 970$ km/h; velocidad relativa $-90$ km/h.],
)

#disparador(
  [Adicional 2 — satélite expulsado del transbordador],
  [Transbordador (90 Mg) expulsa un satélite de 800 kg durante 4 s,
  dándole 0,3 m/s en $z$ *respecto del transbordador*. Velocidad final del
  transbordador y fuerza media de expulsión.],
  resuelve: [conservación de $bold(P)$ con velocidad relativa dada, más $bold(J)=Delta bold(p)$ (#M("cantidad-movimiento")). Ya resuelto.],
  [$v_"transb" = -2,643 times 10^(-3)$ m/s; $F_"prom" = 59,5$ N.],
)

#disparador(
  [Adicional 3 — el cohete, y el transbordador con varios motores],
  [(a) De $mu=220$ kg/s, $abs(v_r)=900$ m/s y $a=6$ m/s², hallar la masa
  total al lanzamiento. (b) El transbordador (2,04 × 10⁶ kg) con dos SRB
  (11,80 × 10⁶ N c/u) y tres SSME (2,00 × 10⁶ N c/u, $I_"sp"=455$ s):
  aceleración inicial y caudal de cada motor principal.],
  resuelve: [empuje $=mu abs(v_r)$, $M=f\/(a+g)$; empuje total, $a=f\/M_0 - g$; $mu = f_"motor"\/(I_"sp" g_0)$ (#M("cohete")). Ya resuelto.],
  [(a) $M = 12 thin 525$ kg. (b) $a = 4,70$ m/s²; $448,3$ kg/s por motor principal.],
)

#subtitulo-anexo("A.3 — Conservación de impulso angular (Problemas 1 a 7)")

#disparador(
  [Problema 1 — torque en seis casos (S&Z 10.1)],
  [Varilla de 4,00 m desde $O$, fuerza $F=10,0$ N aplicada de seis maneras
  distintas (ver figura E10.1 del libro: en el extremo o a 2,00 m, con
  ángulos de 30° a 180°, o directamente en $O$). Torque en cada caso.],
  resuelve: [$tau = r F sin phi$, brazo de palanca (#M("momento-angular")).],
  [a) $40,0$ — b) $34,6$ — c) $20,0$ — d) $17,3$ — e) $0$ — f) $0$ N·m (magnitudes; el sentido de cada una depende de la figura del libro, no transcripta acá). _(cuenta propia de este anexo)_],
)

#disparador(
  [Problema 2 — $bold(L)$ constante para una partícula libre],
  [Demostrar que el impulso angular de una partícula con velocidad
  constante es el mismo respecto de cualquier punto.],
  resuelve: [ya resuelto como ejemplo en #M("momento-angular").],
  [demostrado: $dot(bold(L)) = dot(bold(r)) times bold(p) = bold(v) times m bold(v) = bold(0)$, porque $bold(v) parallel bold(p)$.],
)

#disparador(
  [Problema 3 — $bold(L)$ igual para cualquier origen],
  [Dos partículas de igual masa y rapidez, en trayectorias paralelas
  opuestas separadas $d$: demostrar que $bold(L)$ del sistema no depende
  del origen elegido.],
  resuelve: [ya resuelto como ejemplo en #M("momento-angular").],
  [demostrado: la diferencia entre dos orígenes depende sólo de $bold(P)_"total"$, que acá es nulo.],
)

#disparador(
  [Problema (sin número) — el giroscopio de juguete (S&Z 10.51)],
  [Rotor de 0,140 kg, $I=1,20 times 10^(-4)$ kg·m², marco de 0,0250 kg,
  centro de masa a 4,00 cm del pivote. Precesa una vuelta cada 2,20 s.
  (a) Fuerza del pivote. (b) Rapidez angular del rotor.],
  resuelve: [$F_"pivote" = M_"total" g$; precesión estable $Omega_p = tau\/(I omega)$ con $tau = M_"total" g d$ (#M("euler-giroscopo"), #M("peonza")).],
  [(a) $F approx 1,62$ N. (b) $omega_"rotor" approx 1802$ rpm. _(cuenta propia de este anexo; supone que la distancia de 4 cm es al CM del conjunto rotor+marco)_],
)

#disparador(
  [Ejercicio 4 — el satélite de la figura],
  [Con los datos de la elipse (radios y velocidades en apogeo, perigeo y
  dos puntos intermedios): A) impulso angular específico en apogeo y
  perigeo. B) distancias a los dos puntos intermedios.],
  resuelve: [conservación de $h = r v cos gamma$ en los cuatro puntos (#M("momento-angular")).],
  [A) $h = 57 thin 172$ km²/s en los dos ábsides (coinciden — control ya hecho en la guía). B) $r approx 8388$ km (altura $approx 2010$ km) y $r approx 8578$ km (altura $approx 2200$ km). _(punto B: cuenta propia de este anexo)_],
)

#disparador(
  [Ej. 5 — la pregunta fina],
  [Formular la segunda ley de Kepler como velocidad areolar. ¿Hace falta
  que el potencial sea $1\/r$ (fuerza $1\/r^2$), o alcanza con que la
  fuerza sea central?],
  resuelve: [torque nulo respecto del centro de fuerza (#M("momento-angular")).],
  [alcanza con que la fuerza sea *central* — la conservación de $h$ (y de la velocidad areolar) no usa la forma de la fuerza, sólo que no tenga componente transversal.],
)

#disparador(
  [Ej. 6],
  [En blanco en el PDF de la cátedra: no hay enunciado que resolver.],
  resuelve: none,
  [— (si la cátedra lo completa alguna vez, revisar `fuentes/GUIA-ENUNCIADOS.md`).],
)

#disparador(
  [Ej. 7 — estabilización del Hubble (S&Z 10.53)],
  [Giróscopos modelados como cilindros de pared delgada, 2,0 kg y 5,0 cm de
  diámetro, a 19 200 rpm. Torque para precesar $1,0 times 10^(-6)$ grados
  en 5,0 horas.],
  resuelve: [$H=I omega$ del cilindro; $Omega_p = "ángulo"\/"tiempo"$; $tau = Omega_p H$ (#M("euler-giroscopo")).],
  [$tau approx 2,4 times 10^(-12)$ N·m. _(cuenta propia de este anexo)_],
)

#subtitulo-anexo("A.4 — Conservación de la energía y gravitación (Problemas 0 a 10, más cinco adicionales)")

#disparador(
  [Problema 0 — estimar la masa del Sol],
  [A partir de la órbita de la Tierra.],
  resuelve: [órbita circular, $v_"circ"$ (#M("gravitacion")). Ya resuelto.],
  [$M_"Sol" approx 1,99 times 10^30$ kg.],
)

#disparador(
  [Problema 1 — diagrama de energía potencial (S&Z 7.76)],
  [Partícula sobre el eje $x$, $U(x)$ dado por un gráfico; dirección de la
  fuerza en varios puntos, máximo de $K$, alcance máximo, equilibrios.],
  resuelve: [ya resuelto entero como ejemplo a fondo en #M("trabajo-energia").],
  [ver el módulo #M("trabajo-energia").],
)

#disparador(
  [Problema 2 — la sonda espacial (Beer)],
  [$v_A = 20,2 times 10^3$ mi/h, perpendicular al radio, con $h_A=2700$ mi
  y $h_B=7900$ mi sobre una Tierra de radio 3960 mi. Velocidad en $B$.],
  resuelve: [conservación de la energía (vis-viva), sin necesitar $h$ porque sólo se pide la rapidez (#M("gravitacion") / #M("orbita-conicas")).],
  [$v_B approx 7,00$ km/s ($approx 15 thin 650$ mi/h). _(cuenta propia de este anexo)_],
)

#disparador(
  [Problema 3 — órbita geosincrónica (Beer 12.80)],
  [Altura y velocidad de un satélite con período de un día sideral
  (23,934 h).],
  resuelve: [resuelto de paso dentro del Problema 6, abajo (#M("gravitacion")).],
  [altura $approx 35 thin 780$ km.],
)

#disparador(
  [Problema 4 — perigeo y apogeo (S&Z 13.67)],
  [Nave con perigeo a 400 km y apogeo a 4000 km de altura. (a) Período.
  (b) Razón de rapideces perigeo/apogeo. (c) Rapidez en cada uno.
  (d) $Delta v$ para escapar desde cada uno — ¿cuál conviene?],
  resuelve: [tercera ley de Kepler (#M("kepler")); conservación de $h$ y de $E$ (#M("orbita-conicas")). Ya resuelto — es el mismo satélite del Ej. 4 de impulso angular.],
  [$tau = 7907$ s; escapar conviene en el perigeo: $Delta v_p = 2,41$ km/s contra $Delta v_a = 3,26$ km/s.],
)

#disparador(
  [Problema 5 — Hohmann a Marte (S&Z 13.79)],
  [Sentido de encendido en Tierra y Marte; tiempo de viaje; ángulo de fase
  Sol-Marte/Sol-Tierra en el lanzamiento.],
  resuelve: [transferencia de Hohmann (#M("maniobras")). Ya resuelto.],
  [258,8 días de viaje; 44,4° de ángulo de fase en el lanzamiento.],
)

#disparador(
  [Problema 6 — subir a la geosíncrona (Beer 13.85)],
  [Satélite de 3600 kg en órbita circular a 300 km. (a) Energía para
  subirlo a la geosíncrona (35 770 km de altura). (b) Ídem lanzándolo
  directo desde la superficie.],
  resuelve: [$E=-mu m\/2a$ en cada órbita (#M("gravitacion")). Ya resuelto — resuelve de paso el Problema 3.],
  [(a) $90,6$ GJ. (b) $208,3$ GJ.],
)

#disparador(
  [Problema 7 — frenar en Júpiter (Beer 13.100)],
  [Nave a $v_A=26,9$ km/s en trayectoria parabólica hacia Júpiter (masa
  319 × la de la Tierra); frenar para quedar en una elipse con apoápside
  $100 times 10^3$ km. $Delta v$ necesario.],
  resuelve: [vis-viva antes (parábola) y después (elipse) en el mismo punto (#M("orbita-conicas")). Ya resuelto.],
  [$Delta v = 14,2$ km/s (capturar sólo cuesta 0,9 km/s menos que la velocidad parabólica).],
)

#disparador(
  [Problemas 8 y 9 — el LEM del Apollo (Beer 13.101)],
  [LEM sube desde 8 km sobre la Luna a encontrarse con el módulo de mando
  a 140 km; luego se impulsa 200 m/s respecto del módulo de mando y cae.
  Rapidez al apagar motor, velocidad relativa de encuentro, y velocidad y
  ángulo de impacto.],
  resuelve: [conservación de $h$ y $E$ entre los ábsides, dos veces (#M("kepler")). Ya resuelto.],
  [ver el módulo #M("kepler") — el LEM sube por una Hohmann lunar y baja a $79,2°$ de la vertical.],
)

#disparador(
  [Problema 10 — rendez-vous, un cuarto de órbita adelantado],
  [Investigar el problema del reencuentro orbital, formular una solución
  general y resolver un caso numérico.],
  resuelve: [órbita de fasaje, $T'\/T = 1 - Delta phi\/360°$ (#M("maniobras")). Ya resuelto.],
  [caso geosíncrono a un cuarto de vuelta: $Delta v = 698$ m/s en una sola vuelta de fasaje.],
)

#disparador(
  [Ejercicio adicional 1 — satélite no tripulado],
  [Radio de perigeo 10 000 km, radio de apogeo 100 000 km. Hallar:
  (a) excentricidad; (b) semieje mayor; (c) período (horas); (d) energía
  específica; (e) anomalía verdadera a 10 000 km de altitud; (f) $v_r$ y
  $v_perp$ ahí; (g) velocidad en perigeo y apogeo.],
  resuelve: [$e$ y $a$ de $r_p, r_a$; tercera ley de Kepler (#M("kepler")); $v_perp=h\/r$, $v_r=(mu\/h) e sin nu$ de la sección 16.5 (#M("hiperbola")); $v_p=h\/r_p$, $v_a=h\/r_a$.],
  [(a) $e=0,818$ — (b) $a=55 thin 000$ km — (c) $tau=35,7$ h — (d) $epsilon=-3,62$ km²/s² — (e) $nu approx plus.minus 82,3°$ — (f) $v_perp approx 5,20$ km/s, $v_r approx 3,80$ km/s — (g) $v_p=8,51$ km/s, $v_a=0,851$ km/s. _(cuenta propia de este anexo)_],
)

#disparador(
  [Ejercicio adicional 2 — perigeo a 500 km y 10 km/s],
  [Hallar el ángulo de trayectoria de vuelo $gamma$ y la altitud para una
  anomalía verdadera de 120°.],
  resuelve: [$h=r_p v_p$; energía específica da $a$ y $e$; ecuación de la órbita da $r(nu)$; $v_perp=h\/r$, $v_r=(mu\/h) e sin nu$ (#M("hiperbola"), sección 16.5).],
  [$gamma approx 44,6°$; altitud $approx 12 thin 250$ km. _(cuenta propia de este anexo)_],
)

#disparador(
  [Ejercicio adicional 3 — órbita polar, 200 km del polo cada 100 min],
  [Excentricidad de la órbita.],
  resuelve: [tercera ley de Kepler al revés, sin $h$ ni $E$ (#M("kepler")). Ya resuelto.],
  [$e = 0,0782$ (con $a=7136$ km, $r_p=6578$ km).],
)

#disparador(
  [Ejercicio adicional 4 — dos alturas con sus anomalías],
  [Altitud 1000 km a $nu=40°$, altitud 2000 km a $nu=150°$. Hallar:
  (a) excentricidad; (b) altitud de perigeo; (c) semieje mayor.],
  resuelve: [ecuación de la órbita en los dos puntos — sistema de dos ecuaciones en $p$ y $e$ (#M("orbita-conicas")).],
  [(a) $e approx 0,0775$ — (b) altura de perigeo $approx 876$ km — (c) $a approx 7863$ km. _(cuenta propia de este anexo)_],
)

#disparador(
  [Ejercicio adicional 5 — velocidad y $gamma$ dados],
  [$v=7,5$ km/s, $gamma=10°$, $r=8000$ km. Anomalía verdadera y
  excentricidad.],
  resuelve: [ya resuelto como ejemplo simple en #M("hiperbola") (sección 16.5).],
  [$e=0,215$, $nu=63,8°$.],
)

#subtitulo-anexo("A.5 — Cuerpo rígido (Problemas 1 a 9)")

#disparador(
  [Problema 1 — el satélite cúbico],
  [Cubo de 2 m de lado, 120 kg, con un thruster ($F_E=4$ N, $I_"sp"=50$ s)
  en un vértice, alineado con una arista. Velocidad angular tras 4 s de
  encendido; caudal másico del thruster; cuánto tiempo seguirá girando.],
  resuelve: [$bold(H)_G$ e inercia isótropa del cubo, $I=(1\/6)m d^2$ (#M("inercia")); caudal $=F\/(I_"sp" g_0)$ (#M("cohete")).],
  [$bold(omega) = 0,2 hat(j) - 0,2 hat(k)$ rad/s (ya resuelto en #M("inercia")); caudal $approx 8,16$ g/s _(cuenta propia de este anexo)_; y sigue girando *para siempre* — inercia isótropa, sin torque, las ecuaciones de Euler dan $omega$ constante.],
)

#disparador(
  [Problema 2 — el disco en la horquilla],
  [Disco de masa $m$, radio $r$, gira a $omega_1$ sobre un eje sostenido
  por una horquilla que rota a $omega_2$. Hallar $bold(L)_G$ y $d bold(L)_G\/d t$.],
  resuelve: [$bold(L)_G$ desde el tensor de inercia (#M("inercia")); su derivada, con la fórmula del sistema rotante (#M("euler-giroscopo")). Ya resuelto en los dos módulos.],
  [ver #M("inercia") y #M("euler-giroscopo") — el enunciado dice «eje vertical» pero la figura del PDF lo muestra horizontal: se resuelve con la figura, no con el texto.],
)

#disparador(
  [Problema 3 — el volante en el gimbal],
  [Volante ($omega_s=100$ rad/s en $z$, $I_x=I_y=5$, $I_z=10$ kg·m²) en un
  gimbal que gira a $omega_p=0,5$ rad/s en $y$. Aceleración angular del
  gimbal al aplicar 600 N·m en $x$.],
  resuelve: [cinemática del sistema rotante (#M("cinematica-cr")); ecuación de Euler con $bold(Omega) != bold(omega)$ (#M("euler-giroscopo")). Ya resuelto.],
  [$alpha_"gimbal" = 20$ rad/s² — de los 600 N·m, 500 se gastan en sostener la dirección de $bold(H)_O$.],
)

#disparador(
  [Problema 4 — el spacecraft que precesa],
  [Simétrico en $z$, radio de giro 720 mm (eje) y 540 mm (transversal).
  El eje $z$ describe un cono de 2° al precesar, con spin de 1,5 rad/s.
  Período de precesión.],
  resuelve: [$tan gamma = (I\/I') tan theta$, precesión estable sin torque (#M("peonza")). Ya resuelto.],
  [período de precesión $= 1,832$ s.],
)

#disparador(
  [Problema 5 — la estación orbital de cinco esferas],
  [Estructura de cinco esferas huecas; spin de 3 rev/min alrededor de su
  eje geométrico; el eje $A$-$A$ precesa con ángulo pequeño respecto de
  un eje $Z$ fijo. Velocidad angular de precesión.],
  resuelve: [sería el mismo mecanismo del Problema 4, $Omega_p = H\/I'$ (#M("peonza")).],
  [no se resuelve acá — la relación de inercias, tal como quedó transcripta, compara "la estructura respecto a A-A" con "cada esfera respecto a A-A respecto a O", que no da una sola razón $I\/I'$ clara sin ver la figura original. Conviene revisar el PDF de la cátedra antes de intentarlo.],
)

#disparador(
  [Problema 6 — la relación $ell\/r$],
  [Cilindro de paredes delgadas que rota sobre su eje de simetría, con
  precesión de ángulo pequeño. ¿Para qué $ell\/r$ la precesión es
  retrógrada, y para cuáles directa?],
  resuelve: [criterio de signo $dot(psi)\/dot(phi) = ((I'-I)\/I') cos theta$ (#M("peonza")). Ya resuelto.],
  [umbral $ell\/r = sqrt(6)$: directa de un lado, retrógrada del otro (caso límite isótropo, como el cubo del Problema 1).],
)

#disparador(
  [Problema 7 — la cápsula espacial],
  [Cápsula sin velocidad angular; cohete $A$ activo 1 s con 50 N en $x$;
  $m=1000$ kg, $k_x=k_y=1$ m, $k_z=1,25$ m. Eje de precesión y
  velocidades de spin y precesión al terminar el impulso.],
  resuelve: [sería impulso angular tras un torque breve (#M("euler-giroscopo")) + precesión resultante (#M("peonza")).],
  [no se resuelve acá — el brazo de palanca del cohete $A$ depende de sus coordenadas exactas sobre la cápsula (un tronco de cono), que están en la figura del PDF y no en el texto transcripto.],
)

#disparador(
  [Problema 8 — repetición del Problema 7],
  [Igual que el Problema 7, pero con $bold(omega) = 0,02 hat(j) + 0,10 hat(k)$
  rad/s previa y el cohete $B$ en vez del $A$.],
  resuelve: [mismo mecanismo que el Problema 7.],
  [no se resuelve acá, misma razón que el Problema 7: faltan las coordenadas del cohete, que están en la figura.],
)

#disparador(
  [Problema 9 — el satélite octogonal],
  [Octógono de 2500 kg, $I_y=2400$, $I_x=I_z=2000$ kg·m², girando a
  $omega_0$ en $y$. Thrusters $A$, $B$, $C$, $D$ en posiciones
  $bold(R)_A$, $bold(R)_B$, etc. Tipo de precesión, impulso y velocidad
  angulares tras el disparo, ángulos con el eje de simetría.],
  resuelve: [sería impulso angular tras el disparo (#M("inercia")) + ángulos de precesión y de spin (#M("peonza")).],
  [no se resuelve acá — pide las coordenadas $bold(R)_A$, $bold(R)_B$ de los thrusters, que están en la figura del PDF y no en el texto transcripto. Varios de sus puntos (1 a 7) son de todos modos simbólicos, no numéricos.],
)
