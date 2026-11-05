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
| 1 | Laplace y respuesta temporal | sí, M16 | 16.1 (RLC serie con batería) | integración numérica de la EDO (solve_ivp) | TDC 98-102 |
| 2 | zpk, polos y ceros, ζ y Q | sí, M16 | 16.2 (polos de un RLC, ζ = 0,5) | raíces del polinomio y escalón simulado | TDC 101-102 |
| 3 | RLC serie según de dónde se toma la salida | sí, M16 | 16.3 (Q = 5, pico de H_C) | barrido numérico de las tres H | TDC 103-105 |
| 4 | Filtros activos (Butterworth, Sallen-Key) | sí, M17 | 17.1 (Butterworth n = 3 desde la plantilla) | el circuito resuelto por nodos; polos sobre la circunferencia | TDC 107-109 |
| 5 | Amplificador diferencial y de instrumentación | sí, M17 (el M14 ya los deducía; se suma modo común y CMRR) | 17.2 (restador desapareado 1 %, y con instrumentación) | nodos con v1 = v2 = 1 y con vd = 1; los tres AO por nodos | TDC 110-112 |
| 6 | Trifásicos | sí, M18 | 18.1 (8 + j6 en Y y en Δ, red de 380 V) | I²R fase por fase y fasores complejos | TDC 113-115 |
| 7 | Impedancia reflejada | sí, M18 | 18.2 (adaptar un parlante; bobina serie/paralelo) | las cuatro ecuaciones del trafo como sistema; admitancia | TDC 116-117 |
| 8 | Fourier | no: la guía del parcial no lo pide (retome: «si la guía lo pide») | — | — | — |

Los segundos caminos están escritos adentro de cada ejercicio y corridos en `electronica-analogica/fase3-cuentas.py`:
99 controles en verde (incluye cada número tipeado en el apunte contra el calculado) y `--sabotaje` en ROJO en los 7,
con el control positivo en verde. `verificar.py` (65 ejercicios, 80 figuras) y `verificar-cobertura.py` + su saboteador
en verde. **La fase 3 cerró** (PDP §4, con el tipo declarado: Fase D).

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
