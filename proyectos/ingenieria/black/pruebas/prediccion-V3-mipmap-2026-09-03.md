# Predicción V3 — mipmap=false, escrita ANTES de mirar

**2026-09-03, noche. Fase V3.** Sigue a V2 (`docs/09-remaster-visual.md` §7),
que dejó la causa en `probable`: el pack de texturas sólo reemplaza el mip 0
(0 de 8225 `.dds` llevan `-mip`), y el nivel de mip se elige por el footprint
de la textura por píxel (derivada de UV) — dominado por el ÁNGULO en una
pared plana grande, no por la distancia.

## Cambio hecho

Con PCSX2 **cerrado**, en `C:\Users\frans\Documents\PCSX2\inis\PCSX2.ini`:

```
mipmap = false        (era true)
hw_mipmap = false      (era true)
```

Respaldo previo al cambio: `pruebas/PCSX2.ini.respaldo-2026-09-03-V3`.

**Control de contaminación cruzada, verificado antes de este cambio:**
`C:\Program Files\PCSX2\dxgi.dll` estaba presente con su nombre ACTIVO (Fran
ya lo había restaurado) — es decir, ReShade iba a cargar en la próxima
corrida. El clasificador de permisos bloqueó el intento de esta sesión de
renombrarlo a `.disabled` (escritura en `Program Files`). **Fran tiene que
renombrarlo a mano antes de esta corrida**, y hay que verificar por EFECTO
(`ReShade.log` / `dlss5-feed.log` sin escribir tras el arranque) que no cargó
— no alcanza con confiar en el nombre del archivo.

## Predicción

Con `mipmap = false` y `hw_mipmap = false`, el GS ya no puede caer a un nivel
de mip distinto de 0 — no hay chain que elegir. Si la causa de §7.3 es
correcta:

- **La barrera del savestate 03, mirada desde el ángulo que antes desenfocaba
  ("apenas por arriba del ángulo que evidentemente desenfoca"), se ve NÍTIDA.**
- El ángulo que ya se veía nítido (con el auto detallado) **sigue nítido** —
  no debería empeorar.
- **La nitidez deja de depender del ángulo.** Ése es el observable que decide
  todo: no "¿se ve mejor?", sino "¿la diferencia entre los dos ángulos
  desapareció?".

**Efecto colateral esperado, que NO invalida el test:** posible *shimmer* /
aliasing en superficies lejanas al mover la cámara (§1.4 ya lo anticipó como
gotcha del pack sin mip chain propio). Sin mipmap, el GPU muestrea siempre el
nivel 0 aunque el footprint sea grande, y eso agita el aliasing. Lo único que
se evalúa acá es si la nitidez sigue atada al ángulo o no.

## Árbol de decisión (antes de mirar)

| observación | veredicto |
|---|---|
| los dos ángulos quedan nítidos por igual | causa **CONFIRMADA** por efecto — pasa de `probable` a `confirmado`. Sigue el arreglo de fondo: regenerar el mip chain del pack (ítem 1 de la NEXT ACTION del HANDOFF §9) |
| el ángulo que antes desenfocaba SIGUE borroso | el modelo de §7.3 está mal o incompleto — **subir a Opus**, no seguir con Sonnet |
| aparece shimmer pero la nitidez ya no depende del ángulo | sigue siendo CONFIRMADA (el shimmer es un efecto secundario esperado, no el observable que se mide) |

## Cómo se revierte

Restaurar `pruebas/PCSX2.ini.respaldo-2026-09-03-V3` sobre
`C:\Users\frans\Documents\PCSX2\inis\PCSX2.ini` con PCSX2 cerrado.
