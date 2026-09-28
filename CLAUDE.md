# claude-acceso — el punto de entrada

**Toda sesión de Claude Code empieza acá.** No hay que elegir repositorio ni
rama: hay una sola rama (`main`) y un solo árbol. Se abre esta carpeta, se
dice con qué proyecto se sigue, y la cascada de abajo hace el resto.

Este archivo es el **enrutador**. No explica cómo se trabaja (eso es el perfil
global, que se carga solo) ni qué pasa en cada proyecto (eso es el
`CLAUDE.md` de cada proyecto). Sólo dice **a dónde ir**.

---

## La cascada — se lee de arriba hacia abajo, y se para apenas alcanza

| Nivel | Qué | Dónde | Cuándo se lee |
|---|---|---|---|
| 0 | fundamentos (Meadows, Hunt & Thomas) | `pilares.md` | **solo**, por hook |
| 1 | las reglas del método | `~/.claude/CLAUDE.md` + skills | **solo**, cada sesión |
| 2 | **este archivo: qué proyectos hay y dónde** | acá | **solo**, cada sesión |
| 3 | qué se lee siempre en esta clase de proyecto | `plantillas/naturalezas/<nat>.md` | al entrar a un proyecto |
| 4 | el contrato del proyecto: índice de qué leer según la tarea | `<proyecto>/CLAUDE.md` (se carga solo si abrís ahí) | al entrar a un proyecto |
| 5 | dónde quedamos | `<proyecto>/ESTADO_ACTUAL.md` + `HANDOFF.md` | al retomar |
| 6 | el detalle que la tarea concreta pida | lo que el nivel 4 mande | sólo si hace falta |

Los niveles 0-2 llegan solos y no cuestan decisión. Del 3 al 6 se baja **sólo
hasta donde la tarea necesite**: cada nivel cuesta contexto, y el contexto es
lo que después falta para pensar el problema difícil.

**Esa tabla dice qué clase de archivo va en cada nivel; no dice cuál es el
archivo del proyecto que estás por abrir.** Esa traducción la hacía la sesión,
de memoria, cada vez — y lo que depende de que alguien lo recuerde no es una
regla, es una intención. Ahora la emite un comando:

```powershell
.\cascada.ps1                   # los proyectos que hay en el disco
.\cascada.ps1 <proyecto>        # los archivos a leer, en orden, con rutas exactas
```

`cascada.ps1` **no tiene ninguna lista propia**: deriva todo del disco, de la
carpeta de naturaleza y del contrato del proyecto. Una segunda lista sería
exactamente el problema que existe para no crear. Y de paso imprime **juntas**
las dos fuentes que ya se contradijeron una vez —la fila del enrutador y el
encabezado del `ESTADO_ACTUAL` del proyecto— para que la divergencia se vea en
el momento en que importa. Si no coinciden, **manda el proyecto** (regla 4).

---

## Los proyectos

Cada proyecto es **una carpeta**, no una rama. La naturaleza decide qué se lee
siempre (nivel 3) y con cuánto rigor se trabaja.

### `proyectos/ingenieria/` — sistemas técnicos: hipótesis, evidencia, efecto

