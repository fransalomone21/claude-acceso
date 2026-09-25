// =====================================================================
//  Anexo A — Guía de ejercicios: disparadores y respuestas
//  Los 40 enunciados de fuentes/GUIA-ENUNCIADOS.md, en fichas de práctica.
// =====================================================================

#import "../plantilla.typ": *
// voz: 2026-09-25 -- pasada de la fase 11, tanda (d)

#anexo("A", "Guía de ejercicios — disparadores y respuestas", [
  Los enunciados de `fuentes/GUIA-ENUNCIADOS.md`, organizados en las mismas
  cinco secciones que la guía de la cátedra. Cada ficha dice, en pocas
  líneas, *qué principio plantear y con qué ecuación* — pensada para
  alguien que baja el PDF sin haber leído los módulos, no sólo para quien
  ya los leyó — y da la *respuesta final de todos los incisos*, nunca el
  desarrollo: eso ya está en los ejemplos resueltos de cada módulo. La idea es
  resolver primero y mirar la ficha después, no al revés. Que nadie se
  engañe: todos vamos a mirar la ficha primero. Por lo menos que sea después
  de haber escrito el planteo.
])

Los enunciados de acá van resumidos; el texto completo de la guía, con las
figuras que hagan falta, está en `fuentes/GUIA-ENUNCIADOS.md`. Una respuesta
marcada _"ya resuelto en tal módulo"_ tiene su desarrollo completo adentro
del apunte, mirado en el render; una marcada _(cuenta propia de este anexo)_
se calculó para esta ficha con las herramientas citadas y no tuvo esa
segunda mirada — si algo no cierra al resolverlo, sospechar primero de la
ficha, no del módulo. Ningún inciso queda sin respuesta salvo que el dato
de partida no esté transcripto en ningún lado (se dice explícitamente
cuándo pasa eso, no se salta en silencio).

Y la advertencia vale en los dos sentidos. Hasta el 2026-09-25 las fichas
de los Problemas 4, 5, 6 y 9 de cuerpo rígido decían directa donde era
retrógrada y al revés, copiadas de un módulo que tenía un signo cambiado.
Las respuestas numéricas estaban bien; el sentido, no. Una respuesta que
coincide con la del compañero no está verificada: puede ser que los dos
hayan copiado del mismo apunte.

#subtitulo-anexo("A.1 — Vectores (Ej. 9 a 15)")

Los ejercicios que parecen de trámite y no lo son: el 9 y el 10 son la
cinemática en polares que vuelve, sin avisar, en órbitas y en cuerpo
rígido. Los del 1 al 8 son cuentas de producto escalar y vectorial y no
tienen ficha: si hace falta una ficha para eso, hace falta el módulo
#M("vectores") entero.

#disparador(
  [Ej. 9 — velocidad en polares],
  [Con $r$ el módulo del vector posición, $theta$ su ángulo, y $hat(r)$,
  $hat(theta)$ los versores polares: escribir la velocidad de un punto en
  coordenadas polares.],
  resuelve: [derivar $bold(r) = r hat(r)$ con la regla del producto, usando que $dot(hat(r)) = dot(theta) hat(theta)$ porque el versor gira con la partícula (#M("vectores"), sección 1.6).],
  [$bold(v) = dot(r) hat(r) + r dot(theta) hat(theta)$.],
)

#disparador(
  [Ej. 10 — el cohete visto por el radar],
  [Un cohete se lanza verticalmente desde $B$. Un radar en $A$, a distancia
  horizontal fija $b$, lo sigue con ángulo de elevación $theta$. Determinar
  la velocidad del cohete en términos de $b$, $theta$ y $dot(theta)$.],
  resuelve: [el triángulo $A B "cohete"$ da $r = b\/cos theta$; derivar eso respecto del tiempo da $dot(r)$, y con $bold(v) = dot(r) hat(r) + r dot(theta) hat(theta)$ (#M("vectores")) sale el módulo. Control: tiene que coincidir con derivar $y=b tan theta$ directamente, porque el movimiento es vertical. Ya resuelto entero como ejemplo a fondo.],
  [$v = (b dot(theta))\/cos^2 theta$ — control: coincide con derivar $y = b tan theta$ directamente.],
)

#disparador(
  [Ej. 11 — cosenos directores de $bold(A) = (1,-1,3)$],
  [Hallar los cosenos directores.],
  resuelve: [cada coseno director es la componente sobre ese eje dividida por el módulo: $cos alpha = A_x\/abs(bold(A))$, y así con $beta$, $gamma$; con $abs(bold(A))=sqrt(11)$ (#M("vectores")). Ya resuelto como ejemplo.],
  [$cos alpha = 0,302$, $cos beta = -0,302$, $cos gamma = 0,905$.],
)

#disparador(
  [Ej. 12 — cosenos directores, vector paralelo al eje $Z$],
  [Hallar los cosenos directores de los vectores paralelos al eje $Z$.],
  resuelve: [caso trivial de la misma definición de arriba: un vector $(0,0,C)$ sólo tiene componente sobre $Z$.],
  [$(0,0,1)$ o $(0,0,-1)$ según el sentido.],
)

#disparador(
  [Ej. 13 — versor perpendicular a $bold(A)=(0,1,5)$ y $bold(B)=(-3,0,2)$],
  [Hallar el versor perpendicular a los dos.],
  resuelve: [el producto vectorial $bold(A) times bold(B)$ ya es perpendicular a los dos por definición; dividirlo por su módulo lo deja unitario (#M("vectores")). Ya resuelto como ejemplo — hay *dos* respuestas válidas, opuestas entre sí, según el orden del producto.],
  [$hat(n) approx (0,130;thin -0,972;thin 0,194)$ (o su opuesto).],
)

#disparador(
  [Ej. 14 — proyección de $bold(B)=(2,5,-1)$ sobre $bold(A)=(1,0,-3)$],
  [Hallar la proyección de $bold(B)$ sobre $bold(A)$.],
  resuelve: [la proyección escalar es $(bold(A) dot bold(B))\/abs(bold(A))$ — el producto escalar se queda con la parte de $bold(B)$ paralela a $bold(A)$ (#M("vectores")); la vectorial multiplica ese escalar por el versor de $bold(A)$. Ya resuelto como ejemplo.],
  [escalar $approx 1,581$; vectorial $(0,5;thin 0;thin -1,5)$.],
)

#disparador(
  [Ej. 15 — seis productos con $bold(A)=(2,0,-3)$, $bold(B)=(-1,5,2)$, $bold(C)=(0,-4,1)$],
  [Calcular: i) $bold(A) dot (bold(B) times bold(C))$; ii) $bold(A) times (bold(B) times bold(C))$;
  iii) $(bold(A) times bold(B)) times bold(C)$; iv) $bold(A) times (bold(A) times bold(B))$;
  v) $(bold(A) dot bold(B))(bold(A) times bold(B))$; vi) $(bold(A) times bold(B)) times (bold(A) times bold(C))$.],
  resuelve: [i) es el producto mixto: el determinante de las tres filas. ii), iii), iv) y vi) son dobles productos vectoriales: se abren con BAC$-$CAB, $bold(X) times (bold(Y) times bold(Z)) = bold(Y)(bold(X) dot bold(Z)) - bold(Z)(bold(X) dot bold(Y))$ (#M("vectores"), @vec-dobles). v) es sólo un escalar multiplicando a un vector ya calculado. El punto del ejercicio es que ii) y iii) *no* coinciden: el producto vectorial no es asociativo.],
  [i) $14$ — ii) $(3,-47,2)$ — iii) $(39,-15,-60)$ — iv) $(-3,-65,-2)$ — v) $(-120,8,-80)$ — vi) $(28,0,-42)$. _(cuenta propia de este anexo)_],
)

