# Mensaje de retome — BLACK (después de (127): F7b elegido, D' + montón de pausa; N27 a reproducir)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK (proyectos/ingenieria/black). Fase C. En (127) quedó ELEGIDO el arreglo de F7b (el doble búfer de
armas *(0x0040F540) es de un jugador): D' (cada búfer es del jugador que lo dibuja, no se vacía un búfer que alguien
dibuja, la precarga de la alterna sólo en un búfer libre) + R4 (la pausa carga su menú en un montón propio, el 22,
sobre memoria pedida a malloc). Y apareció N27: con el pnach POR DEFECTO el juego se cayó una vez al cambiar J2 de
arma después de una pausa. Este tramo: primero reproducir N27 (en vivo, notebook, sin Fran), después R4 a nivel
instrucción (en frío) con su regla en coop_diseno.py y sabotajes, ANTES del stub.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER, en orden: `.\cascada.ps1 black -Necesidad ingenieria-inversa` y CON Read cada rango que imprima (la
   puerta no deja actuar sin eso). Después: `sesiones/PREDICCIONES-127.md` (entero), `docs/16-contexto-j2.md` SOLO
   la sección «(127) En frío: qué espera el cargador...» (al final) y la fila N27 de `docs/17-lo-que-falta.md`.
   NO releer la bitácora, docs/14, ni las secciones viejas de docs/16 (la (126) ya está resumida en la (127)).
2. FASE: COOP-C -- NASA Phase C, "Final Design and Fabrication" = el diseño fino y fabricar las piezas. No se
   hace: rediseñar sobre la marcha ni arreglar síntomas de a uno (un cambio de diseño va a docs/16 y a
   coop_diseno.py ANTES del stub). La cierra (PDP §4): las cinco piezas en el stub con predicción, control y DOS
   cargas (y antes de prender una pieza que duplica un recurso compartido, el banco cubre los otros caminos de ese
   recurso con datos distintos); la regresión 8/8 sin bajar el ritmo; «continuar misión» desde el menú;
   controles.py en verde. Piezas 1 y 2a HECHAS. 2b APAGADA. 2d ESCRITA, PASA SU BANCO, APAGADA (traba la pausa).
