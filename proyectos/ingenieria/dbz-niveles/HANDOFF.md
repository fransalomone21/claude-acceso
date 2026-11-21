# Handoff — dbz-niveles

**Escrito el:** 2026-11-20 (noche) · **Fase al cerrar:** 0, Pre-Fase A, abierta

## Arrancá por acá

```
.\cascada.ps1 dbz-niveles -Necesidad ingenieria-inversa,investigar
```

y leer lo que pida. Después `ESTADO_ACTUAL.md` (la tabla de la fase 0 está
ahí) y `docs/spikes-fase0.md` (las mediciones con su predicción).

## Lo que quedó a medias

- **El Sparking ZERO de la notebook está abierto y Fran lo está jugando**: no
  se toca, y ningún juego se abre sin coordinar con las otras sesiones (Fran,
  2026-11-20). Esa instancia corre como admin: la sesión no la puede cerrar.
- El banco `DBZ-mods\scripts\banco-arranque.ps1` está arreglado y **sin
  correr**: primero `-SoloUna -Sabotaje` (tiene que dar SE CIERRA: si da
  ARRANCA, el banco está ciego), después entero (prueba el grupo `plugins`).
- Falta la elección de Fran: camino (PS2 o Sparking ZERO), escala (r de la
  propuesta) y qué quiso decir con «una sola pantalla allá / con las dos»
  (PDP §6, TBR).
- `../ps2-casa/RUTAS.md` dice que Anime War, Crossover y Remake AF están en
  `C:\Games\PS2-ISOs\`; ya no están (medido 2026-11-20). No se corrigió: esta
  sesión tenía orden de tocar sólo dbz-niveles. Lo corrige una sesión de
  ps2-casa.

## Lo que NO hay que volver a intentar

- Buscar los juegos otra vez: el inventario está en `ESTADO_ACTUAL.md`.
- Lanzar el juego por `SparkingZERO.exe` desde un script: tiene el flag
  `RUNASADMIN`, pide permiso y queda elevado (incerrable). El banco lanza
  `SparkingZERO\Binaries\Win64\SparkingZERO-Win64-Shipping.exe` directo.
- `7z l` sin `-tiso` sobre estos ISOs: da «0 files, Errors: 1».
- `DEJAR-TODO-LISTO.ps1` sin mirar: pisa el save con el «desbloqueado»
  (las rutas ya están corregidas a `Desktop\Juegos\Mods\Dragon Ball\DBZ-mods`).

## Datos que no se pueden aproximar

- Respaldo del save antes del banco: `DBZ-mods\respaldos\RESPALDO-save-20261120-221754`.
- Propuesta de DP (sin aplicar): `DBZ-mods\DP_values.propuesta-r2.json`; el
  vivo es `C:\Games\Dragon Ball Sparking ZERO\SparkingZERO\Mods\Extension_Dynamic_DP\Config\DP_values.json`
  (respaldarlo antes de pisarlo; el juego lo lee al arrancar).
- ISOs (notebook): ver `ESTADO_ACTUAL.md` y la versión anterior de este archivo
  en git; `dbzpoderes.iso` en `C:\Games\PS2-ISOs\` (ELF `SLUS_215.78`).
- DP de fábrica (Game8, probable): Goku (Super) 5, SSJ 6, Dios 7, Blue 8, UI
  Señal 8, UI 9.

## Si hay que abrir un chat nuevo

```
Seguimos con dbz-niveles (claude-acceso). 0) En la notebook el libro llega solo; en otro lado, bash .claude/nube/traer-perfil.sh primero.
1) .\cascada.ps1 dbz-niveles -Necesidad ingenieria-inversa,investigar y leé lo que pida. Después ESTADO_ACTUAL.md (la tabla) y docs/spikes-fase0.md.
2) Fase 0, Pre-Fase A. La cierra: en PDP §6 el camino elegido por Fran con fecha, sobre la tabla de ESTADO_ACTUAL (ya está).
3) Opus, esfuerzo alto, sin fan-out ni subagentes.
4) ANTES de abrir cualquier juego: preguntar si Fran está jugando y coordinar con las otras sesiones. Con el juego cerrado: DBZ-mods\scripts\banco-arranque.ps1 -SoloUna -Sabotaje (tiene que dar SE CIERRA) y después el banco entero.
5) Llevarle a Fran: camino, r de la escala, y qué es «una sola pantalla allá / con las dos».
6) Efecto a ver: banco-arranque.log con el sabotaje en SE CIERRA y el resultado de plugins; la fila de Fran en PDP §6.
```
