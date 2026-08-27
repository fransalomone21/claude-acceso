// =====================================================================
//  paleta.typ — los colores del apunte, en un solo lugar
//
//  Vive acá y no en plantilla.typ para que la biblioteca de figuras
//  pueda usar los mismos colores sin importar plantilla.typ (eso sería
//  un ciclo: plantilla → circuitos → estilo → plantilla).
// =====================================================================

#let c-azul  = rgb("#1B4F72") // títulos y definiciones
#let c-verde = rgb("#1E8449") // ejercicios resueltos
#let c-rojo  = rgb("#922B21") // seguridad / errores frecuentes
#let c-ambar = rgb("#B9770E") // notas de laboratorio
#let c-viole = rgb("#6C3483") // vínculo con los TPs de la cátedra
#let c-gris  = rgb("#F4F6F7") // fondo de cajas neutras

// Colores propios de las figuras (no se usan en el texto)
#let c-trazo = rgb("#111111") // conductores y cuerpos de los símbolos
#let c-guia  = rgb("#9AA0A6") // líneas de construcción / punteadas
#let c-dato  = rgb("#B03A2E") // curva o dato destacado de un gráfico
#let c-aux   = rgb("#2471A3") // segunda curva / anotación secundaria
