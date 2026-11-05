# Retome para la nube: el apunte de Teoría de Circuitos para el parcial

Escrito el 2026-11-05 por la sesión local. Fran no está mirando: avanzá todo lo posible y registrá todo. No frenes a
preguntarle: lo técnico se decide, y lo que es de su gusto o de su valor va a «decisiones para Fran» del informe, con la
opción más conservadora aplicada mientras tanto.

## 0. El libro primero

```bash
bash .claude/nube/traer-perfil.sh
```

Si da rojo, hacé lo que dice (`add_repo` de `fransalomone21/perfil-global`) y volvé a correrlo. Leé enteros, con Read, los
archivos que lista. Después, los dos repos privados (`add_repo` con push, y):

```bash
python3 .claude/nube/estado-nube.py --traer teoria-circuitos
python3 .claude/nube/estado-nube.py --traer catedras
```

## 1. Alistar la máquina y medir, antes de tocar nada

```bash
curl -fsSL https://github.com/typst/typst/releases/download/v0.15.1/typst-x86_64-unknown-linux-musl.tar.xz | tar -xJ -C /tmp
sudo cp /tmp/typst-x86_64-unknown-linux-musl/typst /usr/local/bin/ || cp /tmp/typst-x86_64-unknown-linux-musl/typst ~/.local/bin/
typst --version                 # tiene que decir 0.15.1
pip install pymupdf matplotlib scipy python-docx
cd proyectos/documentos/electronica-analogica/apunte
typst compile --ignore-system-fonts --creation-timestamp=1767225600 apunte.typ /tmp/ea.pdf
typst compile --ignore-system-fonts --creation-timestamp=1767225600 --input materia=tdc apunte-tdc.typ /tmp/tdc.pdf
md5sum /tmp/ea.pdf /tmp/tdc.pdf
```

**El efecto que se tiene que ver**, con los fuentes del commit `7aca8b3` (si `git log` dice que cambiaron, el control ya
no aplica y lo decís):

| PDF | Páginas | MD5 medido en la PC, con los mismos parámetros |
|---|---|---|
| `ea.pdf` | 157 | `19046a0240b3d4e66121fcfb0e0a37cc` |
| `tdc.pdf` | 103 | `5da7b6a60732b11b80dfff9fd12761a3` |

- MD5 igual: paridad total, seguí.
- MD5 distinto y mismas páginas y mismo texto (compará con PyMuPDF): anotá la diferencia en el informe y seguí.
- Páginas distintas, Typst que no baja, o paquetes que no aparecen: **frená el contenido**, escribí el informe con lo
  medido, registrá el defecto con `defectos.py` y pusheá. Sin ese control no se escribe: es justo lo que Fran quiere
  evitar. (Los paquetes los deja `traer-perfil.sh` en `~/.cache/typst/packages`, sin red.)
- Control de los frenos, una vez: un archivo con `$ i_s(t) = 3 $` compilado con `typst compile` por Bash tiene que negarlo
  el guardia de Typst. Si no lo niega, va al informe como defecto, urgencia alta.

## 2. Entrar, en este orden

```bash
bash .claude/cascada.sh electronica-analogica -Necesidad materia
bash .claude/cascada.sh teoria-circuitos -Necesidad materia
```

Leé con Read lo que exija la puerta, sin recortar. Se entra a la **fase 3 de `electronica-analogica`**, «los temas que
faltan del programa». La cierra lo que dice su `PDP.md` §4: cada tema escrito, con al menos un ejercicio resuelto y
comprobado por un segundo camino, `python3 verificar.py` y `verificar-cobertura.py` en verde, y las páginas nuevas miradas
en render. El nombre NASA y su criollo los da el hook de la fase; si el PDP no declara el tipo, declaralo y anotalo.
No leas otros proyectos ni el ESTADO entero de `fisica-espacial`.

## 3. El trabajo: de lo que más pesa en el parcial a lo que menos

Primero leé `teoria-circuitos/guia-parcial/` y sus 17 problemas: eso dice qué entra en el parcial de Sanca y fija el orden.
De esa lista, y de `proyectos/documentos/carrera/MATERIAS.md`:

1. Laplace y respuesta temporal.
2. Forma zpk, polos y ceros en el plano $s$, la relación con ζ y Q.
3. Respuesta en frecuencia del RLC serie según de dónde se tome la salida.
4. Filtros activos: Butterworth de orden N, Sallen-Key, ganancia unitaria, diseño por plantillas.
5. Amplificador diferencial y de instrumentación.
6. Sistemas trifásicos: estrella y triángulo, fase y línea, potencias.
7. Impedancia reflejada del transformador, equivalentes serie y paralelo.
8. Señales en frecuencia (Fourier), si la guía del parcial lo pide.

Terminado eso, sin frenar: la pasada de voz y humor de la casa sobre los módulos 7 a 15, que Fran dejó pedida y está
pendiente en el HANDOFF del proyecto.

**Fuentes:** `teoria-circuitos/fuentes-nube/` tiene el Nilsson (escaneo sin texto: se renderiza la página con PyMuPDF y se
mira) y las clases, igual que la PC. `teoria-circuitos/guia-parcial/` es pública y sirve de semilla. La guía de la exposición
del grupo es privada: se usa para entender, y su texto **no** entra al apunte público hasta que Fran lo decida (va a
«decisiones para Fran»). Leé `teoria-circuitos/CRITERIO-CATEDRA.md` antes de escribir.

