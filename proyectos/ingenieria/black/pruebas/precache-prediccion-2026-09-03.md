# Predicción — test de hipótesis 1 (carga asíncrona), 2026-09-03

Escrita ANTES de lanzar el savestate, con `PrecacheTextureReplacements = true`
ya aplicado en `Documents\PCSX2\inis\PCSX2.ini` (PCSX2 estaba cerrado al
tocarlo). Respaldo previo: `pruebas/PCSX2.ini.respaldo-2026-09-03-V2`.

---

## CORRECCIÓN 09:50 — el experimento de arriba salió INVÁLIDO, y por qué

La primera corrida (09:33-09:38) se hizo con **ReShade 6.8.0 + DLSS5-Feeder +
RenoDX + LumeniteFX activos**, porque el `pcsx2-qt.exe` de la ruta corta —el
que el HANDOFF §9 nombra como "el emulador de esta línea"— es **el mismo
binario** de la línea DLSS5 del §8, con `dxgi.dll` hookeado desde el
2026-09-02 01:09. Las dos líneas están documentadas como independientes y en
el disco **no lo son**.

Medido en `C:\Program Files\PCSX2\dlss5-feed.log`, corrida de las 09:34:

```
09:34:06  [feed] effects: DLSS5_Feed.fx technique MISSING, ColorInput MISSING,
          DLSS5_MV MISSING, DLSS5_Depth MISSING, DLSS5_MV_PROVIDER=0 -> none
09:34:xx  [feed] MV probe: mean |mv| 0.000 px, 0% non-zero
          <-- DLSS is getting (almost) no motion vectors
09:34:xx  [feed] frame NNNN delivered (1920x1080, reset=0, same-device)
```

O sea: una reconstrucción neuronal **entregando frames igual, sin vectores de
movimiento y con la técnica del shader ausente**. Eso es un cuarto mecanismo
capaz de producir nitidez variable por zona de pantalla, y no estaba en la
tabla de §1.5.

**Y muy probablemente contamina también la observación ORIGINAL del
2026-09-02**: `ReShadePreset.ini` tiene mtime 2026-09-02 22:13, nueve minutos
después de la confirmación de carga del pack (§1.4, 22:04). El síntoma de
§1.5 se observó en esa misma ventana.

**Lo que NO se contamina:** la cobertura del 70,9 % (V1c). Sale de
`GSTextureReplacements.cpp`, interno al emulador; ReShade post-procesa el
frame final y no toca la caché de texturas del GS. Ese número sigue en pie.

## H4 — el pipeline de post-proceso (nueva, no estaba escrita)

La reconstrucción de DLSS5-Feed/LumeniteFX, con MV en cero, produce zonas
nítidas donde tiene información temporal estable y zonas blandas donde no.
Predice exactamente lo que Fran describió: *"según la altura a la que miro se
ve borroso o no, como el ojo humano que enfoca de lejos y ve borrosa la
periferia"* — un efecto **de pantalla**, no de superficie.

## EL ÁRBOL DE DECISIÓN — escrito antes de la corrida limpia

Corrida 2 (09:50): **ReShade OFF** (`dxgi.dll` renombrado a `.disabled`,
verificado por efecto: no existe `dxgi.dll` en la carpeta) y **precache ON**.
Son dos variables cambiadas respecto de la observación original, así que un
solo resultado NO alcanza para adjudicar:

| resultado de la corrida 2 | qué queda vivo | qué hace falta después |
|---|---|---|
| **el síntoma PERSISTE** | mueren H1 y H4. Queda **H2** (cobertura, 70,9 %) | nada más: H2 gana por descarte y ya tiene número |
| **el síntoma DESAPARECE** | ambiguo entre **H1** y **H4** | corrida 3: ReShade OFF + **precache OFF**. Si vuelve → H1. Si no vuelve → H4 |

El error a no cometer: leer "desapareció" como "H1 confirmada". Con dos
variables movidas a la vez, eso es exactamente la coincidencia sin explicar
que la regla 2 del perfil manda auditar.

---

## Hipótesis en juego

**H1 (carga asíncrona):** con `LoadTextureReplacementsAsync = true` y
`PrecacheTextureReplacements = false` (el default), los reemplazos se leen
del disco bajo demanda. De cerca, el reemplazo "llega tarde" y se ve el
original de PS2 hasta que aparece — coincide con lo que Fran describió como
"carga texturas extra".

## Predicción, si H1 es correcta

Con `PrecacheTextureReplacements = true` (todo el pack de 1,3 GB precargado
en memoria ANTES de que arranque el nivel), el síntoma de la §1.5 —la
barrera se ve MEJOR de lejos que de cerca— **desaparece**: de cerca también
se va a ver el reemplazo de alta resolución, porque ya no hay espera de
disco.

