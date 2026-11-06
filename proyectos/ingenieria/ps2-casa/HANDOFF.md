# Handoff — ps2-casa

**Escrito el:** 2026-11-06 (tarde) · **Fase al cerrar:** 0 (Pre-Fase A), abierta:
ROM de la 8C medido (2.30); falta el de la 1C (sin video) y la elección escrita en PDP §6.

## Arrancá por acá

0. **Antes de buscar cualquier ruta, IP o carpeta: `RUTAS.md`** (todo lo ya encontrado; no se vuelve a buscar).
1. `.\cascada.ps1 ps2-casa -Necesidad investigar` y leer lo que pida.
2. Uso diario (Fran, 2026-11-06): **R1 al prender → OPL directo** (`BOOT/BOOT.ELF` es el OPL; el uLE no
   leía su config y su cuenta automática nunca andaba). [hipótesis hasta la foto de Fran: que abra así]
3. Para FTP: **R2** al prender (o L2, o Aplicaciones → uLaunchELF en el OPL) → uLE → **MISC → PS2Net**, y
   `Test-NetConnection 192.168.137.50 -Port 21` → True.

## Lo que sigue, en orden

1. **Que Fran confirme con foto** la lista del OPL en la tele: LEGO Batman, Simpsons y **BT4 partido (ul)**.
   Si LEGO Batman (PAL) se ve mal: opciones del juego en OPL → modo de video NTSC (GSM).
2. Hecho 2026-11-06: Niveles de Poder 8.1 en el pendrive (5 partes, suma = ISO), tapas en `D:\ART`, tema
   Pixel-Prime en `D:\THM`, LEGO Batman con NTSC forzado (`D:\CFG`). Falta que Fran vea tapas y tema en la tele.
3. **Juegos por red** (God of War II, GTA SA, el resto de DBZ): **decisión de Fran pendiente**. El OPL sólo
   habla SMB1. impacket (servidor en Python) lo bloquea Defender como hacktool: no usar. Caminos:
   (a) Fran activa SMB1 en Windows (ajuste de seguridad, es suyo) y se comparte `PS2SMB`;
   (b) Neutrino + udpbd-server (otro cargador en la tarjeta, sin tocar Windows).
4. **Sin R1** (Fran lo dejó con R1): sólo con una **tarjeta Sony original** (la de 8 MB de Agustín) en la
   ranura 2 y `BOOT/INSTALAR.ELF` eligiendo «mem 2». En ROM 2.30 es dudoso que arranque sin entrar al Explorador.
5. La 1C (sin video) y escribir el concepto elegido en PDP §6 → cierra la fase 0.

## Lo que NO hay que volver a intentar

