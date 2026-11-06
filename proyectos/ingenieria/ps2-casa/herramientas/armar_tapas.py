"""Arma las tapas del OPL (ART/<ID>_COV.png, 140x200: OPL 1.2 solo lee PNG).
Uso: python armar_tapas.py <carpeta_src> <carpeta_ART>
En src van las tapas bajadas de github.com/xlenore/ps2-covers (covers/default/<ID con guion>.jpg)."""
import os, sys
from PIL import Image, ImageDraw, ImageFont

SRC, ART = sys.argv[1], sys.argv[2]
# ID que lee OPL -> (tapa de origen, franja opcional)
TAPAS = {
    'SLES_551.35': ('SLES-55135.jpg', None),                      # LEGO Batman (PAL)
    'SLUS_206.24': ('SLUS-20624.jpg', 'LATINO'),                  # Simpsons Hit & Run Latino
    'SLUS_209.46': ('SLUS-20946.jpg', 'LATINO'),                  # GTA San Andreas Latino
    'SLUS_216.78': ('SLUS-21678.jpg', None),                      # BT3 y sus mods
    'SLUS_219.78': ('SLUS-21678.jpg', 'TENKAICHI 4'),             # BT4 Beta 14 (mod)
    'SLUS_219.99': ('SLUS-21678.jpg', 'NIVELES DE PODER'),        # Niveles de Poder 8.1 (mod)
    'SCES_542.06': ('SCES-54206.jpg', None),                      # God of War II (PAL, DVD5)
    'SLES_543.62': ('SLES-54362.jpg', None),                      # PES 6 (PAL, español)
}
# Para los ISO de DVD\ con nombre sin código: copia con el nombre del archivo (OPL puede usarlo)
ALIAS = {'SLES_551.35': 'Lego Batman', 'SLUS_206.24': 'Simpsons Hit and Run Latino',
         'SCES_542.06': 'God of War II', 'SLES_543.62': 'PES 6'}


def fuente(tam):
    for f in ('C:/Windows/Fonts/arialbd.ttf', 'C:/Windows/Fonts/arial.ttf'):
        if os.path.exists(f):
            return ImageFont.truetype(f, tam)
    return ImageFont.load_default()


os.makedirs(ART, exist_ok=True)
for gid, (src, franja) in TAPAS.items():
    im = Image.open(os.path.join(SRC, src)).convert('RGB').resize((140, 200), Image.LANCZOS)
    if franja:
        d = ImageDraw.Draw(im)
        f = fuente(13 if len(franja) > 12 else 16)
        d.rectangle([0, 160, 140, 182], fill=(200, 20, 20))
        w = d.textlength(franja, font=f)
        d.text(((140 - w) / 2, 163), franja, font=f, fill=(255, 255, 255))
    # OPL 1.2 sólo busca PNG (src/textures.c, texDiscoverLoad arma "<ruta>.png"); JPG no se ve
    out = os.path.join(ART, f'{gid}_COV.png')
    im.save(out, 'PNG')
    print(out, os.path.getsize(out))
    if gid in ALIAS:
        im.save(os.path.join(ART, f'{ALIAS[gid]}_COV.png'), 'PNG')
