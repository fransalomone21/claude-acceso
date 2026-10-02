// =====================================================================
//  Apunte de Teoria de Circuitos (ISE03, UNSAM) — la Parte II del apunte
//  de Electronica Analogica, sin lo que es de la escuela.
//
//  Compilar (el --input NO es opcional: sin el, el assert de abajo frena):
//    typst compile --input materia=tdc apunte-tdc.typ apunte-tdc.pdf
//
//  Mismo fuente que apunte.typ: nada se copia. Lo que es solo de la escuela
//  va envuelto en #solo-ea[...] (plantilla.typ) o es una caja #tp, que en
//  esta compilacion no se imprime.
//
//  Los modulos CONSERVAN su numero (7 a 15): hay ~120 referencias de texto
//  plano ("Modulo 10", "Ejercicio 9.2") que el compilador no valida, y
//  renumerar las rompia todas en silencio.
// =====================================================================

#import "plantilla.typ": *

#assert(materia == "tdc", message: "apunte-tdc.typ se compila con --input materia=tdc")

#show: apunte.with(
  titulo: "Teoría de Circuitos",
  subtitulo: "Apunte teórico-práctico, con las deducciones completas",
  institucion: "UNSAM — Ingeniería en Sistemas Espaciales",
  catedra: "ISE03 — 2.º cuatrimestre",
  ciclo: "2026",
  encabezado: [Teoría de Circuitos — ISE03, UNSAM],
  como-usar: [
    *Cómo usar este apunte.* Cada módulo abre con lo que vas a poder hacer al
    terminarlo y deduce cada fórmula antes de usarla: de dónde sale, no sólo cuál es.
    Memorizar una fórmula sin saber de dónde viene es como aprenderse el camino a la
    facultad de memoria y que un día corten la calle.

    Las *cajas verdes* son ejercicios resueltos, con el resultado comprobado por un
    segundo camino al lado; las *azules*, definiciones e ideas clave; las *rojas*, los
    errores que más se repiten en parciales y en el laboratorio; las *amarillas*,
    práctica de banco.

    *Por qué arranca en el Módulo 7.* Este apunte es la segunda mitad de uno más grande
    (el de Electrónica Analógica de una escuela técnica), y los módulos conservan su
    número para que ninguna referencia cruzada mienta. Cuando el texto nombra los
    módulos 1 a 6 —un diodo, un transformador, una fuente—, habla de ese otro apunte,
    que está en la carpeta de Electrónica Analógica del Drive. No hace falta para seguir
    éste: son ejemplos de aplicación, no prerrequisitos.

    *Lo que todavía no está*, para que nadie lo busque en vano: sistemas trifásicos,
    transformada de Laplace, polos y ceros en el plano $s$, filtros activos de orden
    superior (Butterworth, Sallen-Key) y la impedancia reflejada del transformador. Van
    entrando a medida que se escriben; el resto del programa está.
  ],
  pie: [
    Apunte de estudio armado por alumnos, no material oficial de la cátedra. Si encontrás
    un error, avisá: preferimos enterarnos por vos que por el parcial.
  ],
)

#include "modulos/convenciones.typ"

// Los modulos conservan su numero del apunte completo (ver arriba).
#counter(heading).update(6)

#include "modulos/m7-kirchhoff.typ"
#include "modulos/m8-nodos-mallas.typ"
#include "modulos/m9-teoremas.typ"
#include "modulos/m10-transitorios.typ"
#include "modulos/m11-fasores.typ"
#include "modulos/m12-bode.typ"
#include "modulos/m13-cuadripolos-ao.typ"
#include "modulos/m14-operacional.typ"
#include "modulos/m15-simulacion.typ"

#include "modulos/anexos.typ"
