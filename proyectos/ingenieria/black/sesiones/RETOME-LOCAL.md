# Mensaje de retome — BLACK, notebook (la IA a los dos para probar, y las sondas del concepto; después de (98)–(108) en la nube)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK en LOCAL (notebook). Proyecto: proyectos/ingenieria/black. COOP-B ABIERTA, en DISEÑO PRELIMINAR: la nube cerró la concepción y el diseño (bitácoras (98)–(108), docs/16 «Paso 6» y «Decisiones de Fran»). DECISIONES DE FRAN (106): el juego como con uno pero con dos — la IA ataca a los dos, los recogibles para el primero, HUD separado con vida/munición/punto de mira propios, disparadores de J1, si muere cualquiera pierden los dos, los dos con cuerpo de aliado. Esta sesión: PROBAR LA IA (ya escrita e integrada, apagada: --con-ia) y correr las SONDAS DEL CONCEPTO, que no piden código nuevo. Opus, esfuerzo high, sin subagentes, nunca Fable. Castellano rioplatense. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase en cada respuesta. Grado de evidencia en todo; «confirmado» = efecto visto en pantalla o RAM, con control.

0. git pull en claude-acceso. El último commit de proyectos/ingenieria/black tiene que ser el de (108) («muerte… HUD separado… --con-ia») o posterior; si no, pará.
0a. PREPARAR LA NOTEBOOK: `git -C C:\Users\frans\black-datos pull` (el decompilado y el ELF que leen censo_ab.py, coop_diseno.py y coop_ia.py) y `pip install capstone` (lo usa coop_ia.py verificar). Las sesiones de nube (98)–(108) NO tocaron la máquina.
0b. REGLA DE FRAN («Decime qué hago»): si Fran está frente al emulador, ANTES de sondear se le dice QUÉ HACER (botón, segundos) y se espera su aviso. Si no está, trabajás solo con el fork. Nunca el fork con el 2.8.0 de Fran abierto.

1. LEÉ SOLO: docs/16-contexto-j2.md desde «Paso 6» hasta el final (Paso 6, Decisiones de Fran, la IA (107), Muerte/HUD/cuerpos (108)); las entradas (106)–(108) de docs/03-bitacora.md; y si una sonda lo pide, su sección de T3–T6 en docs/16. Nada más.

2. CONTROLES: python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (184), python herramientas/coop_diseno.py verificar (0; la regla 6 lee el ELF de C:\Users\frans\black-datos: si da «(sin ELF)», correr windows/subir-datos-nube.ps1 o apuntar BLACK_DATOS), python pruebas/probar-coop-diseno.py (TODO BIEN, 12 casos), python herramientas/censo_ab.py --autotest (2 ok), python herramientas/coop_ia.py verificar (0).

