# comun.py -- los bloques de texto que van adentro de TODOS los .asc.
#
# La guia pide (entregable minimo, puntos 3 a 5) que quede registrado el
# circuito, la CONFIGURACION del analisis y COMO se armaron las graficas.
# Eso no puede vivir en un README aparte: un README no se abre cuando
# alguien hace doble clic en el .asc. Va adentro del esquematico, como
# comentarios ';', que es texto que LTspice dibuja en la hoja y NO manda al
# netlist.

MODELO_SW = ".model SW SW(Ron=1m Roff=1G Vt=0.5 Vh=0)"

COMO_SE_LEE_UNA_DIRECTIVA = [
    "COMO SE LEE UNA DIRECTIVA EN ESTA HOJA",
    "  En LTspice el texto de la hoja tiene dos formas, y se distinguen por el primer caracter:",
    "    !algo   es una DIRECTIVA: se copia al netlist y el simulador la ejecuta.",
    "    ;algo   es un COMENTARIO: queda dibujado en la hoja y no llega al netlist.",
    "  Se cambia de una a otra con Ctrl+click sobre el texto (o boton derecho > SPICE directive).",
    "  Por eso todo lo que sigue empieza con ';': es documentacion, no ordenes.",
]

LOS_CUATRO_ANALISIS = [
    "LOS CUATRO ANALISIS DE SPICE, Y CUAL CONTESTA QUE",
    "  .op    punto de reposo en continua permanente. Abre los capacitores y cortocircuita las",
    "         bobinas, y devuelve TODAS las tensiones de nodo y corrientes de rama de una vez.",
    "         Es la forma correcta de obtener los valores en 0- de un circuito que venia en",
    "         regimen: no hay que simular nada en el tiempo para eso.",
    "  .dc    barre una fuente de continua y dibuja la caracteristica (curva del diodo, recta de",
    "         carga). No se usa en esta guia.",
    "  .tran  respuesta en el tiempo. Es el analisis de toda la actividad asincronica.",
    "  .ac    respuesta en frecuencia con fasores (Bode). Aca se usa solo en el problema 6.25,",
    "         para medir una capacidad equivalente por la corriente que toma.",
]

COMO_SE_LEE_TRAN = [
    "COMO SE LEE .tran <tstep> <tstop> <tstart> <tmax>",
    "  tstep  cada cuanto GUARDAR un punto. Se pone 0 y se deja que el programa elija: poner un",
    "         numero aca no hace la simulacion mas exacta, solo mas gorda en disco.",
    "  tstop  hasta que instante simular.",
    "  tstart desde cuando empezar a GUARDAR (no desde cuando simular). Casi siempre 0.",
    "  tmax   el paso MAXIMO de integracion. Es el unico numero que cambia la exactitud, y es el",
    "         que pide el criterio de simulacion de la guia: no mayor que tau/100 en primer orden,",
    "         y al menos 100 puntos por periodo amortiguado en un RLC subamortiguado.",
    "  Sin tmax, LTspice elige el paso solo y en un tramo plano lo agranda hasta perderse el",
    "         detalle del flanco. La curva sigue 'pareciendo correcta': ese es justo el error que",
    "         el criterio de la guia existe para evitar.",
]

COMO_SE_LEE_IC = [
    "COMO SE LEE .ic",
    "  .ic V(nodo)=X  fija la tension inicial de un nodo (la del capacitor).",
    "  .ic I(Lx)=Y    fija la corriente inicial de una bobina.",
    "  El simulador resuelve el punto de reposo CON esas restricciones y despues las suelta: de",
    "  ahi en adelante manda el circuito. Es la forma de simular una respuesta natural sin",
    "  dibujar el conmutador ni el estado previo.",
    "  El SIGNO depende del orden de los nodos del elemento: I(Lx) es positiva cuando la",
    "  corriente entra por el pin A (el primero del netlist). Un elemento dado vuelta no da",
    "  error: da el resultado con el signo cambiado, que es peor.",
]

COMO_SE_LEE_MEAS = [
    "COMO SE LEE .meas (y por que esta aca)",
    "  .meas TRAN nombre FIND <expr> AT <t>          valor de una expresion en un instante",
    "  .meas TRAN nombre FIND <expr> WHEN <cond>     valor cuando se cumple una condicion",
    "  .meas TRAN nombre WHEN <expr>=<valor> TD=<t>  INSTANTE del cruce, ignorando lo anterior a TD",
    "  .meas TRAN nombre INTEG <expr> FROM <t1> TO <t2>   integral (energia, si expr es potencia)",
    "  .meas TRAN nombre DERIV <expr> AT <t>         derivada en un instante",
    "  .meas TRAN nombre PARAM <expr>                cuenta hecha con resultados de otros .meas",
    "  El resultado NO se dibuja: se escribe en el archivo .log, que se abre con Ctrl+L o con",
    "  View > SPICE Error Log. Es lo que convierte 'la curva parece bien' en un numero comparable",
    "  contra el calculo a mano, que es el punto 6 del entregable de la guia.",
]

