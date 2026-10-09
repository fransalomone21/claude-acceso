# Mensaje de retome — BLACK (después de (123): el cuelgue de la 2b arreglado; F7 NO es del sub; sigue en FRÍO)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK (proyectos/ingenieria/black). Fase C, pieza 2 (F7: el arma de J2 se dibuja en la mitad de J).
Este tramo empieza EN FRÍO y termina, si alcanza, con UNA sonda en vivo con predicción escrita antes.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER, en orden: `.\cascada.ps1 black -Necesidad ingenieria-inversa` y CON Read cada rango que imprima (la
   puerta no deja actuar sin eso). Después: `docs/16-contexto-j2.md` SOLO la sección «(123) El sub3 sin su tabla
   virtual» (está al final); `sesiones/PREDICCIONES-123.md` entero (es corto). NO releer la bitácora, docs/14 ni
   las secciones viejas de docs/16 salvo un dato puntual.
2. FASE: COOP-C -- NASA Phase C, "Final Design and Fabrication" = el diseño fino y fabricar las piezas. No se
   hace: rediseñar sobre la marcha ni arreglar síntomas de a uno (un cambio de diseño va a docs/16 y a
   coop_diseno.py ANTES del stub). La cierra (PDP §4): las cinco piezas en el stub con predicción, control y DOS
   cargas; la regresión 8/8 sin bajar el ritmo; «continuar misión» desde el menú; controles.py en verde.
   Piezas 1 y 2a HECHAS. La 2b (sub3): sin cuelgue desde (123) pero NO arregla F7 → APAGADA.
   LA PREGUNTA DE ESTE TRAMO: ¿qué estado de `pers` (`*(0x0040F50C)`) decide qué arma se dibuja en cada mitad?
   (a) EN FRÍO: decompilar FUN_001AD030, FUN_001AC940, FUN_001AD050 y FUN_001AC020 (las cuatro que FUN_001A8168
       y FUN_001A51C8 llaman con `pers`) y escribir QUÉ CAMPOS de pers escriben y quién los LEE en el dibujo del
       aparejo FP (FUN_001A54E0 / FUN_001A7D48 desde 0x00132D98). Nombrar el sospechoso con su campo y su lector.
   (b) EN VIVO (si (a) da un candidato): con el banco `python herramientas/arma_pieza_banco.py control --solo-j2`
       (deja el fork abierto con J en la pistola y J2 en la SPAS tras `j2_cambio`... ojo: el banco termina con
       J2 de vuelta en la pistola; para la sonda, cortar después de `j2_cambio` o volver a cambiar a mano), volcar
       esos campos, y en PAUSA escribirles los valores de cuando el último que armó fue J. PREDICCIÓN a escribir
       antes en PREDICCIONES-124.md: la mitad de J vuelve a la pistola y la de J2 pierde la SPAS → F7 se arregla
       CONMUTANDO esos campos por pasada (primitiva «conmutar el contexto» de T7), no duplicándolos.
3. MOTOR: Opus high, un solo hilo -- es leer desensamblado y la primera hipótesis en un mecanismo que ya refutó
   dos diseños (el puerto en (96), el sub en (123)). Nunca Fable.
4. MÁQUINA (al cerrar (123)): notebook; fork CERRADO; pnach al DEFAULT de 1059 palabras (COOP + IA + HUD doble +
   sonido de J2; `sub3_j2: false`), que es lo que pone JUGAR-BLACK.ps1; COOP activo en
   gamesettings\SLUS-21376_5C891FF1.ini. Con `--con-sub3` el pnach ahora da 1189 (la 2b con el puntero de tabla).
   Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe; lo lanza el banco
   (campana_coop.lanzar() + probar_nivel(0)). Primero `abrir-sesion.ps1 -Rapido`.
5. YA RESUELTO, no rehacer: el cuelgue de la 2b (sub3 sin vtable en +0x5C; SUBH la escribe; confirmado con
   control, dos cargas); el banco del arma (precondición construida, cambio medido con reintentos, vida entre
   pasos); F7 reproducido en el control con la SPAS (con un bloque de basura en la mitad de J); los campos
   +0x34..+0x4C del sub los pone el método virtual. El cuerpo de J2 YA está oculto en la pasada de J
   (`ocultar_pasada`, `oc.A` = J2, por defecto): no es el cuerpo.
6. TRAMPAS MEDIDAS: un juego COLGADO se lee como conducta si el banco no mide que sigue vivo entre pasos (el
   contador de J2 tiene que subir; (121) lo pagó con dos sesiones). Los intentos FALLIDOS de juntar con J lo dejan
   sin arma dibujada (`--solo-j2`). El botón de cambio de arma por mando falso se pierde a veces: apretar y medir.
   Un mensaje de commit con `*` lo frena el guardia: `git commit -F <archivo>`. Escribir CÓDIGO por PINE sólo en
   pausa. `python pruebas/controles.py` antes de commitear. Puede haber OTRA sesión commiteando en paralelo:
   `git add` sólo de lo propio, nunca -A; `git pull --rebase` antes del push.
7. ABIERTO, no bloquea: N25 (la mano de J2 rota al apuntar arriba/abajo, sin control); la pieza 2c (el cue propio
   de J2, decisión de Fran del 2026-10-03) espera a que el arma de J2 se dibuje bien; el testigo del índice
   (regla 11) sigue sin ejercitarse; «BLACK HD Reimagined» (pack de texturas + ReShade de la comunidad, anunciado
   para el 29-08-2026) para cuando se retome el remaster R2/T4.

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa
```