- **DEV1 del chip** (menú con △+○ al prender): se guardó y cae al menú de Sony. Este clon 1.93 no lo cumple.
- **Free McBoot**: no cubre ROM 2.30. Ya se sacó de la tarjeta.
- **Instalador PS2BBL+OpenTuna con la tarjeta clon de 64 MB**: «No memory card detected» (código 1) eligiendo mem 1.
- **OpenTuna 1.0.1 por .psu** (`C:\Games\PS2-respaldos\opentuna-1.0.1\`): su guía dice que en Slim se ejecuta
  entrando al Explorador → tarjeta → atrás dos veces. Más pasos que R1. Además pide psuPaste de uLE, no FTP.
- **impacket** como servidor SMB: Defender lo pone en cuarentena (2026-11-06). Se desinstaló.
- Tocar la red de Windows: se cambió la IP de la PS2, no la de la notebook.
- Subagentes: Fran no los quiere.

## Datos que no se pueden aproximar

- 8C: SCPH-90001, **ROM 2.30** (`0230AC20080220`), chip Matrix Infinity 1.93 (R1 → `mc0:/BOOT/BOOT.ELF`).
- 1C: sin señal de video.
- Tarjeta (clon 64 MB) ahora: BOOT (uLE, OPL 1.2.0-Beta-2271, OPL viejo, INSTALAR.ELF), OPL (config + español),
  SYS-CONF (IPCONFIG, LAUNCHELF.CNF con autostart, PS2BBL.INI, irx), BADATA-SYSTEM, partidas BT3 y BT4.
- OPL: `vmode=2` (NTSC 480i, cable compuesto), `usb_mode=2`, `eth_mode=1`, `default_device=0`.
- Respaldos: `C:\Games\PS2-respaldos\mc0-2026-11-06\` (mañana) y `mc0-2026-11-06-tarde\` (antes de sacar FMCB).
- Pendrive SanDisk Cruzer Blade 16 GB FAT32, ~7 MB/s de escritura.

## Proyecto nuevo pedido por Fran (2026-11-06): DBZ con los personajes del BT4 y niveles de poder realistas

No es parte de ps2-casa: nace como proyecto propio (`nuevo-proyecto.ps1`). Retome listo para pegar:

```
0. Libro primero (regla 16) si no estás en la PC de Fran.
1. En claude-acceso: .\nuevo-proyecto.ps1 dbz-niveles-bt4 -Naturaleza ingenieria  (carpeta, PDP, contrato, ESTADO, HANDOFF). Después .\cascada.ps1 dbz-niveles-bt4 -Necesidad ingenieria-inversa,investigar y leé lo que pida. Leé también proyectos/ingenieria/ps2-casa/RUTAS.md (rutas de ISOs, IDs y herramientas ya encontradas: no buscar dos veces).
2. Fase: Pre-Fase A (estudio de conceptos). La cierra: en el PDP, (a) la necesidad en una frase, (b) cómo hace el ISO «Niveles de Poder» para dar poderes distintos por personaje (qué archivos/tablas toca, medido con diff contra el BT3 y el BT4), (c) la tabla de niveles a usar con su fuente (wiki/fandom) y su conversión a los parámetros del juego, y (d) el camino elegido con Fran (parchear el BT4 con el método de Niveles, o pasar los personajes del BT4 al Niveles). Nada de fabricar el ISO antes de eso.
3. Opus, esfuerzo alto, sin fan-out y SIN subagentes (primera hipótesis en territorio desconocido; Fran no quiere agentes).
4. Máquina: ISOs en C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\ — «DBZ Budokai Tenkaichi 4 (Beta 14 REV2)\SLUS_219.78.DBZBT4B14REV2.iso» (5,40 GB, ELF SLUS_219.78, partida BASLUS-21978DBZT4, trae «Public Changelog.txt») y «DBZ Niveles de Poder (Beta 8.1)\ISO niveles de poder BETA 8.1.ISO» (4,67 GB, ELF SLUS_219.99, partida BASLUS-21678DBZT3). Base de los dos: BT3 NTSC (SLUS_216.78; «DBZ BT3 ISO Remake AF V6.iso» en C:\Games\PS2-ISOs\ sirve de referencia). Comprimidos originales en Downloads (DBZBT4PS2B14REV2.rar, ISO niveles de poder BETA 8.1.rar). 7-Zip en C:\Program Files\7-Zip\7z.exe (desde Bash: -p...). Emulador para probar: el de la PC (memcards en Documents, carpeta del emulador; ojo: nombrar al emulador en un comando dispara la puerta, DA-118: usar globs).
5. Resuelto: los dos ISOs corren en la PS2 por OPL (ps2-casa); la partida al 100% de BT3/BT4 está en la tarjeta del emulador «BT3-TODO-DESBLOQUEADO.ps2»; mymcplus instalado (lee/escribe memcards); iso_a_ul.py parte ISOs > 4 GiB para el pendrive.
6. Primer paso: investigar (web + los dos ISOs) cómo se modifican los stats de personajes en BT3/BT4 (herramientas de la comunidad, formato de los archivos de personaje) ANTES de abrir el ISO a mano; listar archivos de los dos ISOs (7z l) y diffear cuáles cambian entre BT3, BT4 y Niveles.
7. El efecto a ver al cerrar la fase: en el PDP, una tabla «personaje → nivel de poder (fuente) → parámetro del juego» para 3 personajes de prueba, y el camino elegido con fecha.
```

## Si hay que abrir un chat nuevo

```
0. Libro primero (regla 16) si no estás en la PC de Fran.
1. En claude-acceso: .\cascada.ps1 ps2-casa -Necesidad investigar ; leé lo que pide (incluye este HANDOFF y RUTAS.md).
2. Fase 0, Pre-Fase A. La cierra: concepto elegido en PDP §6 + ROMVER de las dos (8C = 2.30, medido; 1C sin video).
3. Opus, esfuerzo medio, sin fan-out y SIN subagentes.
4. Máquina: la 8C arranca con R1 → uLE → 3 s → OPL; el pendrive tiene LEGO Batman, Simpsons y BT4 partido; nada instalado en Windows para la red.
5. Resuelto: respaldo, OPL nuevo en NTSC y español, tarjeta limpia, ROM medida, rutas en RUTAS.md.
6. Primer paso: pedirle a Fran la foto de la lista de juegos del OPL; después Niveles de Poder y la decisión de la red.
7. El efecto a ver: los 3 juegos en la pestaña USB del OPL, y uno arrancando.
```
