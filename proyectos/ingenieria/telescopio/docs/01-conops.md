# ConOps — cómo es una noche con esto funcionando

Esto se escribe **antes** del diseño, no después. Es lo que decide requisitos
que de otro modo aparecen a mitad de la construcción: cuánto puede pesar lo
que hay que llevar al patio, cuánto puede tardar el armado, qué pasa cuando se
termina la carrera de la plataforma.

NASA lo pone en Pre-Fase A por una razón: un sistema que cumple todos los
requisitos y es insoportable de usar falla la validación igual.

---

## La noche, paso por paso

1. **Sacar al patio.** La plataforma primero, el dobson después. Dos viajes,
   porque juntos son ~50 kg más la plataforma.
   → *requisito que sale de acá:* la plataforma tiene que poder llevarse sola,
   y el dobson tiene que poder subirse arriba **sin levantarlo entero**
   (deslizándolo, o con la plataforma al ras del piso).
2. **Nivelar y alinear al polo.** La primera vez, con método de deriva, media
   hora. Las demás, **apoyando las patas en las marcas del piso**, dos
   minutos.
   → *requisito:* tres puntos de apoyo identificables y repetibles, y una
   forma de marcar el piso que sobreviva la lluvia.
3. **Montar el dobson arriba y trabar los dos ejes.** La plataforma se inclina
   hasta ~7,5°: si el eje de altura o el de azimut quedan libres, el telescopio
   se corre solo.
   → *requisito:* tornillos de bloqueo en los dos ejes. Ya estaba en la lista
   de mejoras de la montura y ahora se sabe de dónde viene.
4. **Rebobinar la plataforma al extremo este** y arrancar el seguimiento.
5. **Apuntar a mano** al objeto, con el buscador y el ocular de 25 mm.
6. **Cambiar al tren de imagen** (cámara en foco primario, o celular afocal) y
   enfocar.
   → *requisito:* cambiar de ocular a cámara **no puede desbalancear** el tubo
   al punto de que se corra. De ahí sale el riesgo R7 y la necesidad de medir
   la masa de la cámara y del soporte.
7. **Exponer.** N subs del largo que el sistema aguante, con el disparador.
8. **Cuando se termina la carrera** (una hora), rebobinar y volver a apuntar.
   → *requisito:* rebobinado rápido por botón, y finales de carrera para que
   no se pase.
9. **Apilar al otro día** en la compu.

## Lo que la noche prohíbe

- **Nada de tocar el telescopio durante un sub.** Ni enfocar, ni mirar por el
  buscador. Todo lo que haya que tocar, se toca entre subs.
- **Nada de notebook obligatoria.** El seguimiento tiene que andar solo, con
  el Arduino y una batería. La notebook es para autoguiado, que es opcional.
- **Nada que requiera ver el polo sur celeste cada noche**: por eso las marcas
  en el piso.

## El modo degradado, que también es un modo

Si la noche está mala, o falta tiempo, o la alineación salió fea: **subs
cortos y muchos**. El sistema tiene que seguir siendo útil con subs de 10 s;
si sólo sirve con la alineación perfecta, en la práctica no sirve.

## Lo que se mide para saber si la noche salió bien

| Qué | Cómo se ve |
|---|---|
| ¿las estrellas son puntos? | se mira un sub al 100 %: redondas o con guión |
| ¿cuánto duró la carrera sin tocar nada? | el reloj |
| ¿cuánto tardó el armado? | el reloj, desde sacar al patio hasta el primer sub |
| ¿cuántos subs se tiraron, y por qué? | el que más se repite es el que hay que arreglar |