## Predicción, si H1 es incorrecta

El síntoma **persiste** igual con el pack precargado. Eso mata H1 y deja en
pie H2 (cobertura incompleta, ya con número: 70,9 % — la superficie usa otra
variante de textura, y esa variante en particular no está en el pack, sin
importar si está precargada o no).

## Qué mirar, concreto

Con el savestate 03 (dentro del nivel, primera persona, arma y HUD), la
misma barrera que Fran describió: mirar de cerca (con el auto detallado en
cámara) y después alejarse/retroceder hasta que el auto entre en cuadro.
Comparar la nitidez de la barrera en los dos encuadres.

---

# RESULTADO — corrida 2, 22:23-22:30. EL SÍNTOMA PERSISTE

Fran miró con ReShade fuera y precache puesto. **El síntoma sigue igual**, y
además lo acotó mejor de lo que estaba escrito: *"moví apenas por arriba del
ángulo que evidentemente desenfoca"*. Dos capturas de la MISMA pared de
tablones, con un cambio mínimo de **ángulo vertical**: una nítida con las
vetas y la pintura descascarada, la otra blanda.

Contra el árbol escrito antes de mirar:

| hipótesis | veredicto |
|---|---|
| **H1** carga asíncrona | **MUERTA.** Con los 1,3 GB precargados en RAM el síntoma no se movió |
| **H4** pipeline de post-proceso | **MUERTA.** Sin ReShade cargado el síntoma no se movió |
| **H2** cobertura (70,9 %) | **no explica ESTE síntoma**: la cobertura es por hash y no cambia con el ángulo de cámara |

Controles de la corrida, los dos por efecto:
- ReShade no cargó: `ReShade.log` y `dlss5-feed.log` sin escribir tras el
  arranque de las 22:23:30 (última escritura 09:34 y 09:40).
- El precache actuó: 2,09 GB privados en el proceso (base ~0,7 GB + 1,3 GB).

## LA CAUSA — `probable`, con tres patas medidas

**El pack reemplaza SOLO el mip 0. Todos los demás niveles caen al original
de PS2.**

1. **Convención de nombres leída del binario**, no adivinada — strings de
   `pcsx2-qt.exe`:
   ```
   %llx-%llx-%08x.png          <- textura base (mip 0)
   %llx-%llx-%08x-mip%u.png    <- nivel de mip N
   ```
2. **0 de 8225 `.dds` del pack llevan `-mip`.** Todos son de la primera forma
   (`1004865c455633eb-86566ebe97acefe8-00005554.dds`).
3. **El mip chain está EN USO:** `mipmap = true` y `hw_mipmap = true` en el
   `.ini`. Y el emulador lo dice solo, en cada arranque:
   *"Disabling autogenerated mipmaps on one or more compressed replacement
   textures"* — no puede autogenerar mips sobre DXT comprimido.

## POR QUÉ §1.5 DESCARTÓ MAL LOS MIPMAPS

§1.5 escribió: *"Cualquier explicación de mipmaps predice lo contrario (de
cerca se usa el nivel 0)"*. **Eso es falso, y el error es preciso:** el nivel
de mip no se elige por DISTANCIA, se elige por el **footprint de la textura
por píxel** (la derivada de UV). En una superficie plana grande mirada de
refilón, la derivada se dispara en un eje aunque la pared esté a un metro →
el GPU pide mip 1, 2, 3 → textura original de PS2 → **borroso de cerca**.
Inclinar apenas la cámara achica la derivada → mip 0 → reemplazo HD → nítido.

Por eso el síntoma está atado al ÁNGULO y no a la distancia, y por eso
parecía contraintuitivo: se lo estaba comparando contra un modelo de mip
por distancia, que no es el que usa el hardware.

## LO QUE CIERRA ESTO — una línea y una mirada

Poner `mipmap = false` (o `hw_mipmap = false`) con PCSX2 cerrado y volver al
mismo ángulo. Si la pared queda nítida en los dos ángulos, la causa queda
`confirmado` por efecto. Es el test que falta y no se corrió.

El arreglo de fondo, en cambio, ya estaba en la lista de NEXT ACTION del
HANDOFF §9 — **como ítem 7, el último**: *"Regenerar mipmaps del pack"*.
Estaba ranqueado al fondo porque §1.5 había descartado los mipmaps. Es el
ítem 1.

---

## Costo a medir aparte (paso 5)

1,3 GB de precarga: tiempo entre el lanzamiento (`-statefile`) y que el
juego esté jugable/estable, comparado contra el arranque sin precache de
sesiones anteriores (R1 usó ~20-25 s de estabilización, pero esa medición
era sin precache texturas). No es lo que decide el veredicto de H1; es
aparte.
