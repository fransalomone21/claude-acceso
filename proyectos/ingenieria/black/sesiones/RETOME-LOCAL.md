# Mensaje de retome para una sesión LOCAL (notebook) después de una tanda en la nube

Copiar y pegar tal cual al abrir Claude Code en la notebook, en `claude-acceso`:

```
Retomo BLACK en LOCAL (notebook), después de la tanda en la NUBE del 2026-09-27 (plan del ELF completo, bitácoras (66)–(75)). Proyecto: proyectos/ingenieria/black.
0. RECOLECTAR LO DE LA NUBE: git pull en claude-acceso y en black-datos (el clon local del repo privado). Verificá que main tenga el commit de BLACK que tocó por última vez sesiones/HANDOFF.md (git log -1 -- proyectos/ingenieria/black/sesiones/HANDOFF.md). Si no está, pará.
1. Leé SOLO: el bloque «2026-09-27, CIERRE» de sesiones/HANDOFF.md, ESTADO_ACTUAL.md (sección EL PROGRAMA), PDP.md §4 «Proyecto COOP» y las 5 primeras entradas de docs/03-bitacora.md.
2. REGISTRAR, antes de tocar el emulador:
   a. Las SEIS lecciones del bloque CIERRE, con perfil-global/herramientas/aprender.py agregar (los comandos están escritos tal cual). Después: aprender.py sin-triage tiene que quedar limpio.
   b. .\chequeo-completo.ps1 -SoloSaboteadores (pendiente desde el 26/09) y .\verificar-estructura.ps1.
   c. python herramientas/programa.py verificar (0 rojos) y python pruebas/prueba_herramientas.py.
   d. Las herramientas nuevas de la nube (perfil_singleton.py, valuedb_aku.py) necesitan BLACK_DATOS apuntando al clon local de black-datos: corré su control positivo (python herramientas/valuedb_aku.py sale 0) y, si alguna ruta no resuelve, arreglala en kb/ubicaciones.json, no a mano.
3. Fase: COOP-A. Siguiente: UNA sesión de PCSX2 con el LOTE de sondas del bloque CIERRE (1, 3a–c, 4, 5a y las cuatro NUEVAS: disparadores, 0x0040D9A3, ValueDB y niveles de prueba). Cada PREDICCIÓN se escribe en la bitácora ANTES de correrla; cada resultado lleva su control. Tomá un volcado nuevo en juego y subilo con windows/subir-datos-nube.ps1.
4. Opus, esfuerzo high, SIN subagentes ni fan-out. Nunca Fable.
5. Cuadros PARA VOS y de fase al abrir cada respuesta. Grado de evidencia en todo (hipótesis/probable/confirmado). «Confirmado» es sólo efecto visto en pantalla/RAM con control.
6. AUTONOMÍA: trabajá solo, sonda tras sonda, sin pedirme permiso para lo técnico. Pará sólo si (a) el contexto llega al 40 %, (b) necesitás una decisión de valor mía (por ejemplo, si la cámara desactivada de 0x0040D9A3 funciona y hay que decidir si entra al mod), o (c) algo necesita que yo esté frente a la máquina (mandos, mirar la pantalla).
7. Checkpoint después de CADA sonda o grupo de sondas: bitácora + kb/ (K del nodo en kb/subsistemas.json) + commit + push a main. Al parar: ESTADO_ACTUAL + HANDOFF + actualizar este mensaje (y sesiones/RETOME-NUBE.md si lo que sigue vuelve a ser en frío).
```

**Por qué este orden:** lo que la nube no puede hacer (registrar en el perfil
global y correr los saboteadores en PowerShell) va antes que lo nuevo. Una
lección que no se registra el día que costó se pierde, y un verificador que no
se sabotea hace una semana no dice nada.