NOTA_RSER_POR_DEFECTO = [
    "POR QUE LAS BOBINAS DE ESTAS HOJAS LLEVAN Rser=0 ESCRITO A MANO",
    "  LTspice le pone a TODA bobina, por defecto, una resistencia serie de 1 mohm. No lo avisa, no",
    "  aparece en el netlist y no se ve en el dibujo: esta en Control Panel > Hacks > 'Supply a min",
    "  inductor damping', y esta ahi para que el integrador no oscile con bobinas ideales.",
    "  En casi todos los circuitos es invisible. En uno donde la bobina queda en CORTO --contra una",
    "  fuente de tension apagada, o contra otra bobina-- ese miliohm es la UNICA resistencia del lazo",
    "  y se vuelve la que manda: con L = 200 uH da tau = 0,2 s, y una corriente que en el papel es",
    "  constante se cae un 1% cada 2 ms.",
    "  Medido en este proyecto: con el default, el problema 6.2 daba i(2 ms) = 49,75 mA en vez de",
    "  50 mA y la corriente seguia bajando despues del pulso. La curva 'parecia bien'.",
    "  Se cambia en el segundo campo del simbolo (boton derecho sobre la bobina).",
    "  Y ACA VIENE LA PARTE QUE NO ES OBVIA: PONER Rser=0 EXACTO NO ANDA.",
    "  Una bobina ideal en paralelo con una fuente de tension --o con otra bobina ideal-- deja la",
    "  matriz del sistema SIN SOLUCION UNICA, y LTspice aborta con 'Voltage source V1 and inductor",
    "  L1 are paralleled making an over-defined circuit matrix'. Los dos casos son exactamente los",
    "  del problema 6.2 y del 7.8, o sea justo aquellos donde el default importaba: el miliohm por",
    "  defecto existe para eso, no por capricho.",
    "  Por eso estas hojas llevan Rser=1u y no Rser=0. Con L = 200 uH eso da tau = 200 s contra los",
    "  4 ms de la ventana --una parte en 50.000-- y la matriz sigue siendo resoluble.",
    "  Un valor escrito, aunque sea chico, deja ademas constancia de que la decision se tomo.",
]

COMO_SE_ARMA_UNA_GRAFICA = [
    "COMO SE ARMA LA GRAFICA (lo que en LTspice no queda guardado en el .asc)",
    "  1. Correr (Simulate > Run, o el corredor). Se abre el panel de formas de onda vacio.",
    "  2. Agregar una traza: click sobre el CABLE del nodo dibuja su tension; click sobre el",
    "     CUERPO de un elemento dibuja su corriente (el cursor cambia a una pinza amperometrica).",
    "     El teclado hace lo mismo sin apuntar: boton derecho sobre el panel > Add Trace (Ctrl+A),",
    "     y ahi se escribe la expresion.",
    "  3. Paneles separados: boton derecho > Add Plot Pane, y despues se arrastra la etiqueta de",
    "     la traza de un panel al otro. La guia lo exige: no mezclar senales de escalas",
    "     incompatibles (volt con ampere, o ampere con joule) en el mismo eje.",
    "  4. Rotulos y unidades: LTspice pone la unidad solo si la expresion es una magnitud pura.",
    "     Una expresion como V(a)*I(R1) sale sin unidad; se le pone nombre con boton derecho sobre",
    "     la etiqueta de la traza. La guia pide ejes identificados: hay que hacerlo a mano.",
    "  5. Cursores: boton derecho sobre la ETIQUETA de la traza > Attached Cursor > 1st & 2nd.",
    "     La ventanita que aparece da x, y y la diferencia entre los dos cursores: eso es lo que",
    "     mide tau, el sobreimpulso y el periodo amortiguado.",
    "  6. Escalas: boton derecho sobre el eje > limites a mano. Autoescala es Ctrl+E.",
    "  NADA DE ESTO QUEDA EN EL .asc. LTspice guarda la configuracion de paneles en un archivo",
    "  <nombre>.plt aparte, que se escribe solo al cerrar la ventana de formas de onda. Por eso",
    "  la receta esta escrita aca: es lo unico que viaja con el esquematico.",
]

ORDEN_DE_TRABAJO = [
    "EL ORDEN QUE PIDE LA GUIA: CALCULAR, SIMULAR, MEDIR -- Y EN ESE ORDEN",
    "  Los numeros del bloque 'CONTROL' de mas abajo estan escritos ANTES de correr nada. Una",
    "  prediccion escrita despues de ver la curva no es una prediccion: cualquier curva la",
    "  confirma. Si un .meas no da lo predicho, se arregla el modelo o la cuenta, nunca la",
    "  prediccion.",
]