3. LAS SONDAS, en este orden (de la más barata a la más cara). Cada una: predicción escrita ANTES (está abajo), control en la misma corrida cuando se puede, resultado en la bitácora y en la fila de docs/17. Checkpoint (bitácora + commit + push) después de CADA sonda.

 S0 — LA IA A LOS DOS (107; el primer arreglo de COOP-B, listo para probar): cuatro sitios (ver y visibles con J y J2; blanco por defecto y hostil al más cercano). Código: herramientas/coop_ia.py, listado en docs/listados/107-coop-ia.txt.
   Instalar: `python herramientas/coop_mod.py instalar --con-ia` (787 + 94 palabras) → fork → City Streets. Observables por agente activo (fisica = *(0x0040F4D4); agente i = fisica+0x2B00+i*0x1FD0, activo si +0x78 ≠ 0, personaje +0x7C, bando = personaje+0x3A4: 1 enemigo): máscara de visibles +0x274 (bit 0x2 = J2), amenazas +0x150/+0x1B0/+0x210 (id 1 = J2, id 0 = J), actual +0x270. Vida de J2: J2+0x2F8 (J2 = 0x0046CDF0).
   Predicción: J quieto detrás de una pared, J2 camina a la vista de un enemigo → en < 2 s el bit 0x2 en +0x274 y el id 1 en una amenaza de ese enemigo; después la vida de J2 baja sin que J2 haya disparado (se regenera ~30/s: registrar cada 0,1 s). Con J y J2 a la vista, el enemigo apunta al más cercano.
   Control: `python herramientas/coop_mod.py instalar` (sin la IA) y la misma escena: ni el bit ni el id hasta que J2 dispare.
   Refuta: con la IA y J2 a la vista 10 s, ni bit ni id → la puerta «ver» tiene otra condición (FUN_00185C38(agente+0x6F0), la percepción). Si el emulador cae: anotá el PC; el primer sospechoso es HOST2 (0x00184904).
   Si confirma: la fila «IA: los dos» pasa de coop-plan-b a coop-rangos (docs/14) con su rango exacto, CON_IA = True por defecto, y checkpoint; el pnach de Fran queda CON la IA (pedile el ok antes). Si refuta o cuelga: `python herramientas/coop_mod.py instalar` (sin la IA, 787 palabras) para dejarle el pnach como estaba.

 S1 — JUNTAR (T3, F1): «candidato compartido, consumidor por jugador».
   Setup: City Streets (fork: campana_coop.lanzar() y campana_coop.probar_nivel(0)). Recogibles por PINE: pickups = *(0x0040F4E4); ranura i = pickups + i*0x160; +0xC4 = 7; +0x140 tipo (0 botiquín, 1 munición, 2 ARMA); +0xA0 posición; +0x152 bit 4 = activado (a < 20 m de J). En el lugar de los volcados del parpadeo hay un arma en el piso a ~9 m de J (ranura 25). El candidato: pickups+0x5848 (0 = ninguno), distancia² en +0x584C.
   Control primero: J lejos de toda arma (pickups+0x5848 = 0), J2 mantiene □: `python herramientas/mando_j2.py boton agarrar 1.5` → predicción: NADA (armas de J2 iguales: `python herramientas/armas_j2.py` antes y después).
   Predicción: J parado sobre un arma que no tenga (con Fran: que lo ponga él; en el fork: sondas_coop.py con el mando falso de J) → pickups+0x5848 ≠ 0; J2 LEJOS mantiene □ (mismo comando) → J2 LEVANTA el arma que está bajo J (sus armas cambian; la ranura del recogible deja de estar) y J no cambia.
   Refuta: si J2 no levanta nada, el control o FUN_0015C920 miran algo más (ctrl+0xFB/+0xFC de J2).

 S2 — EL ÍNDICE, NO EL PUERTO (T5, F7/E1/E5): R3 comparte el sub (modelo del arma) con la ranura i de J.
   RAM: `python herramientas/pine.py leer 0x0046E150 --tipo u32` (R3+0x50) contra *(J+0x330)+0x50 (J = 0x005A8AB0) y J+0x2C3 / J2+0x2C3 (J2 = 0x0046CDF0). Predicción A: con índices iguales, R3+0x50 = *(J+0x330)+0x50 (el mismo sub).
   Pantalla (video a 30/s: rafaga_vista.py): J con el arma del MISMO índice que J2 recarga → la mitad de J2 muestra la recarga (E1). J cambia a su otra arma (arma_a/arma_b) y recarga → la mitad de J2 quieta. Control: la misma corrida en el orden inverso, con J1 en el MISMO puerto.
   Refuta: con índices distintos la recarga de J se ve igual en la mitad de J2 → no es el sub (volver a «dibujos directos» de docs/16 T5).

 S3 — AGACHADO (T6, F6): tres hipótesis.
   J agacha 2 s (sondas_coop.py boton agacharse 2, o Fran botón 11), J2 quieto. Registrar cada 0,1 s: *(J+0x32C)+0x30 y *(J2+0x32C)+0x30 (agachado de cada control), J+0x104 y J2+0x104 (altura del ojo, y de +0x100), y lo que el stub puso para la pasada 2 (pantalla_dividida.DATOS+0x70).
   H6a: J2+0x104 baja con el agachado de J2 en 0 → algo del juego le baja el ojo a J2. H6b: J2+0x104 quieto y la mitad de J2 baja → algo del sostén del render viene de J. H6c: el agachado del control de J2 pasa a 1 → entrada compartida. Control: J2 agacha 2 s con J quieto (el espejo).

 S4 — EL SONIDO VIVE EN V (T4, F4). El pnach es patch=1: el aislador no se apaga por PINE, así que son DOS arranques del fork.
   Arranque A: `python herramientas/coop_mod.py instalar --sin-aislar` + fork + City Streets; J2 dispara 3 s (mando_j2.py boton disparar 3) grabando audio (`python herramientas/grabar_audio.py volcados/audio-s4-sin-aislar.wav 6`). Predicción: SE OYE el disparo de J2 (picos como los de J disparando 3 s en la misma corrida, que es el control de nivel) y vuelve el síntoma de (93k) (las dos mitades animan).
   Arranque B (control): `python herramientas/coop_mod.py instalar` (con aislador) y lo mismo → sólo impactos.
   Refuta: sin aislador y J2 igual mudo → el sonido no vive en V (o *(X+0x24)+0x1E54 = 1), y la opción V2 no alcanza para F4. AL TERMINAR: dejar el pnach como estaba (`instalar`, 787 palabras).

 S5 — ctrl+0x100 = J+0x5F0 (F10; (108): el C no muestra quién lo sube, y es la condición de fin de partida). Con el juego EN PAUSA, vigilante de escritura: `python herramientas/ritmo_vigilante.py 0x005A90A0 --tipo write -n 8` (J+0x5F0 = 0x005A8AB0+0x5F0 = 0x005A90A0) y después dejar que J reciba daño hasta morir, sin aliado (Wilderness/Steelworks/Gulag: probar_nivel(i)); b5_vigilar.py para la serie. Predicción: una escritura de valor ≥ 1 antes de morir, con el PC del escritor (anotarlo: es el eslabón que falta), y *(0x0040F0E0)+0x21098 = 1 al morir. Control: un enemigo que muere no la toca. Con eso, el diseño de (108) (copiar J+0x5F0 en J2+0x5F0) se confirma o se ajusta.

 (T2, la IA, NO tiene sonda sin código: su sonda va cuando se construya, docs/16 «Clase B, la IA».)

