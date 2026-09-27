# Plan del ELF: desenmascarar el ejecutable en frío (nube)

Pedido de Fran, 2026-09-27: «darle un golpe fuerte al ELF para que queden muy
pocas cosas, o ninguna, por desenmascarar». Se ordena **por lo que pide la
cartera**: primero el coop, después lo que suba más nodos del mapa de una vez.
Mide el avance `programa.py resumen`, con la K de cada nodo.

## Estado al 2026-09-27

- **Herramientas en la nube:** capstone (desensamblado; decodifica mal las MMI del R5900) y numpy. Ghidra **no está instalado**; se llega a GitHub, así que es instalable (sin probar).
- **Mapa:** 36 nodos. K0: `camara`, `tiempo`. K1: 6 nodos, entre ellos `render`, `s-0x0040F510` (≥219 funciones) y `s-0x0040F4C0` (≥117).

## Etapas (cada una deja un script en `herramientas/` y una entrada de bitácora)

| # | Qué | Sube | Cómo se certifica |
|---|---|---|---|
| E1 | **Ghidra headless en la nube**: bajar Ghidra y la extensión `ghidra-emotionengine-reloaded` a `/home/user/herramientas`, importar el ELF y correr el análisis automático una vez; guardar el proyecto en `black-datos` si pesa menos de 95 MB | toda la cadena | `decompilar.py info` con su control positivo en verde |
| E2 | **Decompilado masivo**: las ~10.000 funciones a C en `black-datos/decompilado/` (privado), con un índice función → singletons que usa (`decompilar_lote.py`) | todos los K1 a K2 | la cuenta de funciones por singleton reproduce `censo_subsistemas.py` |
| E3 | **Cámara (sonda 2)**: quién consume el yaw (`0x0013B6EC` y quienes la llaman) y `sniper_SetMaxZoom`; buscar la escritura de la matriz de vista | `camara` K0 → K3 | una predicción comprobable en la notebook (dirección + campo) |
| E4 | **Render (sonda 4)**: viewport/scissor del GS, y si la mira `WPNSCOPE` dibuja con otra cámara | `render` K1 → K3 | ídem |
| E5 | **Los dos grandes sin nombre**: `0x0040F510` y `0x0040F4C0`, nombrados por las cadenas y los decompilados | K1 → K2/K3 | nombre con evidencia en `kb/subsistemas.json` |
| E6 | **Los 13 «sin-nombre»** y `tiempo` | K1 → K2 | ídem |
| E7 | **Sesión y modos**: las tres clases de modo (vtables `0x003DB590`, `0x003DB538` y `0x003DB4E0`) y el switch de 0x37 casos de `FUN_00106868` | `sesion` K3 | la tabla de modos en `kb/` |

**Límite honesto:** en frío un nodo llega a **K3** como mucho. De K4 para
arriba hace falta la notebook (volcados nuevos o efecto por PINE). «Ninguna
cosa sin desenmascarar» quiere decir **todos los nodos en K ≥ 2 o 3**, no
todos confirmados.
