# HANDOFF — reforma de la arquitectura con ingeniería de sistemas

> **2026-10-02 (nube real) — T7: la puerta medida en la nube, las cinco en verde; R2 cerrado.** Detalle y evidencia citada en [docs/t7-paridad-nube.md](docs/t7-paridad-nube.md) §4 quinquies, «Medido en la nube real». **(1)** sin PowerShell (rc 1), con `python` y `python3` (3.11.15); `CLAUDE_PROJECT_DIR` está **vacía en el shell del tool Bash** pero puesta en el de los hooks (tres scripts emitieron su propio texto con rutas `$CLAUDE_PROJECT_DIR/...`): el `echo` del retome medía el actor equivocado. **(2)** el ROJO de `traer-perfil.sh` llegó al contexto al abrir; `add_repo` + clone y dio `[OK]`. **(3)** la puerta negó el Edit sin declarar y nombró `bash .claude/cascada.sh` (también frenó un `grep` por Bash). **(4)** `cascada.sh arquitectura-se -Necesidad metodo` listó 6 rangos (46 K caracteres), leídos, y el mismo Edit pasó. **(5)** `fase_activa` inyectó la compuerta (Phase D) en el primer Read del proyecto. Nada construido, nada emparchado. **Observaciones, no rojos:** el retome pedía leer dos tramos y la puerta exigió 46 K (la observación (2) de T11, ahora en la nube); el Bash de sólo lectura también se frena; un Read previo a declarar cuenta (`probable`). **Sigue en T7:** §5, puntos 1-2 (el perfil ya no necesita copia, §4 quater), y decidir el exigido inexistente que deja pasar (fila del hallazgo). **Queda de antes:** software-de-vuelo (otra sesión, `materia`).

> **2026-10-02 (PC, 2.ª de retome) — T7 punto 4 HECHO: la puerta anda en la nube.** Detalle en [docs/t7-paridad-nube.md](docs/t7-paridad-nube.md) §4 quinquies. **(1)** `.claude/cascada.sh` (envoltorio de `--exige` con `-Necesidad`/`-Excepcion`, `python` o `python3`); la puerta lo reconoce y su deny nombra el comando de esa máquina; autotest +3 casos, 2 MAL con el reconocimiento viejo; probado en WSL con sólo `python3`. **(2)** `settings.json`: la puerta **sin gate** en sus tres entradas, con respaldo `python3` y rc 2 si no hay intérprete; `probar-settings.py` casos 6 reescritos (3 FAIL con el viejo, verde con el nuevo); en la sesión viva la puerta siguió frenando. **(3)** `fase_activa` en Linux **sí habla** con rutas POSIX: hipótesis refutada. Su autotest estaba rojo en los dos sistemas (esperaba BLACK en Fase B) y nadie lo corría: caso sintético + estructura sobre el real, y enganchado en `chequeo-completo` (entero en verde: 10 medidores, 17 saboteadores). Lecciones 326 y 327 (foldeadas, perfil instalado). **Hallazgo sin arreglar (fase D):** un archivo exigido que no existe hace que la puerta pase en silencio (en la nube sin perfil, `typst`); decisión de diseño anotada en el doc. **Ruido conocido:** dos renglones `prueba` de arquitectura-se en `~/.claude/hooks/cascada-excepciones.log` (19:04, sesión `a0bb32c6`) son una prueba a mano, no excepciones reales (lección 327); y cada excepción se anota dos veces (Pre y Post), `probable` desde antes. **Queda:** (4) para Fran, una sesión real en la nube con `perfil-global` agregado; (5) software-de-vuelo, otra sesión (`materia`). Los autotests de `black/herramientas/` (`v4_registro`, `censo_ab`, `parpadeo_escala`) tampoco están en ninguna suite general: mirarlo en una sesión de BLACK.

> **2026-10-02 (PC, retome con el libro nuevo) — T7: R3 medido, `settings.json` trackeado, el libro se trae solo.** Cuatro de los seis puntos del retome hechos, cada uno con su saboteador visto en rojo (detalle en [docs/t7-paridad-nube.md](docs/t7-paridad-nube.md) §4 quinquies): **(1)** `PYTHONUTF8=1` vive en `bootstrap.ps1` (paso 0 bis, medido por efecto) y `MAQUINA-NUEVA.md`; **(2)** R3 **confirmado**: el harness de Windows corre los hooks por Git Bash y expande `$CLAUDE_PROJECT_DIR`; `.claude/settings.json` pasó a trackeado con esa variable (opción a), gate por capacidad (`command -v powershell`), y la puerta siguió frenando en la sesión viva; saboteador nuevo `.claude/probar-settings.py` (16 casos) dentro de `probar-hooks.ps1` (53 en verde); **(3)** en la nube `SessionStart` corre `traer-perfil.sh` solo (probado simulando la nube; en la nube real, `hipótesis`); **(4)** `nuevo-proyecto.ps1` escribe la fila de `cascada.json` (`probar-nuevo-proyecto.ps1`, 11 casos, 11/11 rojos con la versión vieja, en `chequeo-completo`). `claude -p` no sirve para probar hooks desde la app (no hereda el login): lección 325, `fuera`. **Quedan:** (5) software-de-vuelo (otra sesión, necesidad `materia`; lo de la placa lo hace Fran); (6) la App de GitHub: **cerrado**, Fran la miró: «Todos los repositorios», ya ve los repos privados (con `gh` da 403, no se puede medir desde la sesión). **Sigue en la T7:** `cascada.sh` (§3 punto 4) para sacarle el gate a la puerta en la nube, y una sesión real en la nube que mida las tres `hipótesis` del §4 quinquies.

