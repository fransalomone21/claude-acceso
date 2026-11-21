# Estado actual — sparking-musica

**Última actualización:** 2026-11-21 19:45

## Dónde estamos

| Fase | Estado |
|---|---|
| 0 — Pre-A: investigación externa (qué resolvió ya la comunidad) | cerrada en papel (`docs/investigacion-previa.md`); ampliada hoy con Ryo Framework |
| 1 — instalar y probar | **en curso**: v5 instalada en la PC (21 filas famosas); las ~24 filas de tele siguen con audio de anime |

**Qué cierra la fase en curso:** Fran oye en una pelea J1 vs J2 temas famosos de LP (Hybrid Theory/Meteora
predominando), sin tele elegida por defecto; el guardado carga; el DLC con md5 de fábrica; L2 de los dos mandos
explicado (`docs/controles-l2.md`).

## Lo confirmado

| Qué | Evidencia | Fecha |
|---|---|---|
| **v5 instalada en la PC**: `zzLinkinParkTodo_P` pak 1 655 790 987 B, md5 en `LISTO\v5-filas\md5-v5.txt`; la v4 quedó apartada en `Mods-desactivados\paks\v4-conocidas` | `pc-instalar-v5.ps1`: md5 5/5 OK; juego vivo a 120 s sin error | 2026-11-21 |
| La lista «Música de fondo» muestra los temas nuevos: In the End…Burn It Down en las filas M0102–M0122 | capturas `v5-r6-1.png`, `v5-sel-1.png` (en `lp-trabajo\_intermedios\capturas-pc\`) | 2026-11-21 |
| La lista tiene ~46 filas: 21 mías + *Invisible* + ~24 con ícono de tele (nombres LP puestos por ZeroSpark, audio de anime del DLC) | capturas `v5-inv1-1.png`, `v5-sel-1.png` | 2026-11-21 |
| El DLC está con md5 de fábrica (6/6 iguales al original) | `dlc-md5-ahora.txt` vs `Mods-desactivados\DLC-anime-audio-original` | 2026-11-21 |
| El guardado vivo (`SaveGame\76561197960271872`) era idéntico al respaldo `respaldo-save-1724` antes de tocar nada | md5 Main `0C0BB9E0…`, System `13EC118D…` | 2026-11-21 |
| Música elegida por defecto cambiada de *Given Up* (tele) a *Burn It Down* | captura `v5-sel-1.png` (etiqueta «Burn It Down») | 2026-11-21 |
| Las 21 ondas nuevas decodifican con la duración de su tema; las cambiadas contra fábrica son exactamente las esperadas | `verificar-banco.py` sobre el pak final (Cnk_00: ROJO solo en la onda 8, un interludio de 22 s esperado; bgm_main: igual que v4) | 2026-11-21 |

## Lo que NO se pudo confirmar

| Qué | Por qué |
|---|---|
| Que en una pelea suenen los temas (audio) | el audio no sale en capturas: lo oye Fran |
| Que la fila elegida persista tras reiniciar el juego | no se reinició desde la elección |
| Que el guardado quedó igual tras mi error con *Nuevo juego* de Goku | se devolvió del respaldo (md5 igual); la elección de música posterior pudo volver a escribirlo: no se comparó |

## Lo que es hipótesis

| Hipótesis | Qué la confirmaría | Por qué todavía no se probó |
|---|---|---|
| **Ryo Framework (Reloaded-II) cambia el audio de las filas de tele** sin tocar el DLC firmado (el pack BT3 de la comunidad lo usa: Nexus 65, requiere «Anime Music DLC 1&2») | probar UNA fila de tele con un `.hca` en `Ryo\SparkingZERO-Win64-Shipping\<acb>.acb\<cue>` | falta instalar Reloaded-II y ver que arranque con la versión ElAmigos; decisión de Fran pendiente |
| Kuro's Music Manager (descargado en `herramientas\kuro-mm`, md5 OK, NO instalado) ayuda a elegir/ocultar | instalarlo y mirar Shift+M | no hace falta para lo pedido y exige idioma del juego = idioma de Steam |

## Callejones sin salida

| Se intentó | Resultado | Conclusión |
|---|---|---|
| Mod del DLC en `~mods` (normal y `_999`) | mudo | el DLC le gana a `~mods` |
| Apartar el DLC | la partida no carga | el guardado exige el DLC |
| Pisar el audio del DLC en su lugar | mudo | la tabla que lee es la del DLC |
| Pisar la tabla del DLC con una propia | «falta contenido descargable» | el DLC exige su contenedor cifrado y firmado |
| Mandar teclas sin mirar durante una carga | arrancó Nuevo juego de Goku, cambió el guardado | ver `pc-casa-control` |

## Lo próximo

Que Fran oiga la v5 y diga si va Ryo para la tele; probar L2 con Fran (`docs/controles-l2.md`).