| Proyecto | Qué es | Estado |
|---|---|---|
| [`arquitectura-se/`](proyectos/ingenieria/arquitectura-se/CLAUDE.md) | Reformar el método (cascada, PDP, naturalezas, frenos) contra NASA SP-2016-6105, INCOSE y Rechtin | **ACTIVO** — **fases 0-6 CERRADAS.** Los cuatro libros leídos y medidos, la arquitectura diseñada con trade study (B 810 / A 430 / C 400), y **migrada**: la fase 6 cerró el 17/09 con `chequeo-completo` en verde (7 medidores + 10 saboteadores), los TRES defectos vivos arreglados y **un proyecto real migrado**. Instaladas P2, P3, P4, P6 y P7; P5 con la mitad puesta; P1 diferido con su resta. De paso: **cinco caracteres de control dentro de archivos vivos** —uno en el .md que se inyecta en cada sesión y dos datos técnicos de BLACK— y la **regla 8** de la estructura, que ahora los mide. **Fase 7 abierta: validar ≠ verificar** (P10, el medidor que le falta al método) |
| [`black/`](proyectos/ingenieria/black/CLAUDE.md) | Ingeniería reversa de **BLACK** (PS2) sobre PCSX2 | **ACTIVO** — **programa** (NASA §3). **Pre-Fase A cerrada el 2026-09-27 con la MCR**: Fran contestó las 22 preguntas y delegó pesos y decisiones; `programa.py trade` corre con sensibilidad. **Cartera: un solo proyecto, COOP; su Fase A CERRÓ el 2026-09-27 (83)**, con la pantalla dividida como meta (el juego es en primera persona) y Parsec encima para jugar cada uno en su PC. **El plan del ELF en la nube está completo** (bitácoras (66)–(75)): ELF decompilado, mapa de 37 nodos sin ninguno en K0, **Lote de la notebook corrido el 27/09 sin nadie en el mando** (bitácora (76)): el mando 2 maneja al jugador 1 cambiando tres punteros (`entrada` K5), la vista se gobierna con un float (`camara` K5), `render` K4, y un mando falso mueve al jugador sin manos. **Bitácora (77)**: el mando falso **aprieta botones** (dispara, recarga, cambia de arma) y mata sin manos, y **la cámara desactivada de fábrica anda** (cámara de cine de ~2 s al matar, confirmada con control; si entra al mod lo decide Fran). **Bitácora (78)**: un **selector de niveles de depuración** escondido se abre sin manos (carga cualquier nivel; los de prueba 96 y 99 cuelgan), 5a cerrada (nadie pide el modo de 2 jugadores) y **código nuevo por PINE** (gancho por cuadro, `codigo-nuevo` K5). **Bitácora (79)**: **el jugador 2 existe** — construido por el constructor del juego durante la carga, con arma y cuerpo físico propios, corre a 60 Hz sin congelar al 1, y **el mando 2 le gira la vista** (`juego` K5). Los cuelgues de (78) eran nuestros: el índice −577 caía encima del stub. **Bitácora (80, nube), tanda en frío**: la ranura de personaje quedó **medida** en vez de supuesta. La copia del sistema **puede** funcionar (35 accesos al global medidos sobre las instrucciones, **una sola escritura** del puntero, y por cuadro el global no se usa para nada que importe); J2 no camina porque `FUN_001a6be0` lee **el dueño** de la ranura; y el índice de ranura sale de `J+0x2C3`, que es **el arma en la mano** — las dos ranuras del sistema son **las dos armas del único jugador**. La copia son **tres** bloques (0x1D10 B), no uno: cada ranura tiene un compañero de 0x9D0 B en el montón, y la especificación vieja dejaba a J2 escribiendo en la animación de J0. De paso, `0x0040F50C` **no era `audio`** (nodo nuevo `personajes`, K4; el error venía de fusionar el vecino sin medirlo) y `J+0x7C`/`+0x8C` **dejan de ser sonda**. **Bitácora (81)**: **la ranura no era lo que faltaba.** Las dos sondas **refutadas** —el byte del arma no sobrevive al constructor, y con la ranura propia y su dueño puesto el motor **sí la usa** y J2 igual no camina— y **no es una pared** (los cuatro empujes dan cero exacto y rapidez 0; el control lo pidió Fran mirando la pantalla). La cadena del paso quedó medida eslabón por eslabón: el pedido llega y la rapidez pedida se calcula, pero **el cuerpo físico de J2 no lo toca nadie** (0 escrituras y **0 ruido**, contra 8 y 1 del de J), porque el motor de física recorre **su propia lista** y el de J2 no está en ella. Dos correcciones de (80): `FUN_001a6be0` propaga **acoples** y no camina, y la posición del jugador es `+0xA0` (`+0x100` es el **ojo**). `fisica` K3 → K4. **Bitácora (82): J2 CAMINA con el mando 2 — el prototipo del criterio de COOP-A está hecho.** Lo que faltaba era el **controlador de colisión** de `J+0xB4`, que el cargador sólo ata a los `cuenta` = 1 jugadores: llamar una vez `FUN_0025C210` (`jugador2.py atar`) y J2 camina 8 m en 2 s, choca con las paredes y **empuja a J**; con la ranura compartida camina igual (la ranura propia no hacía falta). **Corrige a (81)**: el cuerpo físico es un **seguidor** que copia la posición del jugador, y el de J2 **sí** está en la lista — el «nadie lo toca» era de medir con J2 quieto. `ragdoll` K2 → K5 (son los cuerpos de personaje). En pantalla, J2 se ve como **dos brazos flotando, sin cuerpo**: tema de la Fase B. **Bitácora (83): `spawn` K5 y COOP-A CERRADA.** La aparición fuera de la carga **existe y es del juego**: por cuadro, un temporizador (`FUN_00174578`) recorre los spawners del nivel (73 en City Streets) y **un byte** en uno armado hace aparecer un enemigo en el cuadro siguiente — 4 de 4 con negativo, en la lista viva, con controlador y cuerpo; **moviendo el punto nace donde se lo pone y se ve** (capturas antes/después). Con eso los siete habilitadores están en su objetivo. **Bitácora (84): COOP-B ABIERTA** con su criterio en el PDP, y **dos vistas en el mismo cuadro** (`render` K5). **Bitácora (85)**: el cuerpo de J2 es **un aliado del nivel** que copia su matriz (prototipo por PINE, con control), **J2 hace daño** (su matriz de vista tenía el cabeceo al revés) y **no hay fuego amigo entre jugadores**, por diseño del juego. **Bitácora (86)**: **B3 anda en la primera carga** — el mod es sólo código en un pnach (el envoltorio del cargador copia a J como molde de J2) y J2 camina 7,5 m con el mando 2 sin PINE; **la segunda carga cuelga el emulador** (algo dado de alta a J2 sobrevive al nivel), así que el bloque quedó instalado y **apagado**. **Bitácora (87)**: **B3.3 arreglada** — al salir del nivel el juego da de baja sólo a los `cuenta` = 1 jugadores (suelta el controlador de colisión y lo saca de la lista); el mod se engancha a ese desarme y hace lo mismo con J2: **tres cargas seguidas** con J2 caminando, y sin la baja la segunda cae (la causa era el controlador de colisión de J2, aislado con control). El bloque del pnach quedó actualizado y **apagado**. **Bitácora (88): el coop en pantalla dividida sale del pnach solo** (375 palabras): con PCSX2 reiniciado y sin Python, J2 se arma, camina con el mando 2, **el aliado le hace de cuerpo desde el stub** y **la pantalla se divide sola** con la vista de J2 calculada en el stub con `sinf`/`cosf` del propio juego. De paso **corrige a (85)**: la matriz de vista tiene la misma convención en J y J2; el mod guarda el cabeceo de J2 negado y le invierte «invertir Y», así el mando 2 apunta para el lado correcto (medido en RAM). La prueba de daño con el enemigo movido a mano **no mide** (J tampoco le pega). Bloque **instalado y apagado**. **Bitácora (89)**: las mitades ya **no salen aplastadas** (la proporción de la cámara a la mitad durante cada pasada) y el **«fantasma» amarillo** era el tinte a pantalla completa del juego dibujado dos veces: filtrado, sale limpio y la pantalla partida pasa de 38–40 a **64 cuadros por segundo**. **Abierto**: por el parche, recién cargado el nivel, una banda amarilla en la mitad derecha (no es el viewport, refutado). 430 palabras, **apagado**. **Sigue**: la banda; que Fran lo juegue con el mando 2 real; los brazos flotantes (`sesiones/RETOME-LOCAL.md`) |
| [`lavarropas-drean/`](proyectos/ingenieria/lavarropas-drean/CLAUDE.md) | Diagnosticar y arreglar el ruido creciente del lavarropas **Drean Next 6.06 ECO** de casa. Lo ejecutan Fran y su papá sobre la máquina; la sesión produce el procedimiento, no el arreglo | **ACTIVO** — abrió el 2026-09-21 con la **fase 0 cerrada**: equipo identificado por etiqueta (6 kg, 600 rpm, 1700 W), causas candidatas ordenadas y la guía escrita con **7 tests** que descartan cada una. La sospecha principal —rulemanes comidos por retén vencido— es `probable` y no `confirmado`: la sostiene el **óxido radial en la polea** de las fotos, no el tacto. **Fase 1 abierta: los 7 tests corridos y al menos una causa descartada.** De paso, las medidas del kit del **Next** 6.06 no se consiguieron de fuente (la publicada es de la línea Blue/Excellent), y eso empujó al procedimiento más barato: se compra con el rulemán viejo en la mano, no por modelo |
| [`metodo-agustin/`](proyectos/ingenieria/metodo-agustin/CLAUDE.md) | Pasar el método (pilares, reglas, skills, hooks, frenos, lecciones, cascada) a la notebook de Agustín **sin** los proyectos de Fran: un núcleo **generado** por script desde los dos repos, filtrado de lo personal, que viaja por GitHub. Sólo ida | **ACTIVO** — abrió el 2026-09-26 con la **fase 0 cerrada**: Windows, sólo ida, y el tope del plan de Claude entra como riesgo vigilado. Se descartó invitarlo a `perfil-global` tal cual («Fran» 103 veces, rutas fijas en 7 archivos, y el colaborador tendría escritura). **Fase 1 abierta: exportador + verificador de privacidad, con su saboteador en rojo 5 de 5.** De paso: `install.ps1` no tiene parámetro de destino, así que el del export **no se corre nunca acá** porque pisaría el perfil de Fran. **2026-09-27:** entregada aparte una **guía de un solo archivo** (`entregables/EL-METODO.md`) para Agustín y para Matías, que usa el plan gratis: ideas, reglas, cuadros, PDP, cascada y un dial de rigor Liviano / Medio / Completo. No cierra la fase 1 |
| [`diagnostico-msi/`](proyectos/ingenieria/diagnostico-msi/) | Secure Boot y batería de la notebook MSI | cerrado con informe |
| [`telescopio/`](proyectos/ingenieria/telescopio/) | Plataforma ecuatorial Dobson, CAD SolidWorks | dormido |
| [`telefono-samsung/`](proyectos/ingenieria/telefono-samsung/) | Kit de diagnóstico y limpieza vía ADB | suspendido (2026-08-15) |

