# Mensaje de retome — BLACK (después de (128): N27 es de la pausa; R4 hecha y probada, apagada)

Pegar tal cual como primer mensaje del chat siguiente.

```
Retomo BLACK (proyectos/ingenieria/black). Fase C. En (128) se reprodujo N27 con control (pnach por defecto: con la
pausa antes del cambio de J2, 2 de 2 caídas; sin la pausa, 0 de 2) y se FABRICÓ y PROBÓ R4 (coop_pausa.py: la pausa
carga su menú en el montón 22, memoria de malloc una vez, y no toca el doble búfer de armas): con R4, 0 de 2 caídas,
dos cargas, menú entero, y con la 2d la pausa ya no se traba. R4 quedó APAGADA por defecto hasta la regresión con
una pausa en cada nivel. Este tramo: (a) esa regresión y, si pasa, prender R4 por defecto; (b) R1–R3 (D') en frío.

0. EL LIBRO PRIMERO: si ~/.claude/CLAUDE.md no empieza con «# Perfil global», correr
   `bash .claude/nube/traer-perfil.sh` en claude-acceso y leer lo que liste (en la PC llega solo).
1. LEER, en orden: `.\cascada.ps1 black -Necesidad ingenieria-inversa` y CON Read cada rango que imprima (la puerta
   no deja actuar sin eso). Después: `sesiones/PREDICCIONES-128.md` (entero) y de `docs/16-contexto-j2.md` SOLO la
   sección «(128) N27 reproducida, y R4 a nivel instrucción» (al final) y, para (b), la (127) (c)/(d) (qué dibuja el
   que cambia; R1–R3). NO releer la bitácora, docs/14 entero, ni las secciones viejas de docs/16.
2. FASE: COOP-C -- NASA Phase C, "Final Design and Fabrication" = el diseño fino y fabricar las piezas. No se hace:
   rediseñar sobre la marcha ni arreglar síntomas de a uno (un cambio de diseño va a docs/16 y a coop_diseno.py ANTES
   del stub). La cierra (PDP §4): las cinco piezas en el stub con predicción, control y DOS cargas (y antes de prender
   una pieza que duplica un recurso compartido, el banco cubre los otros caminos de ese recurso con datos distintos);
   la regresión 8/8 sin bajar el ritmo; «continuar misión» desde el menú; controles.py en verde. Piezas 1 y 2a HECHAS;
   2b APAGADA; 2d ESCRITA, pasa su banco, APAGADA (con R4 no traba la pausa, pero falta F7b en juntar/precarga);
   R4 HECHA, APAGADA.
3. QUÉ HACER, en orden:
   (a) LA REGRESIÓN DE R4, en vivo (notebook, sin Fran), con predicción escrita antes en sesiones/PREDICCIONES-129.md.
       Un banco (nuevo, o un modo de campana_coop.py) que en UN arranque con `coop_mod.py instalar --con-pausa` cargue
       los 8 niveles (campana_coop.probar_nivel(n), n = 0..7) y en cada uno pause y vuelva (Start = botón 8 del mando
       falso de J; en el menú confirma el botón 0), midiendo: contador de J2 vivo después de volver, los testigos de
       R4 (coop_pausa: P_CRUDO, FALLO, ALTAS = 1 en todo el arranque, CARGAS, el byte activo de coop_pausa.entrada()),
       la foto del menú, y el ritmo (cuadros/s; hoy ~30, ~24 en Steelworks, Asylum y City Bridge: no puede bajar).
       Control: la misma corrida sin --con-pausa (o la campaña 8/8 de (111)). Riesgo que mide: la memoria de R4 sale
       de la cima del arena de malloc; un nivel más pesado podría necesitarla. Si pasa 8/8: CON_PAUSA = True en
       coop_mod.py, sus filas de coop-plan-b a coop-rangos CON EL RANGO EXACTO, y en el MISMO turno mudar los dos
       sabotajes de la regla 13 que tocan el plano (reserva achicada, gancho sin fila) a las filas nuevas (la lección
       de (119): un sabotaje que apunta al bloque viejo no sabotea nada). Si un nivel cae: frena, y R4 se rediseña
       (¿pedir la memoria en el arranque, antes de los niveles?) en docs/16 antes de tocar el stub.
   (b) R1–R3 (D') A NIVEL INSTRUCCIÓN en docs/16, en frío. R2 es obligatoria (dibujar un arma cuyo montón se vació
       cuelga el cuadro, (127)). Leer antes cómo se esconde el arma de primera persona (modelo 0 en soporte+0 / una
       bandera: FUN_00138338 y el dibujo del soporte) y el gancho a la entrada de FUN_00143908 (sólo mira el «otro»).
       Después la regla en coop_diseno.py por relación (simulación por caminos, como la 13) con sabotajes, y recién
       ahí el stub. El banco de la prueba tiene que cubrir los cinco caminos (alta, precarga, cambio, juntar, pausa)
       con armas DISTINTAS entre J y J2.
4. MOTOR: (a) es un banco sobre un diseño ya decidido; (b) es desensamblado y arquitectura: Opus high, un solo hilo.
   Nunca Fable.
5. MÁQUINA (al cerrar (128)): notebook; fork CERRADO; pnach al DEFAULT de 1059 palabras (COOP + IA + HUD doble +
   sonido de J2; sub3, soporte2 y pausa propia apagados), lo que pone JUGAR-BLACK.ps1; COOP activo en
   gamesettings\SLUS-21376_5C891FF1.ini. Fork: C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe;
   lo lanzan los bancos (campana_coop.lanzar() + probar_nivel(0)) y lo DEJAN ABIERTO; cerrarlo con
   campana_coop.matar_fork(). Primero `abrir-sesion.ps1 -Rapido`. Al terminar, `python herramientas/coop_mod.py
   instalar` (el default; si R4 pasó a default, el default nuevo).
6. YA RESUELTO, no rehacer ((128), docs/16): N27 es de la pausa (2/2 con, 0/2 sin; registros idénticos; el lazo de
   «syscall indefinida» del núcleo en 0x80001564). R4: ganchos 0x0020AEF4 (era jal FUN_001438C8) y 0x0020AF84 (era
   jal FUN_00143F90); montón 22 = entrada 0x0040F40C (gestor 0x40F0F0, 26 montones de 0x24, nadie más lo pide);
   malloc FUN_0035E7D8 de 0x35FFF alineado a 0x800, montón de 0x35800 (el menú reserva 0x35000); datos
   0x0046F1C0–0x0046F1D0 (no van en el pnach), código 0x0046F200–0x0046F2E8. La salida de la pausa (FUN_001438E8)
   sólo resetea un «otro» en 9: con R4 no hace nada. La 2.ª pausa encuentra el menú registrado (tipo 7, id 0xC) y no
   lo relee. Con R4 + 2d: la pausa abre y vuelve con J2 en otra arma, cada mitad con su arma (una corrida).
7. TRAMPAS MEDIDAS: en el menú de pausa confirma el botón 0. J no junta armas: las precondiciones con armas distintas
   se arman por J2. Con el menú de pausa abierto el contador de J2 no sube aunque el EE corra. Escribir CÓDIGO por PINE
   sólo en pausa. `coop_mod.py instalar` sin cambios devuelve sólo {"cambio": false} (= el pnach ya es el pedido). Un
   GPR del EE es de 128 bits: el valor son las ÚLTIMAS 8 cifras (depurador.py ya lo muestra así). Las etiquetas de
   ensamblar_programa se resuelven por token (una inexistente es KeyError). Un mensaje de commit con `*` lo frena el
   guardia: `git commit -F <archivo>`. Scripts: con Write a un archivo, nunca por heredoc. `python pruebas/controles.py`
   antes de commitear. Puede haber OTRA sesión commiteando: `git add` sólo de lo propio; `git pull --rebase` antes del
   push.
8. ABIERTO, no bloquea: el mecanismo de la caída de N27 (qué escribe dónde: hipótesis); N25 (la mano de J2 rota al
   apuntar arriba/abajo); H-acc; el HUD derecho de J2 corrido con el rifle con mira (visto una vez).

PRIMER COMANDO: .\cascada.ps1 black -Necesidad ingenieria-inversa
```
