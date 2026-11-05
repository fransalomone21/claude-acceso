estado: pendiente

# Regreso de la nube — electrónica (fase 3 de electronica-analogica), 2026-11-05

Sesión `electronica` de la noche del 2026-11-05 (ver `.claude/nube/NOCHE.md`). Fran duerme; nada de Drive.
Se va actualizando por tema: lo que dice acá es lo que estaba pusheado a la hora del último renglón.

## Cuenta y permisos (medido al arrancar, 01:58 GMT-3)

- `claude-acceso`: remote `fransalomone21/claude-acceso`, `git push --dry-run` a `claude/prueba-permisos`: OK.
- `perfil-global`, `teoria-circuitos`, `catedras`: `add_repo` con push OK; `--dry-run` de push OK en los dos primeros.
- El entorno obliga a la rama `claude/awesome-brahmagupta-8mf5j6` en `claude-acceso`: todo lo de este repo va ahí
  (la PC la integra con `regreso.py --traer`). `perfil-global` va a `main`, como dice `NOCHE.md`.

## Control de paridad (RETOME §1)

- Typst 0.15.1 (binario oficial musl, sha256 `a6d077d0…3118c` del tar), en `~/.local/bin`. Paquetes de
  `traer-perfil.sh` en `~/.cache/typst/packages/preview` (cetz, cetz-plot, fletcher, oxifmt, zap).
- Fuentes del apunte **sin cambios desde `7aca8b3`** (medido con `git log 7aca8b3..HEAD -- .../apunte`, tras
  ahondar el clon a 1010 commits: el clon de la nube llega con 1 y `7aca8b3` no existía hasta el `fetch --depth`).
- `lint-typst.py`: 23 archivos limpios (EA) y 17 (TDC).
- **Resultado: paridad total.** `ea.pdf` 157 pág., MD5 `19046a0240b3d4e66121fcfb0e0a37cc`; `tdc.pdf` 103 pág., MD5
  `5da7b6a60732b11b80dfff9fd12761a3`. Los dos iguales a los de la PC.
- Control de los frenos: `$ i_s(t) = 3 $` compilado con `typst compile` por Bash → el guardia de Typst lo **niega**
  (T3). Verde.

## Temas de la fase 3 (sí / no, con su segundo camino)

| # | Tema | Escrito | Ejercicio | Segundo camino | Render mirado |
|---|---|---|---|---|---|
| 1 | Laplace y respuesta temporal | pendiente | | | |
| 2 | zpk, polos y ceros, ζ y Q | pendiente | | | |
| 3 | RLC serie según de dónde se toma la salida | pendiente | | | |
| 4 | Filtros activos (Butterworth, Sallen-Key) | pendiente | | | |
| 5 | Amplificador diferencial y de instrumentación | pendiente | | | |
| 6 | Trifásicos | pendiente | | | |
| 7 | Impedancia reflejada del transformador | pendiente | | | |

## Commits por repo

(se completa por tema)

## Hallazgos

(se completa por tema)

## Lecciones y defectos registrados

(se completa)

## Memoria pendiente (perfil-global/memoria-nube/)

(se completa)

## Decisiones para Fran

(se completa)

## Lo que no se pudo, y por qué

(se completa)