### `proyectos/documentos/` — producir un artefacto de contenido

| Proyecto | Qué es | Estado |
|---|---|---|
| [`electronica-analogica/`](proyectos/documentos/electronica-analogica/CLAUDE.md) | Apunte de Aplicaciones de Electrónica Analógica de 4.º año (E.E.S.T. N.º 1 de Vicente López) en Typst, **156 pág.**, 15 módulos en dos partes | **ACTIVO** — fase 3 abierta (faltan trifásicos, zpk, filtros activos e impedancia reflejada, medido con `grep` el 22/09) y **fase 3b cerrada el 2026-09-22: la cobertura de la guía de TP está medida, no supuesta**. La guía del II cuatrimestre **ya estaba en el repo desde el 23/08** —mismo MD5 que el PDF que se aportó el 22/09—, así que lo que faltaba no era la fuente sino el medidor: itemizada da **43 consignas** y **seis no tenían ninguna sección que las respondiera**, entre ellas la **parte 3 entera del TP 7**, la fuente doble simétrica, que no es el rectificador de punto medio del Módulo 4. Entraron cinco secciones nuevas y `fig-fuente-doble` (72 → 73 figuras), con el resultado que las justifica: **cada rama pierde un solo diodo, no dos**, verificado por dos caminos. Lo mide `verificar-cobertura.py` (43 consignas, 52 anclas, 1 diferida con motivo) y su saboteador va **5/5 con control positivo**. `verificar.py` pasó a **seis** chequeos: el nuevo resuelve las referencias `Ejercicio N.M` de texto plano, y **nació de un error propio de la misma sesión** —insertar la fuente doble corrió el zener de 5.3 a 5.4 y dos referencias quedaron mal, compilando en verde—. De paso, el **PDP quedó migrado** al molde nuevo (§3 rigor por aspecto, §4 «Cómo se certifica», §8 matriz de 16 filas con 3 recortes y su resta): `medir-fase.py` bajó de 8 PDP sin migrar a 7. **Pendiente: la guía del I cuatrimestre (TP 1 a 5) no está medida** — es la fase 3c |
| [`fisica-espacial/`](proyectos/documentos/fisica-espacial/CLAUDE.md) | Apunte general de Física Espacial (UNSAM, Ing. en Sistemas Espaciales) en Typst, 173 pág. | **ACTIVO** — reabierto el 2026-09-25 por la lista de temas *Impulso angular*. **Fase 9 cerrada**: entró el módulo `rotacion` (Sears caps. 9–10, las 17 filas de la lista con sección) y el giróscopo de la guía (S&Z 10.51) resuelto a fondo; **21 módulos, 187 pág.** **Fase 10 cerrada**: Fran aprobó la voz del módulo 17 (sarcástica, integrada en la prosa, sin chistes anunciados); de paso 218 de las 407 cajas del apunte pasaron a marcas de color en el texto. **Fase 11 cerrada el 2026-09-25: la pasada por los 20 módulos y el Anexo A**, en cuatro tandas (**188 pág.**, `medir-estilo.py`: PENDIENTE 58 → 44 → 30 → 10 → **0**). Las `#lectura` del 17/09 fallaron en todas las tandas al medirlas (capítulos del Roederer que no existen, el Bate negado donde trata el tema, páginas del PDF por impresas). **Y la (d) encontró un error de física publicado: directa y retrógrada estaban invertidas** en m20, m21 y cuatro fichas del Anexo —una ecuación enmarcada con un signo que no coincidía con su propia deducción, y una «corrección» vieja que se apoyó en ella—; el Beer pág. 1191 dice alargado → directa, achatado → retrógrada. El spin del Problema 4 es **negativo**. **Fase 12 cerrada el 2026-09-25: las 12 fichas «cuenta propia» del Anexo recalculadas de cero** (grep 13 → 0); diez coincidieron y dos no. La grave: **el Problema 9 de CR tenía el empuje con el signo dado vuelta** (el gas sale a +y, el satélite recibe −y), y el octógono resultó ser el **Beer 18.125**, que estaba en el disco con figura, el ω₀ que la guía no copió y respuestas: la cuenta nueva reproduce las seis. **Fase 13 cerrada el 2026-09-26: los tres anexos, 202 pág.** El formulario (Anexo B) **no copia ninguna ecuación**: las trae de su módulo al compilar, con número, página y link. Lo mide `verificar-anexos.py`, que cuenta las etiquetas **por dos caminos** (regex y `typst query`) — y el segundo encontró que el `grep` del retome daba **124 cuando son 136** (mayúsculas y etiquetas en el renglón de abajo): 122 en el formulario, 14 excluidas con motivo. Su saboteador, 9 de 9 en rojo. Constantes (C) con **cada página medida** —Curtis tiene tres $\mu$ de la Luna y un offset de página que no es constante— y correspondencia de notación (D), 23 filas. De paso, m12 atribuía al Sears números que son de Curtis. Antes salió «hinchapelotas» del m17, a pedido de Fran. **Fase 14 cerrada el 2026-09-27: la guía completa y dos modelos de parcial, en Drive** (`Fisica Espacial/` con tres subcarpetas): los 56 ejercicios de la guía (4) recortados como los pegó Aníbal, con tip y resultado (y una versión sin resultados), un parcialito de momento angular y un integrador. **233 números recalculados de cero** por `practica/validar.py` (saboteador 8/8), que encontró **el rendez-vous del m12 en 698 m/s cuando son 688**. Regla nueva: $bold(L)$ es el *momento angular*, no «impulso angular». **Sin fase abierta** |
| [`clase-asincronica-3/`](proyectos/documentos/clase-asincronica-3/CLAUDE.md) | Actividad asincrónica de Teoría de Circuitos (UNSAM): 12 problemas de Nilsson caps. 6-8, resueltos y simulados en LTspice | **ACTIVO** — fase 2; las 17 simulaciones cerradas y verificadas |
| [`apunte-iise/`](proyectos/documentos/apunte-iise/CLAUDE.md) | Apunte general de Introducción a la Ingeniería de Sistemas Espaciales (UNSAM), unidades 1 a 7, en Typst. Se rinde sobre distinciones léxicas, así que el **glosario controlado es el módulo 0** y hay un verificador de léxico | **CERRADO** — las **siete fases** del PDP (0 a 4 el 2026-09-20; la 5, figuras, y la 6, parcialitos 4 y 5, el 2026-09-21). 7 unidades, 28 módulos, 71 términos, **126 páginas con 18 figuras**, `verificar-lexico.py` y `verificar-cobertura.py` en verde, y **publicado en el Drive** (13 MB, verificado por MD5). La cobertura contra los parcialitos va por **28 preguntas y 62 anclas, ninguna huérfana** — y las mide `verificar-cobertura.py`, que exige el **título exacto de la sección**: de las 11 anclas que la fase 6 escribió de memoria, puso **11 en rojo** |
| [`repaso-iise/`](proyectos/documentos/repaso-iise/) | Repaso oral de IISE: guion + audios | terminado |
| `teoria-circuitos/` | Informes de laboratorio de Teoría de Circuitos (UNSAM, cátedra Sanca), en grupo de tres | **ACTIVO** — **fases 1 a 5 CERRADAS**; el Informe 1 entregado con **nota 7**. La corrección en papel del profe abrió la fase 5: destilar lo que corrigió a mano en reglas medibles. Salió `CRITERIO-CATEDRA.md` —las **15 marcas** traducidas a **22 reglas**, con una hipótesis falsable sobre cómo lee— más `verificar-estilo.py`, que las mide sobre el **`.docx`** y no sobre el script que lo genera, y su saboteador en **14/14**. **Los dos informes quedaron en 0 incumplimientos y 6 páginas**, medidas sobre el PDF que exporta **Google Docs** y no sobre el de LibreOffice, que con el mismo archivo da 7 y un renglón fantasma. El **Pre-Lab** se reescribió con sus 4 errores técnicos arreglados —el peor definía −3 dB como caer al 30 % cuando es **al 71 %**— y va como Doc nuevo de Fran, sin pisar el de Santiago. De paso: los 12 esquemáticos perdieron las leyendas explicativas (el tono didáctico delata que no las escribió él) y **el generador también**, porque tocar sólo los `.asc` los devolvía; y apareció la **regla 22**, que no sale de una marca del profesor sino de un `%s` sin su operador `%` que Python no marca como error y que salió impreso en el `.docx`. En el Drive, la raíz de apuntes es **pública por link** y ese permiso **se hereda**, así que la carpeta «PRIVADOS» que estaba adentro no era privada: las del grupo se mudaron **afuera**, con el entregable arriba y el respaldo debajo. **Corregido el 2026-09-22: mudarlas no las despublicó.** Los dos `.docx` —los que llevan los mails en la carátula— siguieron con `anyone:reader` **25 días**, porque el permiso viaja con el objeto y acá se verificó dónde quedaron, no qué permiso tenían. Ya revocado y medido; lo vigila `verificar-drive.ps1`. **Fase 6 sin abrir: la abre la consigna del laboratorio siguiente. Lo único pendiente lo hace Fran: entregar.** **Repo aparte**: la carátula lleva mails de compañeros |
| [`clases-aed/`](proyectos/documentos/clases-aed/CLAUDE.md) | Clases particulares de Aplicaciones de Electrónica Digital III (6.º, EEST N.º 1): guía de estudio en Typst con FSM y diagramas de flujo, entorno PlatformIO + SimulIDE de cuatro exámenes modelo y el de metales resuelto. **Repo aparte**: lleva nombre y mail de la alumna | **ACTIVO** — **fase 0 cerrada el 2026-09-23**: guía de **25 pág.**, 5 proyectos en `pio run` SUCCESS, todo en Drive (`03 - CLASES PARTICULARES`, MD5 verificado) y compartido como **lector**, medido por permiso. **Fase 1 abierta hasta el examen del 10/10**: la cierra el Examen 1 corriendo en SimulIDE, que todavía **no se abrió** |
| [`taller-de-fisica/`](proyectos/documentos/taller-de-fisica/CLAUDE.md) | Apunte del Taller de Física (materia aparte, dinámica de cátedra), con Ferraro, Pisacane y Young-Freedman como fuentes | fase 0 (fuentes localizadas, recorte de Pisacane sin cerrar); **fase 1 bloqueada a propósito** hasta que Fran lo pida |

