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
2. **Niveles de Poder 8.1 al pendrive** (`SLUS_219.99`, 4,67 GB, entra): con el pendrive en la notebook,
   `herramientas/iso_a_ul.py <iso> D:/ SLUS_219.99 "DBZ Niveles de Poder 8.1" --dvd` (ruta del ISO en RUTAS).
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
