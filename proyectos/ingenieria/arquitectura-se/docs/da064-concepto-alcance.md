# DA-064 — el libro llega al momento de escribir un alcance

**2026-10-19.** Arreglo del defecto DA-064 (`perfil-global/DEFECTOS-ARQUITECTURA.md`): *el libro no llega al momento
de escribir un alcance*. Requisitos: L0-09, L1-19, L2-PTA-20..23, L2-VER-04 y L2-CAS-03/04
([`10-requisitos.md`](10-requisitos.md) §11).

## 1. El defecto

El 2026-10-18/19, escribiendo la sección 1 del TP final de IISE (`trabajo-final-iise/informe/seccion-1.md`), la
necesidad salió primero como tres párrafos de contexto y después con un rótulo «Justificación» inventado debajo de cada
elemento; la regla equivocada se registró en cuatro lugares antes de mirar un ejemplar. El SEH estaba destilado desde
hacía meses (`perfil-global/pilares/nasa-seh/stakeholders.md` §3.12: *«Need: A single statement…»*). La puerta exigió
`nucleo-ise.md`, que en ese momento no traía las NGO, y ningún concepto de `.claude/cascada.json` exigía
`stakeholders.md` al escribir un alcance: el concepto `requisitos` (2026-10-07) cubre sólo requerimientos. Clase: flujo
de información que falta (Meadows: el medidor en el sótano).

## 2. ¿Es la puerta el lugar? Las alternativas

| Alternativa | Por qué no alcanza, o por qué sí |
|---|---|
| El resumen en `nucleo-ise.md` §3b (ya está) | Entra siempre, pero son diez líneas: dicen la regla, no muestran la forma. La ficha nueva lo dice de sí misma: la forma se copia de ejemplares, no se deduce de la definición. Para los requisitos, §4 tampoco alcanzó y por eso existe el concepto. |
| La viñeta de `chequeo-de-trabajo.md` (ya está) | Llega como renglón del núcleo y, entera, por el hook al paso: informa, no exige leer los ejemplares. |
| El freno por FASE (T13) | Exige productos a los proyectos de `ingenieria/` en fase A–D. DA-064 pasó en un proyecto de **materia**, que N-09 deja fuera a propósito. |
| Un verificador de la forma del alcance (que la necesidad sea una frase) | Mediría el EFECTO, que es lo mejor (chequeo: «fijate si ya existe uno que mida el efecto»). No existe todavía: queda como follow-up, y no reemplaza que el libro llegue antes de escribir. |
| **Un concepto de la puerta** | Es la capa que ya lleva los libros al momento de escribir un requisito, falla cerrado y vale en cualquier proyecto. **Elegido.** |

## 3. El disparador: el rol del texto, no una palabra

El riesgo de un concepto nuevo es el que denunció el insumo «NASA por etiqueta»: disparar por una palabra del pedido
o por una necesidad declarada. Acá dispara el **rol** del texto que se escribe: el título de la sección del alcance.

- **Write**: el contenido trae un título de alcance (`## 1.1. Necesidad`, `== Objetivos`).
- **Edit**: el texto viejo o el nuevo trae un título de alcance, **o el título que ENCIERRA el texto viejo en el
  archivo** lo es. Esta última es la del caso real: de la v02 a la v03 se reescribió la frase de la necesidad sin
  tocar su título, y el Edit no lo trae.
- Sólo en documentos (`.md` con `#`, `.typ` con `=`), salteando los bloques de código: en un `.py`, `# objetivo:` es un
  comentario.
- En un `PDP.md`, también «El problema» y «Qué NO es» (su alcance, por la plantilla).
- La prosa que nombra «la necesidad» no es un título y no dispara.

**Medido sobre lo trackeado (380 documentos):** 37 títulos caen en la definición: 25 son las secciones 1 y 2 de los
PDP y 12 el resto. De esos 12, 7 son alcances de verdad (las necesidades de dos documentos de requisitos, las metas
del telescopio, las NGO de BLACK, la meta de dos lluvias de ideas y la de la guía del telescopio); los otros 5 (tres definiciones del glosario de
IISE, el objetivo de una sesión en un HANDOFF viejo y el alcance temático de una guía) cuestan una lectura por sesión,
no un freno permanente.

## 4. Qué exige y cuánto cuesta

La ficha `alcance-como-se-escribe.md` entera, `stakeholders.md` §3.11-3.13 (SEH p. 48-49), y de la cátedra m18 desde
«Los elementos del alcance» (con el ConOps y el CEV) y m20 «El Ejercicio de Alcance» (Marte): **18 711 caracteres,
una vez por sesión**, sólo en la sesión que escribe un alcance. Al declarar `diseno`, `materia` o `lluvia-de-ideas`, y
al declarar un proyecto cuyo documento de requisitos tiene necesidades, la cascada lo imprime con sus rangos (DA-058).

## 5. Lo que no cubre (límites declarados)

- Un alcance escrito **sin títulos** (rótulos en negrita, una tabla suelta) o por **Bash/PowerShell** (un script que
  genera el archivo): el concepto `requisitos` tiene el mismo límite.
- Un alcance escrito por un **conector** (un Google Doc): en los TP de grupo la sesión no escribe el Doc (memoria «la
  IA investiga, el grupo hace»).
- Que la forma quede bien: eso lo mediría el verificador de §2, que no existe.

## 6. Cómo se prueba

- **Autotest de la puerta, caso 20**: cinco sabotajes (Write, Edit bajo la sección, Edit que agrega el título, PDP,
  Typst), cinco controles (prosa, `.py`, bloque de código, «El problema» fuera de un PDP, la sección 4 del PDP), el
  control con las lecturas hechas, y cinco mutantes, cada uno visto en su caso.
- **[`probar-da064.py`](../probar-da064.py)**: el catálogo real sobre los artefactos reales (el informe del TP, el PDP
  y el documento de requisitos de este proyecto, con sus controles), el verificador con un patrón roto, y el mutante
  sin `secciones`.
