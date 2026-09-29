# HANDOFF — Software de Vuelo

## 2026-09-29 (04:50) — TP2 hecho y empaquetado; carpeta del Cohete compartida

**TP2:** `workspace_1.18.1\tp2` completo. PB5 y ADC1 IN0 se agregaron al `.ioc`
y el código se regeneró **sin abrir CubeIDE**, con el motor de CubeMX que trae
adentro (`java -jar ...\com.st.stm32cube.common.mx_*\STM32CubeMX.jar -q
script`, con `config load` + `project generate`). La compilación también fue
sin GUI (`stm32cubeidec.exe ... headlessbuild -cleanBuild tp2/Debug`):
**0 errores, 0 advertencias**. El código va en los bloques USER CODE, con
comentarios cortos en criollo. `diagram.json` verificado **pin por pin** contra
`wokwi-boards/boards/st-nucleo-c031c6/board.json`, con saboteador en rojo: `PB0`
y `3V3` **no existen** en esa placa, son `PB0.1` y `3V3.1`. **Sin simular**: lo
abre Fran. La entrega está en `Desktop\01 - UNSAM\Software de Vuelo\TP2_Salomone.zip`
(proyecto + `.elf` + `diagram.json` + `wokwi.toml`). Hay un respaldo del tp2
anterior en el scratchpad de la sesión.

**Cohete:** la carpeta de Drive está compartida como `writer` con los dos
compañeros, renombrada con los apellidos y declarada por hash en
`.claude/estructura-drive.json` (`verificar-drive` en verde). El análisis
contra los criterios de Petrilli y la predicción de qué no le gustó de la
presentación están en el repo privado:
`catedras/software-de-vuelo/COHETE-ANALISIS.md`.

## 2026-09-29 (03:00) — circuito del TP2 armado; mañana, el código

`tp2\diagram.json` escrito con los dos ejercicios del TP2 (PB0–PB3 contador, PB5
alarma, potenciómetro en PA0, monitor serie en PA2/PA3); JSON válido, **sin
simular todavía**. `3V3` como nombre de pin es `hipótesis`. **El editor visual de
Wokwi en VS Code es pago** (Community: «Upgrade to Edit Diagram»); las dos guías
lo dicen. **Mañana Fran sigue con `Core/Src/main.c`**: el `.ioc` tiene que tener
PB0–PB3 y PB5 en `GPIO_Output` y `ADC1 → IN0`.

## 2026-09-29 (02:40) — el doc del grupo, leído

`Downloads\Sistema cohete de agua.pdf` (9 pág.): **no tiene mails** (0, medido) y
la **sección 7, «Máquina de estados», está vacía**. La nuestra quedó alineada con
sus fases (Tierra, Ascenso, Apogeo, Descenso, Aterrizaje; ≤ 250 m el principal) y
sin las balizas, que el doc no pide. Errores encontrados en el doc, para Fran: el
índice no coincide con el cuerpo; «BPM280» (es BMP280); «6. 2.6.1 Operaciones»
sobrante en el ConOps; REQ-L0-4 con el rationale cortado; REQ-L0-6 sin rationale;
L1 vacío y con REQ-L1-01 repetido; «controlador» y «demostrador» tecnológico
mezclados en 2.7. **Los mails siguen sin aparecer.**

## 2026-09-29 (02:10) — guía pública v0.4 (Wokwi paso a paso)

