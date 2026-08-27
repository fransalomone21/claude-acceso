# La IA: Kynapse, con los nombres puestos

BLACK no programó su IA desde cero: usa **Kynapse**, el middleware de Kynogon.
Y Kynapse trae un **sistema de reflexión propio**, así que el ejecutable
contiene el árbol de clases de la IA escrito, con nombres reales. Levantado el
2026-08-17.

Esto importa por una razón práctica: para "hacer los enemigos más
desafiantes", el hilo no empieza en la tabla de armas ni en un offset
adivinado. Empieza acá, donde los parámetros tienen el nombre que les puso
quien los escribió.

---

## Cómo se leyó — el patrón que lo destrabó

Cada clase de Kynapse tiene un objeto `CMetaClass` estático que se registra una
sola vez, con un accesor perezoso siempre de la misma forma:

```c
// FUN_0038a708 — el accesor de la metaclase de CEntityMaxSpeed
if (DAT_0049aad8 == 0) {                     // aún sin inicializar
    FUN_00389f90();                          // fuerza a la clase padre
    FUN_00370168(0x49aad8,                   // la metaclase de ESTA clase
                 0x405310,                   // "Q24Kaim15CEntityMaxSpeed"
                 0x49aa58);                  // la metaclase del PADRE
}
return 0x49aad8;
```

`FUN_00370168` es el registrador: `(metaclase, nombre, padre)`. Barriendo sus
llamadores y reconstruyendo los tres argumentos sale el árbol entero.

**`herramientas/kynapse.py`** hace exactamente eso:

```bash
python herramientas/kynapse.py clases <ELF> --base 0xFF000 --json kb/kynapse.json
python herramientas/kynapse.py arbol kb/kynapse.json
```

Resultado: **183 llamadas al registrador, 182 clases con nombre resuelto.**
El árbol queda en `kb/kynapse.json`.

> **Dos detalles de MIPS sin los cuales esto no sale.** Primero: una constante
> de 32 bits no está en ninguna instrucción sola, así que hay que **simular**
> `lui`/`addiu`/`ori`/`move` hacia atrás, no buscar un valor. Segundo: **la
> ranura de retardo**. La instrucción que sigue al `jal` se ejecuta ANTES del
> salto, y muy seguido es justo la que carga el tercer argumento. Ignorarla
> deja la mitad de los padres en blanco.

> **Esto corrige `docs/05-iso.md`,** que decía que los nombres `Kaim` de
> `.rodata` eran "rodata muerta que el parser no lee en runtime". Es falso para
> estos: `xref.py absoluto` da 2 sitios de código para `Q24Kaim7CEntity` y 1
> para cada atributo. El registro se construye de verdad al arrancar. Lo que
> sigue siendo rodata muerta es el esquema de armas de `0x004008A0`, que se
> verificó aparte.

---

## Lo que la IA PERCIBE — `CEntityAttribute` y sus 13 hijas

Todas heredan de `Kaim::CEntityAttribute` (`0x0049AA58`) y viven en `.bss`, en
direcciones fijas y contiguas:

| Clase | Metaclase | Qué gobierna |
|---|---|---|
| `CEntityVisualAcuteness` | `0x0049AB08` | **cuánto y qué tan lejos ve** |
| `CEntityHearingAcuteness` | `0x0049AA98` | **cuánto oye** |
| `CEntityMaxSpeed` | `0x0049AAD8` | velocidad máxima |
| `CEntityTeamSide` | `0x0049AAE8` | de qué bando es — **la llave del fuego amigo y del coop** |
| `CEntityEyePosition` | `0x0049AA68` | desde dónde mira |
| `CEntityGunPosition` | `0x0049AA78` | desde dónde dispara |
| `CEntityHeadDirection` | `0x0049AA88` | hacia dónde mira la cabeza |
| `CEntityTorsoOrientation` | `0x0049AAF8` | orientación del torso |
| `CEntityKneePosition` | `0x0049AAB8` | rodilla (agacharse / cobertura) |
| `CEntityHeight` / `CEntityWidth` / `CEntityLength` | `0x0049AAA8` / `0x0049AB18` / `0x0049AAC8` | volumen para evitar obstáculos |
| `CEntityCanFly` | `0x0049AA48` | si ignora el suelo |

**`VisualAcuteness` y `HearingAcuteness` son la dificultad de verdad.** Un
enemigo que te ve antes y desde más lejos cambia el juego mucho más que uno que
te hace más daño por bala.

