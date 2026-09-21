# La guía vive en `guia.typ`

**Este archivo ya no tiene la guía.** La tuvo el 2026-09-21 hasta que se
compiló el PDF, y ahí quedaron dos copias del mismo procedimiento. El mismo día
divergieron: el PDF se corrigió con dos datos medidos sobre la máquina —que la
polea se fija con **tuerca** y no con tornillo allen, y que el retén **no**
queda a la vista al sacar la polea— y este archivo siguió diciendo lo viejo.

Un dato que vive en dos lados diverge, y el que se lee frente a la máquina es
el PDF. Así que la fuente única es:

- [`guia.typ`](guia.typ) — la fuente, se edita acá
- `Guia lavarropas Drean Next 6.06.pdf` — lo que se lee e imprime

Se recompila con:

```powershell
typst compile guia.typ "Guia lavarropas Drean Next 6.06.pdf"
```

## Las fuentes de los precios y las medidas

Están acá porque el PDF no las lleva —no ayudan frente a la máquina— pero
hacen falta para poder auditar de dónde salió cada número.

- [Kit ruleman + retén Drean Blue 6.06 / 6.08 / 7.09 / 7.10 — byparts](https://www.byparts.com.ar/productos/kit-ruleman-reten-lavarropas-drean-blue-6-06-6-08-7-09-7-10-zk9tx/)
  — de acá salen **6203 + 6204 + retén**, y el precio de referencia.
- [Kit rulemanes + retén Drean Next 8.12 SKF 6204 6205 — almacenweb](https://www.almacenweb.com.ar/producto/kit-rulemanes-reten-lavarropas-drean-next-8-12-skf-6204-6205-1130045791)
  — de acá sale que los de **8 kg y más** llevan 6204 + 6205, que es lo que
  permite decir que este no es ese caso.
- [Kit ruleman + retén Drean Blue 6.06 — rodazul](https://www.rodazul.com.ar/MLA-1301017181-kit-ruleman-reten-lavarropas-drean-blue-606-608-709-710-_JM)
- [Rulemanes para lavarropas: medidas y reemplazo — Matich](https://matichsa.com/blog/rulemanes-para-lavarropas)
  — medidas literales: 6203 = 17×40×12, 6204 = 20×47×14, retén 25×47×8/11,5.
- [Manual oficial Drean Next ECO (PDF)](https://blog.drean.com.ar/wp-content/uploads/2022/04/Manual-Drean-Next-ECO.pdf)
- [Cómo controlar si tu lavarropas necesita cambio de rulemanes — Service MJL](https://www.servicedlavarropas.com.ar/podes-controlar-vos-mismo-si-tu-lavarropas-necesita-un-cambio-de-rulemanes/)

**Ninguna de esas fuentes es del Next 6.06.** Es la razón por la que el paso H
de la guía manda leer el número grabado en el aro del rulemán viejo antes de
comprar.