#subtitulo-anexo("A.2 — Conservación de cantidad de movimiento (Ej. 1 a 9, más tres adicionales)")

Varios son del Sears, y casi todos se resuelven con la misma línea:
elegir el sistema, ver que no hay fuerza externa en la dirección que
importa, igualar antes y después. La dificultad nunca está en la
ecuación; está en elegir bien el sistema y el marco.

#disparador(
  [Ej. 1 — la astronauta y la herramienta (S&Z 8.16)],
  [Una astronauta de masa $m_a=68,5$ kg arroja una herramienta de masa
  $m_h=2,25$ kg a $v_h=3,20$ m/s respecto de la estación. ¿Con qué rapidez
  $v_a$ se mueve la astronauta?],
  resuelve: [sin fuerzas externas, $bold(P)$ se conserva; como arranca en reposo, $bold(P)=bold(0)$ antes y después: $0 = m_h v_h + m_a v_a$ (#M("cantidad-movimiento")). Ya resuelto, y otra vez desde el CM en #M("centro-de-masa").],
  [$v_a = -0,105$ m/s (sentido contrario al de la herramienta).],
)

#disparador(
  [Ej. 2 — choque oblicuo de dos asteroides (S&Z 8.31)],
  [Dos asteroides de igual masa chocan oblicuamente: $A$ iba a 40,0 m/s, se
  desvía 30,0° y $B$ (en reposo) sale a 45,0° del otro lado. Rapidez de cada
  uno después, y fracción de energía disipada.],
  resuelve: [$bold(P)$ se conserva en los dos ejes por separado (perpendicular al movimiento original de $A$ no había nada, así que esa componente sola ya da una ecuación gratis). Con las dos rapideces finales, $K$ antes y después da la fracción disipada (#M("cantidad-movimiento")). Ya resuelto, y auditado otra vez desde el CM en #M("centro-de-masa").],
  [$v_A = 29,3$ m/s, $v_B = 20,7$ m/s; se disipa el $19,6%$ de $K$.],
)

#disparador(
  [Ej. 3 — el calamar (S&Z 8.19)],
  [Calamar de 6,50 kg (incluye 1,75 kg de agua en su cavidad), en reposo,
  expulsa el agua para escapar a 2,50 m/s. *(a)* ¿Con qué rapidez expulsa
  el agua? *(b)* ¿Cuánta energía cinética genera esa maniobra?],
  resuelve: [(a) mismo mecanismo que el Ej. 1: $bold(P)=bold(0)$ antes y después, con las dos masas (calamar sin agua, y el agua) (#M("cantidad-movimiento")). (b) con las dos velocidades ya resueltas, $K=1/2 m_"cal" v_"cal"^2 + 1/2 m_"agua" v_"agua"^2$ — la energía la genera el músculo del calamar, no la conserva $bold(P)$ (#M("trabajo-energia")). Ya resuelto en los dos módulos.],
  [(a) $v_"agua" = 6,79$ m/s. (b) $K = 55,1$ J ($40$ de esos J se los lleva el agua, no el calamar).],
)

#disparador(
  [Ej. 4 — unidad de maniobra del astronauta (S&Z 8.61)],
  [De $a = 0,029$ m/s² y $M = 180$ kg, hallar el empuje y el caudal del gas
  expulsado a $v_r = 490$ m/s.],
  resuelve: [empuje $f=M a$ despejado al revés, caudal $mu = f\/abs(v_r)$ de la definición de empuje (#M("cohete")).],
  [$f = 5,22$ N; $mu = 1,07 times 10^(-2)$ kg/s (0,053 kg en 5 s).],
)

#disparador(
  [Ej. 5 — S&Z 8.63],
  [Ecuación de Tsiolkovsky sin gravedad, despejando la razón de masas.],
  resuelve: [misma ecuación que el Ej. 6/7-8, $Delta V = v_r ln(M_0\/M_f)$, pero sin el término de pérdida por gravedad (el enunciado no da tiempo de quemado). Dados $Delta V$ y $v_r$, se despeja $M_0\/M_f = e^(Delta V\/v_r)$ en vez del $Delta V$ (#M("cohete")).],
  [sin datos numéricos transcriptos para dar un número acá — el planteo es el de arriba, despejando la razón de masas en vez del $Delta V$.],
)

#disparador(
  [Ej. 6 — Beer 14.94],
  [Cohete de 1200 kg (1000 kg de combustible), consume 12,5 kg/s a 4000 m/s
  relativos, lanzado verticalmente. Aceleración al despegar y al agotarse
  el combustible.],
  resuelve: [empuje $f=mu abs(v_r)$ es constante durante todo el quemado; $a=(f-M g)\/M$ cambia sólo porque $M$ baja — se evalúa con $M$ inicial y con $M$ final (#M("cohete")). Ya resuelto.],
  [$a_"despegue" = 31,9$ m/s²; $a_"final" = 240$ m/s² ($approx 24 g$).],
)

#disparador(
  [Ej. 7 y 8 — una etapa contra dos, mismos kilos (Beer 14.97/14.98)],
  [Nave de 540 kg, mismo $mu=225$ kg/s y $abs(v_r)=3600$ m/s en los dos
  casos: (a) una etapa de 19 Mg; (b) dos etapas de 9,5 Mg. Rapidez máxima
  en cada caso.],
  resuelve: [la ecuación de Tsiolkovsky con pérdida por gravedad, $V=v_r ln(M_0\/M_f) - g t$, aplicada de punta a punta en (a); en (b), dos veces seguidas —una por etapa—, restando la masa de la cubierta que se desprende sin cambiar la velocidad al pasar de un tramo al otro (#M("cohete")). Ya resuelto.],
  [intermedio (razón de masas $M_0\/M_f$): una etapa $=11,23$; dos etapas, tramo por tramo, $=1,836 times 8,807=16,17$ — ahí está de dónde sale la diferencia. (a) una etapa: $V_f = 7,93$ km/s. (b) dos etapas: $V_f = 9,24$ km/s — 1,31 km/s más, con el mismo combustible total.],
)

#disparador(
  [Ej. 9 — Beer 14.99],
  [Pide la *altura* alcanzada en el Ej. 7 (una etapa): hay que integrar
  $V(t)$ otra vez.],
  resuelve: [la altura es la integral de la velocidad del Ej. 7, $y(t)=integral_0^t V(t') d t'$ con $V(t)=v_r ln(M_0\/(M_0-mu t)) - g t$, entre $t=0$ y los $79,1$ s que dura el quemado de esa etapa —mismos $M_0=19 thin 540$ kg, $M_f=1740$ kg, $mu=225$ kg/s, $v_r=3600$ m/s (#M("cohete")).],
  [$y approx 187$ km. _(cuenta propia de este anexo)_],
)

#disparador(
  [Adicional 1 — separación de dos etapas en inercia],
  [Tercera (400 kg) y cuarta (200 kg) etapa viajan juntas a 18 000 km/h;
  una carga las separa y la cuarta queda a 18 060 km/h. Velocidad de la
  tercera, y velocidad relativa entre las dos.],
  resuelve: [conservación de $bold(P)$ con las dos masas en movimiento —la carga explosiva es interna al sistema de las dos etapas (#M("cantidad-movimiento")). Ya resuelto.],
  [$v_3 = 17 thin 970$ km/h; velocidad relativa $-90$ km/h.],
)

#disparador(
  [Adicional 2 — satélite expulsado del transbordador],
  [Transbordador (90 Mg) expulsa un satélite de 800 kg durante 4 s,
  dándole 0,3 m/s en $z$ *respecto del transbordador*. Velocidad final del
  transbordador y fuerza media de expulsión.],
  resuelve: [conservación de $bold(P)=bold(0)$, escribiendo la velocidad del satélite como la del transbordador más los 0,3 m/s relativos; después, $bold(J)=Delta bold(p)$ dividido por los 4 s da la fuerza media (#M("cantidad-movimiento")). Ya resuelto.],
  [$v_"transb" = -2,643 times 10^(-3)$ m/s; $F_"prom" = 59,5$ N.],
)

#disparador(
  [Adicional 3 — el cohete, y el transbordador con varios motores],
  [(a) De $mu=220$ kg/s, $abs(v_r)=900$ m/s y $a=6$ m/s², hallar la masa
  total al lanzamiento. (b) El transbordador (2,04 × 10⁶ kg) con dos SRB
  (11,80 × 10⁶ N c/u) y tres SSME (2,00 × 10⁶ N c/u, $I_"sp"=455$ s):
  aceleración inicial y caudal de cada motor principal.],
  resuelve: [(a) empuje $=mu abs(v_r)$, y de $M a = f - M g$ (con $g=9,81$ m/s², la gravedad local) se despeja $M=f\/(a+g)$. (b) el empuje total es la suma de los cinco motores; $a=f\/M_0 - g$; el caudal de cada SSME sale de $I_"sp" = abs(v_r)\/g_0$, con $g_0=9,80665$ m/s² la constante que define $I_"sp"$ —*no* la $g$ local de la parte (a), aunque el número se parezca—, o sea $mu = f_"motor"\/(I_"sp" g_0)$ (#M("cohete")). Ya resuelto.],
  [(a) $M = 12 thin 525$ kg. (b) intermedio: empuje total $=29,60 times 10^6$ N. $a = 4,70$ m/s²; $448,3$ kg/s por motor principal.],
)

#subtitulo-anexo("A.3 — Conservación de impulso angular (Problemas 1 a 7)")

El 2 y el 3 son demostraciones, no cuentas, y una demostración que dice
«se ve que» no demostró nada.

#disparador(
  [Problema 1 — torque en seis casos (S&Z 10.1)],
  [Varilla de 4,00 m desde $O$, fuerza $F=10,0$ N aplicada de seis maneras
  distintas (ver figura E10.1 del libro: en el extremo o a 2,00 m, con
  ángulos de 30° a 180°, o directamente en $O$). Torque en cada caso.],
  resuelve: [$tau = r F sin phi$, con $r$ la distancia de $O$ al punto de aplicación y $phi$ el ángulo entre la varilla y la fuerza — el torque es cero apenas $r=0$ (fuerza en $O$) o $phi=0degree\/180degree$ (fuerza sobre la varilla) (#M("rotacion")).],
  [a) $40,0$ — b) $34,6$ — c) $20,0$ — d) $17,3$ — e) $0$ — f) $0$ N·m (magnitudes; el sentido de cada una depende de la figura del libro, no transcripta acá). _(verificada: recalculada por separado el 2026-09-25)_],
)

#disparador(
  [Problema 2 — $bold(L)$ constante para una partícula libre],
  [Demostrar que el impulso angular de una partícula con velocidad
  constante es el mismo respecto de cualquier punto.],
  resuelve: [derivar $bold(L)=bold(r) times bold(p)$ en el tiempo: $dot(bold(L))=dot(bold(r)) times bold(p) + bold(r) times dot(bold(p))$, y con $bold(v)$ constante los dos términos se anulan (el primero porque $bold(v) parallel bold(p)$, el segundo porque no hay fuerza) (#M("momento-angular")). Ya resuelto como ejemplo.],
  [demostrado: $dot(bold(L)) = dot(bold(r)) times bold(p) = bold(v) times m bold(v) = bold(0)$, porque $bold(v) parallel bold(p)$.],
)

#disparador(
  [Problema 3 — $bold(L)$ igual para cualquier origen],
  [Dos partículas de igual masa y rapidez, en trayectorias paralelas
  opuestas separadas $d$: demostrar que $bold(L)$ del sistema no depende
  del origen elegido.],
  resuelve: [escribir $bold(L)$ del sistema medido desde dos orígenes distintos y restar: la diferencia sale proporcional a $bold(P)_"total"$ del sistema, así que si $bold(P)_"total"=bold(0)$ (las dos partículas se cancelan) los dos $bold(L)$ coinciden (#M("momento-angular")). Ya resuelto como ejemplo.],
  [demostrado: la diferencia entre dos orígenes depende sólo de $bold(P)_"total"$, que acá es nulo.],
)

#disparador(
  [Problema (sin número) — el giroscopio de juguete (S&Z 10.51)],
  [Rotor de 0,140 kg, $I=1,20 times 10^(-4)$ kg·m², marco de 0,0250 kg,
  centro de masa a 4,00 cm del pivote. Precesa una vuelta cada 2,20 s.
  (a) Fuerza del pivote. (b) Rapidez angular del rotor. (c) Copiar el
  diagrama con $bold(H)$ y el torque.],
  resuelve: [(a) el pivote sostiene todo el peso: $F=M_"total" g$, con
  $M_"total" = 0,140+0,0250=0,165$ kg la masa del rotor más el marco. (b)
  precesión estable sin nutación, $Omega_p = tau\/(I omega)$, con
  $tau=M_"total" g d$ el torque gravitatorio por el brazo $d=4,00$ cm y
  $omega$ la rapidez angular del rotor, la incógnita (#M("rotacion")). Ya resuelto como ejemplo a fondo.],
  [(a) $F approx 1,62$ N. Intermedio: $tau = M_"total" g d approx 0,0647$ N·m. (b) $omega_"rotor" approx 1802$ rpm. (c) es un dibujo — $bold(H)$ va sobre el eje del rotor, y $bold(tau)$ perpendicular a $bold(H)$ y horizontal, en la dirección en que $bold(H)$ está girando. _(verificada: resuelto de nuevo, por separado, en el módulo #M("rotacion"); la distancia de 4 cm es al CM del conjunto rotor+marco)_],
)

#disparador(
  [Ejercicio 4 — el satélite de la figura],
  [Con los datos de la elipse (radios y velocidades en apogeo, perigeo y
  dos puntos intermedios): A) impulso angular específico en apogeo y
  perigeo. B) distancias a los dos puntos intermedios.],
  resuelve: [A) en los ábsides la velocidad es perpendicular al radio, así que $h=r v$ sin senos ni cosenos. B) en los otros dos puntos, $h=r v cos gamma$ con $gamma$ el ángulo dado respecto de la perpendicular al radio: despejar $r=h\/(v cos gamma)$ con el mismo $h$ de A) (#M("momento-angular")).],
  [A) $h = 57 thin 172$ km²/s en los dos ábsides (coinciden — control ya hecho en la guía). B) $r approx 8388$ km (altura $approx 2010$ km) y $r approx 8578$ km (altura $approx 2200$ km). _(punto B: cuenta propia de este anexo)_],
)

#disparador(
  [Ej. 5 — la pregunta fina],
  [Formular la segunda ley de Kepler como velocidad areolar. ¿Hace falta
  que el potencial sea $1\/r$ (fuerza $1\/r^2$), o alcanza con que la
  fuerza sea central?],
  resuelve: [el torque respecto del centro de fuerza es $bold(r) times bold(F)$; si $bold(F)$ es central (paralela a $bold(r)$) ese producto es cero *sin importar cómo dependa $F$ de $r$*, así que $bold(L)$ —y con él la velocidad areolar— se conserva para cualquier fuerza central (#M("momento-angular")).],
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
  resuelve: [momento angular del cilindro, $H=I omega$ con $I=m r^2$ (cilindro de pared delgada); la velocidad de precesión pedida es el ángulo total sobre el tiempo, $Omega_p="ángulo"\/"tiempo"$; y el torque necesario es $tau=Omega_p H$ (#M("rotacion")).],
  [intermedio: $I=1,25 times 10^(-3)$ kg·m², $H=I omega approx 2,513$ kg·m²/s. $tau approx 2,4 times 10^(-12)$ N·m — un torque casi nulo, que es el punto del problema: así de estable queda un giróscopo bien diseñado. _(verificada: recalculada por separado el 2026-09-25)_],
)

#subtitulo-anexo("A.4 — Conservación de la energía y gravitación (Problemas 0 a 10, más cinco adicionales)")

La sección más larga. La mitad orbital sale de
dos ecuaciones —vis-viva y la conservación de $h$—, y el error más barato de cometer no
es de física sino de radios: medidos desde la superficie cuando había que
medirlos desde el centro.

#disparador(
  [Problema 0 — estimar la masa del Sol],
  [A partir de la órbita de la Tierra.],
  resuelve: [para una órbita circular, la gravedad ES la centrípeta: $G M_"Sol" m\/r^2 = m v_"circ"^2\/r$, con $r$ la distancia Tierra-Sol y $v_"circ"=2 pi r\/tau$ ($tau=$ 1 año) (#M("gravitacion")). Ya resuelto.],
  [$M_"Sol" approx 1,99 times 10^30$ kg.],
)

#disparador(
  [Problema 1 — diagrama de energía potencial (S&Z 7.76)],
  [Partícula sobre el eje $x$, $U(x)$ dado por un gráfico (se suelta del
  reposo en $A$, con $U_A approx 3,0$ J). *(a)* Dirección de la fuerza en
  $A$. *(b)* Y en $B$ ($x approx 1,0$ m). *(c)* ¿Dónde es máxima $K$?
  *(d)* Fuerza en $C$ (máximo local, $x approx 1,4$ m). *(e)* ¿Hasta dónde
  llega? *(f)* Equilibrio estable. *(g)* Equilibrio inestable.],
  resuelve: [soltarse del reposo en $A$ fija $E=K_A+U_A=U_A$ para todo el movimiento. De ahí: $F_x=-d U\/d x$ da el signo de la fuerza en cualquier punto con sólo mirar si la curva sube o baja; $K=E-U$ es máxima donde $U$ es mínima; los máximos locales de $U$ son barreras — la partícula los pasa si $E$ alcanza, si no queda atrapada; los mínimos de $U$ son equilibrio estable y los máximos, inestable (#M("trabajo-energia")). Ya resuelto entero como ejemplo a fondo, con los seis valores leídos del gráfico.],
  [(a) hacia $+x$. (b) hacia $-x$. (c) $K_"máx"=5,7$ J en $x approx 0,75$ m. (d) $F=0$ ($C$ es un máximo local, tangente horizontal). (e) $x_"máx" approx 2,2$ m. (f) equilibrio estable en $x approx 0,75$ m y $x approx 1,9$ m. (g) equilibrio inestable en $x approx 1,4$ m (el punto $C$).],
)

#disparador(
  [Problema 2 — la sonda espacial (Beer)],
  [$v_A = 20,2 times 10^3$ mi/h, perpendicular al radio, con $h_A=2700$ mi
  y $h_B=7900$ mi sobre una Tierra de radio 3960 mi. Velocidad en $B$.],
  resuelve: [con $r_A = 3960+2700=6660$ mi y $r_B=3960+7900=11 thin 860$ mi
  —radio de la Tierra más la *altura*, nunca la altura sola (#M("gravitacion"))—,
  conservación de la energía específica, $v_A^2\/2 - mu\/r_A = v_B^2\/2 - mu\/r_B$: no hace falta el momento angular porque sólo se pide la *rapidez* en $B$, no su dirección (#M("gravitacion") / #M("orbita-conicas")).],
  [$v_B approx 7,00$ km/s ($approx 15 thin 650$ mi/h). _(cuenta propia de este anexo)_],
)

#disparador(
  [Problema 3 — órbita geosincrónica (Beer 12.80)],
  [Altura y velocidad de un satélite con período de un día sideral
  (23,934 h).],
  resuelve: [de la tercera ley de Kepler, $tau=2 pi a^(3\/2)\/sqrt(mu)$, se despeja $a=r$ (órbita circular); con ese radio, $v_"circ"=sqrt(mu\/r)$ (#M("gravitacion"), #M("kepler")). Resuelto de paso dentro del Problema 6, abajo.],
  [altura $approx 35 thin 780$ km; $v approx 3,07$ km/s.],
)

#disparador(
  [Problema 4 — perigeo y apogeo (S&Z 13.67)],
  [Nave con perigeo a 400 km y apogeo a 4000 km de altura. (a) Período.
  (b) Razón de rapideces perigeo/apogeo. (c) Rapidez en cada uno.
  (d) $Delta v$ para escapar desde cada uno — ¿cuál conviene?],
  resuelve: [(a) tercera ley de Kepler con $a=(r_p+r_a)\/2$ (#M("kepler")). (b) en los ábsides $h=r v$, así que $v_p\/v_a = r_a\/r_p$, geometría pura. (c) las mismas velocidades salen también de la vis-viva, como control cruzado. (d) escapar es llegar a $v_"esc"=sqrt(2mu\/r)$ sin tocar el otro ábside: $Delta v = v_"esc"(r) - v(r)$ en cada uno (#M("orbita-conicas"), #M("gravitacion")). Ya resuelto — es el mismo satélite del Ej. 4 de impulso angular.],
  [(a) $tau = 7907$ s. (b) $v_p\/v_a = 1,531$. (c) $v_p=8,435$ km/s, $v_a=5,509$ km/s. (d) intermedio: $v_"esc"(r_p)=10,85$ km/s, $v_"esc"(r_a)=8,765$ km/s — escapar conviene en el perigeo: $Delta v_p = 2,41$ km/s contra $Delta v_a = 3,26$ km/s.],
)

#disparador(
  [Problema 5 — Hohmann a Marte (S&Z 13.79)],
  [*(a)* Sentido de encendido en Tierra y Marte, ida y vuelta. *(b)* Tiempo
  de viaje. *(c)* Ángulo de fase Sol-Marte/Sol-Tierra en el lanzamiento.],
  resuelve: [(a) la elipse de transferencia es tangente a las dos órbitas circulares: yendo hacia *afuera* (Tierra→Marte) hay que acelerar en los dos extremos; volviendo hacia *adentro* (Marte→Tierra), frenar en los dos. (b) el tiempo de viaje es medio período de la elipse de transferencia. (c) Marte tiene que estar exactamente donde la nave lo va a encontrar $t_v$ después: se resta lo que Marte avanza en ese tiempo de los $180degree$ que recorre la nave (#M("maniobras")). Ya resuelto.],
  [(a) ida: los dos encendidos aceleran, en la dirección del movimiento. Vuelta: los dos frenan, en contra. (b) 258,8 días de viaje. (c) 44,4° de ángulo de fase en el lanzamiento.],
)

#disparador(
  [Problema 6 — subir a la geosíncrona (Beer 13.85)],
  [Satélite de 3600 kg en órbita circular a 300 km. (a) Energía para
  subirlo a la geosíncrona (35 770 km de altura). (b) Ídem lanzándolo
  directo desde la superficie.],
  resuelve: [la energía de una órbita circular es $E=-mu m\/2a$; (a) es la resta entre la energía de la geosíncrona y la de la órbita a 300 km; (b) es la misma resta pero contra la energía en la superficie, que es puro potencial ($v=0$, aunque en realidad la Tierra gire, eso no lo pide el enunciado) (#M("gravitacion")). Ya resuelto — resuelve de paso el Problema 3.],
  [intermedio: $E_"300 km"=-107,4$ GJ, $E_"geosíncrona"=-17,0$ GJ, $E_"superficie"=-225,0$ GJ. (a) $90,6$ GJ. (b) $208,3$ GJ.],
)

#disparador(
  [Problema 7 — frenar en Júpiter (Beer 13.100)],
  [Nave a $v_A=26,9$ km/s en trayectoria parabólica hacia Júpiter (masa
  319 × la de la Tierra); frenar para quedar en una elipse con apoápside
  $100 times 10^3$ km. $Delta v$ necesario.],
  resuelve: [vis-viva ANTES del frenado (parábola, $E=0$) y DESPUÉS (elipse, con el $a$ que fijan los dos ábsides dados), evaluadas las dos en el mismo punto $A$: la resta de velocidades es el $Delta v$ (#M("orbita-conicas")). Ya resuelto.],
  [intermedio: $v_"antes"$ (parabólica en $A$) $=26,96$ km/s (coincide con el dato); $v_"después"$ (elipse en $A$) $=12,71$ km/s. $Delta v = 14,2$ km/s (capturar sólo cuesta 0,9 km/s menos que la velocidad parabólica).],
)

#disparador(
  [Problemas 8 y 9 — el LEM del Apollo (Beer 13.101)],
  [*Problema 8:* el LEM sube desde 8 km sobre la Luna ($A$) a encontrarse
  con el módulo de mando en órbita circular a 140 km ($B$), apagando el
  motor en $A$ con velocidad paralela a la superficie. *(a)* Rapidez al
  apagar el motor. *(b)* Velocidad relativa con la que el módulo de mando
  se le acerca en $B$. *Problema 9:* de vuelta en $B$, el LEM frena 200 m/s
  respecto del módulo de mando y cae hacia la superficie ($C$). Magnitud y
  ángulo $phi$ (desde la vertical $O C$) de $bold(v)_C$.],
  resuelve: [$A$ y $B$ son los dos ábsides de la transferencia de subida (perilunio y apolunio): vis-viva en $A$ da (a); el momento angular $h$ de esa elipse da la velocidad tangencial del LEM en $B$, que restada de la $v_"circ"$ del módulo de mando en el mismo radio da (b) —los dos son ábsides, así que la resta es directa, sin vectores (#M("kepler"), #M("momento-angular")). Para el Problema 9, frenar 200 m/s en $B$ (que sigue siendo ábside) fija la nueva órbita: con $r_B$ y la nueva $v_B$, vis-viva y $h$ dan la energía y el semieje, y el perilunio de esa órbita queda *adentro* de la Luna — el LEM se estrella antes en $r=R_L$. Ahí, vis-viva da $v_C$ y $h=r_C v_C cos gamma$ da el ángulo respecto de la horizontal local, que convertido a "desde la vertical" es $phi=90degree-gamma$ (#M("orbita-conicas"), #M("momento-angular")). Ya resuelto.],
  [*Problema 8* — intermedios: $r_A=1748$ km, $r_B=1880$ km, $a'=1814$ km, $h'=2980$ km²/s. (a) $v'_A = 1,705$ km/s. (b) $v'_B=1,585$ km/s (tangencial en $B$) contra $v_"circ"(r_B)=1,615$ km/s del módulo de mando → velocidad relativa de encuentro: $30$ m/s. *Problema 9* — al frenar, $v''_B=1,415$ km/s (intermedio); con eso, $a''=1526$ km, $e''=0,233$ y perilunio $r''_p=1171$ km —*adentro* de la Luna (radio 1740 km), por eso el LEM se estrella antes de completar la elipse—. En el impacto: $v_C = 1,556$ km/s, a $phi = 79,2°$ de la vertical $O C$ — un impacto rasante, casi paralelo a la superficie.],
)

#disparador(
  [Problema 10 — rendez-vous, un cuarto de órbita adelantado],
  [*A)* Investigar el problema del reencuentro orbital. *B)* Formular una
  solución general. *C)* Resolver un caso numérico.],
  resuelve: [B) la idea general es una *órbita de fasaje*: cambiar temporalmente el tamaño de la propia órbita para que el período nuevo, sostenido durante algunas vueltas, acumule (o recupere) el atraso angular $Delta phi$ respecto del blanco (acá, "un cuarto de vuelta adelantado" quiere decir $Delta phi = 90degree$) — la relación es $T'\/T = 1 - Delta phi\/360degree$ por vuelta de fasaje. C) con eso, más la ecuación de Tsiolkovsky (#M("cohete")) para el costo en combustible de los dos encendidos que cambian de órbita y vuelven (#M("maniobras")). Ya resuelto.],
  [A) es el problema clásico de reencuentro orbital: no se puede apurar acelerando en línea recta, porque acelerar sube la órbita y *reduce* la velocidad angular media. B) la solución general es la órbita de fasaje de arriba. C) caso geosíncrono a un cuarto de vuelta adelantado: $Delta v = 698$ m/s en una sola vuelta de fasaje.],
)

#disparador(
  [Ejercicio adicional 1 — satélite no tripulado],
  [Radio de perigeo 10 000 km, radio de apogeo 100 000 km. Hallar:
  (a) excentricidad; (b) semieje mayor; (c) período (horas); (d) energía
  específica; (e) anomalía verdadera a 10 000 km de altitud; (f) $v_r$ y
  $v_perp$ ahí; (g) velocidad en perigeo y apogeo.],
  resuelve: [$e$ y $a$ salen directo de $r_p, r_a$; con $a$, la tercera ley de Kepler da el período (#M("kepler")); $h$ sale de $r_p v_p$ una vez que se tiene $v_p$ por vis-viva, o de $h=sqrt(mu p)$ con $p=a(1-e^2)$; con $h$, la ecuación de la órbita $r(nu)$ despejada da la anomalía a la altitud pedida, y $v_perp=h\/r$, $v_r=(mu\/h) e sin nu$ dan las dos componentes ahí (#M("hiperbola"), sección 16.5); $v_p=h\/r_p$, $v_a=h\/r_a$ porque los ábsides son perpendiculares.],
  [intermedio: $h=85 thin 131$ km²/s. (a) $e=0,818$ — (b) $a=55 thin 000$ km — (c) $tau=35,7$ h — (d) $epsilon=-3,62$ km²/s² — (e) $nu approx plus.minus 82,3°$ — (f) $v_perp approx 5,20$ km/s, $v_r approx 3,80$ km/s — (g) $v_p=8,51$ km/s, $v_a=0,851$ km/s. _(cuenta propia de este anexo)_],
)

#disparador(
  [Ejercicio adicional 2 — perigeo a 500 km y 10 km/s],
  [Hallar el ángulo de trayectoria de vuelo $gamma$ y la altitud para una
  anomalía verdadera de 120°.],
  resuelve: [«perigeo a 500 km» es *altura*: el radio de perigeo es
  $r_p = R_T + 500 = 6378+500=6878$ km, no $500$ km (#M("gravitacion")). En
  el perigeo (ábside) $h=r_p v_p$ directo, con $v_p=10$ km/s el dato; la energía específica $v_p^2\/2-mu\/r_p$ da $a$, y con $a$ y $r_p=a(1-e)$ sale $e$; la ecuación de la órbita $r(nu)$ da el radio (y la altitud, restándole $R_T$) a $nu=120degree$; ahí, $v_perp=h\/r$ y $v_r=(mu\/h) e sin nu$ dan $gamma=arctan(v_r\/v_perp)$ (#M("hiperbola"), sección 16.5).],
  [intermedio: $h=68 thin 780$ km²/s, $a=25 thin 060$ km, $e=0,7255$. $gamma approx 44,6°$; altitud $approx 12 thin 250$ km. _(cuenta propia de este anexo)_],
)

#disparador(
  [Ejercicio adicional 3 — órbita polar, 200 km del polo cada 100 min],
  [Excentricidad de la órbita.],
  resuelve: [pasar sobre el polo una vez por vuelta significa que el período es $100$ min; la tercera ley de Kepler, al revés, da $a$ a partir de ese período — sin necesitar $h$ ni $E$; con $a$ y el perigeo (200 km sobre el radio terrestre), $r_p=a(1-e)$ da $e$ (#M("kepler")). Ya resuelto.],
  [$e = 0,0782$ (con $a=7136$ km, $r_p=6578$ km).],
)

#disparador(
  [Ejercicio adicional 4 — dos alturas con sus anomalías],
  [Altitud 1000 km a $nu=40°$, altitud 2000 km a $nu=150°$. Hallar:
  (a) excentricidad; (b) altitud de perigeo; (c) semieje mayor.],
  resuelve: [la ecuación de la órbita $r=p\/(1+e cos nu)$ escrita en los dos puntos da un sistema de dos ecuaciones con dos incógnitas, $p$ y $e$; despejando ese sistema sale (a); con $p$ y $e$, $r_p=p\/(1+e)$ da (b) y $a=p\/(1-e^2)$ da (c) (#M("orbita-conicas")).],
  [intermedio: $p=7816$ km. (a) $e approx 0,0775$ — (b) altura de perigeo $approx 876$ km — (c) $a approx 7863$ km. _(cuenta propia de este anexo)_],
)

#disparador(
  [Ejercicio adicional 5 — velocidad y $gamma$ dados],
  [$v=7,5$ km/s, $gamma=10°$, $r=8000$ km. Anomalía verdadera y
  excentricidad.],
  resuelve: [con $v$, $gamma$ y $r$ dados, $v_perp=v cos gamma$ y $v_r=v sin gamma$ quedan fijos; junto con la ecuación de la órbita y $h=r v_perp$, arman un sistema de cinco ecuaciones y cinco incógnitas (sección 16.5 de #M("hiperbola")) que se resuelve armando $e sin nu$ y $e cos nu$, elevando al cuadrado y sumando. Ya resuelto como ejemplo simple.],
  [$e=0,215$, $nu=63,8°$.],
)

#subtitulo-anexo("A.5 — Cuerpo rígido (Problemas 1 a 9)")

Todo del Beer, capítulo 18. Antes de mirar cualquier respuesta de acá:
*alargado ($I > I'$) precesa directo; achatado ($I < I'$), retrógrado*
(Beer §18.11, pág. 1191). Es la línea que más fácil se da vuelta, y este
anexo ya la dio vuelta una vez.

#disparador(
  [Problema 1 — el satélite cúbico],
  [Cubo de 2 m de lado, 120 kg, con un thruster ($F_E=4$ N, $I_"sp"=50$ s)
  en un vértice, alineado con una arista. Velocidad angular tras 4 s de
  encendido; caudal másico del thruster; cuánto tiempo seguirá girando.],
  resuelve: [el cubo tiene los tres momentos de inercia iguales, $I=(1\/6)m d^2$: su tensor es isótropo, así que $bold(H)_G=I bold(omega)$ vale para cualquier eje. La cupla del thruster es $bold(tau)=bold(r) times bold(F)$ (con $bold(r)$ del centro al vértice); $Delta bold(H)_G = bold(tau) t$ da $bold(omega)=Delta bold(H)_G \/ I$ directo (#M("inercia")). El caudal sale de la definición de $I_"sp"$: $dot(m)=F_E\/(I_"sp" g_0)$ (#M("cohete")).],
  [$bold(omega) = 0,2 hat(j) - 0,2 hat(k)$ rad/s (ya resuelto en #M("inercia")); caudal $approx 8,16$ g/s _(cuenta propia de este anexo)_; y sigue girando *para siempre* — inercia isótropa, sin torque, las ecuaciones de Euler dan $omega$ constante.],
)

#disparador(
  [Problema 2 — el disco en la horquilla],
  [Disco de masa $m$, radio $r$, gira a $omega_1$ sobre un eje sostenido
  por una horquilla que rota a $omega_2$. Hallar $bold(L)_G$ y $d bold(L)_G\/d t$.],
  resuelve: [los ejes clavados a la horquilla son principales del disco ($hat(k)$ su eje de simetría, $hat(i)$, $hat(j)$ diámetros), pero *no* con el mismo momento: $I_z=1/2 m r^2$ (polar) e $I_x=I_y=1/4 m r^2$ (diametral). Con $bold(omega)=omega_2 hat(j)+omega_1 hat(k)$, $bold(L)_G$ sale de multiplicar cada componente por SU momento —no es paralelo a $bold(omega)$ porque $I_z != I_x$ (#M("inercia")). La derivada usa que los ejes rotan con $bold(Omega)=omega_2 hat(j)$ (no con el disco): $dot(bold(L))_G = bold(Omega) times bold(L)_G$, porque en esa base las componentes de $bold(L)_G$ no cambian (#M("euler-giroscopo")). Ya resuelto en los dos módulos.],
  [$bold(L)_G = 1/4 m r^2 omega_2 hat(j) + 1/2 m r^2 omega_1 hat(k)$ (no paralelo a $bold(omega)$: la razón entre sus componentes es la mitad de la de $bold(omega)$, porque $I_z=2I_x$ pesa el doble sobre $hat(k)$). $d bold(L)_G\/d t = 1/2 m r^2 omega_1 omega_2 hat(i)$ — la cupla que hace falta para sostener el movimiento, en la misma dirección que $bold(alpha)$ del módulo #M("cinematica-cr"). (El enunciado dice «eje vertical» pero la figura del PDF muestra el eje del disco horizontal: se resuelve con la figura.)],
)

#disparador(
  [Problema 3 — el volante en el gimbal],
  [Volante ($omega_s=100$ rad/s en $z$, $I_x=I_y=5$, $I_z=10$ kg·m²) en un
  gimbal que gira a $omega_p=0,5$ rad/s en $y$. Aceleración angular del
  gimbal al aplicar 600 N·m en $x$.],
  resuelve: [los ejes $x,y,z$ están clavados al *gimbal* (no al volante) y son principales del volante en todo instante; $bold(omega)=Omega_x hat(i) + omega_p hat(j) + omega_s hat(k)$, con $Omega_x=0$ en el instante inicial pero $dot(Omega)_x$ la incógnita. $bold(H)_O$ sale directo de los momentos principales; derivándolo con $dot(bold(H))_O = (dot(bold(H))_O)_"gimbal" + bold(Omega)_"gimbal" times bold(H)_O$ e igualando a la cupla aplicada, sale una ecuación lineal en $dot(Omega)_x$ (#M("cinematica-cr"), #M("euler-giroscopo")). Ya resuelto.],
  [$alpha_"gimbal" = 20$ rad/s² — de los 600 N·m, 500 se gastan en sostener la dirección de $bold(H)_O$ (el término $bold(Omega) times bold(H)_O$), y sólo 100 aceleran de verdad.],
)

#disparador(
  [Problema 4 — el spacecraft que precesa],
  [Simétrico en $z$, radio de giro 720 mm (eje) y 540 mm (transversal).
  El eje $z$ describe un cono de 2° al precesar, con spin de 1,5 rad/s.
  Período de precesión.],
  resuelve: [precesión estable de un cuerpo simétrico sin torque: $tan gamma = (I\/I') tan theta$ relaciona el ángulo del eje instantáneo con el de $bold(H)$, y de ahí sale la razón entre spin y precesión, $dot(psi)\/dot(phi)=((I-I')\/I') cos theta$, con $I=m k_"transversal"^2$, $I'=m k_"eje"^2$ (#M("peonza")). Despejando $dot(phi)$ con el spin dado, y el período es $2 pi\/abs(dot(phi))$. Ya resuelto.],
  [período de precesión $= 1,832$ s (con $abs(dot(phi)) approx 3,431$ rad/s); el spin es *negativo*, en el sentido de $-z$: precesión retrógrada porque el cuerpo es achatado, $I'>I$ (Beer fig. 18.24).],
)

#disparador(
  [Problema 5 — la estación orbital de cinco esferas (M 7.99)],
  [Estructura de cinco esferas huecas conectadas por tubos, simétrica
  alrededor del eje $A$-$A$; spin de 3 rev/min alrededor de ese eje; el
  eje $A$-$A$ precesa con ángulo pequeño respecto de un eje $Z$ fijo, sin
  que el CM acelere (sin torque externo). Velocidad angular de precesión
  $dot(chi)$.],
  resuelve: [las esferas están dispuestas con simetría $>=3$ alrededor de $A$-$A$ (ver la figura), así que el teorema de ejes perpendiculares da $I_"transversal" = I_(A"-"A) \/ 2$ *sin* necesitar la posición ni la masa de cada esfera — es la misma razón por la que el enunciado dice "el doble". Con eso, precesión estable sin torque: $dot(chi) = H\/I_"transversal" = (I_(A"-"A)\/I_"transversal") omega_"spin"$ (mismo mecanismo que el Problema 4, #M("peonza")).],
  [$dot(chi) = 2 omega_"spin" = 6$ rev/min $= 0,628$ rad/s (período $10,0$ s) — *retrógrada* (sentido opuesto al spin relativo), porque el eje $A$-$A$ tiene más inercia que el transversal: es un cuerpo achatado. _(cuenta propia de este anexo)_],
)

#disparador(
  [Problema 6 — la relación $ell\/r$],
  [Cilindro de paredes delgadas que rota sobre su eje de simetría, con
  precesión de ángulo pequeño. ¿Para qué $ell\/r$ la precesión es
  retrógrada, y para cuáles directa?],
  resuelve: [el signo de $dot(psi)\/dot(phi) = ((I-I')\/I') cos theta$ decide directa ($I>I'$) o retrógrada ($I<I'$); con $I$ e $I'$ del cilindro de paredes delgadas en función de $ell$ y $r$, el umbral sale de igualar $I=I'$ (#M("peonza")). Ya resuelto.],
  [umbral $ell\/r = sqrt(6)$: *retrógrada* para $ell\/r < sqrt(6)$ (corto, tipo disco) y *directa* para $ell\/r > sqrt(6)$ (largo, tipo varilla); en el umbral, caso límite isótropo, como el cubo del Problema 1.],
)

#disparador(
  [Problema 7 — la cápsula espacial],
  [Cápsula (tronco de cono) sin velocidad angular; cohete $A$ activo 1 s
  con 50 N en $x$; $m=1000$ kg, $k_x=k_y=1$ m, $k_z=1,25$ m. Eje de
  precesión y velocidades de spin y precesión al terminar el impulso.],
  resuelve: [de la figura: $A$ está en el radio de la base, $bold(r)_A = (·,thin 2,thin -1,25)$ m respecto del CM (coordenada $x$ irrelevante: $bold(F)=F hat(i)$ no la usa). $Delta bold(H) = (bold(r)_A times bold(F)) Delta t$; con $I_x=I_y=1000$, $I_z=1562,5$ kg·m² se separa en $omega$ y de ahí $dot(phi) = H\/I_x$ (precesión), $dot(psi) = omega_z (I_x - I_z)\/I_x$ (spin) — mismo mecanismo que #M("euler-giroscopo") y #M("peonza").],
  [$Delta bold(H) = (0,thin -62,5,thin -100)$ kg·m²/s $=> bold(omega) = (0,thin -0,0625,thin -0,064)$ rad/s. Eje de precesión: $bold(H)$, a $148,0°$ del eje $z$ del cuerpo. $dot(phi) approx 0,118$ rad/s ($1,13$ rpm); $dot(psi) approx 0,036$ rad/s ($0,34$ rpm). _(cuenta propia de este anexo, geometría leída de la figura de la guía)_],
)

#disparador(
  [Problema 8 — repetición del Problema 7 (B 18.126)],
  [Igual que el Problema 7, pero con $bold(omega)_0 = 0,02 hat(j) + 0,10 hat(k)$
  rad/s previa y el cohete $B$ en vez del $A$.],
  resuelve: [mismo mecanismo que el Problema 7, con $bold(r)_B = (·,thin 1,25,thin 2)$ m (el radio y la altura de $B$ están intercambiados respecto de $A$: $B$ está arriba, en el radio angosto) y $bold(H)_0 = (0,thin I_x omega_(0y), thin I_z omega_(0z)) != bold(0)$ antes del impulso.],
  [$bold(H)_0=(0,20,156,25)$, $Delta bold(H)=(0,100,-62,5)$ $=> bold(H)_f=(0,120,93,75)$ kg·m²/s, $bold(omega)_f=(0,thin 0,12,thin 0,06)$ rad/s. Eje de precesión: $bold(H)_f$, a $52,0°$ del eje $z$. $dot(phi) approx 0,152$ rad/s ($1,45$ rpm); $dot(psi) approx -0,034$ rad/s ($-0,32$ rpm). _(cuenta propia de este anexo)_],
)

#disparador(
  [Problema 9 — el satélite octogonal],
  [Octógono de 2500 kg y 2,4 m de alto, lado 1,2 m, $I_y=2400$,
  $I_x=I_z=2000$ kg·m², girando a $omega_0$ en $y$ (eje de simetría) y
  libre de torques. Los thrusters $A$, $B$, $C$, $D$ —en posiciones
  $bold(R)_A=(x_A,y_A,z_A)$, $bold(R)_B=(x_B,y_B,z_B)$, en dos vértices
  del octógono— pueden empujar en $+y$ con $J=20$ N. Se activan $A$ y $B$
  durante $T=2$ s. *1)* Tipo de precesión si se lo perturba. *2)* Impulso
  angular tras el disparo, en función de los parámetros. *3)* Velocidad
  angular, ídem. *4)* y *5)* Ángulos de $bold(H)$ y de $bold(omega)$ con
  el eje de simetría. *6)* y *7)* Dibujo y descripción cualitativa.
  *8)* Calcular explícitamente 2 a 5.],
  resuelve: [$bold(F)=J hat(j)$ es *paralela* al eje de simetría: $bold(r) times bold(F)$ no usa la coordenada $y$ de ningún thruster (mismo truco que los Problemas 7 y 8), sólo $x$ y $z$. Con eso, 1 a 7 salen sin necesitar la figura; el 8 numérico sí la necesita —#M("inercia") para el impulso, #M("peonza") para los ángulos.],
  [*1)* $I_y=2400 > I_x=2000$ (axial mayor que transversal, "achatado"): precesión *retrógrada*. *2)* $Delta bold(H) = J T [-(z_A + z_B), thin 0, thin x_A + x_B] + (0,thin I_y omega_0,thin 0)$. *3)* $bold(omega) = (Delta H_x \/ I_x,thin omega_0,thin Delta H_z\/I_x)$. *4)* $cos theta_H = (I_y omega_0)\/abs(bold(H))$. *5)* $cos theta_omega = omega_0 \/ abs(bold(omega))$. *6-7)* $bold(H)$, $bold(omega)$ y el spin quedan los tres del mismo lado del eje $y$, inclinados hacia el par aplicado; visto desde afuera el satélite hace un cono de precesión retrógrada —el cono espacial queda adentro del corporal— mientras gira sobre sí. *8)* no se resuelve con un número acá: falta fijar con certeza *qué vértice del octógono mira hacia $+x$* en la figura —con eso fijo, $x_A,z_A,x_B,z_B$ salen de la geometría regular (lado 1,2 m) y la cuenta es idéntica a la de los Problemas 7/8. _(1 a 7: cuenta propia de este anexo; 8 queda para cuando se confirme la orientación exacta contra el PDF original)_],
)
