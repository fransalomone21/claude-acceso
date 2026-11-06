# Handoff — ps2-casa

**Escrito el:** 2026-11-06 · **Fase al cerrar:** 0 (Pre-Fase A), abierta

## Arrancá por acá

1. `.\cascada.ps1 ps2-casa -Necesidad investigar` y leer lo que pida.
2. Mirar si Fran ya mandó el ROMVER de las dos consolas y las respuestas de
   abajo. Sin eso no se elige concepto: se le pide.

## Lo que quedó a medias

- Preguntas a Fran, sin contestar al 2026-11-06:
  1. ¿La PC queda prendida cuando juegan? (decide si la red es el camino
     principal o el USB).
  2. ¿Ya tenés FreeMcBoot instalado en alguna de las dos tarjetas, o lo
     instalaste antes en otra consola?
- Respuesta parcial de Fran (2026-11-06): tiene una **notebook del gobierno**
  para usar sólo como repositorio de juegos por Ethernet, y además el pendrive.
  Eso resuelve «la PC apagada»: el servidor sería esa notebook, no la PC.
- Fran está revisando si la tarjeta Sony de 8 MB tiene FreeMcBoot (prendiendo
  la consola con la tarjeta y mirando el navegador). Esperar su foto.
- El inventario de ISOs de PS2 en la PC (la sesión del 2026-11-06 lo lanzó por
  todo el disco; si no quedó, rehacerlo).

## Lo que NO hay que volver a intentar

- Pedirle a Fran el exploit antes de saber el ROM: en una SCPH-90001 el camino
  depende del ROM (FMCB, OpenTuna o PS2BBL).

## Datos que no se pueden aproximar

- Consolas: SCPH-90001, NTSC U/C, códigos de fecha **8C** y **1C**.
- Tarjetas: Sony SCPH-10020 (8 MB, original); «Sony 64 MB MagicGate» (clon probable).
- Pendrive: 16 GB.
- ROMVER: en uLaunchELF, MISC → Debug Info, los 4 dígitos después de `rom0:ROMVER` (0230 = ROM 2.30).

## Si hay que abrir un chat nuevo

```
0. Libro primero (regla 16) si no estás en la PC de Fran.
1. Abrí claude-acceso y corré: .\cascada.ps1 ps2-casa -Necesidad investigar ; leé lo que pide.
2. Fase 0, Pre-Fase A. La cierra: Fran elige el concepto por consola (PDP §6) con el ROMVER de las dos medido.
3. Opus, esfuerzo medio, sin fan-out: es armar un concepto con datos que da Fran.
4. Máquina: nada instalado todavía para las PS2.
5. Ya está: la investigación de red (docs/investigacion-red.md) y el alcance (PDP §1).
6. Primer paso: leer ESTADO_ACTUAL y ver si llegaron el ROMVER y las dos respuestas.
```
