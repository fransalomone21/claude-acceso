// =====================================================================
//  Apunte de C — Software de Vuelo (UNSAM, Ing. en Sistemas Espaciales)
//  Compilar:   typst compile --root .. apunte.typ apunte.pdf
//              (--root .. porque la plantilla sale de ../guia-ides/)
//  Verificar:  python verificar-ejemplos.py   (cada programa compila y
//              dice lo que el apunte muestra)
//
//  El orden de los módulos es el de la clase de Leandro (docs/ALCANCE.md).
// =====================================================================

#import "plantilla.typ": *

#show: apunte.with(
  titulo: "C para software de vuelo",
  subtitulo: "Apunte de la materia, de la primera variable a la máquina de estados",
  institucion: "UNSAM — Ingeniería en Sistemas Espaciales",
  materia: "Ingeniería de Software de Vuelo para Sistemas Espaciales Críticos",
  ciclo: "2.º cuatrimestre 2026",
  version: "v0.8 — módulos 1 a 9 de 12",
  presentacion: [
    *Para qué es esto.* Para aprender el C que usa la materia, en el orden en que lo
    da la cátedra, con cada programa *compilado de verdad* con los mismos flags que
    pide el práctico. Si un ejemplo de acá no compila, el apunte no se publica: lo
    chequea un script, no la buena voluntad.

    *Lo que no es.* No resuelve los prácticos: los ejemplos están ambientados en el
    mismo OBC imaginario, pero con otros números y otros casos. Copiar y pegar no
    va a andar, y ésa es la idea.

    *El código sale en verde con su salida abajo, en negro*, copiada de la corrida
    real en el gcc de Ubuntu: lo que ves impreso es lo que imprimió.
  ],
)

#include "modulos/m01-programa-minimo.typ"
#include "modulos/m02-variables-tipos.typ"
#include "modulos/m03-constantes-calificadores.typ"
#include "modulos/m04-operadores-bits.typ"
#include "modulos/m05-control-flujo.typ"
#include "modulos/m06-funciones.typ"
#include "modulos/m07-vectores-cadenas.typ"
#include "modulos/m08-punteros.typ"
#include "modulos/m09-maquinas-estados.typ"