3. QUÉ HACER, en orden:
   (a) N27, EN VIVO, con predicción escrita antes en sesiones/PREDICCIONES-128.md. La secuencia que cayó
       (volcados/arma/f7b-pausa-20261011-200815/): pnach por defecto (1059), J2 empieza en la SPAS y J en la pistola,
       J1 pausa y despausa, J2 cambia a la pistola (hizo falta 2 pulsaciones) -> EE en el núcleo 0x80001578, Cause
       0x20, EPC 0x0027DBFC (un nop), v1 0x01010101. Construir ESA precondición a propósito (f7b_pausa.py hoy da
       ROJO_PRECONDICION si los dos no quedan en la misma arma: hace falta un modo que deje a J2 en la SPAS) y correr
       con control: la misma secuencia SIN la pausa previa, y la misma con la pausa. Si cae sólo con la pausa, es de la
       familia F7b (la pausa vacía el «otro») y R4 la tapa; si cae sin pausa, es otra cosa y frena la fabricación.
       En la caída: `python herramientas/f7b_hilos.py <dir>` y `python herramientas/depurador.py registros
       --categoria 1` (EPC/Cause/BadVaddr) ANTES de cerrar el fork.
   (b) R4 A NIVEL INSTRUCCIÓN en docs/16 (127)(d): el sitio en FUN_0020AEA0 (la pausa) que hoy llama
       FUN_001438C8(dbuf) y FUN_00143F90(dbuf, PseMenu, 0x0020AAC8, 0xC, 1); la llamada directa
       FUN_001093C0(*(0x0040F4C4), PseMenu, 6, 22, 0x0020AAC8, 0xC, 1, 0x2000000); el alta del montón 22 con
       FUN_00107A08(0x40F0F0 + 4 + 22*0x24, alineado(p), -1, 0x35000) sobre p = FUN_0035E7D8(0x35080) pedido UNA vez
       (dónde se guarda p, y qué pasa si malloc devuelve 0: la pausa vuelve al camino original). Leer antes: quién más
       llama a FUN_0020AFF8/FUN_001438E8 y si algo del menú cuenta con el estado 9 del «otro». Después la regla en
       coop_diseno.py (por relación, como la 12) con sabotajes en rojo, y recién ahí el stub.
   (c) Después, R1–R3 (D') a nivel instrucción. R2 es obligatoria: dibujar un arma cuyo montón se vació CUELGA el
       cuadro (medido en (127)), no deja la mano vacía. Falta leer cómo se esconde el arma (modelo 0 en soporte+0 /
       una bandera) antes de diseñarla.
4. MOTOR: Opus high, un solo hilo -- desensamblado y arquitectura de un recurso compartido. Nunca Fable.
5. MÁQUINA (al cerrar (127)): notebook; fork CERRADO; pnach al DEFAULT de 1059 palabras (COOP + IA + HUD doble +
   sonido de J2; sub3 y soporte2 apagados), lo que pone JUGAR-BLACK.ps1; COOP activo en
   gamesettings\SLUS-21376_5C891FF1.ini. Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe;
   lo lanzan los bancos (campana_coop.lanzar() + probar_nivel(0)) y lo DEJAN ABIERTO al terminar (para f7b_hilos.py);
   cerrarlo con campana_coop.matar_fork(). Primero `abrir-sesion.ps1 -Rapido`. Al terminar,
   `python herramientas/coop_mod.py instalar` (el default, 1059).
6. YA RESUELTO, no rehacer ((127), docs/16): el cargador *(0x0040F4C4) = 0x00598380, 10 ranuras de 0x140 B
   (+0x138 pendiente, +0x13D soltar); +0x8B8 = pendiente de la ranura 6 (arma y pausa); hilo propio de menor
   prioridad (id 3; el principal es el 1), no cuenta referencias, vacía el montón (cursor = inicio) y lee encima. La
   traba: el principal en el lazo de FUN_002B32D8 (espera el DMA del cuadro anterior), el cargador listo sin correr
   (medido). Los 26 montones de 0x40F0F0 con su lector (13/14 = armas, 0xB2000 c/u; 15 front-end en juego; 18
   paquetes de render; 20 pila del cargador; 22/23 sin inicializar; 24 = 0x25800, chico; 25 = Guns.bin). PseMenu.bin
   = 215 400 B -> 0x35000 en el montón. La región 0x01F28800.. NO es libre (malloc). Los caminos del recurso: alta
   del jugador (0x0013.c, P+0x8A4), PRECARGA de la alterna en cada cuadro (FUN_0015BBD8 estado 0), cambio, juntar
   (FUN_0015C1A8), pausa. A y E descartadas. +0x5CA0 = armas plateadas (Guns_s.bin).
7. TRAMPAS MEDIDAS: en el menú de pausa confirma el botón 0. J no junta armas: las precondiciones con armas distintas
   se arman por J2 (`--por-j2`). Un banco que sigue sin su precondición mide otra cosa: f7b_pausa.py da
   ROJO_PRECONDICION (arreglado en (127)). Con el menú de pausa abierto el contador de J2 no sube aunque el EE corra:
   para saber si está vivo, f7b_hilos.py (PC y lista de hilos), no el contador. Escribir CÓDIGO por PINE sólo en
   pausa. Un mensaje de commit con `*` lo frena el guardia: `git commit -F <archivo>`. Scripts de Python: con Write a
   un archivo, nunca por heredoc (lo frena el guardia). `python pruebas/controles.py` antes de commitear. Puede haber
   OTRA sesión commiteando: `git add` sólo de lo propio; `git pull --rebase` antes del push.
8. ABIERTO, no bloquea: N25 (la mano de J2 rota al apuntar arriba/abajo); H-acc; el HUD derecho de J2 corrido con
   el rifle con mira (visto una vez).

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa
```