> **2026-10-02 (cierre de la tanda en la nube) — `cierre-desde-la-nube.ps1` corrido ENTERO en la PC, todo en verde** (pasos 0 a 6: `PYTHONUTF8=1` fijado, estructura, `perfil-global` al día, 6 repos privados, saboteadores en Windows, publicación por MD5, `_Min_Stack_Size` medido). **Lo que queda de la T7, en orden:** (1) en la PC, `perfil-global\install.ps1` para que la regla 16 y el núcleo nuevo lleguen a `~/.claude` local (el pull no los instala); (2) sumar `PYTHONUTF8=1` a `bootstrap.ps1` / `MAQUINA-NUEVA.md`, que es su dueño (hoy sólo lo fija el script de cierre); (3) R3 en Windows y la opción (a) del §4 bis: `settings.json` trackeado con `$CLAUDE_PROJECT_DIR`, para que los hooks corran en la nube; (4) que la sesión de la nube corra `traer-perfil.sh` sola (hoy depende de leer el aviso del `CLAUDE.md`).

> **2026-10-02 (nube, 7.ª) — REGLA 16, EL LIBRO PRIMERO (la lección que Fran llamó la más importante).** Esta sesión trabajó toda la tanda **sin el perfil**: el retome decía «no existe en la nube, no pelear» y nadie lo midió; `perfil-global` se suma con `add_repo` en un minuto. Seis de sus errores ya eran lecciones del núcleo. Arreglo en tres capas: **(1)** el `CLAUDE.md` de `claude-acceso` (lo único que llega solo a cualquier clon) abre con el bloque «EL LIBRO PRIMERO»; **(2)** `.claude/nube/traer-perfil.sh` lo trae, lo instala en `~/.claude`, mide el efecto y lista qué leer; sin perfil da rojo y dice cómo (saboteador `--probar`: TODO BIEN, 3 casos); **(3)** en `perfil-global` (`a03a500`): regla 16, paso 0 del retome, primera sección del núcleo, 7 viñetas foldeadas, y 8 lecciones con su nivel (324 en total). Además, regla 15 aplicada a lo que había quedado emparchado: encabezados de `template.c` leídos de la fuente por el verificador (saboteador nuevo, 9 casos), y `PYTHONUTF8=1` como paso 0 del cierre para toda la clase del encoding. **Para la T7:** R1 queda cubierto *sin copia generada* (el perfil se trae del repo con `add_repo`, así que no hay copia que envejezca, y R4 deja de hacer falta para el perfil); lo que sigue faltando en la nube son los **hooks** (la puerta, `fase_activa`), §4 bis punto 1.

> **2026-10-02 (nube, 6.ª) — `cierre-desde-la-nube.ps1` corrido en la PC: pasos 1, 2 y 3 en verde** (los 5 repos propios que faltaban, creados **privados** en GitHub; verificador del apunte 49 en verde en WSL). **Frenó en el 4:** `probar-verificar-ejemplos.py` reventaba en Windows porque el subproceso escribía en cp1252 (las comillas `‘ ’` de gcc como `0x91`) y se leía como UTF-8. Arreglado (`PYTHONIOENCODING=utf-8` al hijo, `errors="replace"`) y probado reproduciendo el fallo con `PYTHONIOENCODING=cp1252`: antes revienta, ahora TODO BIEN. `claude-acceso` queda **público** (decidido). `MAPA.md` §2 al día. **Lección para `aprender.py`**: *un script que lee la salida de otro Python fija el encoding de los dos lados.* Síntoma: TODO BIEN en Linux, `UnicodeDecodeError 0x91` en Windows, en el mismo commit. Regla: `PYTHONIOENCODING=utf-8` en el `env` del hijo, y probar el saboteador con `PYTHONIOENCODING=cp1252` antes de darlo por portable. Opuesto: suponer que «anda en la nube» quiere decir «anda en la PC».

> **2026-10-02 (nube, 5.ª) — corrido en la PC: pasos 1 y 2 en verde (regla 8 ya en verde), frenó en el 3** por `catedras/fisica-espacial/iluminacion-final.pdf`. Fran decidió: todo lo privado a GitHub privado (T7 §4). El paso 3 ahora crea **privados todos** los repos propios sin remote, instala `gh` si falta, y frena sólo si un remote es público o hay un archivo de más de 95 MB. **Probado en Linux** con pwsh 7.4, `gh` simulado y remotos locales: crea y sube el que no tiene remote, `pull`/`push` del que tiene, y con un remote PUBLIC frena antes de cualquier push. Sin probar todavía: `winget` y `gh auth login` reales (sólo existen en Windows).

> **2026-10-02 (nube, 4.ª) — `herramientas/cierre-desde-la-nube.ps1`: lo que vuelve de la nube a la PC, en un comando.** Pull + `verificar-estructura`, commit/pull/push de `perfil-global`, crea `catedras` privado en GitHub con `gh` (se frena si hay PDF/PPT/ZIP trackeados), verificador y saboteadores del apunte de C, `publicar-apuntes` y `-Verificar`, y mide `_Min_Stack_Size` en los `.ld` del workspace de STM32. Se frena en el primer rojo; log en `%TEMP%\cierre-desde-la-nube.log`. **Sin correr en Windows todavía**: sólo se verificó que parsea (pwsh 7.4 en Linux). `ErrorActionPreference` en `Continue` a propósito (PS 5.1 convierte el stderr de git en error). Es el embrión del R6 de la T7 al revés; no toca nada vivo (regla 4).

