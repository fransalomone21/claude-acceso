# Mensaje de retome — BLACK (después de (125): la pieza que arregla F7 escrita y APAGADA; sigue la prueba EN VIVO)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK (proyectos/ingenieria/black). Fase C, pieza 2d: J2 con SU soporte de modelo (arregla F7: el arma
de J2 se dibuja en la mitad de J). La pieza está DISEÑADA, ESCRITA e INTEGRADA APAGADA desde (125). Este tramo es
EN VIVO, en la notebook, sin Fran: correr el banco contra las predicciones ya escritas.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER, en orden: `.\cascada.ps1 black -Necesidad ingenieria-inversa` y CON Read cada rango que imprima (la
   puerta no deja actuar sin eso). Después: `sesiones/PREDICCIONES-125.md` (entero, corto) y `docs/16-contexto-j2.md`
   SOLO la sección «(125) La pieza 2d a nivel instruccion» (al final). NO releer la bitácora, docs/14 ni las
   secciones viejas de docs/16.
2. FASE: COOP-C -- NASA Phase C, "Final Design and Fabrication" = el diseño fino y fabricar las piezas. No se
   hace: rediseñar sobre la marcha ni arreglar síntomas de a uno (un cambio de diseño va a docs/16 y a
   coop_diseno.py ANTES del stub). La cierra (PDP §4): las cinco piezas en el stub con predicción, control y DOS
   cargas; la regresión 8/8 sin bajar el ritmo; «continuar misión» desde el menú; controles.py en verde.
   Piezas 1 y 2a HECHAS. 2b (sub3) APAGADA (no arregla F7). 2d (el soporte de J2) ESCRITA y APAGADA.
3. QUÉ HACER, en orden:
   (a) `python herramientas/soporte2_banco.py control` (instala --sin-soporte2, lanza el fork, City Streets,
       J2 junta la SPAS y cambia). Llenar R0 e I0 de PREDICCIONES-125 (tiene que dar F7, como en (124)).
   (b) `python herramientas/soporte2_banco.py pieza` (instala --con-soporte2, DOS cargas). Llenar R1-R4 e I1-I4.
       El veredicto de RAM lo imprime el banco (R1_base, R2_J_no_cambia, R2_J2_cambia, R3_registros); la IMAGEN se
       mira en las mitades -izq/-der de cada foto. Al lado de cada fila, sin reescribirlas.
   (c) Si pasa (I2: la mitad de J con SU pistola y la de J2 con la SPAS, con control y dos cargas): CON_SOPORTE2 =
       True en coop_mod.py, sus filas de coop-plan-b a coop-rangos con el RANGO EXACTO (código 0x00470080..0x00470134;
       el envoltorio pasa a 0x0046DA00..0x0046DBBC; los datos como fila «soporte2 (datos)»), mudar en el MISMO turno
       los sabotajes de la regla 12 que apuntan a las filas del plan, `controles.py` en verde, y
       `coop_mod.py instalar` (el default pasa de 1059 a 1106 palabras). Después la 2c (el cue propio de J2).
   (d) Si aparece un fragmento fuera de lugar en la mitad de J2: es H-acc (docs/16 (125)): los accesorios de J2
       quedan enganchados a la ranura compartida y no a R3. Se diseña en docs/16 antes de tocar R3.
4. MOTOR: Opus high, un solo hilo -- la lectura de lo que salga contra el mecanismo. Nunca Fable.
5. MÁQUINA (al cerrar (125)): notebook; fork CERRADO; pnach al DEFAULT de 1059 palabras (COOP + IA + HUD doble +
   sonido de J2; sub3 y soporte2 apagados), que es lo que pone JUGAR-BLACK.ps1; COOP activo en
   gamesettings\SLUS-21376_5C891FF1.ini. Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe;
   lo lanzan los bancos (campana_coop.lanzar() + probar_nivel(0)). Primero `abrir-sesion.ps1 -Rapido`. El banco deja
   el pnach como lo dejó su último modo: al terminar, `python herramientas/coop_mod.py instalar` (el default) si la
   pieza no pasó, o con ella prendida por defecto si pasó.
6. YA RESUELTO, no rehacer: la causa de F7 (soporte compartido, confirmada con control en (124)); el diseño a nivel
   instrucción (125): la llamada va después del constructor de J2; los buffers miden 0x70 y 0x240 (la capacidad del
   juego, FUN_00131EF0), no 0x38/0x60; J2 lleva 3 accesorios propios (+0x270..+0x278) iniciados con FUN_00142E90;
   +0x360 es un recurso por hash (no compartido); nadie indexa el arreglo de soportes desde P+0x328. La regla 12 de
   coop_diseno.py con 9 sabotajes en rojo. El asignador M descartado; el sub propio no arregla F7.
7. TRAMPAS MEDIDAS: un juego COLGADO se lee como conducta si el banco no mide que sigue vivo entre pasos (el banco
   da ROJO_MUERTO). El cambio de arma por mando falso se pierde a veces: el banco aprieta y mide. Escribir CÓDIGO por
   PINE sólo en pausa. Un mensaje de commit con `*` lo frena el guardia: `git commit -F <archivo>`.
   `python pruebas/controles.py` antes de commitear. Puede haber OTRA sesión commiteando en paralelo: `git add` sólo
   de lo propio, nunca -A; `git pull --rebase` antes del push. La puerta de la cascada puede confundir «punteros» con
   software-de-vuelo: `.\cascada.ps1 software-de-vuelo -Excepcion "falso positivo..."`.
8. ABIERTO, no bloquea: N25 (la mano de J2 rota al apuntar arriba/abajo, sin control); la pieza 2c (el cue propio
   de J2) espera a la 2d; el testigo del índice (regla 11) sigue sin ejercitarse; lo que J2 sigue heredando
   (+0x294, +0x35C, ver clon_comparte.py).

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa
```
