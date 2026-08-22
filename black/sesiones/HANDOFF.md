# Handoff

Se sobreescribe en cada cierre de sesión relevante. No es historial (para eso,
`docs/03-bitacora.md`); es el paquete mínimo para que una sesión nueva, sin
memoria del chat anterior, retome exactamente donde quedó ésta.

Última actualización: **2026-08-22**, PC, **en frío sobre el ELF** (el
emulador no hizo falta en ningún momento).
**7c CERRADA, con respuesta.** El bloque de IA del arma **no lo elige ningún
campo**: es el descriptor de arma **+`0x30`**, un offset fijo en una sola
instrucción. Lo que sigue (7d) es el último eslabón: quién decide **qué
descriptor** le toca a cada enemigo.

> **La sesión terminó con un apagado de la máquina** (ver §5). El hallazgo
> estaba escrito en `kb/` pero sin commitear; se recuperó y ya está pusheado
> en `143b880`. Nada quedó pendiente de escribir.

---

## 1. QUÉ LEER, EN ORDEN

1. `black/ESTADO_ACTUAL.md` — el bloque **7c/7d** en N2 y las dos primeras
   filas de la tabla de hechos.
2. `black/docs/03-bitacora.md`, **sólo la entrada (34)**. Es larga pero es
   toda la cadena; la (33) ya está resumida acá abajo.
3. `black/kb/rutinas.json`, las entradas `arma_instancia_init` y
   `arma_instancia_asignar` — tienen la convención de llamada y los puntos
   de parche con las instrucciones originales.

**NO leer** salvo que la tarea lo pida: `docs/01-entorno.md`,
`docs/05-iso.md`, `docs/90-glosario-ee.md`, las entradas (29)–(33), y nada
de `perfil-global/`.

## 2. LA FASE, Y QUÉ LA CIERRA

**7d — quién escribe `slot_0x110 + 0xEC`**, o sea quién decide qué descriptor
de arma se le asigna al slot **antes** de que `FUN_0015D060` lo lea y se lo
pase a `FUN_00158F50`.

**Cierra cuando** se identifique la instrucción que escribe ese campo y de
dónde saca el valor — y, con eso, si el arma del enemigo se puede fijar desde
un archivo del ISO (que es lo que se viene buscando desde 7a) o si es un
puntero que sólo existe en runtime.

**Por qué éste es el eslabón que importa:** es el único punto de la cadena
donde todavía hay una *decisión*. Todo lo de abajo ya está resuelto y es
mecánico:

```
slot_0x110 + 0xEC  =  descriptor de arma      <-- 7d: ESTO no se sabe quién lo escribe
        │
        ├─ FUN_0015D060 (0x0015D060) lo lee, elige la entrada n del pool
        │  (primer byte libre de manager+0x10) y llama a
        │
        └─ FUN_00158F50 (0x00158F50):
              entrada+0x08 = descriptor          (bloque del jugador)
              entrada+0x0C = descriptor + 0x30   (bloque de IA)  <-- offset FIJO
```

**Camino concreto, ya acotado:** stores a `+0xEC` en el rango del subsistema
`0x00155000`–`0x0015D200`. La técnica que funcionó en 7c está en el §6.

## 3. LO QUE ESTA SESIÓN DEJÓ RESUELTO — no rehacer

- **`FUN_00158F50` @ `0x00158F50`–`0x0015911F` es la función que escribe el
  puntero de `0x006E18B8 + n*0x24 + 0x04`.** Confirmado.
  - `0x00159008  addiu $4, $16, 0x30` → rama **NPC**: `entrada+0x0C =
    descriptor + 0x30`.
  - `0x00158FF4  sw $16, 0xc($17)` → rama **jugador**: sin desplazar.
  - Discriminante: `*(int*)(*(int*)(slot+0xF0) + 0xC4) == 2` → jugador.
- **`+0x8C` y `+0xA8` del registro de personaje quedan DESCARTADOS por
  lectura.** No participan de la cadena. No gastar un parche de ISO en
  probarlos: la (33) ya había refutado `+0x78` por efecto, y ahora se sabe
  *por qué* ninguno de los tres podía funcionar.
- **La base real del pool es `0x006E18B0`, paso `0x24`, `0x32` (50)
  entradas**, hasta `0x006E1FB8`. La base vieja `0x006E18B8` que usa todo el
  `kb/` es `entrada_0 + 0x08`: **coincide entrada por entrada**, así que
  nada de lo anotado se invalida, pero los offsets están corridos 8.
  Layout real en `kb/mapa-memoria.json#arma_bloque_ia_por_instancia`.
- **`n` no significa nada.** Es el primer byte libre del array de ocupación
  de `manager+0x10`, recorrido linealmente por `FUN_0015D060`. Por eso el
  array se llenaba progresivamente al spawnear y el orden no es estable.
- **La cadena de punteros hasta lo estático:** pool `0x006E18B0` → manager
  `0x005AE880` → global `.bss` **`0x0040F4E0`** (malloc de `0xFE0` en
  `FUN_001020C0` @ `0x00102478`, init en `FUN_0015C970`).
