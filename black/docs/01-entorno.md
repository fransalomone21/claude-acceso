# Entorno

Cómo dejar una máquina lista para trabajar. Hay que hacerlo una vez por equipo
(la PC y la notebook). Al final hay una verificación que dice si quedó bien.

---

## 0. Windows: el camino automático

Si PCSX2 ya está instalado (con o sin BLACK cargado), este script hace por
vos los pasos 1 a 5 de más abajo: detecta Python, instala numpy, activa PINE,
apaga la compresión de savestates, abre PCSX2 si hace falta, y confirma la
identidad del juego en `kb/objetivo.json`.

```powershell
cd black\herramientas\windows
.\preparar_entorno.ps1
```

Va a pedir permisos de administrador (UAC) al arrancar — aceptalo. Con una
ISO a mano, para que también abra el juego directo:

```powershell
.\preparar_entorno.ps1 -IsoPath "D:\Juegos\BLACK.iso"
```

Si PowerShell se queja de la política de ejecución de scripts, corré esto una
vez (afecta sólo a tu usuario, no hace falta admin):

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

**Qué hace exactamente, y qué NO hace:**

- Antes de tocar el `.ini` de PCSX2, guarda una copia (`PCSX2.ini.respaldo-<fecha>`)
  al lado del original.
- Si PCSX2 ya está corriendo, **no toca el `.ini`**: PCSX2 lo pisaría con lo
  que tiene en memoria al cerrarse, así que editarlo en ese momento no serviría
  de nada. Te avisa y hay que cerrarlo primero.
- No fuerza el cierre de ningún proceso, nunca.
- Todo lo que hace queda en un log dentro de `black/volcados/diagnostico-entorno-<fecha>.txt`.
- Ver `.\preparar_entorno.ps1 -?` para las opciones (`-Pcsx2Exe`, `-SinElevar`,
  `-SinPatchIni`, `-EsperaSegundos`).

Si algo sale mal o preferís entender cada paso, seguí manual desde el punto 1.

---

## 1. PCSX2

Necesitás **PCSX2 2.x** (la rama con la interfaz Qt). Es la que trae el
debugger completo y PINE. Descarga: <https://pcsx2.net/downloads>.

Tres ajustes que no son opcionales para este proyecto:

### PINE — el canal por el que le hablan las herramientas

`Settings > Advanced > PINE Settings`

- **Enable PINE**: sí
- **Slot**: `28011` (el que esperan las herramientas)

Sin esto, `pine.py`, `vigilar.py` e `inspeccionar.py` no funcionan.

### Compresión de savestates — ponela en "Uncompressed"

`Settings > Advanced > Savestate Compression` → **Uncompressed**

Por defecto PCSX2 usa zstd, que Python no lee sin una dependencia extra. Sin
comprimir ocupa más disco, pero guarda y carga más rápido — que es lo que
importa cuando vas a hacer treinta savestates en una tarde.

> Si preferís dejar zstd: `pip install zstandard` y `estado.py` lo destraba
> solo. Lo que **no** sirve es Deflate64: Python no lo soporta.

### Debugger

`Tools > Show Advanced Settings` (tildarlo) y después `Debug > Open Debugger`.
En PCSX2 2.x **no** está en el menú Tools. Es la única pieza que estas herramientas no
reemplazan: los breakpoints de ejecución y de escritura son lo que convierte
una dirección en una rutina.

---

## 2. Python

Hace falta **3.11 o más nuevo** (por `tomllib`, que lee las definiciones de
mods).

```bash
python3 --version      # tiene que decir 3.11+
pip install numpy      # opcional pero muy recomendable
```

`numpy` no es obligatorio. Sin él, el primer filtro de un escaneo tiene que ser
por valor exacto (`=100`). Con él, podés arrancar sin saber el valor y filtrar
por "bajó", que es como se encuentra la vida en la práctica.

Verificá que todo esté sano — esto **no** necesita PCSX2 abierto:

```bash
cd black
python3 pruebas/prueba_herramientas.py
```

---

## 3. Ghidra + Emotion Engine  *(para el trabajo de fondo)*

Para el escaneo y los parches puntuales no hace falta. Hace falta cuando
quieras entender una rutina entera en vez de una instrucción, o buscar
referencias cruzadas a una tabla.

1. **Ghidra**: <https://ghidra-sre.org/>
2. **Extensión del EE**:
   [`chaoticgd/ghidra-emotionengine-reloaded`](https://github.com/chaoticgd/ghidra-emotionengine-reloaded).
   Bajá el release que coincida con tu versión de Ghidra e instalalo con
   `File > Install Extensions`.

Esa extensión aporta dos cosas que valen mucho:

- El procesador **MIPS-R5900** de verdad, con las instrucciones de 128 bits y
  las unidades vectoriales que el MIPS genérico de Ghidra no entiende.
- El **MIPS-R5900 Constant Reference Analyzer**, que reconstruye las
  referencias a variables globales. Sin él, la mitad de los accesos a datos
  quedan como constantes sueltas y no podés seguir nada.

### Qué cargar en Ghidra

Dos caminos, y conviene usar los dos:

**a) El ELF del juego, desde tu propio disco.** Montá tu ISO y copiá el
ejecutable de la raíz (`SLUS_213.76` o el que corresponda a tu región). Es el
código estático: ideal para leer funciones, seguir referencias cruzadas y
buscar cadenas de texto.

**b) Un savestate.** La extensión abre savestates de PCSX2 directamente, con la
memoria ya cargada — datos dinámicos incluidos. Para esto también conviene la
compresión "Uncompressed".

> Las direcciones de Ghidra y las de PCSX2/`.pnach` son el mismo espacio (la
> RAM del EE arranca en `0x00000000` y el ELF se carga alrededor de
> `0x00100000`). Lo que ves en Ghidra se usa tal cual en un parche.

---

## 4. El repositorio

```bash
git clone https://github.com/fransalomone21/claude-acceso
cd claude-acceso
git checkout claude/black-game-reverse-engineering-ricv3t
cd black
```

Igual en las dos máquinas. Lo que sincroniza el trabajo es `git pull` /
`git push`, no copiar carpetas a mano.

`volcados/` está ignorado por git a propósito: son archivos de 32 MB que no
tiene sentido versionar. Si un volcado concreto importa (por ejemplo, el
entorno de una estructura que estás mapeando), forzalo con
`git add -f volcados/loquesea.bin` y explicá en la bitácora por qué.

---

## 5. Verificación

Con PCSX2 abierto **y el juego cargado y corriendo** (no en el menú de PCSX2):

```bash
python3 herramientas/pine.py info
```

Tiene que salir algo así:

```
transporte       unix:/run/user/1000/pcsx2.sock
version_pcsx2    PCSX2 2.x.x
titulo           Black
serial           SLUS-21376
crc              5C891FF1
estado           corriendo
```

**Copiá `serial` y `crc` a `kb/objetivo.json`** y poné `version_activa` con la
clave que corresponda. Es el primer dato real del proyecto: sin él, `pnach.py`
no compila, y con el valor equivocado todas las direcciones que anotes después
no van a servir en la otra máquina.

### Si `pine.py info` falla

| Síntoma | Causa habitual |
|---|---|
| "No pude conectarme… probé unix:… tcp:…" | PINE apagado, o PCSX2 sin juego cargado |
| conecta pero `titulo` vacío | el juego no arrancó todavía; dale play |
| en Windows no encuentra el socket | normal: en Windows PINE es TCP, y el cliente lo intenta solo |
| el slot no es 28011 | `python3 herramientas/pine.py --slot <n> info` |