### `proyectos/seguimiento/` — datos longitudinales de la vida real

| Proyecto | Qué es | Estado |
|---|---|---|
| `caso-tio/` | Caso clínico familiar → guía para la familia | vivo, **repo aparte, no se pushea acá** |
| [`haberes-docentes/`](proyectos/seguimiento/haberes-docentes/CLAUDE.md) | Cobrar el cargo docente de la EEST N°1 de Vicente López: bancarización, primer COULI y ruteo del sueldo | **ACTIVO** — **fases 0, 1 y 2 CERRADAS**; las dos primeras el 2026-09-20, el día que abrió, y la 2 el **2026-09-27**: **Fran está bancarizado**, cuenta `ACTIVA` en BAPRO, sucursal Avda. Maipú 741 de Vicente López, en **7 días** contra los "más de 30" que advertía el instructivo. La fase 0 midió que la cuenta sueldo sólo puede ser del Banco Provincia —Mercado Pago (CVU, no CBU), Patagonia y Ciudad quedaron afuera— y que **Cuenta DNI ya era** una caja de ahorro de BAPRO, así que se cargó `Nueva Cuenta con CBU` para asociarla. **El banco no lo hizo: ignoró el pedido, lo dejó colgado en `PENDIENTE` para siempre y abrió una cuenta nueva** en una sucursal que nadie eligió — el resultado del camino descartado, que salió bien de casualidad porque cayó en Vicente López. Eso **reabrió un riesgo que el PDP había tachado** ("sin cuenta nueva no hay tarjeta que retirar"): la tarjeta se destruye a los 60 días, ≈26/11. **Fase 3 abierta: el COULI con conceptos prefijo `A`**, el 5.º día hábil de octubre. De paso, el medidor de la fase 1 **se puso en rojo una vez** —con el cartel verde de "solicitud exitosa" en la mano— y eso es lo que lo vuelve creíble. **Repo aparte**, sin remote |
| [`coaching/`](proyectos/seguimiento/coaching/CLAUDE.md) | Entrenamiento y dieta: músculo y fuerza | **ACTIVO** — **fase 1 abierta el 2026-09-14**, hasta el 26/10. Línea base de la fase 0: 135 kg (banca 80 + fondo 40 + dominada 15, a 5 reps con RIR 2). **Semana 1 medida el 21/09** (4 de 4) y **la primera de la semana 2 el 22/09**: 13 sesiones, pierna 1/4 y **calibrador 0/4, que es el criterio de cierre en riesgo**. El lunes 21/09 fue la mejor banca de la fase —las reps **subieron dentro de la sesión**, 4 → 6 → 8 a 80 kg, cosa que no había pasado nunca— y **no se sabe por qué**: hay tres variables cambiadas a la vez (una sola aproximación, agarre ancho desde el arranque, rotación externa en el calentamiento). La hipótesis principal es la más aburrida —faltó una aproximación y la serie 1 se comió el calentamiento— y quedó **escrita como predicción antes de medirla**: el 28/09 la serie 1 tiene que dar ≥ 6 reps. **La regla de progresión NO se tocó** aunque el número la invita, porque cambiarla con el resultado a la vista es inventar el criterio para que encaje. De paso: el ancho del agarre falló por **tercera** vez y dejó de pedirse — ahora hay un **default prescripto**; el calibrador perdió el «jueves *o* sábado», que era la elección que lo hacía saltable; y nació el **espejo en Drive** (`publicar-drive.ps1`), cuyo verificador arrancó en **rojo permanente** porque Typst estampaba la hora de compilación. **Repo aparte**, privado y con remote desde el 2026-08-28 |