## Lo que la IA HACE — `CActionAttribute` y sus 11 hijas

El vocabulario completo de un agente. Todas cuelgan de `Kaim::CActionAttribute`
(`0x0049A9D8`):

| Clase | Metaclase |
|---|---|
| `CActionShoot` | `0x0049AA18` |
| `CActionCrouch` | `0x0049A9E8` |
| `CActionJump` | `0x0049A9F8` |
| `CActionSpeed` | `0x0049AA28` |
| `CActionAcceleration` | `0x0049A9C8` |
| `CActionSteering` | `0x0049AA38` |
| `CActionRotate` | `0x0049AA08` |
| `CActionHeadRotate` | `0x0049AB38` |
| `CActionTorsoRotate` | `0x0049AB48` |
| `CActionVerticalSpeed` | `0x0049AB58` |
| `CActionActivate` | `0x0049AB28` |

Que exista `CActionCrouch` y `CActionJump` dice que el motor de IA **sabe**
agacharse y saltar, lo use el juego o no. Si BLACK no los usa, son
comportamientos disponibles y no características por escribir de cero.

## Los agentes — el comportamiento de alto nivel

`CFleeAgent` (`0x0049A908`), `CFollowerAgent` (`0x0049A958`), `CGotoAgent`
(`0x0049A968`), `CHideAgent` (`0x0049A978`) y el que ya conocíamos,
`CShooterAgent`, con sus parámetros declarados en `0x00404458`:
`DangerousConeAngle`, `TargetBot`, **`GunRange`**, **`MaxInaccuracy`**,
`AimAtTargetInterval`.

---

## MEDIDO: el registro de reflexión NO se inicializa. Kynapse está linkeado, no corriendo

Esta sección se escribió primero diciendo que cada metaclase era "un ancla
estable para encontrar los objetos en RAM". **Se midió y es falso**, así que
queda corregida en el lugar en vez de borrada: el error tiene más valor
anotado que escondido.

La prueba, sobre `volcados/ee-nivel-mod0.bin` —un volcado desde la dirección 0,
con un nivel cargado, 32 enemigos en el pool y varios vivos peleando—:

```
metaclases con algún byte distinto de cero: 0 de 182
referencias desde el heap a cualquiera de las 23 clases CEntity*: 0
```

Las 182 viven en `.bss` y `.bss` arranca en cero. El accesor perezoso
(`if (DAT_0049aad8 == 0) { ... }`) **nunca se ejecutó**. Si la IA del juego
usara este sistema de reflexión, al menos una metaclase estaría inicializada
mientras hay enemigos disparando.

**Conclusión, acotada a lo medido:** el árbol de clases de Kynapse existe en el
binario y el código que lo registraría también, pero **no se ejecuta durante
el juego**. Es código enlazado y muerto — probablemente el enlazador se trajo
la biblioteca entera.

### Qué sigue valiendo de todo esto, entonces

Vale como **mapa de diseño, no como manija de runtime**:

- Dice qué conceptos maneja la IA de la que partió BLACK, con los nombres de
  quien la escribió. Cuando `estructura.py` encuentre un `f32` sin identificar
  en el enemigo, "velocidad máxima", "agudeza visual" y "bando" son hipótesis
  con nombre y no invenciones.
- Dice que agacharse y saltar (`CActionCrouch`, `CActionJump`) son conceptos
  del motor de IA de origen. Que BLACK los use es otra pregunta.

### Y qué queda abierto, dicho con precisión

**No está establecido que BLACK ejecute NADA de Kynapse.** Lo único medido es
que su reflexión no arranca. La creencia previa del proyecto —"el middleware de
IA es Kynapse"— se apoyaba en que los nombres están en `.rodata`, y eso prueba
que la biblioteca se enlazó, no que corra.

**El test barato que lo settlea**, para cuando se retome: poner un watchpoint
de ejecución sobre una función de Kynapse con un nivel andando. Si no se
dispara nunca, la biblioteca es peso muerto y toda la dificultad de la IA hay
que buscarla en el código propio de Criterion.

> Ojo con el instrumento: los breakpoints de EJECUCIÓN crashean esta build de
> PCSX2 (ver `ESTADO_ACTUAL.md`). Habría que hacerlo con un watchpoint de
> lectura sobre una constante que use esa función, no con `bp poner`.
