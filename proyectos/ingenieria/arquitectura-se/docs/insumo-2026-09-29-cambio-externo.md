# Insumo para la validación (P10) — un cambio externo real, 2026-09-28/29

Escrito por una sesión **de otro trabajo** (ordenar el Escritorio, registrar
los criterios de los profesores), no por la reforma. No se tocó nada de la
reforma: ni `install.ps1`, ni los saboteadores, ni el HANDOFF de este
proyecto. Es dato para la fase 7 (validar ≠ verificar), porque Fran lo pidió
así: *«la arquitectura nueva, si está bien hecha, debería ser capaz de
alinearse a cambios externos como estos»*.

## El cambio

Fran reordenó el Escritorio (`Mis Documentos` se repartió en `00 - Personal` …
`04 - Terceros`, con la numeración de la raíz de Drive), mudó el workspace de
STM32CubeIDE y trajo material nuevo de tres materias. Detalle en `MAPA.md` §1.

## Lo que la arquitectura NO vio (medido)

1. **El censo del Escritorio (regla 6) sólo mira el Escritorio.** El
   workspace de STM32CubeIDE (`C:\Users\frans\STM32CubeIDE\`, dos proyectos
   con `.ioc`) y los proyectos de C en WSL (`\\wsl.localhost\Ubuntu\home\...`)
   eran invisibles. Es la misma ceguera que taparon los bloques 5, 6 y 7:
   *un verificador sólo ve donde vive*.
2. **Declarar un contenedor oculta a sus hijos.** `Mis Documentos` estaba en
   `fuera-del-sistema.txt`; adentro había carpetas con `.typ`, `.py` y `.c`
   que el censo nunca miró.
3. **La lista de excepciones no encoge.** De las entradas de
   `fuera-del-sistema.txt`, 10 nombran carpetas que ya no existen (`EA`,
   `facu pendrive07del07`, `Programas`, `Programas y juegos`, `vscode`,
   `juegos folders`, `claude`, `Apps`, `Notas y setup`, `_Revisar`). Nada lo
   avisa; `datos-permitidos.json` sí tiene ese aviso («ya no aparece…
   sacarlo»). No se podaron: es decisión de la reforma.
4. **Las rutas locales escritas a mano se pudren.** Había rutas absolutas a
   material local en cuatro documentos de tres repos. Una (los libros de
   Física Espacial, en `fuentes/RUTAS.md`) **ya estaba mal antes** de la
   mudanza. Ningún medidor las ejecuta. Lección 296.
5. **No había capa para «lo que pide cada profesor».** Se creó
   `proyectos/documentos/catedras/` (privado) con los mecanismos que ya
   existían (`nuevo-proyecto.ps1 -Sensible`, contrato de nivel 4, verificador
   con saboteador). Que el molde alcanzara sin tocar la arquitectura es un
   dato **a favor**.

## Lo que sí funcionó

- `nuevo-proyecto.ps1` creó los dos proyectos nuevos en un comando, y
  `verificar-estructura.ps1` los vio (reglas 1–4) sin que nadie se lo dijera.
- La regla 2 (sensibilidad → destino) decidió sola dónde va lo privado.
- `verify-install` atrapó en el acto que editar la fuente del chequeo sin
  instalar deja rojo el arranque (ver `perfil-global/PENDIENTES.md` §10).
