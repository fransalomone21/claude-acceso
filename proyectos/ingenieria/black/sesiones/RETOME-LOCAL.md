# Mensaje de retome — BLACK (después de (124): F7 confirmado — el soporte de modelo compartido; sigue el diseño en FRÍO)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK (proyectos/ingenieria/black). Fase C, pieza 2 (F7: el arma de J2 se dibuja en la mitad de J).
F7 ya tiene causa CONFIRMADA en (124). Este tramo es EN FRÍO: el diseño a nivel instrucción de la pieza
«soporte propio de J2», su regla en coop_diseno.py con sabotaje, y el stub; la prueba en vivo, si alcanza.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER, en orden: `.\cascada.ps1 black -Necesidad ingenieria-inversa` y CON Read cada rango que imprima (la
   puerta no deja actuar sin eso). Después: `docs/16-contexto-j2.md` SOLO la sección «(124) F7 en frio» (al final);
   `sesiones/PREDICCIONES-124.md` (corto). NO releer la bitácora, docs/14 ni las secciones viejas de docs/16 salvo un
   dato puntual (para el armado de J2: `herramientas/coop_mod.py`, el bloque que copia J en 0x0046CDF0 y llama
   `jal 0x139c68`).
2. FASE: COOP-C -- NASA Phase C, "Final Design and Fabrication" = el diseño fino y fabricar las piezas. No se
   hace: rediseñar sobre la marcha ni arreglar síntomas de a uno (un cambio de diseño va a docs/16 y a
   coop_diseno.py ANTES del stub). La cierra (PDP §4): las cinco piezas en el stub con predicción, control y DOS
   cargas; la regresión 8/8 sin bajar el ritmo; «continuar misión» desde el menú; controles.py en verde.
   Piezas 1 y 2a HECHAS. 2b (sub3) APAGADA (no arregla F7). La pieza nueva: J2 con SU soporte de modelo.
   LO CONFIRMADO (124): el dibujo (FUN_00133BA0) toma el modelo de *(*(P+0x328)) y los registros de submallas de
   *(P+0x354) / *(P+0x358); el cambio de arma (FUN_0013C868(P,i)) pone en *(P+0x328) el modelo de la última arma
   cargada (*(*(0x0040F540)+0x7C)+0x14) y copia los registros (FUN_00136B50: 56 B y 96 B). J y J2 comparten
   soporte 0x00597810 y buffers 0x006EC700 / 0x006EC780 (J2 es copia del molde). Devolverle la pistola a mano
   arregla la mitad de J y rompe la de J2 (ON->OFF->ON, 7 de 7).
   LA DECISIÓN (docs/16 (124)): DUPLICAR. J2 con su soporte (0x40 B, copia del de J) y sus dos buffers (0x38 y 0x60 B)
   en memoria del mod; J2+0x328/+0x354/+0x358 apuntan ahí.
   (a) EN FRÍO, lo que falta antes del stub: dónde reapuntar los tres campos en el armado de J2 -- el constructor
       FUN_00139C68 le vuelve a dar el soporte 0 (0x00139E1C, FUN_00138C40(mgr,0)) y copia registros
       (FUN_00136B50 en 0x0013A22C) -- así que va DESPUÉS de la llamada a 0x139c68 del mod; qué modelo inicial lleva
       (el arma con que arranca J2) y soporte+4 / +0x38 (FUN_00138328; el conjunto de agregados de FUN_00137320);
       los accesorios P+0x25C.. (compartidos desde (93s); en b-pistola.png queda un fragmento suelto en la mitad de
       J2) y P+0x360 (igual en J y J2, el fogonazo: candidato a F8). Memoria libre: medir en docs/14 / coop-plan-b.
   (b) La regla en coop_diseno.py (relación, no inmediato suelto) + sabotaje en rojo; después el stub.
   (c) EN VIVO, si alcanza: predicción escrita antes en PREDICCIONES-125.md; banco: `f7_soporte.py` sirve de
       plantilla (pieza vs control, dos cargas). Predicción base: con la pieza, J2 cambia a la SPAS y la mitad de J
       sigue con su pistola bien; el control (sin la pieza) da F7.
3. MOTOR: Opus high, un solo hilo -- diseño a nivel instrucción sobre código del juego. Nunca Fable.
4. MÁQUINA (al cerrar (124)): notebook; fork CERRADO; pnach al DEFAULT de 1059 palabras (COOP + IA + HUD doble +
   sonido de J2; `sub3_j2: false`), que es lo que pone JUGAR-BLACK.ps1; COOP activo en
   gamesettings\SLUS-21376_5C891FF1.ini. Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe;
   lo lanzan los bancos (campana_coop.lanzar() + probar_nivel(0)). Primero `abrir-sesion.ps1 -Rapido`.
5. YA RESUELTO, no rehacer: la causa de F7 (soporte compartido, confirmado con control); el asignador M =
   pers+0x8F0 DESCARTADO (nadie le pide memoria por cuadro; M+0x08 no sigue al que cambia); el sub propio no
   arregla F7 (123); el cuelgue de la 2b (vtable del sub3, arreglado); el banco con la precondición construida.
6. TRAMPAS MEDIDAS: Ghidra NO ve las llamadas por tabla virtual: «quién llama» se contesta también con el barrido
   crudo del ELF (jal, j, palabras, lui/addiu) y con un control positivo conocido. Un juego COLGADO se lee como
   conducta si el banco no mide que sigue vivo entre pasos. El cambio de arma por mando falso se pierde a veces:
   apretar y medir. Un mensaje de commit con `*` lo frena el guardia: `git commit -F <archivo>`. Escribir CÓDIGO
   por PINE sólo en pausa. `python pruebas/controles.py` antes de commitear. Puede haber OTRA sesión commiteando en
   paralelo: `git add` sólo de lo propio, nunca -A; `git pull --rebase` antes del push.
7. ABIERTO, no bloquea: N25 (la mano de J2 rota al apuntar arriba/abajo, sin control); la pieza 2c (el cue propio
   de J2) espera a que el arma de J2 se dibuje bien; el testigo del índice (regla 11) sigue sin ejercitarse.

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa
```
