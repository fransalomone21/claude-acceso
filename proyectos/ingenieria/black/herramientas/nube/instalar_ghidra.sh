#!/usr/bin/env bash
# Ghidra 12.1.2 + ghidra-emotionengine-reloaded en la NUBE, sin GitHub releases.
#   bash proyectos/ingenieria/black/herramientas/nube/instalar_ghidra.sh
#
# Por qué así (bitácora (66)): el proxy de la nube da 403 a los *releases* de
# GitHub y sólo deja `git clone`. Entonces:
#   - Ghidra sale del caché binario de Nix (`ghidra-bin`, la misma 12.1.2
#     oficial), bajado con traer_nix.py, que verifica el NarHash firmado;
#   - la extensión se COMPILA desde su fuente, en el tag v2.1.36, que es el que
#     declara soporte para 12.1.2 (el HEAD ya es 12.1.3).
# Deja todo donde lo espera decompilar.py: ~/herramientas/ghidra_12.1.2_PUBLIC
# y el proyecto en ~/herramientas/ghidra-proyectos2/BLACK.
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"
H=$HOME/herramientas
G=$H/ghidra_12.1.2_PUBLIC
NIX_GHIDRA=hmccjb8iyf8qbdn8x8gvk2cl3zc1awgc   # ghidra-bin 12.1.2, de Hydra
export JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-21-openjdk-amd64}
mkdir -p "$H"
pip install -q zstandard pyghidra 2>&1 | grep -v WARNING || true

if [ ! -d "$G" ]; then
  python3 "$AQUI/traer_nix.py" $NIX_GHIDRA
  cp -r /nix/store/$NIX_GHIDRA-ghidra-12.1.2/lib/ghidra "$G"
  chmod -R u+w "$G"
  # El launch.sh de Nix es un envoltorio que ejecuta la copia de /nix/store,
  # cuyo Extensions/ es de sólo lectura: la extensión nunca se cargaba y el
  # import decía «Unsupported language: r5900». Se usa el script real.
  cp "$G/support/.launch.sh-wrapped" "$G/support/launch.sh"
fi

EXT=$G/Ghidra/Extensions/ghidra-emotionengine-reloaded
if [ ! -d "$EXT" ]; then
  SRC=/home/user/chaoticgd/ghidra-emotionengine-reloaded
  [ -d "$SRC" ] || GIT_LFS_SKIP_SMUDGE=1 git clone -q --depth 50 \
      https://github.com/chaoticgd/ghidra-emotionengine-reloaded "$SRC"
  git -C "$SRC" checkout -q v2.1.36
  if [ ! -d "$H/gradle-8.14.3" ]; then
    curl -sSL -o "$H/gradle.zip" https://services.gradle.org/distributions/gradle-8.14.3-bin.zip
    (cd "$H" && unzip -q gradle.zip)
  fi
  (cd "$SRC" && "$H/gradle-8.14.3/bin/gradle" -q --no-daemon -PGHIDRA_INSTALL_DIR="$G" buildExtension)
  (cd "$G/Ghidra/Extensions" && unzip -q -o "$SRC"/dist/*.zip)
fi

P=$H/ghidra-proyectos2
if [ ! -f "$P/BLACK.gpr" ]; then
  mkdir -p "$P"
  if [ -f /home/user/black-datos/ghidra/BLACK.tar.zst ]; then
    # el proyecto ya analizado, guardado en el repo privado
    (cd "$P" && python3 -c "import zstandard,sys,tarfile,io;tarfile.open(fileobj=io.BytesIO(zstandard.ZstdDecompressor().decompress(open(sys.argv[1],'rb').read(),max_output_size=2**32))).extractall('.')" /home/user/black-datos/ghidra/BLACK.tar.zst)
  else
    GHIDRA_HEADLESS_MAXMEM=8G "$G/support/analyzeHeadless" "$P" BLACK \
      -import /home/user/black-datos/SLUS_213.76 -processor "r5900:LE:32:default" -max-cpu 4
  fi
fi
cd "$AQUI/../.."
python3 herramientas/decompilar.py info
