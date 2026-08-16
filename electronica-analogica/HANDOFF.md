# Handoff — próxima sesión

## Cuadro de fase para abrir el próximo chat

```
Fase     : Fase 1 CERRADA (apunte completo, 43 pág., compila y verificado
           por render). Lo que sigue es Fase 2 — revisión pedagógica con
           el apunte usado en clase. La cierra: Fran dicta al menos un
           módulo y marca qué falta o qué sobra.
Modelo   : Sonnet 5 para ajustes de redacción y agregados menores.
           Opus solo si hay que agregar deducciones nuevas.
Contexto : chat nuevo. El apunte está en el repo y se lee solo; arrastrar
           este contexto no aporta nada.
```

## Lo primero que hay que hacer

1. `cd electronica-analogica/apunte && typst compile apunte.typ apunte.pdf` — confirmar
   que sigue compilando antes de tocar nada.
2. Leer `ESTADO_ACTUAL.md`, en particular las tres decisiones de contenido.

## Trampas de Typst ya pagadas — no volver a pisarlas

- **Coma decimal antes de `/`**: `16,3/1000` se dibuja como "16" más la fracción 3/1000.
  Escribir siempre `(16,3)/(1000)` con paréntesis.
- **Coma decimal dentro de una función**: `sqrt(1000^2 + 99,5^2)` es un error de sintaxis
  (la coma separa argumentos). Usar `"99,5"` entre comillas.
- **Espacio detrás de la coma**: ya está resuelto globalmente en `plantilla.typ` con una
  regla `show ","` que la reclasifica como átomo normal. No borrar esa regla.
- **Unidades con micro**: `6667 mu "F"` sale con espacio feo. Escribir `"6667 µF"`.
- **No hay poppler en la máquina**: la herramienta Read no abre PDFs. Para leer uno,
  extraer texto con `pypdf` (ya instalado) — ver `fuentes/_extraer.py`.
- **Verificar por render, no por compilación.** `typst compile apunte.typ "chk-{p}.png"
  --ppi 80 --pages N` y mirar la imagen. Los dos defectos que se encontraron habrían
  pasado desapercibidos mirando solo el fuente, y el PDF compilaba igual.

## Cómo se agrega o edita contenido

Un archivo por módulo en `apunte/modulos/`. `m1-mediciones.typ` es el modelo canónico:
apertura con `#modulo(...)`, teoría con deducción explícita, ecuaciones etiquetadas
`<ec-...>` y referenciadas con `@ec-...`, cajas `#definicion` / `#clave` / `#atencion` /
`#laboratorio`, ejercicios con `#ejercicio`, circuitos con `#circuito(...)` en ASCII, y
cierre con `#tp(...)`. La numeración de ejercicios, ecuaciones y figuras se reinicia sola
en cada `#modulo(...)`: no agregar contadores a mano.

## Pendientes explícitos

- **Agregar la fila de este proyecto a la tabla del `CLAUDE.md` raíz** (rama
  `claude/apunte-electronica-analogica`, carpeta `electronica-analogica/`, ACTIVO).
- **Decisión de cátedra sin confirmar**: hoy el apunte trae ejercicios resueltos
  *análogos* a los TPs, con los mismos números, pero no resuelve los TPs. Si Fran quiere
  que los resuelva directamente, hay que cambiar el criterio.
- **Los circuitos son ASCII.** Se leen bien, pero si el apunte se va a imprimir y repartir
  conviene evaluar redibujarlos como vectores con CeTZ (paquete de Typst). Es trabajo
  puramente estético y no bloquea nada.
- **Sin verificar contra el apunte interactivo** de Moodle, que sigue sin poder leerse.
