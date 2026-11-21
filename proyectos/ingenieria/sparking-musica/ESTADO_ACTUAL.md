# Estado actual — sparking-musica

**Última actualización:** 2026-11-21 17:50

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Pre-A: investigación externa (qué resolvió ya la comunidad) | **en curso**, a medias |

**Qué cierra la fase en curso:** `docs/investigacion-previa.md` con los mods más usados para música en
Sparking ZERO, qué hace cada uno (entradas nuevas, ocultar, aleatorio, cambio en pelea, pistas del DLC),
qué requiere, y la vía elegida con su porqué. Recién ahí se toca la PC.

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| La PC tiene v4: 45 temas conocidos de LP, de a 4, en las peleas del juego base (M_1000..1044), nombres por ZeroSpark | instalada a las 16:45; captura de la lista 17:16 | 2026-11-21 |
| Las filas con ícono de tele = DLC Anime Music Pack 1/2 (M_2000..2022) y suenan anime | Fran las oyó | 2026-11-21 |
| Sin el DLC la partida NO carga ("falta contenido descargable") | captura sin-dlc-3, 17:24 | 2026-11-21 |
| Una tabla del DLC rearmada (mismo id de contenedor, sin cifrar ni firmar) también da "falta contenido descargable" | captura dlc-id-1, 17:40 | 2026-11-21 |
| Con el audio del DLC pisado y la tabla de fábrica, la pista queda muda (sigue la del menú, Easier to Run) | Fran, ~17:35 | 2026-11-21 |
| DLC vuelto a fábrica (md5 igual al original) y la partida carga | md5 + captura fabrica-1, 17:42 | 2026-11-21 |
| **Revisión 18:31-18:34 (sin cambiar nada):** el juego abierto (pid 16604, desde 18:28:57, 2 GB, responde) llega a la pantalla de título y, con "Iniciar", carga la partida hasta el Menú principal (Episodio de batalla / Batalla personalizada). Nadie jugando (sesión de Fran activa, juego en el título). Archivos del DLC con fecha original (24/06/2025), sin tocar | capturas `_intermedios\capturas-pc\revision-1-1.png` (título), `revision-3-1.png` (menú principal), `revision-5-1.png` (Batallas adicionales); `Get-ChildItem` del DLC | 2026-11-21 |

| **Investigación de Kuro's Music Manager (fase 0 cerrada en papel):** 1.3.3 en [GameBanana](https://gamebanana.com/mods/595406) (la página de Nexus fue **removida por el staff**); tiene BGM Swapper (cualquier canción del juego) y Save Updater (forzar desbloqueo); no existe pack de LP de Hybrid Theory/Meteora hecho. Vía elegida: instalarlo y probar el Swapper con los M1000+ antes de construir nada | `docs/investigacion-previa.md` (lo dicen los autores; nada probado en la PC) | 2026-11-21 |
| **El menú de música tiene 25 filas (22 M0102–M0123 con LP de discos nuevos + 3 de tele); los famosos M1000–M1044 no están en él** | `docs/menu-musica.md`, capturas `musica-9..12` | 2026-11-21 |

## Lo que NO se pudo confirmar en esta revisión

| Qué | Por qué |
|---|---|
| Que en una pelea suenen los temas de LP (M_1000..1044) | el audio no sale en una captura de pantalla y no se entró a una pelea. Hace falta que Fran escuche una pelea (vs CPU, escenario con música del juego base) y diga qué suena, o una captura de la lista de música de Batalla personalizada con los nombres de ZeroSpark |
| Que el guardado quedó igual al respaldo | el guardado vivo no está en `%LOCALAPPDATA%` de la PC (búsqueda recursiva: nada); no se comparó. Solo se sabe que el respaldo (`respaldo-save-1724`, 100811 B) sigue ahí |
| Navegar por teclado | en esta pantalla ESC y BACKSPACE no vuelven atrás; DOWN+ENTER desde el Menú principal lleva a "Batallas adicionales", no a Batalla personalizada. El juego quedó en ese submenú |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| Kuro's Music Manager da lo que pide Fran sin tocar el DLC: entradas LP nuevas, aleatorio por pelea, cambio en pelea (RePág/AvPág) | leer su doc y la del pack "Extra BGM Slots"; probar un BGMMod | la fase 0 quedó a medias |
| Con Music Manager se pueden ocultar las filas del DLC | su ReOrderBGM.json lista BGMMods según el mod 949; no dice nada del DLC | sin leer la doc de Kuro |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Mod del DLC en ~mods (prioridad normal y _999) | mudo | el DLC le gana a ~mods |
| Apartar el DLC | la partida no carga | el guardado exige el DLC |
| Pisar el audio del DLC en su lugar | mudo | la tabla que lee es la del DLC |
| Pisar la tabla del DLC con una propia | el juego da el DLC por faltante | el DLC exige su contenedor cifrado y firmado |

## Lo próximo

Cerrar la fase 0 (ver HANDOFF). Nada sobre la PC hasta cerrarla.
