# Apunte de Física Espacial — contrato de contexto

Apunte general de la materia **Física Espacial** (UNSAM — Ingeniería en
Sistemas Espaciales, cátedra Feder–Valenti, 2026). Fuente única en **Typst**,
se compila a un solo PDF. Destinatario: **el alumno que cursa la materia**.

**Naturaleza:** `documentos`. Antes de trabajar acá se lee
[`plantillas/naturalezas/documentos.md`](../../../plantillas/naturalezas/documentos.md):
el render se mira, las fuentes se anotan donde se usan, y las referencias
cruzadas de texto plano no las valida el compilador.

## Qué leer según lo que se vaya a hacer

| Si la tarea es… | Leer |
|---|---|
| retomar, saber qué módulos están cerrados | [`ESTADO_ACTUAL.md`](ESTADO_ACTUAL.md) (entero) |
| saber qué cierra la fase en curso, o por qué se decidió algo | [`PDP.md`](PDP.md) — sobre todo §3 y §4 |
| lo que quedó a medias y las trampas de Typst ya pagadas | [`HANDOFF.md`](HANDOFF.md) |
| verificar un dato contra la bibliografía | [`fuentes/RUTAS.md`](fuentes/RUTAS.md) — los seis libros, con ruta exacta |
| entender qué pide la cátedra en cada tema | [`fuentes/TEMARIO.md`](fuentes/TEMARIO.md) — las listas de temas y el plan de 17 semanas, transcriptos |
| tocar o agregar una figura | [`docs/figuras.md`](docs/figuras.md) |
| generar el PDF | `.\compilar.bat`. El flujo y el chequeo visual: `/pdf-con-codigo` |

## Las dos reglas propias

**1. Ninguna sección se da por cerrada sin haber mirado su página compilada.**
Que Typst compile no dice nada sobre si los rótulos se cruzan, si una figura
entró, o si una tabla se cortó.

**2. Se deduce lo que cambia el entendimiento; se cita lo que sólo cambia el
álgebra.** Es la regla de contenido que define este apunte y viene textual del
destinatario. Una fórmula que aparece de la nada incumple la primera mitad;
tres páginas de despeje incumplen la segunda.

## Dónde está cada cosa

```
apunte/
  apunte.typ          el documento: llama a los modulos en orden
  plantilla.typ       estilo, cajas, caratula, indice
  biblioteca/
    paleta.typ        los colores, en un solo lugar
    estilo.typ        helpers de CeTZ compartidos por las figuras
    figuras.typ       las figuras del apunte, una funcion por figura
    galeria.typ       compila SOLO las figuras (segundos, no minutos)
  modulos/            m1-*.typ … m15-*.typ, uno por modulo
docs/                 figuras.md (el catalogo de figuras)
fuentes/              RUTAS.md y TEMARIO.md — la bibliografia no se copia acá
PDP.md · ESTADO_ACTUAL.md · HANDOFF.md
```

Los PDFs de los libros **no se commitean**: pesan cientos de MB y no son
nuestros. `fuentes/RUTAS.md` guarda dónde están en el disco.

## Al cerrar cualquier sesión

1. Actualizar `ESTADO_ACTUAL.md` y `HANDOFF.md`.
2. Registrar las lecciones de proceso:
   `python ..\..\..\perfil-global\herramientas\aprender.py agregar ...`
3. Commit y push a `main`.
