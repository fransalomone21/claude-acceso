# BLACK — ingeniería reversa

Herramientas y base de conocimiento para analizar y modificar **BLACK**
(PlayStation 2, Criterion Games, 2006) corriendo en PCSX2.

No es una colección de trucos. Es un método para *entender* el juego —sus
estructuras, sus rutinas, sus tablas— y que cada cosa que se entiende quede
anotada, verificable y reutilizable desde cualquiera de las dos máquinas.

Requiere tu propia copia del juego.

---

## Empezar

```bash
python3 pruebas/prueba_herramientas.py     # verifica el instrumental, sin PCSX2
python3 herramientas/pine.py info          # con PCSX2 abierto y el juego corriendo
```

Instalación completa (PCSX2, PINE, Python, Ghidra): **`docs/01-entorno.md`**.

---

## Qué hay acá

| Carpeta | Qué es |
|---|---|
| `herramientas/` | el instrumental: escaneo, inspección, parcheo, PINE |
| `kb/` | lo que sabemos del juego, en JSON, con confianza y evidencia |
| `mods/` | definiciones de mods en TOML → se compilan a `.pnach` |
| `docs/` | entorno, metodología, plan, bitácora, glosario del EE |
| `pruebas/` | 65 comprobaciones que corren sin PCSX2 |
| `volcados/` | memoria y CSVs de trabajo (ignorados por git) |

---

## Las herramientas

Todas tienen `--help`.

### `pine.py` — hablarle a PCSX2 en vivo

PINE es el canal IPC de PCSX2: permite leer y escribir la memoria del juego
mientras corre, sin parar nada.

```bash
python3 herramientas/pine.py info
python3 herramientas/pine.py leer 0x2038A0 --tipo u32
python3 herramientas/pine.py escribir 0x2038A0 500 --tipo u32
python3 herramientas/pine.py volcar 0x200000 0x1000 salida.bin
```

### `escanear.py` — encontrar una dirección

Escaneo diferencial sobre los 32 MB del Emotion Engine. Lo mismo que hace
Cheat Engine, pero scriptable y —lo importante— con cada paso registrado, así
que la búsqueda se puede repetir y auditar.

```bash
python3 herramientas/escanear.py nuevo vida --tipo u32 --pedir
python3 herramientas/escanear.py filtrar vida bajo --pedir      # te pegaron
python3 herramientas/escanear.py filtrar vida subio --pedir     # te curaste
python3 herramientas/escanear.py poner vida --indice 0 --valor 500
```

Las fotos de memoria salen de savestates (32 MB de un saque) y, cuando quedan
pocos candidatos, pasa solo a leer en vivo por PINE. Una pasada completa sobre
RAM realista tarda ~2 segundos.

Filtros: `=N` `!=N` `<N` `>N` `bajo` `subio` `igual` `cambio` `bajo=N`
`subio=N` `entre=A:B`.

### `inspeccionar.py` — entender una estructura

Cuando ya tenés una dirección buena, lo que sigue es mirar alrededor: los
campos de un mismo objeto viven pegados.

```bash
python3 herramientas/inspeccionar.py volcar 0x2038A0 --antes 0x40 --largo 0x100
python3 herramientas/inspeccionar.py comparar 0x203880 --largo 0x100 --guardar antes.bin
python3 herramientas/inspeccionar.py seguir 0x1F4000 0x1C 0x40
```

Marca lo que parece puntero, flotante razonable o texto, y en modo `comparar`
te dice exactamente qué campos se movieron entre dos momentos.

### `vigilar.py` — contestar "¿cada cuánto?"

Muestrea direcciones en el tiempo y analiza la serie: detecta escalones, mide
el intervalo entre ellos y calcula la tasa.

```bash
python3 herramientas/vigilar.py grabar --de-kb vida_jugador --hz 20 --segundos 60
python3 herramientas/vigilar.py analizar ../volcados/vigilancia-*.csv
```

Es la herramienta para medir regeneración, cadencia de disparo o dispersión de
daño, en vez de suponerlas.

### `mips.py` — parches de código

Muchas modificaciones no se hacen tocando un dato sino el código que lo toca.

```bash
python3 herramientas/mips.py des 0x10A2B4 0xAE02001C   # -> sw v0, 0x1C(s0)
python3 herramientas/mips.py ens "addiu v0, zero, 999"
python3 herramientas/mips.py li32 v0 0x00123456
```

### `pnach.py` — compilar los mods

Los mods se declaran en TOML con su nota y —si son parches de código— su
assembly en texto. El `.pnach` es el resultado compilado, no la fuente.

```bash
python3 herramientas/pnach.py listar
python3 herramientas/pnach.py compilar --instalar
```

### `fijar_objetivo.py` — confirmar la identidad del juego

Le pregunta a PCSX2 el serial y el CRC reales por PINE y actualiza
`kb/objetivo.json` solo: marca la versión como confirmada y la deja como
`version_activa`. Es el paso que cierra el checkpoint 0.

```bash
python3 herramientas/fijar_objetivo.py
```

### `windows/preparar_entorno.ps1` — automatizar todo lo anterior en Windows

Hace de punta a punta lo que describe `docs/01-entorno.md`: detecta Python,
instala numpy, activa PINE, apaga la compresión de savestates, abre PCSX2 y
corre `fijar_objetivo.py` al final. Pide UAC al arrancar.

```powershell
cd black\herramientas\windows
.\preparar_entorno.ps1 -IsoPath "D:\Juegos\BLACK.iso"
```

---

## Cómo se trabaja

El método está en **`docs/02-metodologia.md`** y es una escalera de cinco
escalones: dirección → rutina → estructura → clases → tablas. Cada escalón
desbloquea al siguiente, y saltarse uno es la causa más común de quedarse
trabado.

El plan por fases, la política de modelos y las reglas para no desperdiciar
contexto están en **`docs/04-plan.md`**.

En qué anda el proyecto ahora mismo: **`docs/03-bitacora.md`**.

---

## Una advertencia sobre las direcciones

Las direcciones dependen de la versión del juego. NTSC-U y PAL no comparten
nada. Por eso `kb/objetivo.json` tiene `version_activa`, todo lo anotado lleva
su versión, y `pnach.py` se niega a compilar si eso no está definido.

Es molesto exactamente una vez, y ahorra una tarde de perseguir un mod que
"antes funcionaba".
