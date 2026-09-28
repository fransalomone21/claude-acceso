# Bitácora — metodo-agustin

## 2026-09-26 — fase 0: diseño

Fran pidió pasarle a la notebook de Agustín "toda la arquitectura y las
lecciones", sin los proyectos. Primero se midió cuánto del sistema es de Fran
y cuánto es método. Salió que están mezclados: "Fran" 103 veces en
`perfil-global`, rutas `frans` fijas en 7 archivos, `bootstrap.ps1` clonando
el perfil de Fran y dos medidores de Drive en el arranque.

Se descartó darle acceso a `perfil-global` tal cual. En un repo de cuenta
personal el colaborador tiene escritura, y la sesión de Agustín lo trataría
como si fuera Fran. También se descartó partir `perfil-global` en núcleo y
capa personal, porque reforma un sistema que anda (regla 6). Quedó un núcleo
**generado** por script, con el mismo patrón que las fichas, que son una vista
del registro.

Fran contestó las tres incógnitas: Windows, sólo ida, y cómo están las
cuentas de Claude. El detalle de las cuentas **no se escribe acá**, porque este
repo es público; vive en la auto-memoria. No cambia la arquitectura, pero entra
a riesgos: el tope del plan, con ~130 KB inyectados por cada arranque.

Hallazgo que cambió una regla del proyecto: `install.ps1` no tiene parámetro
de destino. Probar el `install.ps1` del export en esta máquina pisaría el
perfil de Fran, así que queda prohibido y la instalación se certifica en la
notebook de Agustín.

## 2026-09-27 — entregable aparte: la guía de un solo archivo

Fran pidió pasarle la arquitectura también a **Matías**, que usa el plan
gratis de claude.ai sin Claude Code. Pidió que fuera **un archivo** que los
nombre a los dos, explique la primera vez y deje regular el rigor según el
proyecto y el presupuesto. El núcleo instalable de la fase 1 no le sirve a
Matías, así que salió `entregables/EL-METODO.md` con:

- las ideas de fondo, las 12 reglas y los cuadros;
- el PDP, las tres naturalezas y la cascada;
- lecciones, frenos, y modelo y esfuerzo;
- un **dial de tres niveles** (Liviano / Medio / Completo);
- un bloque para pegar como primer mensaje o como instrucciones de Proyecto.

La guía está escrita a mano, no generada, así que **no reemplaza** la fase 1:
Agustín, para usar Claude Code, sigue necesitando el núcleo.

La regla 2 del contrato ("nada sale sin el verificador del export") no se pudo
cumplir tal cual, porque el verificador todavía no existe. Se cubrió el
aspecto `b` (datos personales) así:

- escaneo de mail, teléfono, DNI, rutas `frans` y nombres de proyectos de
  Fran: **0** hallazgos;
- control positivo: el mismo escaneo sobre un archivo que sí tiene un DNI da
  1 hit;
- la regla 5 de `verificar-estructura.ps1` da verde.

Después se subió a la carpeta de Drive que se comparte con Matías.
