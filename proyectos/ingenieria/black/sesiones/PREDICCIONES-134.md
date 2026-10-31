# Predicciones de (134) — poner la plataforma en la PC con doble clic

Escritas **antes** de medir (2026-10-30, notebook). Requisitos: `docs/20` §11 (L2-INS-01..04).

## Qué cambió respecto del retome

El retome pedía «control total de la PC desde la notebook». La primera lectura fue un agente de control remoto a
medida; se descartó por ser la opción de más trabajo y riesgo (ver `docs/20` §11). El camino que Fran rankeó primero
—pendrive con un `.bat` de doble clic que corre `TRAER`— ya deja la PC instalada sin que tipee nada, y es lo que se
mide acá. Control en vivo = RDP, decisión de Fran.

## Estado de la máquina medido al abrir (notebook `MSI`)

- `Ethernet 2` arriba a 1 Gbps con `169.254.234.106` (cable directo a la PC), red **pública**.
- Tabla de vecinos del cable: `169.254.233.156`, MAC `F0-2F-74-…` (prefijo ASUSTek), `Stale` → la PC, *probable*.
- `C:\Games\BLACK\coop` existe (plataforma instalada en la notebook, (133b)).

## E1 — el instalador (notebook, sin la PC)

| # | Predicción | Requisito |
|---|---|---|
| E1a | `PAQUETE-PC.ps1 -Destino <pendrive>` deja en el pendrive `INSTALAR-BLACK.bat` junto a `TRAER.ps1`, y el `.bat` corre `TRAER` con `-Origen` = la carpeta del paquete | L2-INS-01 |
| E1b | `TRAER.ps1 -Origen <copia local> -SoloCopiar` copia los archivos del manifiesto con sha256 idéntico; una segunda corrida no vuelve a bajar ninguno | L2-INS-01, L2-INS-03 |
| E1c | el `.bat` resuelve su propia carpeta base (`%~dp0..`) y no depende de la letra del pendrive | L2-INS-01 |

## E2 — la PC real (con Fran: pendrive y doble clic)

| # | Predicción |
|---|---|
| E2a | Fran pone el pendrive, doble clic en `INSTALAR-BLACK.bat`, y la PC copia los 7,6 GB por el cable/pendrive verificando sha256 |
| E2b | al terminar, `PREPARAR` deja los accesos en `Escritorio\Juegos\BLACK` y la calidad de la PC en `calidad.toml`, sin que Fran tipee |
| E2c | Fran abre «coop - unirse», pone la IP de la notebook, y entra a la partida |

## Resultados

**E1 — medido en la notebook el 2026-10-30, con banco chico (2 archivos, 2 MB) en el scratchpad:**

- **E1b CUMPLIDA.** `TRAER -Origen <copia> -Raiz <dest> -SoloCopiar` copió los 2 con sha256 **idéntico** de los dos
  lados y el texto con acentos entero; la 2.ª corrida imprimió «[ok] los 2 archivos, verificados» sin volver a bajar
  ninguno (retoma por sha256, L2-INS-03). exit 0.
- **Sabotaje (regla 3):** pisé `a.txt` en el destino con otro contenido del **mismo tamaño** (sha distinto). `TRAER`
  rebajó **sólo** ese archivo (`[1/2] coop\a.txt`, no tocó `b.bin`) → RECUPERADO. La verificación por sha256 es
  load-bearing: no se queda con el tamaño.
- **E1c CUMPLIDA.** El `.bat` generado: 285 B, CRLF, sin BOM, con `pushd "%~dp0.."` + `-Origen "%CD%"` → no depende de
  la letra del pendrive.
- **E1a (parcial).** El bloque que escribe el `.bat` en `PAQUETE-PC.ps1` es idéntico al probado acá; la corrida
  completa de `PAQUETE-PC -Destino <pendrive>` (que hashea los 7,3 GB) queda para cuando Fran ponga el pendrive.

**E2 — la PC real: pendiente de Fran** (pendrive + doble clic; después abrir «coop - unirse»).
