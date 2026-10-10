# Mensaje de retome — BLACK (después de (126): la 2d pasa su banco pero traba la pausa; F7b, el doble búfer de armas)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK (proyectos/ingenieria/black). Fase C. La pieza 2d (J2 con su soporte de modelo, arregla F7) PASÓ su
banco en (126) pero TRABA LA PAUSA si J2 cambió a otra arma: volvió a APAGADA. La causa de fondo es F7b: el doble
búfer de recursos del arma en la mano (*(0x0040F540) = 0x005BFC00) es de UN jugador. Este tramo es EN FRÍO primero
(notebook o PC, sin Fran): leer lo que falta para elegir el arreglo, escribirlo en docs/16 y en coop_diseno.py.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER, en orden: `.\cascada.ps1 black -Necesidad ingenieria-inversa` y CON Read cada rango que imprima (la
   puerta no deja actuar sin eso). Después: `sesiones/PREDICCIONES-126.md` (entero) y `docs/16-contexto-j2.md`
   SOLO la sección «(126) La 2d pasa, y lo que destapó» (al final). NO releer la bitácora, docs/14, ni las
   secciones viejas de docs/16.
2. FASE: COOP-C -- NASA Phase C, "Final Design and Fabrication" = el diseño fino y fabricar las piezas. No se
   hace: rediseñar sobre la marcha ni arreglar síntomas de a uno (un cambio de diseño va a docs/16 y a
   coop_diseno.py ANTES del stub). La cierra (PDP §4): las cinco piezas en el stub con predicción, control y DOS
   cargas; la regresión 8/8 sin bajar el ritmo; «continuar misión» desde el menú; controles.py en verde.
   Piezas 1 y 2a HECHAS. 2b (sub3) APAGADA (no arregla F7). 2d ESCRITA, PASA SU BANCO, APAGADA (traba la pausa).
3. QUÉ HACER, en orden (en frío, con el decompilado de black-datos/decompilado/0x0014.c, 0x0010.c y el del cargador):
   (a) QUÉ ESPERA EL CARGADOR en la traba: con la 2d, J2 en la SPAS y J1 en pausa, el búfer «otro» (id 14) queda en
       estado 9 con el recurso de la pistola adentro y *(0x0040F4C4)+0x8B8 = 1 sin bajar. Leer quién baja +0x8B8
       (FUN_00108458 / FUN_001084A8 / FUN_00108668 / FUN_001093C0 sobre DAT_0040f4c4) y si cuenta referencias de un
       recurso que se dibuja. Apuntar el modelo del soporte de J a la SPAS NO destrabó: mirar los agregados
       (soporte+0x38), los registros que el dibujo reescribe (+0x354) y los accesorios.
   (b) SI HAY UN ID DE RECURSO LIBRE en el cargador para un tercer búfer (los del doble búfer son 13 y 14; la pausa
       pide 7/0xC aparte): el menú no carga sonido, así que un búfer sólo para la pausa no necesita cues ni área.
   (c) QUÉ DIBUJA EL QUE CAMBIA con su carga en vuelo (FUN_0015BBD8 / FUN_0015C3C8 / FUN_00143908): desde cuándo la
       animación deja de dibujar el arma vieja. Decide si la política D (cargar en el búfer que el otro no usa) tiene
       un instante visible.
   (d) ELEGIR (A / D + búfer de pausa / E, tabla en docs/16 (126)), escribir la elección a nivel instrucción en
       docs/16 y su regla en coop_diseno.py con sabotajes en rojo, ANTES del stub. La 2c sale de ahí: SONJ2 toca el
       cue (+0x08, o +0x0C si arma+0x108) del búfer que tiene el arma de J2, no *(V+0x1BE0).
   (e) Recién después, en vivo: predicciones escritas, y los bancos que ya existen: `herramientas/f7b_pausa.py`
       (`--sin-soporte2` es el control, `--espera N`), `herramientas/f7b_buffer.py --por-j2` (J2 junta una 3.ª arma),
       `herramientas/soporte2_banco.py pieza|control`. La 2d sólo se prende por defecto si pasan LOS TRES.
4. MOTOR: Opus high, un solo hilo -- desensamblado y arquitectura de un recurso compartido. Nunca Fable.
5. MÁQUINA (al cerrar (126)): notebook; fork CERRADO; pnach al DEFAULT de 1059 palabras (COOP + IA + HUD doble +
   sonido de J2; sub3 y soporte2 apagados), lo que pone JUGAR-BLACK.ps1; COOP activo en
   gamesettings\SLUS-21376_5C891FF1.ini. Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe;
   lo lanzan los bancos (campana_coop.lanzar() + probar_nivel(0); a veces PINE no contesta a tiempo: se reintenta
   una vez). Primero `abrir-sesion.ps1 -Rapido`. Cada banco deja el pnach como lo dejó su último modo: al terminar,
   `python herramientas/coop_mod.py instalar` (el default, 1059).
6. YA RESUELTO, no rehacer: F7 = soporte compartido (124); la 2d a nivel instrucción (125) y su banco cumplido
   (126: R0-R4, I0-I4; R3 se lee con `copia_ok` porque el dibujo reescribe el buffer de +0x354). El doble búfer
   leído en frío (126): +0 índice, +0x08/+0x40 búferes de 0x38 (+4 recurso, +8 cue, +0xC cue alterno, +0x10 área de
   sonido, +0x14 modelo, +0x18 agregados, +0x1C estado, +0x20/+0x28 claves), +0x7C actual, +0x80 otro; arranque
   FUN_00143688, cues/áreas en la 1.a carga FUN_00143700, descarga FUN_001437D8, carga por cuadro FUN_00143908, alterna
   FUN_00144078, escritor de +0x7C medido 0x001440A0. Las 6 sub-ranuras de cue de V y sus 2 áreas: OCUPADAS (la 2c
   «en una sub-ranura libre» era imposible). La pausa vacía el «otro» y carga PseMenu.bin ahí (control sin la 2d:
   anda). H-cue (el cambio de J2 cambia el sonido de J): REFUTADA (el aislador engancha FUN_001D6E78).
7. TRAMPAS MEDIDAS: en el menú de pausa confirma el botón 0 (un 2.º Start NO lo cierra). J no junta armas (3 de 3,
   como en (123)): las precondiciones con armas distintas se arman por J2 (`--por-j2`). Un juego COLGADO se lee como
   conducta si el banco no mide que sigue vivo (ROJO_MUERTO); con el menú de pausa abierto el contador de J2 no sube
   aunque el EE corra (mirar la foto antes de leerlo como cuelgue). Escribir CÓDIGO por PINE sólo en pausa. Un mensaje
   de commit con `*` lo frena el guardia: `git commit -F <archivo>`. `python pruebas/controles.py` antes de
   commitear. Puede haber OTRA sesión commiteando: `git add` sólo de lo propio; `git pull --rebase` antes del push.
8. ABIERTO, no bloquea: N25 (la mano de J2 rota al apuntar arriba/abajo); H-acc (accesorios de J2 enganchados a la
   ranura compartida, sin síntoma); con el rifle con mira el HUD derecho de J2 se ve corrido hacia afuera (visto una
   vez, sin control); FUN_00143908 mapea la clave del arma con FUN_001440B8 si *(*(0x0040F4D0)+0x5CA0) != 0 (¿modelos
   alternativos?, sin medir).

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa
```
