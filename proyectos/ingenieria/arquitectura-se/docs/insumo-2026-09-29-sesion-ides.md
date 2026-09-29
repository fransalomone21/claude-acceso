# Insumo para la validación (P10) — una sesión real de producción, 2026-09-29

Fran pidió que la sesión de la guía de IDEs de `software-de-vuelo` sirviera
de **sesión de prueba de la arquitectura**. Es el primer uso real después de
cerrar T1. Esto es dato para la fase 7 (validar ≠ verificar), **no** una lista
de cosas para arreglar ahora.

## Lo que Fran tuvo que corregir en vivo (tres veces en la misma sesión)

Las tres son preferencias suyas **ya conocidas** en otros proyectos, y
ninguna capa que llega sola a la sesión las traía para éste.

1. **«Revisá los PowerPoints primero: el profe dice cómo hacer las cosas;
   antes de inventar un método, sacalo de ahí.»** El contrato de
   `software-de-vuelo` manda leer `catedras/.../CRITERIOS.md` (regla 1), pero
   los criterios de Leandro están **pendientes**, y nada dice qué hacer
   entonces. La sesión leyó el texto de las clases y siguió; las diapositivas
   que son sólo imagen (el código del Blink, cómo arrancar el simulador, la
   licencia de 30 días) no las miró hasta que Fran lo pidió. Falta el camino
   de repuesto: *sin criterios registrados, el material de la cátedra es el
   criterio*.
2. **«Todo apunte va con el formato que usamos, sin complicarla, criollo y
   formal.»** El formato vive en `fisica-espacial/apunte/plantilla.typ` y la
   voz en la regla 8 de ese contrato. La naturaleza `documentos` (nivel 3) no
   nombra ningún estilo de la casa, y el contrato de `software-de-vuelo` sólo
   dice «`/pdf-con-codigo` (Typst)». Un dato que vive en un solo proyecto no
   llega a los otros.
3. **«Lo público es lo que la materia pide; lo personal (mis rutas, mis
   repos, mi entorno) es mío.»** La regla 2 de la estructura decide el
   destino de un **archivo** por su sensibilidad. Acá el problema fue el
   **contenido de un documento**: la guía mezclaba lo de la materia con lo de
   la máquina de Fran. Ninguna regla dice que un documento se parte en dos
   versiones.

Lo que se hizo: memoria de feedback (`feedback_apuntes-materia`), decisiones
en el PDP de `software-de-vuelo` §6, y las dos versiones. Lo que **no** se
hizo, porque es diseño (T2/T10): llevar esas tres preferencias a una capa que
llegue sola.

## Lo que la arquitectura no vio (medido)

4. **El detector de «sin declarar» del publicador sólo busca `apunte.pdf`**
   (`publicar-apuntes.ps1`, línea 228). `guia-ides.pdf` está en el disco,
   no está declarada, y el chequeo dice «ninguno sin declarar». Es la misma
   ceguera del insumo del 29/09 (el censo que sólo mira el Escritorio): un
   verificador sólo ve lo que su patrón nombra.
5. **El núcleo pierde la regla cuando la viñeta abre con un anuncio.** La
   trampa de PowerShell `"$var:"` está en `chequeo-de-trabajo.md`, pero su
   viñeta empieza «Dos trampas de PowerShell que fallan LEJOS de donde
   están…»: la primera oración —lo único que inyecta el núcleo— no dice cuál
   es la trampa. La sesión la pisó (`"$placa:"`) y la encontró al correr. El
   criterio de T1 («la primera oración tiene que ser la regla») no tiene
   medidor.
6. Del cierre de T1, esa misma noche: el ancla por mtime de `medir-inyeccion`
   se movió por una escritura de la app (PENDIENTES §11), e `install.ps1`
   corrompía `settings.json` (arreglado).

## Lo que sí funcionó

- El hook al paso trajo las viñetas de `typst` y de `freno` en el momento en
  que se usaron; el guardia del heredoc frenó un script de 19 líneas con
  barras invertidas, y la alternativa (escribir el archivo) salió bien.
- `/pdf-con-codigo` y la regla «el render se mira» atraparon cuatro defectos
  de maquetado que compilaban en verde (encabezado con la sección equivocada,
  bloque de código partido entre páginas, ruta fuera de la celda, lista
  cortada por un bloque de código).
- La regla 3 del perfil atrapó un verde falso **de la propia prueba**: con la
  ruta del `.elf` vacía, `Test-Path` de la carpeta daba `True`.
