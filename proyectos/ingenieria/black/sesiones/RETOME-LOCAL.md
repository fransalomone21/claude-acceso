# Mensaje de retome — BLACK (después de (121): la pieza 2b medida en vivo y RECHAZADA; sigue en FRÍO)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK (proyectos/ingenieria/black). Fase C, pieza 2b. La prueba en vivo YA SE HIZO en (121) y la pieza NO
pasó: queda APAGADA (CON_SUB3 = False) y su fila sigue en coop-plan-b. Este tramo es EN FRÍO: no se abre el
emulador. NO se rehace el banco ni se vuelve a medir en vivo hasta tener la causa leída.

1. LEER, en orden: primero `.\cascada.ps1 black -Necesidad ingenieria-inversa` y CON Read cada rango que imprima
   (la puerta no deja actuar sin eso). Después: `sesiones/PREDICCIONES-118.md` SOLO la sección P3 (las cinco
   predicciones YA tienen su resultado anotado al lado -- no se reescriben); `docs/16-contexto-j2.md` SOLO la
   sección «Lo que la prueba en vivo del sub3 dejó, (121)»; y `herramientas/coop_sub3.py` entero (el FUENTE de
   SUBH, que es lo que hay que auditar). NO releer la bitácora ni docs/14 salvo un dato puntual.
2. FASE: COOP-C -- NASA Phase C, "Final Design and Fabrication" = el diseño fino y fabricar las piezas. No se
   hace: rediseñar sobre la marcha ni arreglar síntomas de a uno. La cierra (PDP §4): las cinco piezas en el
   stub, cada una con predicción escrita antes, control y DOS cargas seguidas; la regresión 8/8 con todo
   prendido sin bajar el ritmo (~30 cuadros/s, ~24 en Steelworks, Asylum y City Bridge); «continuar misión»
   desde una partida del menú; controles.py en verde. Piezas 1 y 2a HECHAS (115, 119); la 2b, rechazada en (121).
   LAS DOS PREGUNTAS DE ESTE TRAMO, las dos en frío y las dos con su respuesta escrita antes de tocar el stub:
   (a) POR QUÉ, con la pieza, J2 deja de cambiar de arma. El gancho 0x001ACA2C vive DENTRO de FUN_001AC960, que
       es el camino del cambio de arma. Leer el tramo 0x001ACA34–0x001ACA68 (lo que corre DESPUÉS del jal) y
       contestar: qué registros da por vivos, si `s0` queda con el sub que ese tramo espera, y qué pisa SUBH.
       SUBH usa t0-t9, a0-a3, la pila y escribe s0 a propósito; FUN_001A8168 preserva s0-s7. El sospechoso se
       nombra con la instrucción exacta, no con una teoría.
   (b) QUÉ TIENE QUE LIMPIAR EL DESARME (riesgo N26, `hipótesis` SIN control): el arreglo de armas de J2
       (ARMAS2 0x0046DBC0) sobrevive a la descarga, y en la carga 2 J2 arrancó con instancias del nivel
       anterior; esa carga terminó con el juego muerto. Medir en los volcados qué queda vivo y qué colgado, como
       hizo sub_estado.py en (118). DESARME_BLOQUE hoy sólo invalida el molde y la cuádrupla.
   El arreglo que salga de (a) y (b) se escribe en docs/16 y en coop-plan-b ANTES de tocar el stub (lo exige la
   Fase C), con su regla en coop_diseno.py y su sabotaje en rojo en el mismo turno.
3. MOTOR: Opus high -- es leer desensamblado y formar la primera hipótesis en territorio que ya contradijo una
   predicción escrita. Nunca Fable. Cuando se vuelva al banco en vivo, Sonnet medium alcanza.
4. MÁQUINA (al cerrar (121)): fork MUERTO; pnach reinstalado al DEFAULT de **1059 palabras** (COOP + IA + HUD
   doble + sonido de J2; `sub3_j2: false`), que es lo que pone JUGAR-BLACK.ps1; COOP activo en
   gamesettings\SLUS-21376_5C891FF1.ini; los tres parches de mira prendidos. Con `--con-sub3` el pnach da 1181.
   Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe; se lanza con
   campana_coop.lanzar() + probar_nivel(n) y, SI FRAN VA A JUGAR, campana_coop.entregar_a_fran(). Primero
   abrir-sesion.ps1. ESTE TRAMO NO NECESITA EL EMULADOR.
5. YA RESUELTO, no rehacer: (121) el banco `herramientas/arma_pieza_banco.py` (`pieza`/`control`) existe, anda y
   construye su propia precondición con s1_juntar.py; el CONTROL de P3a está medido y fotografiado
   (volcados/arma/sonda-precondicion/: con J2 en el fusil las dos mitades lo dibujan aunque el HUD de J marque
   015\030; con J2 en la pistola, las dos muestran pistola -- F7 en las dos direcciones); y está medido que CON
   la pieza la ranura de J2 carga su propio sub (R3+0x50 = SUB3 0x0046EF00) y la de J queda en sub_0, con el
   gancho 1 de 1 y el molde rearmado en las dos cargas. (120) la integración entera y la regla 10 con sus seis
   sabotajes. (119) la pieza 2a prendida. (118) la guarda de plantilla viva, 16/16 contra 0/14. (115) el HUD doble.
6. TRAMPAS MEDIDAS: un banco que no CONSTRUYE su precondición mide cuatro veces lo mismo (lección 336, pagada en
   (121) con una corrida entera: en City Streets por el selector cada jugador arranca con UN ARMA SOLA). Un
   chequeo sobre código que busca un inmediato SUELTO es ciego (lección 335): se exige la relación entre
   registros. Un sabotaje con rc=99 no es rojo: es rojo por otro motivo. capstone en MIPS32 no decodifica sd/ld:
   MIPS64. desensamblar.py imprime `move` como `daddu x, y, zero` y los inmediatos en DECIMAL. Escribir CÓDIGO
   por PINE sólo en pausa. Toda reserva nueva se mide en cero en los volcados. `python pruebas/controles.py`
   antes de commitear. Heredocs largos y con comillas mezcladas: Write + `python <ruta>` (el guardia los frena, y
   tiene razón). Los .md del proyecto los lee git en LF: insertar con un script Python que lea con read_text y
   escriba con newline="". Puede haber OTRA sesión commiteando en paralelo: `git add` sólo de los archivos
   propios, nunca -A; `git pull --rebase` antes del push.
7. ABIERTO, no bloquea: N25 (la mano/arma de J2 rota al apuntar arriba o abajo, reportado por Fran con dos fotos,
   SIN control; sospechoso en grado `hipótesis`: (88c), el mod guarda el cabeceo de J2 negado). El banco de
   «continuar misión» (partida arrancada DESDE EL MENÚ) lo tiene que jugar Fran. **PREGUNTA PENDIENTE PARA FRAN,
   hecha el 2026-10-03 y todavía sin respuesta: si J2 con otra arma que J suena con el arma de J, ¿molesta para
   la v1?** Lo que conteste decide si la 2b se queda sólo con el modelo o se le suma el sonido por arma.

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa
```