Ampliada la sección de Wokwi (dónde van los archivos, tres formas de editarlos, correr y reiniciar) y agregado el cartel Board Project Options. Publicada por el hook post-commit. **La guía personal sigue en v0.3**: falta pasarle lo mismo. Máquina de estados del Cohete en `01 - UNSAM\Software de Vuelo\TP Cohete de Agua (Petrilli)\maquina-de-estados\` (PNG + .drawio editable + generar.py). El doc del grupo está en OneDrive y **no se pudo leer** (Word Online no expone el texto): hace falta una copia .docx para ver si ya trae máquina de estados y los mails.

## 2026-09-29 (01:20) — guía de IDEs publicada; el TP Cohete salió de lo público

**Hecho:** guía de IDEs v0.3 publicada y verificada por MD5; el hook
`post-commit` la republica sola en cada commit que toque su PDF. El informe del
TP Cohete salió de la carpeta pública `TDC` a una carpeta de GRUPOS privada
(detalle en `ESTADO_ACTUAL.md`).

**Búsqueda de los autores del Cohete (01:40), para retomar mañana con Fran.**
Fran cree que los mails están en «el doc inicial» del grupo y dice que se va
a trabajar sobre ese, no sobre los generados. **No apareció:**
- Drive (búsqueda de texto completo, incluidos los compartidos conmigo desde
  el 15/08): con «cohete», «apogeo», «BMP280», «paracaídas», «Petrilli» y
  «ESP32» sale sólo nuestro .docx y, además, un dibujo **«Esquema ESP32»
  de Santiago** (el del grupo de TdC), creado el 15/09 a las 03:39. Es
  del Cohete, así que Santiago es integrante `probable`. Ese dibujo es de él y
  está **público por link**; no es nuestro y no se tocó.
- Las sesiones de Claude: el informe se armó el 15/09 (`ddd5e1a3`) **a partir
  de lo que Fran dictó**, sin ningún doc adjunto ni link. Tampoco aparece en
  `Classroom` ni en `SOLO FRAN`, ni en `Downloads`.
- Hipótesis: el doc inicial es de otro integrante y a Fran le llegó por link
  (un doc abierto sólo por link no figura en «compartidos conmigo»). Pedirle
  el link a Fran.

**CubeIDE, para la v0.4 de la guía:** al crear el proyecto de la C031C6, después
del Finish aparece **«Board Project Options»**: elegir los componentes BSP (LED
verde LD4, botón de usuario, Virtual Com Port, los tres tildados por defecto) y
«Generate demonstration code» sin tildar. Se deja así y OK. El Virtual Com
Port es lo que genera `BSP_COM_Init`. La guía v0.3 no lo menciona (Fran lo vio
el 29/09 al crear `tp2`).

**Lo que sigue, en orden:**
1. **Compartir la carpeta del TP Cohete con los autores**, cuando Fran diga
   quiénes son o pase el link del doc inicial (el .docx nuestro no tiene mails:
   medido). Y abrir el Cohete como proyecto **privado** aparte (regla 2 del
   contrato), no acá. Al compartir, declararla en
   `.claude/estructura-drive.json` → `compartido-con-nombre`, **por hash del
   mail** (nunca el mail: el repo es público), y renombrar la carpeta con los
   apellidos, como la de Teoría de Circuitos.
2. Con lo que Fran cuente del TP2, corregir y subir a v0.4 las dos versiones.
   Commitear el PDF público alcanza: el hook lo sube.
3. La guía de C, cuando Fran la pida (la dejó para después el 29/09).

## 2026-09-29 (madrugada) — la guía de IDEs v0.3, adelantada para el TP2

**Hecho:** guía pública (`guia-ides/`, 6 pág., sin publicar) y guía personal
(`catedras/software-de-vuelo/personal/`, PDF en la carpeta local de la
materia). Detalle en `ESTADO_ACTUAL.md`.

**Lo que sigue, en orden:**
1. **Preguntarle a Fran si se publica la pública** en el Drive de apuntes. Si
   dice que sí: declararla en `.claude/apuntes-publicos.json` (materia
   «Software de Vuelo», `local` = `proyectos/documentos/software-de-vuelo/guia-ides/guia-ides.pdf`)
   y `.\publicar-apuntes.ps1`. **Ojo:** el detector de «sin declarar» busca
   sólo archivos llamados `apunte.pdf`, así que esta guía **no aparece** en
   rojo si nadie la declara — no esperar que el arranque lo recuerde.
2. Con lo que Fran cuente del TP2 (si el script, el simulador o IntelliSense
   fallaron), corregir y subir a v0.4. Es la validación real de la guía.
3. La fase 0 sigue igual: criterios de Leandro en `catedras`, y
   `docs/ALCANCE.md`.

**Trampas de esta sesión:** en PowerShell, `"...$placa: ..."` no compila (la
variable seguida de `:` es un calificador; va `${placa}`). En Typst, un bloque
de código en medio de una lista numerada la corta y reinicia la numeración: se
indenta dentro del ítem. Y un `raw` largo sin espacios (una ruta de WSL) se
sale de la celda de una tabla.

## 2026-09-29 — primera sesión

**Lo que sigue:** la fase 0 de este proyecto espera a la fase 0 de
`catedras` (los criterios de Leandro). Orden:

1. En `catedras`: leer la presentación del 18/08 y los prácticos 1 a 3 y
   registrar `LEA-R1` a `LEA-R4` con sus criterios (ver su `HANDOFF.md`).
2. Acá: `docs/ALCANCE.md`, cada tema de las dos guías con la clase o el
   práctico que lo pide.

**No hacer:** abrir el TP Cohete acá (regla 2), ni publicar nada que no sea
una de las dos guías.
