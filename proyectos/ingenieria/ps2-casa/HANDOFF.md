# Handoff — ps2-casa

**Escrito el:** 2026-11-06 · **Fase al cerrar:** 0 (Pre-Fase A), abierta; el
arranque está resuelto en la 8C y la red anda.

## Arrancá por acá

1. `.\cascada.ps1 ps2-casa -Necesidad investigar` y leer lo que pida.
2. Fran prende la 8C con **R1 apretado** (sin disco, tarjeta en ranura 1) →
   uLaunchELF 4.43a, arriba `Net Config: 192.168.137.50`.
3. Cable directo PS2 ↔ notebook (placa «Ethernet 2», 192.168.137.1). Medir:
   `ping 192.168.137.50` y `Test-NetConnection 192.168.137.50 -Port 21`.
   El 2026-11-06 dieron **respuesta en 1 ms y puerto 21 abierto**.

## Lo que sigue, en orden

1. **Entrar por FTP** a 192.168.137.50 (usuario anónimo) y **respaldar la
   tarjeta entera a la PC** antes de tocar nada (regla 3 del contrato):
   carpetas BOOT, APPS, OPL, SYS-CONF, las Free McBoot y las partidas.
2. **Pendrive** (D:, etiqueta `HBCD_PE_X64`, FAT32, 14,3 GB): Fran pidió dejar
   un God of War o un Dragon Ball. No se copió: Fran se iba y un corte a mitad
   de copia deja el archivo roto. **God of War II (7,95 GB) no entra en FAT32**;
   los DBZ de `C:\Games\PS2-ISOs\` sí (Anime War 3,75; Crossover 2,96; BT3
   Remake 3,9; dbzpoderes 3,87). OPL los busca en `D:\DVD\`. Mirar antes qué
   tiene el pendrive (la etiqueta dice Hiren's Boot CD): agregar, no borrar.
3. **Juegos por red**: carpeta compartida (SMB) en la notebook del gobierno o
   en esta, con la estructura de OPL (`DVD\`, `CD\`), y OPL configurado a
   192.168.137.x. Ahí entra God of War II.
4. **Arranque sin R1** (opcional): Infinity Manager (△ al prender) → modo
   DEV1 → `mc0:/BOOT/BOOT.ELF`; después apuntarlo a OPL para la familia.
5. Escribir L0/L1 (fase 1) con el concepto ya probado.

## Lo que NO hay que volver a intentar

- Buscar exploit por la memoria de la tarjeta: la 8C tiene **chip Matrix
  Infinity 1.93** y R1 al prender lanza `mc0:/BOOT/BOOT.ELF` (uLaunchELF).
- Tocar la configuración de red de Windows: se cambió la IP de la PS2, no la
  de la notebook.
- Subagentes: Fran no los quiere (memoria «Sin agentes»).

## Datos que no se pueden aproximar

- Consolas: SCPH-90001 NTSC U/C, códigos 8C (anda; DVD 3.11U, Browser 1.40) y
  1C (**sin señal de video**).
- Chip de la 8C: Matrix Infinity 1.93. Botones al prender: R1 → BOOT.ELF;
  △ → Infinity Manager; START → chip apagado.
- Tarjeta: una sola, «Sony 64 MB» clon; tiene BOOT, APPS, OPL, cuatro Free
  McBoot, SYS-CONF y partidas.
- Red de la PS2 (en `mc0:/SYS-CONF/IPCONFIG.DAT`): 192.168.137.50 /
  255.255.255.0 / puerta 192.168.137.1. Antes era 192.168.0.10.
- Notebook: Ethernet 2 = 192.168.137.1/24 (Windows comparte internet ahí);
  WiFi 192.168.1.3.
- ISOs: `C:\Games\PS2-ISOs\` y `Desktop\Juegos\Juegos de emulador\PS2\`.

## Si hay que abrir un chat nuevo

```
0. Libro primero (regla 16) si no estás en la PC de Fran.
1. En claude-acceso: .\cascada.ps1 ps2-casa -Necesidad investigar ; leé lo que pide (incluye este HANDOFF).
2. Fase 0, Pre-Fase A. La cierra: concepto elegido en PDP §6 con el ROM medido. El arranque ya está (chip Infinity + R1 → uLaunchELF 4.43a); la red anda (ping 1 ms, FTP abierto en 192.168.137.50).
3. Opus, esfuerzo medio, sin fan-out y SIN subagentes.
4. Máquina: nada instalado en Windows para la PS2; la PS2 tiene IP 192.168.137.50 guardada en la tarjeta; el pendrive D: (FAT32) sin juegos copiados.
5. Resuelto: arranque, red, inventario de ISOs, investigación (docs/investigacion-red.md).
6. Primer paso: con Fran prendiendo la 8C con R1 y el cable puesto, medir ping y puerto 21; después respaldar la tarjeta por FTP.
7. El efecto a ver: "Respuesta desde 192.168.137.50" en el ping y TcpTestSucceeded True.
```
