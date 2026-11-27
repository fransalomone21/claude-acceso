"""Las dos versiones de la tienda (L1-01 y L1-20). Cada proceso atiende UNA, elegida por TIENDA_VERSION:

  (sin nada)               -> 1.21.1 NeoForge, la principal: pagina en :8765, server de la tienda en :25568
  TIENDA_VERSION=1.21.4    -> 1.21.4 Fabric, la del mundo con Agus: pagina en :8766, server en :25569

Cada version tiene sus datos (catalogo y curado), su carpeta fuera del repo (cache, publicado, prueba, server) y su
instancia de Prism. Nada se comparte entre las dos salvo el Java.
"""
import os

PERFILES = {
    "1.21.1": {"mc": "1.21.1", "cargador": "neoforge", "cargador_version": "21.1.267", "datos": "datos",
               "raiz": r"C:\Users\frans\MinecraftServer\tienda", "puerto_web": 8765, "puerto_server": 25568,
               "puerto_prueba": 25598, "instancia": "Tienda 1.21.1", "nombre": "1.21.1 (NeoForge)"},
    # Fabric 0.20.1, el ultimo estable (medido 2026-11-27): con el 0.19.3 del mundo con Agus, Fabric Language Kotlin
    # 1.14.2 no arranca ("needs fabricloader >= 0.19.5"); el mundo con Agus sigue en el suyo
    "1.21.4": {"mc": "1.21.4", "cargador": "fabric", "cargador_version": "0.20.1", "instalador_fabric": "1.1.2",
               "datos": "datos-1.21.4",
               "raiz": r"C:\Users\frans\MinecraftServer\tienda-1.21.4", "puerto_web": 8766, "puerto_server": 25569,
               "puerto_prueba": 25597, "instancia": "Tienda 1.21.4", "nombre": "1.21.4 (Fabric, el mundo con Agus)"},
}
VERSION = os.environ.get("TIENDA_VERSION", "1.21.1")
if VERSION not in PERFILES:
    raise SystemExit(f"TIENDA_VERSION={VERSION!r} no existe: es una de {list(PERFILES)}")
P = PERFILES[VERSION]
