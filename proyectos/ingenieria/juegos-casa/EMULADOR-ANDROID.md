# Emulador de Android en la PC de casa (PCFRAN)

Sesión rápida de casa, sin requisitos ni fases NASA (pedido de Fran, 2026-11-15).
Para que el hermano juegue **Drive Ahead** y otros juegos de Android.

## Estado (2026-11-15)

- BlueStacks 5 **instalado y configurado**. Arranque **bloqueado** hasta que Fran active la
  virtualización (SVM) en la BIOS de la PC. Evidencia: `systeminfo` dice «Se habilitó la
  virtualización en el firmware: No»; con eso, BlueStacks quedó 3+ minutos en «Iniciando
  BlueStacks» sin que arrancara la VM (causa: *probable*, no hay mensaje de error propio).
- Falta: que el hermano entre con su cuenta de Google en el Play Store e instale Drive Ahead.

## Por qué BlueStacks y no Nox

| | BlueStacks 5 | Nox | Google Play Games PC |
|---|---|---|---|
| Instalación | winget oficial (`BlueStack.BlueStacks`) | **no está en winget**; instalador del sitio, con historia de software de yapa y de un ataque a su actualizador (2021) | winget oficial (`Google.PlayGames`) |
| Rendimiento | bueno | bueno | bueno, pero catálogo cerrado |
| Virtualización | la pide en la práctica | la pide en AMD | la pide |
| Drive Ahead | sí (Play Store completo) | sí | **no confirmado** (no apareció en la búsqueda) |

Elegido: BlueStacks 5. Si Fran insiste con Nox, se instala desde el sitio oficial, rechazando todo lo extra.

## Qué hay en la PC (medido)

- Ryzen 7 5700G (8 núcleos / 16 hilos), 15,3 GB de RAM, RTX 3090, pantalla 2560x1440 a 143 Hz.
- Sólo hay disco C: (953 GB, **~11 GB libres** tras instalar). Hyper-V apagado.
- Sesión SSH con privilegios de administrador: el instalador corrió sin pedir UAC.

## Dónde quedó

- Programa: `C:\Games\BlueStacks\` (la carpeta de juegos que ya usa la PC). Los datos de la VM
  los fija el instalador en `C:\ProgramData\BlueStacks_nxt\` (no se pueden mover con winget).
- Acceso directo: `Escritorio\Juegos\Android - BlueStacks (Drive Ahead).lnk`
  (`HD-Player.exe --instance Nougat32`). El instalador dejó además «BlueStacks 5» y
  «BlueStacks Multi-Instance Manager» en el Escritorio público.
- Lanzador para abrirlo por SSH: `C:\Games\BlueStacks\abrir-bluestacks.bat`.
- Instancia: `Nougat32` (Android 7, 32 bits). Una Pie/Android 13 de 64 bits se crea desde el Multi-Instance Manager.
- Copia de la configuración original: `C:\ProgramData\BlueStacks_nxt\bluestacks.conf.bak-original`.

## Configuración puesta (leída del archivo `bluestacks.conf`)

| Clave `bst.instance.Nougat32.` | Valor |
|---|---|
| `cpus` | 4 |
| `ram` | 4096 MB |
| `fb_width` x `fb_height` | 1280 x 720 |
| `dpi` | 240 |
| `max_fps` / `enable_high_fps` | 60 / 1 |
| `graphics_renderer` | dx (DirectX, la RTX 3090 lo banca) |
| `display_name` | Android - Hermano |

Se edita con BlueStacks **cerrado** (si está abierto, pisa el archivo al salir).

## Lo que tiene que hacer Fran: activar SVM en la BIOS (una vez)

1. Reiniciar la PC y tocar `Supr` (o `F2`) varias veces para entrar a la BIOS.
2. Pasar al modo avanzado (`F7`) → **Advanced** → **CPU Configuration** → **SVM Mode** → **Enabled**
   (en algunas placas está en *Tweaker* / *M.I.T.* o se llama «AMD-V»).
3. Guardar y salir (`F10`). Al volver: abrir BlueStacks desde el acceso directo.
4. Medir: `systeminfo` debe decir «Se habilitó la virtualización en el firmware: Sí».

## Después de la BIOS

1. Abrir BlueStacks, entrar al **Play Store**, que el hermano ponga su cuenta de Google (la sesión no escribe contraseñas).
2. Buscar **Drive Ahead!** e instalar. No bajar APKs de terceros.
3. Teclado: BlueStacks carga solo el mapa por defecto de cada juego al abrirlo; si no hay, usar
   *Controles de juego* (Ctrl+Shift+A) y arrastrar teclas sobre los botones de pantalla.
   Hasta que el juego esté instalado no hay archivo de mapeo que dejar listo.
4. Para apagar publicidad: Ajustes → Preferencias → desactivar anuncios durante el juego,
   banner de inicio y apertura de la tienda al iniciar.

## Cómo agregar juegos más adelante

Abrir BlueStacks → Play Store → instalar. Si algo anda lento: subir `cpus` o `ram` en el
`.conf` (hay 15 GB de RAM; no pasar de 6144 con otros juegos abiertos). Cuidado con el
espacio: C: tiene ~11 GB libres.

## Cómo se hizo (para repetirlo)

- `winget install --id BlueStack.BlueStacks --silent --location C:\Games\BlueStacks` (3,5 GB).
- Por SSH no se ven ventanas: `.bat` + `schtasks /Create ... /SC ONCE /IT`, `/Run`, `/Delete`
  (la receta de Minecraft). Captura de pantalla de la PC: mismo truco con un script que
  usa `Graphics.CopyFromScreen` y se trae por `scp`.
- Había en Descargas de la PC un instalador viejo de «BlueStacks 10» bajado de la página de
  Drive Ahead: no se usó ni se tocó (decide el hermano si lo borra).
