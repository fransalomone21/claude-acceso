# 23 — Jugar BLACK en coop (la plataforma nueva), desde (133)

La plataforma es **black-seamless-coop v2026.10.18.2**: el port nativo BLACK-XBERecomp con el coop adentro (hasta 8
jugadores, por red), instalado en `C:\Games\BLACK\coop` con `assets\Black (USA).iso`. Lo medido está en
`sesiones/PREDICCIONES-133.md`; acá va cómo se juega.

## Preparar una máquina: un comando (desde (133b))

En cada computadora (la notebook ya está hecha), en una consola de PowerShell:

```powershell
git -C "$env:USERPROFILE\Desktop\claude-acceso" pull; powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\PREPARAR-BLACK.ps1"
```

Instala lo que falte (coop con su sha256, la ISO desde su zip), controla que el `BLACK.exe` sea el mismo en las dos,
instala pygame, **elige la calidad gráfica según el monitor y la placa** (guardada en `C:\Games\BLACK\coop\calidad.toml`
y reaplicada por cada lanzador), mira red y firewall, y deja los accesos en `Escritorio\Juegos\BLACK`: **BLACK solo**,
**coop - hostear**, **coop - unirse** (pide la IP y recuerda la última), **coop - misma maquina**, **coop - dos pantallas**.
Medido en la notebook el 2026-10-30: RTX 4060 Laptop, 1080p → render 150 %, MSAA 4x + SMAA, anisotrópico 16x,
distancia 8x, GTAO, tope de cuadros = la frecuencia del monitor. Con dos copias en la misma máquina el render baja a
100 %. Los cuadros por segundo con esa calidad **no se midieron todavía**.

## Pasarle todo a la PC sin internet (la PC sólo tiene cable)

Con la PC enchufada por cable directo a la notebook, la PC no tiene internet, pero sí ve a la notebook: alcanza para
pasarle todo y para jugar. Windows les da a las dos una IP `169.254.x.x` sola, en un minuto, y el coop se une a esa.

- **Por el cable** (más rápido, y sirve para cualquier carpeta en el futuro): en la notebook
  `lanzadores\SERVIR-A-LA-PC.ps1` (arma el paquete y lo sirve, sólo lectura y sólo en la IP del cable, hasta Ctrl+C);
  imprime el comando exacto para pegar en la PC. Para otra carpeta: `-Carpeta "D:\lo que sea"`.