- **Los perfiles de arma son una tabla de paso `0x30`** en `0x01842xxx`; el
  par (jugador, IA) es siempre `(X, X+0x30)`. Si los dos punteros de una
  entrada son **iguales**, es el jugador.
- Sigue valiendo de antes: `+0x78` = modelo **visual** del arma
  (`FUN_00136848`); `entidad+0x58` = puntero al registro de personaje (paso
  `0xB0`), no escuadra; el parche de ISO in-place **anda**, confirmado tres
  veces.

## 4. LO QUE SIGUE, CONCRETO

```
python herramientas/ubicaciones.py          # control positivo del entorno
python herramientas/decompilar.py info      # control positivo de Ghidra
```

1. Buscar los **stores a `+0xEC`** en `0x00155000`–`0x0015D200`, con el
   decodificador manual del §6 (no con `capstone` — ver la trampa ahí).
2. Para cada candidato, `decompilar.py c <dirección>` y leer de dónde sale
   el valor.
3. **Control positivo obligatorio:** la función tiene que poder producir
   `0x01842C10` para un `E_BLACKHD_M0` en `LEVEL_00` — es el descriptor que
   los cinco enemigos de la (33) tenían de verdad, medido en RAM.
4. Si aparece un índice o un nombre, cruzarlo contra `STLEVEL.BIN` con
   `herramientas/id64.py`, que ya está probado.

**No hace falta el emulador.** Si en algún momento hace falta RAM viva,
`decompilar.py estado` trae el savestate adentro de Ghidra sin PCSX2
corriendo, y `volcados/ee-e4.bin` (32 MB, array poblado) ya está commiteado.

## 5. ESTADO DE LA MÁQUINA AL CERRAR

- **LA MÁQUINA SE APAGÓ SOLA** durante la sesión, después de que Fran
  cambiara el renderizado a la **GPU discreta** porque BLACK corría a
  **10 fps en el menú** (no debería). **Esto NO está diagnosticado** y no es
  parte de 7d — es un tema de entorno, aparte. Si vuelve a pasar, ver §7.
- **PCSX2 quedó abierto** antes del apagado (PID 3836), con
  `Black-mod-7b.iso`. Después del apagado **no se relanzó**: dar por hecho
  que **no está corriendo**. Ejecutable:
  `C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe`
  (NO el de Program Files). Lanzador:
  `C:\Users\frans\Desktop\BLACK\ABRIR-BLACK-MOD-7B.bat`.
- **RAM LIMPIA, cero parches vivos.** El nop de vida infinita de
  `0x0013BD20` se había restaurado y releído en la sesión anterior
  (`0xE65402F8`), y esta sesión **no escribió un solo byte en memoria**:
  fue toda lectura en frío.
- **Ningún ISO se tocó.** `Black-mod-7b.iso` y `Black-mod-armas.iso` están
  como estaban.
- `ubicaciones.py` **13/13** al abrir. Las rutas no se copian a mano:
  `python herramientas/ubicaciones.py ruta <clave>`.
- Archivos temporales de la sesión (`black/funciones.txt`,
  `black/xref40F4E0.txt`) **se perdieron en el apagado y no hacen falta**:
  se regeneran con `decompilar.py funciones` y `decompilar.py xref`.

## 6. LA TÉCNICA QUE FUNCIONÓ EN 7C — reusarla en 7D

Dos trampas que ya costaron tiempo, las dos evitables:

1. **`capstone` no sirve para desensamblar el `.text` del EE de corrido.**
   Con `CS_MODE_MIPS32` se detiene **a las 2 instrucciones** en el primer
   opcode propio del R5900. Para barrer patrones, **decodificar a mano**:
   son campos fijos y alcanza con `struct.unpack_from`.
   `.text` empieza en el offset de archivo `0x1000` y en la dirección
   `0x00100000` (o sea, `addr = 0x100000 + (off - 0x1000)`).
2. **Un xref sobre una dirección de heap siempre da 0.** Antes de gastarlo,
   mirar si cae dentro de alguna sección (`decompilar.py info` las lista).
   Si cae fuera, el camino es **subir la cadena de punteros** buscando quién
   *contiene* el valor en un volcado, hasta llegar a algo `< 0x0049BFBC`,
   que ya es estático y sí tiene xrefs.

Y el criterio que hizo confiable el resultado: **el parámetro de búsqueda
que sirve es el que discrimina**. Los `sw` con offsets `{4,8,C}` dieron 339
candidatos (inútil); `addiu rX,rX,0x24` —el paso del pool— dio 32, y uno cayó
dentro de la misma función a la que había llegado la cadena de punteros por
otro lado. **Dos vías independientes convergiendo** es lo que cerró la fase,
no una sola vía con más esfuerzo.

## 7. PENDIENTES QUE NO SON DE LA FASE

- **BLACK a 10 fps en el menú y la máquina apagándose sola.** Sin
  diagnosticar. Es entorno, no ingeniería reversa: merece su propia sesión y
  su propio criterio de salida (probablemente térmico o de alimentación, dado
  que apareció al pasar a GPU discreta). **No mezclarlo con 7d.**
- **Fase 5a — pnach sobre `0x00142CA0`** (daño de salida del jugador).
  **PARQUEADA a propósito**, sigue lista para cuando Fran quiera volver al
  emulador por ese lado.
