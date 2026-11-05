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

## Lo que se hizo además de la fase 3

- **Fase 5 de electronica-analogica (la voz de la casa en los módulos 7 a 15), abierta y cerrada.** Era el pedido
  pendiente de Fran del 2026-10-02 que el retome mandaba hacer después de la fase 3. 37 pasajes (la apertura y tres o
  más por módulo), humor en la prosa y sin cartel, sin cargar a ningún profesor. **Ni una ecuación, número, título,
  figura ni ejercicio cambió**: lo mide `comparar-matematica.py` (nuevo) contra `06391c6`, con sabotaje por categoría.
  Los 37 pasajes mirados en render.
- **Fase 18 de teoria-circuitos**: la guía del parcial (pública) decía que el apunte no tenía Laplace ni filtros
  activos; ahora apunta a los módulos 16 y 17. Sólo cambió `guia.typ`: la PC tiene que regenerar y publicar la central.
- **Regla 15, un nivel arriba**: la lección 440 (un `;` comido después de `#f[...]`) se repitió en esta sesión; el
  guardia de Typst ahora corre las reglas a pedido (T6 a T9) en los proyectos que las declaran en
  `lint-typst.reglas` (perfil `d694d0a`, con autotest y mutante detectado), y `electronica-analogica` las declara.
  Visto el efecto con el guardia vivo. De paso apareció un T6 real en el M16 (`(0, 0)` se leía decimal): corregido.

## Commits por repo

- `claude-acceso` (rama `claude/awesome-brahmagupta-8mf5j6`): `8500209` informe abierto · `27b0c8e` M16 · `92ac6cd`
  M17 y M18 · `888d549` fase 3 cerrada en los registros, tablero de la carrera, SVG deterministas · `a469716` T6 del
  M16 y `compilar.bat` con `--t6 --t7 --t8` · `06391c6` fase 5 abierta y `comparar-matematica.py` · `0ce5db3` la pasada
  de voz · `b6a90c0` fase 5 cerrada · `ddd210a` `lint-typst.reglas` · y el cierre (este informe y la auditoría).
- `perfil-global` (`main`): `e66928a` DA-109 y DA-110 · `a7de1cd` lección 467 y recurrencia de la 440 · `d694d0a`
  guardia de Typst por proyecto · `54d3dec` la 440 subida a regla · `5e8911f` DA-113.
- `teoria-circuitos` (`master`): `b32e4a8` fase 18.
- `catedras`: nada (no entró material nuevo de ningún profesor).

## Lo que la PC tiene que hacer al volver (además de `regreso.py --traer`)

1. Regenerar los dos PDF del apunte y publicarlos: **EA 177 pág. y TDC 124 pág.** (medidos en la nube con los
   parámetros del retome: EA `d3fd9890…` antes de la fase 5; los MD5 finales cambian con la pasada de voz). La nube no
   commiteó PDF.
2. `python guia-parcial/compilar.py` en `teoria-circuitos` y publicar la **central** de la guía del parcial (la de
   sólo ejercicios no cambia).
3. Actualizar el renglón «estado» de la entrada TDC en `.claude/apuntes-publicos.json` al publicar (no se tocó: es del
   publicador).
4. Las figuras nuevas de matplotlib necesitan la Libertinus como `.otf` para regenerarse
   (`LIBERTINUS=<carpeta> python biblioteca/figuras/generar-fase3.py`); en la PC no hace falta regenerarlas: los SVG
   están commiteados y son deterministas.

## Hallazgos

- [VD 5/10] **La paridad nube-PC del apunte es total** (MD5 iguales en los dos PDF): la nube puede escribir el apunte
  sin divergir. Cambia el plan: el apunte se puede seguir en la nube con confianza; lo que diverge está en otro lado.
- [VD 4/10] **La guía del parcial no tiene paridad** (DA-113): mismo texto, distintos SVG por matplotlib 3.11 y sympy
  ausente. Acota qué se puede republicar desde la nube.
- [VD 3/10] `fase3-cuentas.py`, al comparar el número **tipeado** con el calculado, agarró dos redondeos propios
  (1575,5 por 1575,55 Hz; 1111 por 1110,5) que los dos caminos en verde no veían. El tercer control vale.
- [VD 3/10] El autotest del guardia de Typst daba BIEN en Linux en un caso por la palabra «T3» del texto de ayuda
  (sabotaje por el motivo equivocado): arreglado, ahora la marca se busca en los hallazgos.
- [VD 2/10] La puerta deja pasar un `cd <otro proyecto> &&` sin pedir la necesidad (DA-109): se escribió en `carrera`
  así antes de declararla; se declaró y se leyó después.

## Lecciones y defectos registrados

- Defectos: **DA-109** (media), **DA-110** (media), **DA-113** (media) y **DA-114** (media, **arreglado**: la
  auditoría buscaba perfil-global adentro de claude-acceso; en la nube P10 daba ROJO falso y P11 no miraba
  perfil-global; `perfil_de()` con autotest y `--sabotaje-perfil`), todos en `ORDEN-DE-ATAQUE.md`.
- Lecciones: **467** (las reglas a pedido del lint no corren en el guardia) y la **440** marcada como repetida y subida
  a nivel `regla` con su arreglo.

## Memoria pendiente (perfil-global/memoria-nube/)

Nada: Fran no habló esta noche, y no hay nada nuevo de él que guardar.

## Decisiones para Fran

1. **El tono de la pasada de voz en el apunte de EA.** Quedó *moderado* a propósito (la opción conservadora): el
   destinatario primario del apunte de EA es el docente. Si lo querés tan crudo como el de Física Espacial, es una
   segunda pasada sobre los mismos 37 lugares, con `comparar-matematica.py` cuidando que no se mueva nada.
2. **Dónde van los módulos nuevos.** Quedaron 16, 17 y 18 al final (detrás del de SPICE) para no renumerar nada, y la
   carátula del TDC dice el orden de lectura. Si preferís que Laplace quede entre el 12 y el 13, es una renumeración
   con ~120 referencias de texto plano: se puede, con `verificar.py` (chequeo 6) midiendo.
3. **La guía privada de la exposición** (H(s), polos y ceros, 2026-10-09) no entró al apunte: el M16 se escribió
   desde el Nilsson. Sigue siendo tuya para decidir si se publica.
4. **El M18 trabaja en eficaz** (lo dice en una caja), contra la convención de pico del resto del apunte, porque en
   potencia todo el mundo habla en eficaz. Si preferís pico también ahí, son las fórmulas de potencia con el ½.

## La auditoría

`.claude/auditorias/2026-11-05-c323fd80.md`: **sin rojos**. P5 amarillo (una excepción registrada: la auditoría
nombra la ruta del contrato de `fisica-espacial` como lectura usada, y la puerta frena el texto que la nombra; no se
leyó ni escribió nada de ese proyecto). P13 amarillo (4 de 37 lecturas exigidas declaradas como usadas: el tronco de
requisitos y alcance no se usó para decidir nada de un apunte; propuesta de retiro para Fran, como dice el lazo de uso).

## Lo que no se pudo, y por qué

- **Fourier** (tema 8 del retome) no se escribió: la guía del parcial no lo pide, que era la condición del retome.
- **Las citas al Nilsson con página** sólo donde se miró la página o el índice; el resto quedó como sección (§) sin
  página, a propósito.
- **No se compiló el EA con la pasada de voz para mirar sus páginas**: la prosa es la misma en los dos PDF y se miró
  en el TDC; `verificar.py` compila el EA en verde.