---

> **`claude-acceso` es un repositorio PÚBLICO.** Nada personal —datos de
> salud, físicos, de alimentación, seriales, informes de dispositivos— se
> commitea acá. Para eso están las carpetas ignoradas de la tabla de arriba,
> que tienen su propio repo. `perfil-global` sí es privado.

## Las cuatro reglas de la estructura

1. **Un proyecto, una carpeta.** Nunca una rama. Las ramas se usan para
   trabajo en curso que todavía no se integra, no para separar proyectos: eso
   ya se probó y produjo un `ESTADO_ACTUAL.md` que declaraba la fase 5 cuando
   el proyecto iba por la 7e.

2. **Un archivo, un repo dueño.** Si una carpeta tiene su propio `.git`, este
   repo la pone en `.gitignore` en el mismo turno, y `git ls-files <carpeta>`
   tiene que dar **0**. *Cuáles son hoy no se escribe acá*: se mide con
   `.\verificar-estructura.ps1`, que las descubre en el disco. Esta línea
   enumeraba dos cuando ya eran tres, y nadie se enteró durante un mes — un
   dato que vive en dos lados diverge, y la lista vive en el disco.

   **Y cuál repo lo decide la sensibilidad, que es un eje aparte de la
   naturaleza.** La naturaleza dice *qué se lee y con cuánto rigor* (nivel 3);
   la sensibilidad dice *dónde puede vivir el archivo*. Son independientes: un
   informe con mails de terceros se **produce** igual que cualquier otro
   documento —mismo `documentos.md`, mismo `/pdf-con-codigo`— pero no puede
   publicarse. Por eso no se inventa una naturaleza para eso; se elige destino:

   | Sensibilidad | Destino | Ejemplos |
   |---|---|---|
   | pública | `claude-acceso` | casi todo |
   | personal, **y vale recordarla** | **repo propio**, ignorado acá, remote privado o ninguno | `caso-tio`, `coaching`, `teoria-circuitos` |
   | personal, y **no** vale recordarla | carpeta ignorada acá | `telefono-samsung/informes/`, `diagnostico-msi/datos-crudos/` |

   La fila del medio es la que faltaba y la que se elude sola, porque cuesta
   un `git init` más. Elegir mal para abajo **pierde el trabajo** (nada existe
   si no está commiteado); elegir mal para arriba **lo publica**. Las dos
   fallas son silenciosas, así que hay una que las mide: la **regla 5** de
   `verificar-estructura.ps1` busca mails y teléfonos en lo que este repo
   trackea. Lo que sea legítimo se declara en `.claude/datos-permitidos.json`
   — declarar una excepción es un acto, no un silencio.