4. CON LOS RESULTADOS: actualizá docs/16 (cada «Sonda del concepto» con su resultado), docs/17 (evidencia y entrada), y si una sonda REFUTA, la opción elegida de esa tarea se revisa en frío antes de construir. Las preguntas de diseño YA LAS CONTESTÓ FRAN (106): IA a los dos, recogibles al primero, HUD separado con vida/munición/punto de mira propios, disparadores de J1, si muere uno pierden los dos, los dos con cuerpo de aliado; primero funcionalidad, después estética y balance. Orden de construcción (lo escribe la nube en frío, la notebook lo prueba): IA (hecha) → ventana 1: muerte (J2+0x5F0 ← J+0x5F0) y juntar → HUD por jugador → cuerpos → sub3 → V2 → FOV2. Si en la nube hay entradas nuevas de frío (109…), leelas: pueden traer código listo para probar con su sonda.

4b. EN PARALELO puede estar corriendo una sesión de FRÍO en la nube (numera sus entradas desde (120, nube)). Esta sesión numera desde (109). Antes de cada commit: `git pull --rebase origin main`; si choca la cabecera de docs/03-bitacora.md, quedate con LAS DOS entradas (la más nueva arriba).
5. Autonomía: de sonda en sonda hasta ~50 % de contexto o ~90 % del 5 h; antes, checkpoint con ESTADO_ACTUAL + HANDOFF + este mensaje + commit + push.

ESTADO DE LA MÁQUINA (al cerrar (97); sin cambios hasta (108)): pnach de Fran con el bloque COOP (787/792 palabras, ranura 3 prendida), los PCSX2 cerrados. ISO: C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso. Su partida: slot 14 (no la pises). Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe (comparte Documents\PCSX2 y PINE 28011 con el 2.8.0: NUNCA los dos abiertos). En el fork: campana_coop.lanzar() y campana_coop.probar_nivel(i) (0 City Streets … 7 Gulag); en el slot 3 J2 no existe hasta cargar un nivel. Una sola conexión PINE a la vez (también entre dos scripts tuyos).

TRAMPAS MEDIDAS: `--help` en un script propio sin argparse lo CORRE (grep argparse antes). El pnach es patch=1: reescribe sus palabras en cada cuadro; con la ranura 3, 0x001295A8 y 0x001ACA84 son ganchos del pnach. Memoria: manda coop-rangos de docs/14, y lo reservado para COOP-B está en coop-plan-b (no uses esas direcciones para pruebas). FALSO2 (mando falso de J2) = 0x00472100. Dos cuerpos de colisión en el mismo punto cuelgan el EE. Breakpoints de ejecución tiran el emulador. No apretes Start en pleno juego. Commits con mensaje en archivo, sin BOM. kb/*.json: pegar antes del cierre, sin json.dump del archivo entero; sin subir K sin efecto en vivo.

PRIMER COMANDO: git log --oneline -3 -- proyectos/ingenieria/black
```