> **2026-10-02 (nube, 3.ª) — regla 8 en rojo, arreglada.** Este HANDOFF tenía un BEL (0x07) desde el commit `d2b090b`: «`C:\`… `aprender.py`» pasó por una capa que interpretó `\a` como escape, y quedó «prender.py» con un carácter invisible delante; en el mismo renglón se había perdido `$CLAUDE_PROJECT_DIR` (quedaba «expanden \ (si no…»). `verificar-estructura.ps1` lo vio (regla 8) en la PC. Barrido de todo lo trackeado: el único otro caso es el `.txt` ya declarado en `controles-permitidos.json`. **Lección para `aprender.py`** (la registra la PC): *texto con barras invertidas se escribe sin capa de escapes.* Síntoma: «prender.py» y un FAIL de regla 8 en un HANDOFF recién escrito. Regla: lo que lleva `\` (rutas de Windows, regex) se escribe con la herramienta de archivos o con un *heredoc* entre comillas (`<<'EOF'`), nunca dentro de un string que el shell o Python interpretan. Opuesto: pasar rutas `C:\...` por `echo`, `-c "..."` o un string normal de Python.

> **2026-10-02 (nube, 2.ª sesión) — T7 con evidencia nueva y las dos decisiones de Fran.** La causa raíz de que no corran hooks en la nube es que `.claude/settings.json` **no está en el clon** (gitignored, lo genera `instalar-hooks.ps1`): el punto 3 del diseño no alcanza tal cual. Fran dijo **sí** a las dos preguntas del §4 (método público sin lecciones; criterios de Leandro en resumen público, ya hecho a mano). Todo en [docs/t7-paridad-nube.md](docs/t7-paridad-nube.md) §1, §4 y §4 bis. Sigue sin construirse nada: R3 primero, en la PC.

> **2026-10-02 (noche, plan al 97 %) — T7 ADELANTADA: paridad nube/local.** Fran pidió un método general para pasar a la nube sin pensar el «cómo». Medido: en la nube no corre ningún hook (rutas C:\), el perfil es repo privado, aprender.py no está. Diseño y requisitos R1-R7 en [docs/t7-paridad-nube.md](docs/t7-paridad-nube.md); **nada construido todavía**. Primero R3: probar en Windows que los hooks expanden `$CLAUDE_PROJECT_DIR` (si no, la puerta local falla abierta). Rojo abierto: carrera sin entrada en .claude/cascada.json.

> **2026-10-02 (tarde) — VALIDACIÓN 5 DE 5 de T11/T12: la sesión de BLACK (114)**, `eb1dd110` (caliente, con Fran
> jugando; cerró la Fase B de BLACK y abrió la C). **CIERRA la validación de T11 y T12.**
> **T11** (`medir-cascada.py`): las **dos** filas de esta sesión cumplen (BLACK y el cierre en arquitectura-se, que
> declaró `metodo` y leyó los seis rangos). La puerta frenó 3 veces, las tres legítimas: el concepto `pcsx2` (una
> memoria), **un rango de `chequeo-de-trabajo.md` que se corrió de línea** porque la misma sesión agregó una lección y
> corrió `install.ps1` (la puerta pidió releerlo: anda como debe, el rango sigue al archivo), y la necesidad sin
> declarar en arquitectura-se. Período: **7 de 9, «NO cumple (2 sin leer)»**, las mismas dos filas de cierre de (111)
> y (112). **Balance de las cinco validaciones:** las filas de PROYECTO (BLACK) cumplieron **5 de 5**; las de CIERRE
> en arquitectura-se, **3 de 5** (las dos que no, de antes de que el retome pidiera leer). Contra la línea de base
> (1 de 113), T11 **funciona** para lo que fue hecho: entrar a un proyecto leyendo lo que hace falta. Lo que la
> validación deja para decidir: (1) `-Necesidad ninguna` sigue imprimiendo «NECESIDAD SIN DECLARAR» (**2 de 2**,
> `probable`: `ninguna` no registra; con `metodo` sí); (2) el cierre de una validación cuesta ~36 K caracteres de
> lectura para anotar un párrafo: conviene una necesidad liviana para «anotar en HANDOFF» en vez de que la sesión
> declare `metodo`.
> **T12** (`medir-costo.py --ultimas 3`): esta sesión **ses.met 78 070**, cuadro/turno 1111, al-paso 8143, **nested 0**;
> mediana de las tres 78 070 contra **131 889** antes de T12: la baja de −41 % **se sostiene en sesiones reales**. La
> entrada de ésta (200 203) suma dos declaraciones de BLACK (la segunda por el rango corrido) y la de cierre.
> **Sigue:** T2 (un dueño por dato) del camino crítico; y decidir (1) y (2) de arriba en T11.

> **2026-10-02 (mediodía) — VALIDACIÓN 4 DE 5 de T11/T12: la sesión de BLACK (113)**, `f885a69f` (caliente, pantalla
> libre; V1–V3 confirmadas con control). **T11** (`medir-cascada.py`): las **dos** filas de esta sesión cumplen —BLACK
> y también arquitectura-se: esta vez el cierre declaró `metodo` y leyó los seis rangos (~35 K caracteres) antes de
> anotar acá—; la puerta frenó una vez en cada proyecto (BLACK por `abrir-sesion.ps1` y por el concepto `pcsx2`;
> arquitectura-se por la necesidad sin declarar). El período da **5 de 7, «NO cumple (2 sin leer)»**: las dos son las
> filas de cierre de (111) y (112), que no se pueden arreglar después. **Observación para T11:** cumplir el ritual de
> cierre cuesta ~10 K tokens para anotar un párrafo — el protocolo de validación pide más lectura que la tarea; si se
> quiere que el cierre cuente, conviene una necesidad liviana (p. ej. `ninguna` que exija sólo HANDOFF), no saltearlo.
> Y `-Necesidad ninguna` desde PowerShell imprimió «NECESIDAD SIN DECLARAR» (`hipótesis`: `ninguna` no registra como
> declaración en este camino; con `metodo` sí). **T12** (`medir-costo.py --ultimas 3`): esta sesión todavía no sale en
> el listado (salen `18728731`, `a97df594`, `ba7b0eec`; mediana ses.met 78 813, entrada 128 457, al-paso 8795,
> nested 7204). Falta: la validación 5 (el retome de BLACK la pide).

> **2026-10-02 (mañana) — VALIDACIÓN 3 DE 5 de T11/T12: la sesión de BLACK (112)**, `18728731` (frío + una sonda en
> vivo; cortada una vez por el límite de uso y retomada en el mismo chat). **T11** (`medir-cascada.py`): la fila de
> BLACK leyó las cuatro piezas antes de actuar y declaró la necesidad (sí); la puerta frenó una vez por concepto
> (`pcsx2`) y se leyó lo pedido. El total del período da **3 de 5, «NO cumple (2 sin leer)»**, y los dos «sin leer»
> son las filas de **arquitectura-se** de (111) y (112): el ritual de cierre de la validación (anotar acá sin leer
> el proyecto, como pide el retome). **Observación para T11:** el medidor cuenta ese cierre como incumplimiento — el
> protocolo de validación choca con su propio medidor; y dio «excepciones usadas: 0» con una `-Excepcion` corrida
> antes de medir (`hipótesis`: no la cuenta, o la cuenta por otra fuente). **T12** (`medir-costo.py --ultimas 3`):
> esta sesión todavía no aparece en el listado (salen `a97df594` y `ba7b0eec`; mediana ses.met 78 813, entrada
> 128 457, al-paso 8795); la entrada que exigió la puerta acá fue ~128 K caracteres. Falta: validaciones 4 y 5 (el
> retome de BLACK pide la 4).

> **2026-10-02 (madrugada del 3) — VALIDACIÓN 2 DE 5 de T11/T12: la sesión de BLACK (111)**, `a97df594`, de
> noche y sin Fran. **T11** (`medir-cascada.py`): leyó las cuatro piezas antes de actuar y declaró la necesidad,
> **2 de 2** sesiones del período → **100 %, cumple**; la puerta frenó una vez por concepto (`pcsx2`, una memoria) y se
> leyó lo que pedía; 1 excepción usada, registrada, para anotar esto sin leer el proyecto. **T12**
> (`medir-costo.py --ultimas 3`): esta sesión ses.met **77 901** (mediana de las 3: 124 829), cuadro/turno 1079,
> entrada 110 868, al-paso 16 339, **nested 0** (se leyó y editó en `perfil-global/`: cumple). Observación: al-paso
> es el más alto de las tres (16 339 contra 8795 de mediana) por una sesión larga con muchas herramientas distintas.
> Falta: validaciones 3 a 5 (el retome de BLACK ya pide la 3).

> **2026-10-02 (noche) — LO ÚLTIMO. T12 CONSTRUIDA y T11b cerrado en lo que
> sobrevivió.** Medido con `medir-costo.py --simular`: sesión −41 %, turno
> −68 %, entrada −64 % (`docs/t12-simplificar.md` §9). Fran pidió el cuadro con
> la fase por su nombre NASA y los subtítulos fusionados: ahora es **un solo
> bloque de 14 líneas** (molde y spec en `perfil-global/apertura-proyecto.md`;
> los nombres NASA y su criollo los da `fase_activa`). El enrutador es vista
> corta (la fila ya no copia el estado; `cascada.ps1` sólo vigila por fecha a
> la fila que nombra una fase). La fuente del perfil es
> `perfil-global/CLAUDE-global.md`. `chequeo-completo` entero en verde.
> **Sigue:** BLACK en chat nuevo (`proyectos/ingenieria/black/sesiones/RETOME-LOCAL.md`),
> que es además la sesión 2 de 5 de la validación de T11 y T12; en ella mirar
> con `python proyectos\ingenieria\arquitectura-se\medir-costo.py` que la
> columna *nested* dé 0 al leer en `perfil-global/`. Después de BLACK, T2 (un
> dueño por dato) del camino crítico. **Fran:** apagar los plugins de SEO y
> Adobe en su cuenta de claude.ai.

> **2026-10-02 (tarde, 2.ª) — LO ÚLTIMO. T12 paso 2 escrito: la matriz de
> todo el método** (`docs/t12-simplificar.md` §7: 25 piezas, 5 recortadas con
> su resta, 1 sale, T11b partido en entra/diferida). **Sigue el paso 3, la
> poda, en el orden de §7.5**: (1) catálogo de la puerta, (2) enrutador corto
> —las dos vivas al guardar, sin install—; después (3)-(5) en el perfil, con
> `install.ps1` + `verify-install`. Falta escribir §8 (las dos preguntas a
> Fran: si lee los dos cuadros en una pregunta suelta; si usa los plugins de
> SEO y Adobe). Se cortó por el límite del plan, con todo commiteado.

> **2026-10-02 (tarde) — T12, paso 1 de 5: el costo ANTES está
> medido** (`docs/t12-simplificar.md` §6; instrumento `medir-costo.py`, semilla
> de P10). Lo que cambia el orden de la poda: el **enrutador** (`CLAUDE.md`
> raíz, 54,6 K) es el 43 % del costo fijo; la spec de los cuadros se paga en
> cuatro lugares; leer en `perfil-global/` recarga su `CLAUDE.md` (18 K
> duplicados); `al-paso` reinyecta lo que la puerta ya hizo leer. **Sigue el
> paso 2: la matriz de cumplimiento de TODO el método** (pieza, impacto
> original, costo medido, veredicto), después podar con saboteador. **De
> paso:** la puerta perdía lecturas hechas en paralelo (append de Windows no
> atómico entre procesos): candado del SO en `cascada_puerta.py`, caso nuevo
> (1057/1200 sin candado, 1200/1200 con), autotest 23/23; lección registrada y
> foldeada en `chequeo-de-trabajo.md` del perfil, **sin `install.ps1`
> todavía** (se dejó para después de la renovación del plan, que estaba al
> 88 %: un install cortado a la mitad es lo único que deja la máquina sucia).
> Validación de T11: esta sesión es la 1 de 5 (declaró `metodo,diseno`, leyó
> 17 rangos, la puerta frenó una vez de más por el defecto del append).

> **2026-10-02 (01:05) — LO ÚLTIMO, y REORDENA lo de abajo. Fran aceptó las
> críticas y pidió simplificar.** Le dije que el método crece por acumulación
> (cada falla suma una capa y no se saca nada; hoy, para editar un párrafo,
> hubo que releer ~37 K tokens), que los requisitos absolutos empujan a más
> maquinaria y que el método se come la ventana de 5 h. Respondió: «ingeniá
> vos la simplificación, con los libros; yo aporto intuición; sensatez antes
> que orgullo». **Por eso la próxima sesión NO arranca por T11b** (sumaría
> cuatro piezas más): arranca por **T12, simplificar**, y de T11b entra sólo
> lo que sobreviva a esa poda (candidato firme: el `--nivel` de la regla 15,
> que es barato). Plan de T12 en el mensaje de retome de esta fecha.

> **2026-10-02 (00:40–01:00) — LO ÚLTIMO. Fran respondió y abrió T11b.** Dijo:
> las necesidades son abiertas (si una no encaja, clase nueva o requisitos);
> buscar las herramientas y el respaldo de cada tarea; ser ingeniero aunque la
> tarea sea de albañilería; validar con **más de 3** sesiones (quedó en 5); y
> **regla 15**: un error evitable frena la tarea y se arregla uno o n niveles
> más arriba, no con un parche. **Hecho (escrito y en el catálogo):** clase
> `nueva` (requisitos), campo `herramientas` con respaldo en cada clase (lo
> imprime `cascada.ps1`), reglas 14 ampliada y 15 en el perfil, dos memorias.
> **Falta diseñar e implementar (T11b, la próxima sesión):** (1) que la regla
> 15 tenga freno —`aprender.py agregar --nivel parche|herramienta|regla|flujo|meta`
> obligatorio, `parche` solo rechazado sin `--por-que-no-mas-arriba`, con su
> caso en `probar-chequeo-lecciones.ps1`—; (2) `--verificar` exige que cada
> clase tenga herramientas y una de respaldo; (3) la puerta, ante una
> necesidad desconocida, dice «creá la clase o declarala `nueva`», y
> `medir-cascada` cuenta los `nueva` repetidos (señal de clase que falta);
> (4) **medir** cuántas sesiones actúan fuera de todo proyecto (la puerta no
> las ve) antes de decidir si la «albañilería» necesita puerta propia.

> **2026-10-02 (00:00–00:35) — LO ÚLTIMO. T11 CONSTRUIDA: la puerta de la
> cascada.** Pedido de Fran al cerrar BLACK (110), con prioridad máxima.
> Medido antes (censo, `perfil-global/herramientas/medir-cascada.py --desde
> 2026-09-01`): **1 de ~110** entradas sesión × proyecto leía ESTADO + HANDOFF
> + PDP + contrato antes de su 1.ª acción; BLACK abría 7 de 28. Construido:
> `.claude/cascada.json` (catálogo: base, 7 necesidades, 3 conceptos, 20
> proyectos), `.claude/hooks/cascada_puerta.py` (PreToolUse deny + registro +
> CLI `--exige/--verificar/--autotest`), `cascada.ps1 -Necesidad/-Excepcion`,
> instalado por `.claude\instalar-hooks.ps1`, medidor `--verificar` en la capa
> rápida y `--autotest` (22 casos, con mutante) en los saboteadores;
> `probar-cascada` y `probar-hooks` en verde con la puerta instalada. Diseño:
> [`docs/t11-cascada-obligatoria.md`](docs/t11-cascada-obligatoria.md); A12 en
> el diagnóstico. **Validación 1 de 4, esta sesión** (es de transición: empezó
> antes de la puerta, así que `medir-cascada` no la cuenta): frenó, se declaró
> `metodo,diseno`, se leyeron 16 rangos (~37 K tokens) y pasó; encontró **cuatro
> defectos de frontera real** que el autotest no veía, todos arreglados con
> caso. La salida explícita se usó una vez (nota en el retome de BLACK) y quedó
> en `~/.claude/hooks/cascada-excepciones.log`. **De paso, pedidos de Fran:**
> reglas 13 (al chat lo que cambia, en su idioma; lo técnico al repo) y 14
> (pregunta de marco y preguntarle para aprender) en el perfil global, y tres
> memorias de feedback. **Sigue:** las 3 sesiones reales que validan T11 (la
> primera es BLACK, ya anotado en su `sesiones/RETOME-LOCAL.md`); después, T2.

> **2026-09-29 (00:30–00:50) — LO ÚLTIMO. T1 CERRADA: el paso 6 validó en 3
> sesiones reales limpias.** Contadas desde los saboteadores (28/09 21:42:33),
> como fijó la corrección de abajo: `53e404af`, `e5fa731f` (Escritorio) y
> `b3a19cc1` (ésta); `medir-inyeccion --solo despues` sobre esa ventana = 3
> sesiones, 0 cortados, 0 cancelados; `disparos.log` sin ERROR. **El medidor
> tal cual anclaba en 23:44:41 y daba 2:** esa escritura la hizo **la app** al
> enviarse el primer mensaje de la sesión del Escritorio (al segundo, sin
> herramienta corrida; ningún hook cambió después de 21:43; `probable`). Se
> midió con una copia fechada (`--settings <copia con mtime 21:42:33>`).
> Lección 298 (`fuera`) y `perfil-global/PENDIENTES.md` §11 (anclar por
> contenido, no por mtime). **Validación cerrada, así que se corrió
> `install.ps1`:** PENDIENTES §10 cerrado (líneas de 295 y 296 escritas; núcleo
> 201 reglas; `verify-install` verde). **De paso:** `install.ps1` leía
> `settings.json` sin `-Encoding` y le agregaba una capa de mojibake cada vez
> que la app lo dejaba sin BOM (la raya de `autoMode`, desde las 20:50 del
> 28/09): seis lectores arreglados en cuatro scripts, probado en réplica
> (viejo 1 capa / nuevo limpio), 9 rayas reparadas con `autoMode` igual al
> respaldo limpio, `probar-guardia-fanout` 5/5. Lección 297 (foldeada).
> **Sigue T2 «un dueño por dato»**, con el alcance fijado en `ESTADO_ACTUAL.md`
> (entran las rutas locales a mano y `fuera-del-sistema.txt`; el censo fuera
> del Escritorio y el contenedor que oculta a sus hijos van a P10). T2 es
> diseño: Opus, esfuerzo alto, un hilo. Primer paso: la tabla dato → archivo
> dueño, medida sobre el disco (qué datos se repiten y dónde), no de memoria.
> **Fran pidió que la próxima sesión real de prueba sea la guía de IDEs de
> `software-de-vuelo`** (STM32 con VS Code y Wokwi): sirve de dato para P10.
> **Hecha en esta misma sesión, y ya es dato:**
> [`docs/insumo-2026-09-29-sesion-ides.md`](docs/insumo-2026-09-29-sesion-ides.md)
> — Fran corrigió tres veces en vivo cosas que ya pide en otros proyectos
> (método del profe primero, formato de los apuntes, público ≠ personal) y
> ninguna capa se las trajo a la sesión; el detector de «sin declarar» sólo ve
> `apunte.pdf`; y el núcleo pierde la regla cuando la viñeta abre con un
> anuncio. Entra al alcance de T2/T10 junto con el insumo del Escritorio.

> **CORRECCIÓN 23:35 — la cuenta del paso 6 es 1 de 3–5, no 2.** Los
> saboteadores reescriben `~/.claude/settings.json` (21:42:33) y el medidor
> cuenta desde ese cambio: hoy da «1 sesión posterior». No correr
> `-SoloSaboteadores` durante la validación. Próxima sesión: «2 de 3–5».
>
> **2026-09-28 (noche, 6.ª) — Paso 6 de T1: sesión 2 de 3–5 [ANULADA, ver arriba]
> LIMPIA** (`--solo despues`: 2 sesiones, 0 cortados, 0 cancelados;
> `disparos.log` sin ERROR). No se construyó nada. **ACTUALIZACIÓN 23:31: la
> clave real `rclone` YA disparó en uso real (7 viñetas, archivo de estado de la
> sesión creado); el pendiente de abajo quedó cerrado.** (Antes: ninguna clave real de
> `al-paso` disparó todavía** desde el cambio de settings de las 21:17
> (`al-paso-estado/` sólo tiene el archivo de las 21:11; las líneas de las
> 21:35 son muestras del medidor): en la próxima sesión, usar una clave real
> (`rclone`, un Edit, `typst`) y ver que aparezca su archivo de estado.
> `chequeo-completo -SoloSaboteadores`: **14/14 + 9 medidores de limpieza en
> verde** (el rojo del 28/09 no se reprodujo; el de estructura tardó 257 s).
> Próxima: mismo comando, anotar «3 de 3–5»; si es la 3.ª–5.ª y limpia, cerrar
> el paso 6 y elegir T2 (`docs/diagnostico-2026-09-28.md`, sólo su sección).

> **2026-09-28 (noche, 5.ª) — LO ÚLTIMO. Paso 6 de T1: sesión 1 de 3–5
> LIMPIA** con el hook al paso instalado (`--solo despues`: 1 sesión, 0
> cortados, 0 cancelados; `disparos.log` sin ERROR). No se construyó nada. No
> es la 3.ª–5.ª, así que **T2 no se elige todavía**. Ojo al leer el log: las
> líneas `al-paso` de 21:31:59 son las muestras sintéticas que corre el
> medidor, no disparos reales. Próxima sesión: mismo comando, anotar «2 de
> 3–5»; mirar además que `~/.claude/hooks/al-paso-estado/<session_id>.txt`
> exista si se usó alguna clave real.

> **2026-09-28 (noche, 4.ª) — LO ÚLTIMO. T1 paso 5 CONSTRUIDO: el hook al paso.**
> (0) Validado: la primera sesión con pilares y núcleo partidos dio `--solo
> despues` = 0 cortados y 0 cancelados. (5) `perfil-global/hooks/al-paso.py`
> (PreToolUse, Python; lo registra `install.ps1` desde `Get-Guardias` con los
> campos nuevos `Interprete`/`Decide='contexto'`/`Timeout`; se desinstala
> sacando su entrada de `~/.claude/settings.json`): por clave inyecta las
> viñetas **enteras** de `chequeo-de-trabajo.md` una vez por sesión (estado en
> `~/.claude/hooks/al-paso-estado/<session_id>.txt`). Seis claves que
> discriminan: `freno`, `fanout`, `gui`, `rclone`, `typst`, `pcsx2` (ghidra y gh
> quedan fuera: la sonda no midió si discriminan). 8 441 / 3 799 / 1 532 /
> 5 242 / 7 029 / 7 350, tope 9 000 sobre **stdout** (los escapes del JSON
> cuentan). **`freno` no entra entero** (31 viñetas, salen 16, el pie lo dice);
> entregar el resto en la 2.ª llamada sería cambio de diseño y no se hizo.
> Saboteador `perfil-global/probar-al-paso.ps1` **20/20** (en
> `chequeo-completo`); `medir-inyeccion` corre una muestra por clave;
> `verify-install` mide registro y efecto. **Confirmado en sesión real:** el
> `settings.json` se recargó en caliente y el primer `rclone` trajo sus 7
> viñetas; el segundo, nada; un Edit a `medir-inyeccion.py` disparó `freno`.
> **Sigue el paso 6:** instalar movió `settings.json`, así que la cuenta de
> 3–5 sesiones reales arranca de nuevo con la próxima; en cada una
> `python perfil-global\herramientas\medir-inyeccion.py --solo despues` tiene
> que dar 0 cortados y 0 cancelados. Después, T2 del diagnóstico. Aviso: el
> hook usa `python` del PATH bajo el shell del harness (igual que
> `fase_activa.py`); si una máquina no lo tiene, falla abierto y sólo lo dice
> `~/.claude/hooks/disparos.log`.

> **2026-09-28 (noche, 3.ª) — LO ÚLTIMO. T1 pasos 3 y 4 CONSTRUIDOS; la capa
> rápida entera en VERDE** (9 medidores, primera vez desde que existe el de
> inyección). (0) **Paso 2 validado en su primera sesión real**: `--solo
> despues` sin `hook_cancelled` (1 de 3-5). (3) `pilares.md` en **dos hooks**
> (7 940 + 4 791): lo corta el lanzador `perfil-global/hooks/emitir-contexto.ps1`
> (`archivo parte de`, frontera de sección, empaque a 9 000; si pide más partes
> que hooks, la última se lleva el resto y el medidor da rojo). `install.ps1`
> ahora es dueño de toda entrada que invoca el lanzador y **retira** lo que sale
> del manifiesto. (4) **El núcleo**: `perfil-global/herramientas/nucleo-chequeo.py`
> genera `chequeo-nucleo.md` (la primera oración de cada una de las 200
> viñetas, tope 160; 25 914 caracteres) y va en **cuatro hooks**
> (6 831 / 3 732 / 7 790 / 7 764), no dos: el corte es por momento y «antes de
> confiar en una herramienta» sola ocupa 7 800 (nota de construcción en el doc
> §7). La fuente se sigue instalando en `~/.claude/` para leer la viñeta
> entera. `install.ps1` lo regenera; `verify-install` exige que esté al día;
> saboteador de T1 **14/14**. Las frases «se lee solo» (aprender.py,
> install.ps1, los dos CLAUDE.md, README, skill) corregidas. Los PDF de Física
> Espacial, **subidos** (MD5 al día). **Sigue el paso 5 (hook al paso)** y
> juntar sesiones reales para el 6: `medir-inyeccion.py --solo despues` en
> cada una; la próxima es la **primera con pilares y núcleo partidos**, y
> tiene que dar 0 cortados.
>
> **Antes (2026-09-28, noche, 2.ª) — T1 pasos 1 y 2 CONSTRUIDOS.**
> (1) `perfil-global/herramientas/medir-inyeccion.py` en los medidores de
> `chequeo-completo.ps1`, **en rojo sobre el estado de hoy** (pilares 12 863,
> chequeo 133 973, cortes y cancelaciones en los transcripts) y amarillo en la
> apertura (9 592); saboteador `perfil-global/probar-medir-inyeccion.ps1` 10/10
> y saboteado él mismo. `verify-install` ya no imprime el tamaño. (2) Arranque
> partido: `.claude/hooks/arranque-proyecto.ps1` sólo texto (timeout 15) +
> `.claude/hooks/arranque-medicion.ps1` (capa rápida en paralelo,
> `-FechaLimite 40`, matcher `startup|resume|clear`), instalados en
> `.claude/settings.json`; 41 s de pared contra 56 en serie; `probar-hooks`
> 51 OK. **Sigue el paso 3: pilares en dos hooks** (la fuente sigue siendo un
> archivo; corte en frontera de sección, 2 × ~6 400). El medidor va a pasar
> `pilares` a verde y dejar `chequeo` en rojo hasta el paso 4. **La primera
> sesión nueva ya valida el paso 2**: `python perfil-global\herramientas\
> medir-inyeccion.py --solo despues` tiene que dar 0 `hook_cancelled` para
> `arranque-medicion.ps1`. Corrige a S3: `publicar-apuntes -Verificar` es
> bimodal SOLO (10 o 45 s). Rojo ajeno al arrancar: los PDF de Física Espacial
> recompilados a las 19:32 y sin subir (otra sesión).
>
> **Antes (2026-09-28, noche) — T1 DISEÑADA, sin construir:
> [`docs/t1-presupuesto-inyeccion.md`](docs/t1-presupuesto-inyeccion.md).**
> Umbral del harness **10 000 caracteres por hook** (`confirmado`: constante
> `1e4` en `claude.exe` 2.1.284 + censo de 1 235 salidas). El arranque del repo
> se pierde entero en **13 de 30** sesiones (58 s contra 60 de timeout). Lo que
> sigue es el §7 del doc, **en orden**: (1) `perfil-global/herramientas/
> medir-inyeccion.py` + `probar-medir-inyeccion.ps1`, que tienen que dar
> **rojo sobre el estado de hoy**; (2) arranque partido (texto / medición con
> fecha límite 40 s); (3) pilares en dos hooks; (4) núcleo generado de
> `chequeo` en dos hooks; (5) hook al paso. Nada de eso está hecho. De paso:
> la línea `Fase en curso` del PDP ya dice 7, tipo D, verificado sobre lo que
> inyecta el hook. Dos lecciones nuevas (`propia`), con su línea en
> `chequeo-de-trabajo.md` e instaladas. El doc de T1 ya está en el índice del
> contrato, y el título del ESTADO dice «Fase 7 ABIERTA».
>
> **Antes (2026-09-28, tarde): el diagnóstico medido del método entero está en
> [`docs/diagnostico-2026-09-28.md`](docs/diagnostico-2026-09-28.md)**: once
> problemas (A1–A11) con su evidencia, el N² de quién le entrega qué a quién y
> el camino crítico de la reforma (T1 → T2 → T3 → T4 → T7 → T9, ~9-16
> sesiones a ojo). Lo pidió Fran para dedicar sesiones a reformar y dejarlo
> sostenible. **El primero es A1**: `chequeo-de-trabajo.md` (129 KB) y
> `pilares.md` llegan a la sesión como **2 KB de vista previa**: lo que el
> método dice que «se lee solo» no se lee. Salió de una sesión de BLACK (109),
> no de una sesión de este proyecto; la fase 7 sigue abierta y el diagnóstico
> es su insumo. De paso: la fila 6 del PDP quedó marcada CERRADA (el hook
> inyectaba «fase 6» como activa). **Al cerrar se vio A11 en vivo:** otra
> sesión de Claude trabajaba en `fisica-espacial` en este mismo árbol mientras
> corrían los saboteadores, y su recompilación puso en rojo la limpieza.

Sesión 7 de N. **2026-09-17.** Opus, esfuerzo alto, **inline, sin un solo
subagente** — la sexta fase seguida así. **Cero PDF extraídos.**

## OBJETIVO
Rehacer la arquitectura del método (cascada, PDP, naturalezas, fases) sobre
NASA SE Handbook + INCOSE + Rechtin & Maier. Fran: "mínima ambigüedad
posible", y las necesidades que generaron la arquitectura actual **siguen
valiendo**.

## ESTADO — fase 6 CERRADA, abre la fase 7

La fase 6 cerraba por tres cosas y cerró por las tres, medidas:

```
Chequeo OK. Ningun rojo.     7 medidores + 10 saboteadores + 7 de limpieza
38 filas: 33 cumple, 2 no aplica, 3 recortado   (todas con su resta)
8 PDP: 1 en verde, 0 en rojo, 7 sin migrar
```

**Es la primera fase que tocó archivos vivos**, y el rigor pleno se respetó:
saboteador corrido **antes** de dar por puesta cada pieza, repo commiteado y
pusheado entre piezas.

**Instalado:** P2 (matriz), P3 (rigor por aspecto), P4 (molde de fase), P6
(criterio de entrada) y P7 (System 2/3) en `cumple`; P5 **recortado con la
mitad puesta**; P1 diferido con su resta; P10 es de la fase 7.

**Los tres defectos vivos, cerrados:** D12, D14 y el medidor de desuso.

## LO QUE SE APRENDIÓ, Y CAMBIA CÓMO SE TRABAJA

**1. Un saboteador escrito por el autor del freno hereda su punto ciego, y
esta vez se midió.** El freno de D12 **ya existía** en `install.ps1`, con su
caso de sabotaje, en verde desde el 2026-08-28. El patrón miraba la **primera
línea**; el saboteador rompía el archivo **en la primera línea**; el `186` real
vivía en la **línea 19**. El test probaba que el patrón matchea su propio
ejemplo. **Es el argumento más fuerte para que P8 siga declarada como hueco sin
respuesta** en vez de darse por cubierta con los saboteadores.

**2. La inyección dejó de ser entrega, y hay número.** La lección de los
escapes de C estaba escrita desde el 13/09, con triage `propia`, e **inyectada
en `chequeo-de-trabajo.md` línea 553**. Estuvo en el contexto desde el arranque
y el mismo error corrompió **cinco archivos vivos** en esta sesión —uno de
ellos el .md que se inyecta en cada sesión, y dos datos técnicos de BLACK
medidos contra el ELF—. A **95 KB, 1347 líneas, 154 viñetas**, es exactamente
lo que Rechtin p. 35 llama hojear una ferretería. Eso decidió qué mitad de P5
construir: el guardia que entrega **en el paso**, no la partición del archivo.

**3. Un chequeo que valida un rango tiene que validar las dos puntas.** El de
ASCII miraba `>127` y era ciego a los controles `<32`. La pregunta correcta no
es *qué valores malos conozco* sino *cuál es el conjunto de los legítimos*.

**4. "Nada que medir" y "todo bien" son opuestos, y el segundo crece solo.**
Apareció **dos veces**: en `medir-matriz.py` y en `medir-fase.py`, la segunda
ya con la lección escrita. Verde por vacío es el único verde que **aumenta** a
medida que la disciplina se abandona, porque abandonarla borra justo lo que el
medidor buscaba.

**5. Se reescribieron los requisitos, no el chequeo.** Los 4 VIOLA que
quedaron en español eran defectos reales (`su`, una negación), los mismos que
el chequeo marca en inglés sobre `its` y `not`. Ablandar las listas para que
pasaran habría sido calibrar el medidor contra el resultado buscado.

**6. Un saboteador sin `exit 0` hereda el código del comando que TENÍA que
fallar.** Dos saboteadores sanos reportados en rojo por el orquestador, en
0,9 s — y el tiempo corto hizo pensar que morían al arrancar.

## ENTRADAS A LA FASE 7, YA ESCRITAS

1. **P10, el medidor de validación** — *timely / affordable / predictable /
   comprehensive* (SEH p. 165-166). **Tiene con qué medirse**: el costo por
   fase está registrado fase por fase en `ESTADO_ACTUAL.md`, desde los 2,07 M
   tokens de la fase 0 hasta los ~31 puntos de la 6.
2. **La otra mitad de P5**: partir `chequeo-de-trabajo.md`, que sigue pesando
   95 KB. Criterio ya escrito: lo que se inyecta pesa menos, **y** la lección
   del paso en curso está adentro.
3. **P1, el catálogo derivado**, con su resta ya escrita en la matriz.
4. **Migrar los otros 7 PDP.** `medir-fase.py` cuenta 1 en verde y 7 sin
   migrar; ese número tiene que bajar, y el medidor lo muestra solo.
5. **`ingenieria-de-sistemas.md`** con las 4 correcciones de
   `docs/arquitectura.md` §8, y la pregunta abierta sobre si sigue haciendo
   falta.

## LO QUE SE TOCÓ

Archivos vivos, **todos con su saboteador corrido**: `install.ps1`,
`chequeo-de-trabajo.md`, `herramientas/aprender.py`, `verify-install.ps1`,
`manifiesto.ps1`, `CLAUDE.md` del perfil, `README.md` del perfil,
`verificar-requisito.py` y sus casos, `verificar-estructura.ps1`,
`probar-verificador.ps1`, `probar-chequeo-lecciones.ps1`,
`chequeo-completo.ps1`, `plantillas/PDP.md`, `MAQUINA-NUEVA.md`, el `CLAUDE.md`
de la raíz, y el `PDP.md` y `docs/` de este proyecto. Más BLACK:
`ESTADO_ACTUAL.md` y `sesiones/HANDOFF.md`, por los caracteres de control.

**Nuevos:** `herramientas/medir-matriz.py`, `herramientas/medir-fase.py`,
`hooks/guardia-escapes.ps1`, `probar-medidor-matriz.ps1`,
`probar-medidor-fase.ps1`, `probar-chequeo-ascii.ps1`,
`probar-guardia-escapes.ps1`, `casos/sanos-es.txt`, `casos/rotos-es.txt`,
`.claude/controles-permitidos.json`.

## PRIMER COMANDO DE LA PRÓXIMA SESIÓN

```powershell
.\chequeo-completo.ps1 -SoloMedidores
```

Tiene que dar **7 verdes y ningún rojo**. Si da otra cosa, eso es lo primero
que se mira: la fase 6 cerró con todo en verde, así que un rojo ahí es algo
que pasó **después**.
