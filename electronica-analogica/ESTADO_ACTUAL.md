# Estado actual — Apunte de Aplicaciones de Electrónica Analógica (4.º año)

**Fecha:** 2026-08-16
**Rama:** `claude/apunte-electronica-analogica`
**Estado: APUNTE COMPLETO.** 43 páginas, los 6 módulos redactados más anexos.

## Qué es esto

Apunte teórico-práctico completo de la materia, fuente única en **Typst**, listo para
compilar a PDF. Destinatario: alumnos de 4.º año de la E.E.S.T. N.º 1 de Vicente López.

## Cómo se compila

```bash
cd electronica-analogica/apunte && typst compile apunte.typ apunte.pdf
```

Typst **0.15.1** instalado vía `winget install Typst.Typst`. No hace falta LaTeX ni
pandoc. Para trabajar con vista viva: `typst watch apunte.typ apunte.pdf`.

## Contenido por módulo

| Módulo | Tema | Ejercicios resueltos |
|---|---|---|
| 1 | Mediciones y expansión de rango | 5 |
| 2 | Señales periódicas e instrumental | 4 |
| 3 | Electromagnetismo y transformadores | 2 |
| 4 | Diodos y rectificación | 2 |
| 5 | Fuentes lineales (incluye zener) | 3 |
| 6 | BJT en conmutación y relés | 2 |
| — | Anexos: código de colores, series E12/E24, formulario, símbolos, seguridad | — |

Todos los módulos llevan: teoría con deducción explícita, ecuaciones numeradas y
referenciadas, circuitos en ASCII, cajas de definición / idea clave / cuidado /
laboratorio, y una caja final que ata el módulo con el TP correspondiente de la cátedra.

## Decisiones de contenido y por qué

**1. El apunte cubre la unión del temario pedido y de los TPs, que no coinciden.**
Los TPs suman regulador zener (TP 8), filtro pasa bajos RC (TP 5) y multímetro en
serie/paralelo (TP 2 y 3), que el temario no menciona. El temario suma transformadores y
BJT, que no tienen TP. Todo eso está.

**2. El apunte oficial de la cátedra (`AEA_Conceptos.pdf`, Prof. Esteban Lemos) está
incompleto.** Desarrolla mediciones, señales, osciloscopio y la introducción a fuentes
(hasta la página 39 de 42). Las secciones **7 (El diodo), 8 (El relé) y 9 (El transistor
bipolar)** son *títulos sin contenido*. Es decir: **todo el segundo cuatrimestre no tiene
material escrito.** Los módulos 4, 5 y 6 de este apunte llenan exactamente ese hueco.

**3. Se adoptó la notación de la cátedra, no la propia.** En expansión de rango:
$R_m$ = resistencia interna del galvanómetro, $I_m$ = corriente de deflexión a plena
escala, $R_S$ = shunt, $R_M$ = multiplicadora. El Módulo 1 se reescribió para alinearse
con el apunte oficial: si no, el alumno estudia con dos idiomas distintos.

## Evidencia (qué está confirmado y cómo)

- **Compila** → `apunte.pdf`, 43 páginas. Confirmado por ejecución.
- **Se ve bien** → verificado por render a PNG y lectura visual de páginas de muestra de
  los módulos 4 y 5. Que compile no prueba que se vea bien.
- **Dos defectos encontrados y corregidos por ese render**, no por leer el fuente:
  1. En Typst, una coma decimal seguida de `/` parte el número: `16,3/1000` se dibujaba
     como "16" seguido de la fracción 3/1000. Corregido con paréntesis en las seis
     expresiones afectadas.
  2. Typst trata la coma como separador y le agrega un espacio detrás: los decimales
     salían como "15, 6". Corregido globalmente en `plantilla.typ` con una regla
     `show` que reclasifica la coma como átomo normal.

## Fuentes

En `fuentes/`, con su texto ya extraído a `.txt` (la herramienta Read no abre PDFs en
esta máquina: no hay poppler).

- `AEA_Conceptos.pdf` — apunte oficial de la cátedra, 42 pág., Prof. Esteban Lemos, 2015.
  **Incompleto** a partir de la sección 7.
- `TP_I_cuatrimestre.pdf` / `TPX.pdf` — guía de TPs 0 a 5 + Anexo 1. Son el mismo
  documento (difieren en ~90 caracteres de encabezado).
- `TP_II_cuatrimestre.pdf` / `TP_II_completo.pdf` — guía de TPs 6 a 8. Ídem.
- Autor de las guías: Prof. Guillermo Ruisi.
- **No accesible:** el aula virtual de Moodle pide login.
