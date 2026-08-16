# Handoff — próxima sesión

## Cuadro de fase para abrir el próximo chat

```
Fase     : Fase 1 — redacción de los módulos 2 a 6.
           La cierra: los 6 módulos redactados, el PDF compilando sin
           errores, y `pendientes.typ` borrado del repo.
Modelo   : Opus 5 / effort alto para las DEDUCCIONES (Vef por integral,
           ripple, RB con beta forzado). Sonnet 5 para redacción
           expositiva y anexos. Haiku para compilar y commitear.
Contexto : chat nuevo POR MÓDULO. Cada módulo es independiente y el
           contrato está en el repo; arrastrar contexto sólo encarece.
```

## Lo primero que hay que hacer

1. `cd electronica-analogica/apunte && typst compile apunte.typ apunte.pdf` — confirmar
   que sigue compilando **antes** de tocar nada.
2. Leer `ESTADO_ACTUAL.md` y `apunte/modulos/pendientes.typ`. El plan de contenido de
   cada módulo ya está decidido; no volver a diseñarlo.

## Procedimiento por módulo (uno por sesión)

1. Leer la sección correspondiente de `pendientes.typ` — ahí está el plan.
2. Leer el TP asociado en `fuentes/*.txt` (ya extraído a texto, no hace falta pypdf).
3. Escribir `apunte/modulos/mN-<nombre>.typ` copiando la estructura de
   `m1-mediciones.typ`, que es el modelo canónico: apertura con `#modulo(...)`,
   teoría con deducción explícita, ecuaciones etiquetadas con `<ec-...>`,
   `#definicion`, `#clave`, `#atencion`, `#laboratorio`, mínimo 2 `#ejercicio`
   resueltos paso a paso, circuitos con `#circuito(...)` en ASCII, y cierre con
   `#tp(...)` atando el práctico.
4. Agregar el `#include` en `apunte.typ` y **borrar esa sección de `pendientes.typ`**.
5. Compilar. **Verificar por render, no por compilación**: `typst compile apunte.typ
   "chk-{p}.png" --ppi 85 --pages N` y mirar la imagen. Que compile no prueba que se vea
   bien (lección 7: confirmar el efecto, no la precondición).
6. Commit + push de ese módulo solo.

## Cosas que ya se aprendieron y no hay que redescubrir

- **No hay poppler en la máquina**, así que la herramienta Read no abre PDFs. Para leer
  un PDF: extraer texto con `pypdf` (ya instalado). El script quedó en el scratchpad,
  pero es de tres líneas.
- **Typst sí renderiza PNG nativo** (`--pages`, `--ppi`): es la forma de verificar el
  resultado visual sin poppler.
- Los caracteres de dibujo de caja (`─ │ ┌ ┴`) funcionan en los circuitos ASCII porque
  la plantilla usa DejaVu Sans Mono. No cambiar esa fuente sin volver a verificar.
- La numeración de ejercicios, ecuaciones y figuras se **reinicia sola** en cada
  `#modulo(...)`. No agregar contadores a mano.

## Pendiente explícito, fuera de los módulos

- **Agregar la fila de este proyecto a la tabla del `CLAUDE.md` raíz** (rama
  `claude/apunte-electronica-analogica`, carpeta `electronica-analogica/`, estado
  ACTIVO). No se hizo en esta sesión por falta de contexto.
- El apunte general de la materia y el apunte interactivo están en Moodle, que pide
  login. Si Fran los baja a `fuentes/`, conviene cruzarlos con los módulos ya escritos
  antes de seguir: podrían cambiar notación o alcance.
- Decidir si el apunte lleva **soluciones de los TPs** o sólo ejercicios análogos. Hoy
  lleva ejercicios análogos con los mismos números que el TP, que es lo pedagógicamente
  correcto, pero es una decisión de cátedra que Fran no confirmó.