**Cómo se escribe** (lo que no es del contrato del proyecto lo pidió Fran para todo apunte):

- Mismo fuente, dos PDF: los módulos 7 a 15 salen en los dos; lo que es sólo de la escuela va en `#solo-ea[...]`. Compilá y
  mirá **los dos**.
- Voz de la casa: buen profesor, completo, en criollo, humor integrado en la prosa y nunca anunciado, con cosas reales de
  Fran y sin cargar a sus profesores (`feedback_humor-en-todo`, `feedback_voz-de-fran`).
- **Ningún símbolo en el aire**: cada letra se presenta en palabras donde aparece primero, con de dónde sale, por qué y qué
  representa conceptual y matemáticamente. Muchos dibujos explicativos.
- Figura con semiconductor u operacional: recorte de píxel (regla 2 del contrato). Curvas cuantitativas: matplotlib a SVG
  con `svg.fonttype: "path"`. Consigna y figura en la misma página.
- La fuente se nombra donde se usa; una cita de página se mira en la página.

## 4. Registrar todo, mientras se trabaja y no al final

**Al arrancar** creá `.claude/nube/regreso/2026-11-05-electronica.md`, que empieza con el renglón `estado: pendiente`, y
actualizalo en cada tema. Lleva: temas (sí o no, con su segundo camino), commits por repo, hallazgos con su [VD n/10],
lecciones y defectos registrados, memoria pendiente, decisiones para Fran, lo que no se pudo y por qué, y el resultado del
control de paridad.

**Commit y push por tema**, a `main` (`master` en `teoria-circuitos`); si el entorno obliga a una rama `claude/*`, ahí, que
la PC la mira. `ESTADO_ACTUAL.md` y `HANDOFF.md` del proyecto al día en cada uno, porque lo que sobrevive a un corte es lo
que está en el remoto. Nunca `--force` ni reescribir historia.

- Lecciones: `python3 ~/.claude/herramientas/aprender.py agregar ...`, en `/home/user/perfil-global`, con commit y push.
- **Errores de arquitectura, siempre y con urgencia**: `defectos.py agregar ... --urgencia critica|alta|media|baja --urgencia-por "..."`,
  después `vista`, y ubicado en `arquitectura/ORDEN-DE-ATAQUE.md`, con commit y push. Toda diferencia entre esta sesión y la
  PC es un defecto.
- Lo que aprendas de Fran **no** va a `perfil-global/memoria/` (la PC lo pisa, DA-101): va a un `.md` nuevo en
  `perfil-global/memoria-nube/`, con el formato de memoria. No corras `--sincronizar-memoria`.
- Lo que un profesor pidió: al `REGISTRO.md` de `catedras`.

## 5. Lo que acá no se hace, y queda para la PC

No se publica a Drive ni se toca Drive. **No se commitean `apunte.pdf` ni `apunte-tdc.pdf`**: compilá a `/tmp` para mirar, y
la PC los regenera con sus fuentes. No se tocan otros proyectos, ni `.claude/nube/en-la-nube.json`, ni los 10 archivos que la PC
dejó sin commitear (SVG de física y BLACK, de otras sesiones). Nada de subagentes para escribir contenido, ni Fable.

## 6. Modelo, y estado de la máquina

Sonnet 5.5, esfuerzo alto, un solo hilo: es un plan decidido, con la cuenta de Fran contada. Sólo si una deducción no cierra
después de dos caminos, Opus para ese tramo. Se declara en la línea Motor del cuadro, que va en cada respuesta.

La máquina arranca limpia: al cerrarse se pierde lo que no esté pusheado, incluida la memoria de la sesión. No hay
PowerShell ni rclone: `compilar.bat` no corre y se usan los comandos de arriba, con
`python3 ~/.claude/herramientas/lint-typst.py <entrada.typ>` antes de cada compilación.

## 7. Al cerrar

Pasá el informe a su versión final, dejándolo en `estado: pendiente`, que la PC lo marca `procesado`. Después:

```bash
python3 auditar-sesion.py --de-fran "ninguno | sesion en la nube sin Fran" --escribir \
  --procedimiento "control de paridad | que la nube compile igual que la PC | <resultado>" \
  --uso "<archivos> | <para que decision>"
```

Commit y push del informe y de la auditoría, en todos los repos tocados. Primer comando de todo esto:
`bash .claude/nube/traer-perfil.sh`.

## 8. Al volver a la PC (lo hace la próxima sesión local, no esta)

La marca `.claude/nube/en-la-nube.json` hace que el arranque lo avise solo. Entonces, antes de cualquier tarea:

1. `python .claude\nube\regreso.py --traer`: baja los repos, integra las ramas de la nube y pasa la memoria.
2. Leer el informe y procesar lo que traiga: decisiones a Fran, memoria al índice, `--sincronizar-memoria`, lecciones y
   defectos revisados, y `estado: procesado`.
3. `perfil-global\install.ps1`, regenerar los dos PDF (lo dice `--medir`), mirarlos y `publicar-apuntes.ps1`.
4. `python .claude\nube\regreso.py --cerrar`: saca la marca **sólo si mide 0 divergencias**. Commit y push.
