# Emotion Engine — lo mínimo para leer desensamblado

Referencia para no re-deducir lo mismo cada vez. El EE es un **MIPS R5900**,
32 bits, little-endian.

## Registros

| Registro | Uso por convención |
|---|---|
| `zero` | siempre 0. Escribirle no hace nada |
| `at` | reservado para el ensamblador |
| `v0`, `v1` | **valores de retorno**. `v0` es el que importa |
| `a0`–`a3` | **argumentos** 1 a 4. Lo primero que hay que mirar en una llamada |
| `t0`–`t9` | temporales. El llamado los puede pisar |
| `s0`–`s7` | preservados entre llamadas. **Acá suele estar el `this`** |
| `k0`, `k1` | del kernel. No aparecen en código de juego |
| `gp` | puntero global: base de las variables globales |
| `sp` | pila |
| `fp`/`s8` | frame pointer |
| `ra` | dirección de retorno. `jr ra` es un `return` |

**En la práctica:** si ves `sw v0, 0x1C(s0)`, casi seguro `s0` es el objeto y
`0x1C` el offset del campo. Eso es media estructura resuelta.

## Instrucciones que aparecen todo el tiempo

| Instrucción | Qué hace |
|---|---|
| `lw rt, off(rs)` | carga 32 bits de `[rs+off]` |
| `sw rt, off(rs)` | **guarda** 32 bits en `[rs+off]` ← el objetivo de los breakpoints |
| `lh`/`lhu`/`lb`/`lbu` | carga 16/8 bits (con y sin signo) |
| `sh`/`sb` | guarda 16/8 bits |
| `addiu rt, rs, N` | `rt = rs + N`. Con `rs = zero` es cargar una constante |
| `addu`/`subu` | suma/resta entre registros |
| `sll`/`sra` | desplazamientos. `sra rd, rt, 1` es dividir por 2 |
| `beq`/`bne` | salta si igual / distinto |
| `slt`/`slti` | "menor que" → 0 o 1. Es el `if (a < b)` compilado |
| `jal destino` | **llamada a función**. La vuelta queda en `ra` |
| `jr ra` | return |
| `jalr rs` | llamada indirecta ← esto es una **llamada virtual** (vtable) |
| `nop` | nada. `0x00000000`. La herramienta preferida del modder |

## Tres cosas del MIPS que confunden si no se saben

1. **Delay slot.** La instrucción *después* de un salto o llamada **se ejecuta
   igual**, salta o no salta. Si vas a `nop`ear un `jal`, mirá qué hay en la
   línea siguiente: probablemente sea el último argumento y forme parte de la
   llamada.

2. **Los inmediatos son de 16 bits.** Cargar un valor de 32 bits siempre son
   dos instrucciones: `lui` (mitad alta) + `ori` (mitad baja). Por eso
   `mips.py li32` devuelve dos palabras. Si querés cambiar una constante grande
   hay que parchear las dos.

3. **`addiu` extiende el signo, `ori` no.** `addiu v0, zero, 0xFFFF` carga
   `-1`, no `65535`.

## Prólogo y epílogo de una función

Sirve para encontrar dónde **empieza** una función cuando el breakpoint te dejó
en el medio: subí hasta el primer `addiu sp, sp, -N`.

```asm
addiu   sp, sp, -0x20      ; reserva espacio en la pila  <- ACÁ empieza
sw      ra, 0x1C(sp)       ; guarda la dirección de retorno
sw      s0, 0x18(sp)       ; guarda los registros preservados que va a usar
...
lw      ra, 0x1C(sp)
lw      s0, 0x18(sp)
jr      ra
addiu   sp, sp, 0x20       ; delay slot: se ejecuta antes de saltar
```

## Objetos de C++

```asm
lw      v0, 0x0(s0)        ; v0 = puntero a la vtable  (offset 0 del objeto)
lw      v1, 0x18(v0)       ; v1 = el método número 6 de la vtable
jalr    v1                 ; llamada virtual
```

El primer `u32` de un objeto polimórfico es su vtable, y **todos los objetos de
la misma clase comparten ese valor**. Es la forma más directa de encontrar
todos los enemigos de un tipo: escaneá esa dirección como valor exacto.

## Mapa de memoria

| Rango | Qué es |
|---|---|
| `0x00000000`–`0x000FFFFF` | kernel de la PS2. No escanear |
| `0x00100000`–`0x01FFFFFF` | RAM del juego: código y datos |
| `0x70000000`–`0x70003FFF` | scratchpad (16 KB rapidísimos) |

El offset dentro de `eeMemory.bin` de un savestate **es** la dirección EE, y es
la misma que se escribe en un `.pnach`. No hay conversión en el medio.