- **Por pendrive** (exFAT o NTFS, 16 GB o más): `lanzadores\PAQUETE-PC.ps1 -Destino E:\`. En la PC, abrir el pendrive
  y hacer **doble clic en `BLACK-para-la-PC\paquete-pc\INSTALAR-BLACK.bat`** (desde (134)): corre `TRAER` solo, sin
  tipear nada. Para ver la PC en vivo y manejarla (no hace falta para jugar) está Escritorio remoto, y sólo si la PC
  es Windows Pro: lo prende Fran en Configuración → Sistema → Escritorio remoto (`docs/20` §11).

En la PC, `TRAER.ps1` copia y verifica cada archivo por sha256 (si se corta, se vuelve a correr y retoma), instala
Python si falta y pygame sin internet, pone el repo al día desde un git bundle (si la PC tiene cambios propios no lo
toca y usa los lanzadores sueltos del paquete), corre `PREPARAR-BLACK.ps1` y anota la IP de la notebook para «BLACK
coop - unirse». Paquete medido el 2026-10-30: 7,6 GB (el disco es 7,3).

## Tres maneras de jugar de a dos, de mejor a peor

| | Cómo | Ventaja | Medido |
|---|---|---|---|
| **1. Dos computadoras** | `JUGAR-COOP-RED.ps1 -Anfitrion` en una, `-Unirse <IP>` en la otra | cada uno su pantalla, su sonido y sus fps; es el camino principal del mod (su autor terminó la campaña así) | **no**: el coop por red se probó sólo dentro de la notebook (127.0.0.1) |
| **2. Notebook + monitor** | enchufar el monitor y `PROBAR-COOP-PC.ps1 -DosMonitores` | una ventana entera por pantalla, una sola máquina | lado a lado sí; con monitor no (no había uno enchufado) |
| **3. Notebook sola** | `PROBAR-COOP-PC.ps1` | cero preparación | **sí**: 145 cuadros por segundo cada copia, cada mando su ventana (Fran) |

En la 2 y la 3 las dos copias suenan por el mismo parlante (cada uno escucha su arma; el ambiente sale doble). En la 1
no hay ese problema.

## La opción 1, paso a paso (notebook de Fran + PC)

1. **En la PC:** `git pull` en `C:\Users\frans\Desktop\claude-acceso`. Necesita Python (el de las herramientas).
2. **El disco en la PC:** tiene que estar `C:\Games\BLACK\xbox\iso-redump\Black (USA).zip` (6,5 GB). Si no está, se
   copia desde la notebook (pendrive o carpeta compartida). El lanzador lo dice si falta.
3. **En la notebook (anfitriona):** `JUGAR-COOP-RED.ps1 -Anfitrion`. Muestra las IP: la de la red de casa es
   `192.168.1.3` (cable) o `192.168.1.4` (Wi-Fi), medidas el 2026-10-30; puede cambiar, se usa la que imprima.
4. **En la PC:** `JUGAR-COOP-RED.ps1 -Unirse 192.168.1.3`. La primera vez instala el coop solo (lo baja de GitHub y
   verifica el sha256) y saca la ISO del zip (~1,5 min). Avisa si el `BLACK.exe` no es el mismo que el de la notebook.
5. La anfitriona elige la misión; la otra entra sola, aunque sea a mitad de nivel.

**Por cable mejor:** con la PC y la notebook por Ethernet al mismo router se evita el retardo y los cortes del
Wi-Fi; la notebook ya está por cable (`192.168.1.3`). **Red:** el juego usa UDP 45410. En la notebook el firewall ya lo permite (regla «Black - XBE Recomp», red privada y
pública, medido); en la PC, la primera vez Windows pregunta: **Permitir**. **A distancia** (Agustín en su casa): la
notebook está en una red ZeroTier (`10.147.20.2`, la del server de Minecraft); si la máquina de Agustín está en la
misma red, `-Unirse 10.147.20.2`. Que la otra esté en esa red no se midió.

## Los controles

Con el mando, los lanzadores pasan por el **puente** (`herramientas/puente_mandos.py`), que traduce a los botones de
BLACK de PS2 que Fran usaba en PCSX2 (`docs/10-jugar.md`). Con el puente no hay teclado ni mouse en el juego.

| Acción | Mando (perfil PS2, el de siempre) | Teclado y mouse (`-Teclado`) |
|---|---|---|
| disparar | R1 | click izquierdo |
| apuntar | L1 | click derecho |
| granada | R2 | G |
| agacharse | L2 | C |
| recargar | X (cruz) | R |
| cuerpo a cuerpo | círculo | V |
| agarrar / cambiar arma del piso | cuadrado | F |
| silenciador | triángulo | T |
| modo de disparo / zoom de la mira | flecha ↑ | X |
| botiquín | flecha ↓ | H |
| arma anterior / siguiente | flechas ← / → | Q / E, rueda |
| ir con el compañero (coop) | L3 + R3, un segundo | F8 |
| pausa / objetivos | Options / Share | Esc / Tab |

`-Xbox` deja los botones de Xbox tal cual (RT dispara, click del stick derecho apunta). «Hold to Aim» (mantener para
apuntar) se cambia en el menú: Recomp Settings → Controller.

## Las reglas del coop (del mod)

- Si uno cae, **no se pierde**: queda caído mirando al compañero y vuelve en la próxima zona u objetivo. Se pierde la
  misión sólo si caen los dos.
- Las zonas cargan para los dos: el primero que llega a la puerta espera al otro. Trabado o perdido: **L3 + R3** (F8).
- Objetivos, recogibles, continuar y reiniciar valen para los dos. Cada uno guarda su progreso.
- **Todavía no sincroniza:** las escenas (cutscenes) y los vehículos.
- La anfitriona maneja a los enemigos: conviene que hostee la máquina más estable.

## La dificultad

El juego tiene cuatro (`*(0x2D45F0)+0x2014C` = 0..3, leído en el coop: `coop.cpp`, `LoadMission`); la que elige la
**anfitriona** es la de los dos (la otra la copia al unirse). Fran jugó (133) en la 2 (Hard). La 3 es **Black Ops**:
si el menú no la ofrece, está bloqueada (*hipótesis*: se desbloquea terminando en Hard; no se midió). **Más difícil que
Black Ops** (más daño recibido, menos munición, más enemigos) no existe en el juego: es un mod de reglas, L0-07 /
L1-29 de `docs/20` (una función propia en lugar de la del juego), y va en la fase que sigue a PLAT-PreA. Forzar la 3
desde afuera tampoco se puede hoy: el canal de control del coop sólo escribe números con coma (`pokef`), no enteros.

## Ajustes de imagen recomendados (Recomp Settings, F10 o el menú de opciones)

Max Frame Rate 144 (el monitor de la notebook) con V-Sync; Render Resolution 150 % (125 % si baja de 60); MSAA 4x y
SMAA; Anisotropic 16x; Draw Distance 8x; Ambient Occlusion GTAO; Field of View 85-90 a gusto. HDR no: el monitor no lo
soporta. Si a más de 60 cuadros algo se ve raro (física, animaciones), volver Max Frame Rate a 60: el juego original
corría a 30 y no se midió por encima.

## Si algo falla

- **No conectan:** el mismo `BLACK.exe` en las dos (el lanzador avisa), la IP correcta, Permitir en el firewall.
- **El juego se cierra:** el lanzador guarda `logs\` y los CrashDumps nuevos en `volcados\plataforma\<fecha>-...\`;
  la sesión los lee.
- **Un mando no responde:** que esté prendido antes de abrir el lanzador (`python herramientas\puente_mandos.py
  --listar` dice cuántos ve).
