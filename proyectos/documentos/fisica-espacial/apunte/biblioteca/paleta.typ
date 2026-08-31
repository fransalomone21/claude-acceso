// =====================================================================
//  paleta.typ — los colores del apunte, en un solo lugar
//
//  Vive acá y no en plantilla.typ para que la biblioteca de figuras
//  pueda usar los mismos colores sin importar plantilla.typ (eso sería
//  un ciclo: plantilla -> figuras -> estilo -> plantilla).
// =====================================================================

#let c-azul = rgb("#1B4F72") // títulos, definiciones e ideas clave
#let c-verde = rgb("#1E8449") // ejemplos resueltos
#let c-rojo = rgb("#922B21") // errores frecuentes
#let c-ambar = rgb("#B9770E") // cuidado geométrico / vectorial
#let c-viole = rgb("#6C3483") // vínculo con la guía de problemas
#let c-teal = rgb("#117A65") // choques de notación entre los libros
#let c-gris = rgb("#F4F6F7") // fondo de cajas neutras

// Colores propios de las figuras (no se usan en el texto)
#let c-trazo = rgb("#111111") // trazo principal, cuerpos, ejes
#let c-guia = rgb("#9AA0A6") // líneas de construcción / punteadas
#let c-dato = rgb("#B03A2E") // el vector o la curva protagonista
#let c-aux = rgb("#2471A3") // vector o curva secundaria
#let c-orbe = rgb("#1B4F72") // cuerpo central (Tierra, Sol)