3. **Todo proyecto nuevo nace de un PDP, y nace acá adentro.** `plantillas/PDP.md`
   — Plan de Desarrollo de Proyecto; el contrato sale de
   `plantillas/proyecto-CLAUDE.md`. Sin PDP no hay carpeta: es lo que define
   las fases y, sobre todo, el **criterio de salida** de cada una *antes* de
   empezarla.

   **Esta regla se incumplió el 2026-08-28 y nada lo notó.** Un informe de
   Teoría de Circuitos se trabajó una sesión entera en
   `Desktop\Informe TC - Thevenin y Norton\`: sin PDP, sin contrato, sin bajar
   al nivel 3 de la cascada, y sin que ninguna de las cuatro reglas dijera una
   palabra. No podían: **las cuatro miran adentro de `proyectos/`**, y un
   proyecto que nace en el Escritorio es invisible por construcción.

   Una regla que se incumple no se escribe más fuerte — se le agrega el flujo
   de información que falta (`pilares.md`, Meadows). Los dos que se agregaron:

   - **El censo del Escritorio** (regla 6 de `verificar-estructura.ps1`):
     nombra toda carpeta del Desktop que parezca proyecto y no esté en el
     sistema. Lo que legítimamente no es un proyecto se declara en
     `.claude/fuera-del-sistema.txt`. El medidor deja de estar en el sótano.
   - **`.\nuevo-proyecto.ps1`**: crea carpeta, PDP, contrato, `ESTADO_ACTUAL`
     y `HANDOFF` en un comando, y avisa de agregarlo al enrutador. Mientras
     hacerlo bien costó seis pasos y hacerlo mal costó un `mkdir`, la regla
     iba a seguir perdiendo — y eso no es indisciplina, es la misma señal de
     impracticabilidad que ya archivó el esquema de un proyecto por rama.

4. **Lo que este archivo dice se verifica antes de repetirlo.** Un documento
   no se entera de que alguien lo cambió. Si una fila de las tablas de arriba
   contradice al `ESTADO_ACTUAL.md` del proyecto, **gana el proyecto** y esta
   tabla se corrige en el mismo turno.

**Las cuatro son ejecutables desde el 2026-08-28.** Antes, la única con un
chequeo era la 2; las otras tres las sostenía que alguien se acordara, y una
regla que nadie mide se corre sola:

```powershell
.\verificar-estructura.ps1      # las cuatro reglas, contra el disco
.\probar-verificador.ps1        # rompe cada una y exige ver el rojo
.\nuevo-proyecto.ps1 <nombre>   # el camino correcto, en un comando
```

`verificar-estructura.ps1` mide las cuatro reglas en **siete** bloques. Los
tres últimos son mitades que faltaban, y las tres son la misma clase de
ceguera: *un verificador sólo ve donde vive.*

| bloque | mira | qué agujero tapa |
|---|---|---|
| 5 | lo que este repo **publica** | que la regla 2 haya elegido bien el destino |
| 6 | lo que este repo **no ve** (el Escritorio) | que la regla 3 se haya aplicado |
| 7 | lo que cada **contrato** enlaza | que la cascada no se corte en el nivel 6 |

La 5 y la 6 se descubrieron el mismo día, las dos por el mismo informe: un
chequeo que sólo se pregunta por lo que ya está adentro no puede atrapar lo
que nunca entró. La 7 es la de abajo — la regla 3b ya exigía que los enlaces
del **enrutador** resolvieran, pero nadie miraba los de cada contrato, que es
justo donde una sesión que ya bajó al nivel 4 sigue el puntero y cae en la
nada.

El segundo es el que hace que el primero valga algo. Un chequeo que nunca
falló está sin verificar.

## Los frenos — lo que ya no depende de que alguien se acuerde

Desde el **2026-08-28** hay tres capas ejecutables, instaladas y probadas por
`bootstrap.ps1`:

| capa | qué es | contra qué |
|---|---|---|
| 1 | atributo `ReadOnly` sobre los archivos de `.claude/protegidos.json` | lo frena **el sistema operativo**, incluso fuera de una sesión |
| 2 | hook `PreToolUse` (`.claude/hooks/guardia-iso.ps1`) | alarma temprana que **explica**; falla **cerrado** |
| 3 | integridad medida en `abrir-sesion.ps1` de cada proyecto | mide el **efecto** sobre el objeto: no tiene agujeros |

Y un hook `SessionStart` emite `.claude/arranque.md`: las autorizaciones
permanentes y el comando de apertura de cada proyecto, que vivían en archivos
que **no se leen solos** y por eso se olvidaban cada sesión.

**Desde el 2026-08-29 ese hook además MIDE.** Emitir el texto decía que
existían siete verificadores; correrlos seguía dependiendo de que alguien se
acordara, y lo único que informaba del estado real era el `HANDOFF` que dejó
la sesión anterior — un archivo escrito por otra sesión, que no se entera de
nada que pase después de escribirse. El hook corre ahora la **capa rápida** de
`chequeo-completo.ps1` y mete el resultado en la sesión, medido:

```powershell
.\chequeo-completo.ps1                  # las dos capas (~110 s)
.\chequeo-completo.ps1 -SoloMedidores   # la rapida (~7 s) -- la que corre el hook
```

| capa | qué | cuándo corre |
|---|---|---|
| **medidores** (7 s) | `verificar-estructura` + `verify-install` + `aprender.py sin-triage` | **sola, en cada arranque** |
| **saboteadores** (96 s) | los cuatro `probar-*.ps1`: rompen cada alarma y exigen el rojo | a mano; el hook **avisa** si pasaron más de 7 días |
| **limpieza** | los medidores otra vez, *después* de sabotear | con los saboteadores |

La tercera fila no estaba prevista y salió de una falla real del mismo día:
`probar-chequeo-lecciones.ps1` restauraba el archivo **fuente** y dejaba la
copia **instalada** en `~/.claude` con el sabotaje adentro — y su control
positivo daba verde porque miraba el repo, no el efecto. Es exactamente la
ceguera que los saboteadores existen para atrapar, del lado de adentro. Ahora
lo mide un segundo pase, y la clase entera de suciedad se ve, no sólo la que
ya conocemos.

```powershell
.\probar-hooks.ps1              # cada freno en rojo, y los controles positivos
.\.claude\desinstalar-hooks.ps1 # lo que se instala solo, se desinstala solo
```

**Si un comando legítimo queda bloqueado, el guardia no se saca**: se corrige
el patrón y se vuelve a correr `probar-hooks.ps1`, que exige ver el rojo *y*
que lo legítimo siga pasando. La segunda mitad no es decorativa — el guardia
bloqueó mal su primer comando real porque `\bdel\b` matcheaba el "DEL" de una
frase en español.

---

## Los apuntes que ven los compañeros — Drive

La carpeta es
[esta](https://drive.google.com/drive/folders/1Uz_4Lu4i1LX7xbeS-dDVEF-TXi6EA1mL)
y adentro va **una carpeta por materia** con el PDF del apunte. Se sube con
`rclone` contra el remote `drive-apuntes`; el token vive en
`~/.config/rclone/rclone.conf` —medido, **no** en `%APPDATA%`—, **fuera
del repo**, y por eso este archivo puede nombrar la carpeta sin publicar
nada. Esa ruta es la que pasa `publicar-apuntes.ps1`, y es la fuente: un
`rclone` invocado a mano con otra ruta corta con «empty token found -
please run config reconnect», que se lee como token vencido y no lo es.
Ya costó una vez; esta línea decía `%APPDATA%` y por eso costó una
segunda. **Si hay un script propio que envuelve la herramienta, se lee
el script antes de invocar la herramienta cruda.**

```powershell
.\publicar-apuntes.ps1             # sube lo que cambio
.\publicar-apuntes.ps1 -Verificar  # solo mide, no sube. Es lo que corre en cada arranque
.\probar-publicacion.ps1           # rompe el publicador y exige verlo en rojo
```

Los dos scripts pasan `--config` con la ruta completa **a propósito**: un
archivo resuelto por una variable de entorno no es una ruta, es una función
del entorno, y
ya pasó que una consola dijera «not found» sobre el mismo archivo que otra
ventana de la misma máquina listaba sin problema.

**Qué se publica es una lista, no una regla implícita.** Vive en
`.claude/apuntes-publicos.json` y es *deny-by-default*: un PDF no se publica
por estar en el repo, se publica por estar declarado. Lo que parece apunte y
no está en la lista sale reportado como **«sin declarar»** — ni se sube ni se
ignora en silencio, que es la misma forma de la regla 5 de
`verificar-estructura.ps1` y de `.claude/datos-permitidos.json`. Eso es lo que
hace que un apunte **nuevo** entre al circuito sin que nadie se acuerde de
nada: aparece solo, en rojo, el día que se compila por primera vez.

**Sólo apuntes.** Los informes de cátedra no van: la carátula lleva mails de
compañeros y viven en un repo aparte. El material de `seguimiento/` tampoco.
Las dos exclusiones están escritas en el JSON, con el motivo al lado.

> **Corregido el 2026-09-22, y la corrección importa más que la línea.** Esto
> decía que el material de `seguimiento/` «no sale nunca de su repo», y el
> 22/09 la rutina del coaching **sí** salió a Drive — a pedido de Fran. La
> regla estaba escrita sobre el destino equivocado: el freno nunca fue contra
> Drive, fue contra **este remote**, `drive-apuntes`, cuya carpeta es
> **pública por link y hereda el permiso**. Lo que rige es el eje de
> sensibilidad de la regla 2 de la estructura, aplicado a Drive:
>
> | remote | apunta a | qué puede ir |
> |---|---|---|
> | `drive-apuntes` | la carpeta de los compañeros — **pública por link** | sólo lo declarado en `apuntes-publicos.json` |
> | `drive-personal` | la raíz de Mi unidad — **privada** | el espejo del coaching (`Coaching/`), verificado por permisos: un solo `owner` y ningún `anyone` |
>
> Los dos remotes usan el mismo token y se distinguen **sólo** por el
> `root_folder_id`: `drive-apuntes` lo tiene y `drive-personal` no. Una regla
> que quedó falsa no se obedece a medias — se deja de obedecer en todos
> lados, y por eso se reescribe el mismo día en que deja de ser cierta.

**Lo publicado se compara por MD5, no por fecha.** La fecha del lado de Drive
no es la del archivo local —depende de cómo se subió—, así que comparar fechas
da rojos falsos (molestos pero inocuos) y, cuando además coincide el tamaño,
**verdes falsos, que son silenciosos**. El hash lo da `rclone lsjson --hash`
gratis. Esto salió de auditar un verde que no se podía explicar: el apunte de
Electrónica figuraba «al día» con una fecha que no tenía por qué coincidir.
Coincidía de verdad —el MD5 lo confirmó—, pero el chequeo que lo había dicho
no era el que podía decirlo.

**El que mide es el arranque**, no la memoria: `publicar-apuntes.ps1
-Verificar` es uno de los medidores de `chequeo-completo.ps1`, así que cada
sesión abre diciendo si el Drive quedó atrasado. Un apunte que se toca y no se
sube es exactamente la falla que no duele el mismo día.

> **Aviso con fecha:** rclone usa hoy su `client_id` compartido de Google, que
> **se retira durante 2026** — el propio rclone lo avisa en cada corrida.
> Cuando deje de andar, el arreglo es crear un `client_id` propio
> (https://rclone.org/drive/#making-your-own-client-id) y agregarlo al remote.
> No es urgente hasta que el medidor se ponga en rojo por eso.

---

## Mi unidad — el orden, y por qué se mide

Ordenada el **2026-09-22**. La raíz son **seis carpetas y un LEEME**, y el
número no ordena por tema sino por **quién puede verlo**: `00 - PERSONAL`
(nadie), `01 - UNSAM` (adentro conviven los tres niveles, cada uno dicho en su
propio nombre), `02 - ARCHIVO`, `Coaching` y `Classroom` (las escriben scripts
o Google: **no se tocan a mano**), y `_REVISAR`. Cuál es cuál no se escribe
acá: vive en `.claude/estructura-drive.json`, que es la fuente.

```powershell
.\verificar-drive.ps1              # las tres reglas, contra Drive. ~5 s
.\verificar-drive.ps1 -Rapido      # solo la raiz, sin pedir permisos. ~2 s
.\probar-verificar-drive.ps1       # rompe las cinco y exige ver el rojo
```

**Lo que lo hizo falta.** El 22/09 se midió que los **dos `.docx` de los
informes del grupo** —los que llevan los mails de Santiago y Valentina en la
carátula— estaban con `anyone:reader`, o sea **públicos por link**, viviendo en
una carpeta privada. El 15/09 se los había mudado afuera de la carpeta pública
y este archivo lo registró como hecho: *«las del grupo se mudaron afuera»*.
Era cierto, y aun así estuvieron públicos **25 días**.

**Mudar un archivo no lo despublica: el permiso viaja con el objeto.** Se
verificó la **precondición** —dónde está el archivo— en lugar del **efecto**
—qué permiso tiene. Es la regla 3 del perfil, del lado que no duele: nadie
revisa un cambio que ya salió bien.

Por eso `verificar-drive.ps1` mide permisos y no rutas, y por eso su regla
dura no admite lista de perdón: **nada con `anyone` fuera de la carpeta
pública declarada**. Si algo tiene que ser público, se **mueve adentro**; no se
declara una excepción afuera. Lo compartido con personas concretas no es rojo
—compartir no es publicar— pero se declara en el JSON con su motivo, y lo que
aparezca sin declarar sale en amarillo, que es la misma forma que
`apuntes-publicos.json` y `datos-permitidos.json`.

**Y no se solapa con el publicador.** `publicar-apuntes.ps1 -Verificar` mira el
**repo** y contesta si lo que está acá llegó a Drive; por eso no podía ver esos
dos informes, que no están declarados en ningún lado. *Un verificador sólo ve
donde vive* — es el mismo agujero que taparon los bloques 5, 6 y 7 de
`verificar-estructura.ps1`, ahora del lado de Drive.

De paso, la raíz tenía **13 archivos sueltos** (DNI, partida, analítico, DDJJ)
y `SOLO FRAN - no se comparte con nadie/` estaba **vacía**: el contenedor
privado se había creado y nunca se había usado. Nada se borró para ordenar —
lo que no tenía dueño claro está en `_REVISAR`, que se puede auditar.

---

## Dónde está el resto

- **Cómo se trabaja** (evidencia, modelo, esfuerzo, cierre de sesión):
  `perfil-global/` — repo propio, se instala con `perfil-global\install.ps1`.
- **El inventario completo del sistema**, con el porqué de cada decisión de
  estructura: [`MAPA.md`](MAPA.md). Se lee una vez, no cada sesión.
- **Máquina nueva** (la PC, o cualquier otra): [`MAQUINA-NUEVA.md`](MAQUINA-NUEVA.md)
  — qué viaja, qué no, y por qué las dos máquinas comparten un solo `main`.
  El comando sigue siendo `.\bootstrap.ps1`: mide dependencias, clona el
  perfil, lo instala, lo verifica, corre `verificar-estructura.ps1` e instala
  y **sabotea** los frenos.
- **¿Este árbol quedó atrasado respecto de la otra máquina?**:
  `.\verificar-sincronia.ps1`, y para probar que ese chequeo no está ciego:
  `.\probar-sincronia.ps1`.
- **¿Qué leo para entrar a un proyecto?**: `.\cascada.ps1 <proyecto>` — el
  flujo de los seis niveles, con rutas exactas y medido contra el disco.
- **¿La estructura sigue sana?**: `.\verificar-estructura.ps1`. Y para probar
  que ese chequeo no está ciego: `.\probar-verificador.ps1`.
- **¿El fan-out no se decide solo?**: es el guardia de nivel 4 del perfil
  (`perfil-global/hooks/guardia-fanout.ps1`), que intercepta `Workflow` y
  `Agent` y **pregunta**. Para probar que no está ciego:
  `perfil-global\probar-guardia-fanout.ps1`.
- **Proyecto nuevo** (o adoptar uno que nació suelto en el Escritorio):
  `.\nuevo-proyecto.ps1 <nombre> -Naturaleza <nat> [-Desde <ruta>] [-Sensible]`.
- **¿Las lecciones llegan a alguna sesión?**:
  `python perfil-global\herramientas\aprender.py sin-triage`, y para probar que
  ese chequeo tampoco está ciego: `perfil-global\probar-chequeo-lecciones.ps1`.
- **¿El Drive de los compañeros está al día?**: `.\publicar-apuntes.ps1
  -Verificar`, y para probar que ese chequeo no está ciego:
  `.\probar-publicacion.ps1`.
- **¿Quedó algo público por link que no tendría que estarlo?**:
  `.\verificar-drive.ps1` — mide el permiso del objeto, no la carpeta donde
  está. Para probar que no está ciego: `.\probar-verificar-drive.ps1`.
- **Las ramas viejas** y qué quedó en cada una: [`archivo/RAMAS.md`](archivo/RAMAS.md).
