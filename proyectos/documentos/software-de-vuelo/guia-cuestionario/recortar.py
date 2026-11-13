"""Recorta las figuras de las presentaciones de Leandro para la guia del cuestionario.

Las diapositivas son material de la catedra: los PNG van a fig-catedra/, que
esta en el .gitignore (el repo es publico). Este script los regenera desde la
carpeta local de la materia. Las cajas estan en puntos PDF (la diapositiva
mide 720 x 405).

    python recortar.py
"""
import os
import sys

import fitz

MAT = r"C:\Users\frans\Desktop\01 - UNSAM\Software de Vuelo\Material de catedra"
AQUI = os.path.dirname(os.path.abspath(__file__))
SALIDA = os.path.join(AQUI, "fig-catedra")

# nombre -> (pdf relativo a MAT, pagina 1-based, (x0, y0, x1, y1) en puntos)
FIGURAS = {
    "ambiente": (r"Semana_1\Confiabilidad_Avionica_Espacial.pdf", 19, (12, 66, 712, 385)),
    "lockstep": (r"Semana_1\Confiabilidad_Avionica_Espacial.pdf", 29, (460, 126, 662, 298)),
    "watchdog": (r"Semana_1\Confiabilidad_Avionica_Espacial.pdf", 33, (442, 138, 704, 268)),
    "harvard": (r"Semana_2\Arquitectura_ARM.pdf", 10, (12, 220, 704, 384)),
    "cortex-m": (r"Semana_2\Arquitectura_ARM.pdf", 11, (46, 76, 668, 350)),
    "memoria-c": (r"Semana_3\Arquitectura_ARM_Cortex-17-49.pdf", 20, (16, 62, 710, 382)),
    "misra-switch": (r"Semana_2\MISRA-C.pdf", 8, (16, 244, 620, 382)),
    "misra-recursion": (r"Semana_2\MISRA-C.pdf", 11, (10, 250, 632, 382)),
    "serie-paralelo": (r"Semana_6\Perifericos_e_Interfaces_de_Comunicacion.pdf", 2, (178, 82, 542, 386)),
    "duplex": (r"Semana_6\Perifericos_e_Interfaces_de_Comunicacion.pdf", 3, (208, 86, 500, 366)),
    "diferencial": (r"Semana_6\Perifericos_e_Interfaces_de_Comunicacion.pdf", 4, (34, 124, 704, 326)),
    "i2c": (r"Semana_6\Perifericos_e_Interfaces_de_Comunicacion.pdf", 13, (16, 66, 698, 382)),
    "spi": (r"Semana_6\Perifericos_e_Interfaces_de_Comunicacion.pdf", 19, (160, 30, 580, 250)),
    "can": (r"Semana_6\Perifericos_e_Interfaces_de_Comunicacion.pdf", 29, (52, 63, 668, 331)),
    "pasaje": (r"Semana_7\punteros_funciones.pdf", 5, (10, 80, 710, 360)),
    "struct": (r"Semana_7\punteros_funciones.pdf", 19, (22, 66, 698, 376)),
    "superloop": (r"Semana_8\RTOS.pdf", 4, (22, 78, 692, 302)),
    "periodo": (r"Semana_8\RTOS.pdf", 6, (22, 70, 698, 314)),
    "contexto": (r"Semana_8\RTOS.pdf", 10, (22, 94, 710, 350)),
    "estados": (r"Semana_8\RTOS.pdf", 11, (16, 66, 674, 362)),
    "preempcion": (r"Semana_8\RTOS.pdf", 14, (34, 72, 698, 284)),
    "cola": (r"Semana_8\RTOS.pdf", 19, (22, 60, 692, 340)),
    "semaforo": (r"Semana_8\RTOS.pdf", 20, (22, 63, 698, 331)),
    "mutex": (r"Semana_8\RTOS.pdf", 22, (22, 63, 698, 313)),
    "inversion": (r"Semana_8\RTOS.pdf", 23, (22, 63, 698, 331)),
    "msp-psp": (r"Semana_8\RTOS.pdf", 29, (22, 65, 698, 333)),
    "nvic-prio": (r"Semana_8\RTOS.pdf", 30, (22, 65, 698, 333)),
}


def main():
    if not os.path.isdir(MAT):
        sys.exit("ROJO: no esta la carpeta de la materia: " + MAT)
    os.makedirs(SALIDA, exist_ok=True)
    abiertos = {}
    for nombre, (pdf, pag, caja) in FIGURAS.items():
        if pdf not in abiertos:
            abiertos[pdf] = fitz.open(os.path.join(MAT, pdf))
        pagina = abiertos[pdf].load_page(pag - 1)
        pix = pagina.get_pixmap(dpi=220, clip=fitz.Rect(*caja))
        pix.save(os.path.join(SALIDA, nombre + ".png"))
    print(f"{len(FIGURAS)} figuras en {SALIDA}")


if __name__ == "__main__":
    main()
