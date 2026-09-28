# Mensaje de retome — BLACK, notebook EN FRÍO (sin emulador): revisar la tanda (98)–(108b) y seguir con las estructuras

Pegar tal cual como primer mensaje del chat siguiente, en la notebook, con los PCSX2 **cerrados**.

```
Retomo BLACK en LOCAL (notebook) pero EN FRÍO: NO se abre ningún emulador (ni el fork ni el 2.8.0 de Fran). Proyecto: proyectos/ingenieria/black. Fase COOP-B (diseño preliminar, alcance ampliado el 2026-09-28 (106)). REGLA DE FRAN (99): no bajar a la implementación sin liquidar concepción y diseño. Opus, esfuerzo high, sin subagentes ni fan-out, nunca Fable. Castellano rioplatense. Cuadros PARA VOS (con «Cómo venimos» en criollo, contra la META: jugar el coop en pantalla dividida) y de fase en cada respuesta. Grado de evidencia: sin emulador lo máximo es «confirmado en frío» o «confirmado en volcado».

0. git pull en claude-acceso (último commit de black: el de «(108b)… revisar» o posterior; si hay entradas más nuevas, mandan). `git -C C:\Users\frans\black-datos pull` y `pip install capstone`. Numerá tus entradas desde (109); si en paralelo corre una nube, ella numera desde (120, nube): antes de cada commit `git pull --rebase origin main` y, si choca la cabecera de la bitácora, quedate con las dos entradas.

1. LO QUE LA NUBE NO PUDO CORRER (desde la raíz de claude-acceso): `.\verificar-estructura.ps1`, `.\chequeo-completo.ps1 -SoloMedidores` (y `.\chequeo-completo.ps1` entero si los saboteadores tienen más de 7 días), `.\cascada.ps1 black` (que la fila del enrutador y el ESTADO_ACTUAL coincidan), y las DOS lecciones de proceso con aprender.py: los comandos exactos están en el paso 2b de proyectos/ingenieria/black/sesiones/RETOME-LOCAL.md.

2. LEÉ: proyectos/ingenieria/black/sesiones/REVISAR-98-108.md ENTERO (lo que se corrigió y la tabla B de «revisar por las dudas»); en docs/16-contexto-j2.md desde «Paso 6» hasta el final; las entradas (106)–(108b) de docs/03-bitacora.md; y en PDP.md «Proyecto COOP — Fase B» (criterio con el punto 4 y la tabla B1–B11). Nada más.

3. CONTROLES: python herramientas/programa.py verificar (0 rojos), python pruebas/prueba_herramientas.py (184), python herramientas/coop_diseno.py verificar (0), python pruebas/probar-coop-diseno.py (TODO BIEN, 12), python herramientas/censo_ab.py --autotest, python herramientas/coop_ia.py verificar (0).

4. TAREAS, en este orden:
 4a. LA REVISIÓN EN FRÍO de REVISAR-98-108.md, las filas marcadas R: B2 (buscar en las INSTRUCCIONES quién escribe ctrl+0x100 = J+0x5F0: todo sw con desplazamiento 0x100 sobre un control y 0x5F0 sobre un jugador, lectores_global.py / capstone; el C no lo muestra), B3 (quién lee ctrl+0x30 fuera del aparejo), B5 (punteros a la cabecera sombra, punteros_a.py), B6 (J+0x190 contra J+0xA0 en los volcados), B7 (los nodos 0x0040F510 y 0x0040F4D8: ¿hay que partirlos? sólo con medición), B8 (quién llama FUN_001848C0 y con qué p), B15 (censo por instrucciones con lectores_global.py 0x0040F4D0 contra las 103 de censo_ab), B16. Cada fila revisada: su resultado en la tabla (columna nueva «resultado (109…)»), y si algo refuta un diseño, se anota en docs/16 y se corrige ANTES de construir.
 4b. Las tareas de estructuras de sesiones/RETOME-NUBE.md (E1 el jugador por dentro → docs/18-el-jugador.md; E2 las estructuras de al lado; E3 el HUD por jugador), con BLACK_DATOS = C:\Users\frans\black-datos. En la notebook además hay Ghidra (`decompilar.py info` primero: control positivo) para lo que el decompilado guardado no alcance.
 4c. Si sobra: E4 de RETOME-NUBE (el código de la ventana 1: muerte y juntar, detrás de banderas, como coop_ia.py).
 NO correr `coop_mod.py instalar` ni `poner`: sin emulador no se prueba, y el pnach de Fran se toca sólo en caliente.

5. AL CERRAR: ESTADO_ACTUAL.md, sesiones/HANDOFF.md (bloque arriba), REVISAR-98-108.md con los resultados, y el retome que siga (caliente: RETOME-LOCAL.md; frío: este o RETOME-NUBE.md). Commit y push a main.

TRAMPAS MEDIDAS: `--help` en un script propio sin argparse lo CORRE (grep argparse antes). Ninguna etiqueta de ensamblar_programa puede ser prefijo de otra. Capstone no decodifica el VU0 en macro (lqc2/sqc2/vadd salen como bbit032): para eso, el C. Memoria: coop-rangos y coop-plan-b de docs/14 mandan. kb/*.json: pegar antes del cierre, sin json.dump del archivo entero; sin subir K sin efecto en vivo. Commits con mensaje en archivo, sin BOM.

PRIMER COMANDO: git log --oneline -3 -- proyectos/ingenieria/black
```
