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

## Qué habilita esto, y qué NO

**Habilita** dejar de adivinar: cada metaclase es una dirección FIJA de `.bss`,
o sea un ancla estable para encontrar en RAM los objetos de esa clase, igual
que el puntero de vtable en `objeto+0x10` sirvió para encontrar el pool de
enemigos.

**NO habilita** todavía leer un valor. Falta el paso siguiente, y es concreto:
volcar la RAM con un nivel cargado y buscar qué objetos referencian cada
metaclase, para llegar del nombre al dato. Ese es el próximo hilo de la Fase 7.

**Y una advertencia honesta:** nada de esto está confirmado por efecto. Lo
confirmado es que los nombres y el árbol existen y que el código los usa. Que
escribirle a `VisualAcuteness` cambie lo que un enemigo ve es una **hipótesis
muy bien fundada**, no un hecho, hasta que alguien lo escriba y lo vea.
