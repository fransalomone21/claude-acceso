"""Sintetiza guion.md a un podcast de dos voces rioplatenses (edge-tts, gratis, sin clave).

Uso:  python sintetizar.py <salida.m4a>
Necesita: pip install edge-tts, y ffmpeg en el PATH.
Cada renglon 'CARO:' o 'MARTIN:' es un audio; '[PAUSA n]' es silencio.
Las siglas se pasan a como se dicen (PRONUNCIA), para que no las lea como palabra.
"""
import asyncio
import re
import subprocess
import sys
import tempfile
from pathlib import Path

import edge_tts

AQUI = Path(__file__).parent
VOCES = {"CARO": "es-AR-ElenaNeural", "MARTIN": "es-AR-TomasNeural"}
RITMO = {"CARO": "+6%", "MARTIN": "+4%"}
HUECO_MISMO = 0.18   # s entre dos renglones de la misma voz
HUECO_CAMBIO = 0.32  # s cuando cambia quien habla

PRONUNCIA = [
    (r"\bI2C\b", "i dos ce"), (r"\bSPI\b", "ese pe i"), (r"\bUART\b", "u art"),
    (r"\bRS-485\b", "erre ese cuatro ochenta y cinco"), (r"\bRS-422\b", "erre ese cuatro veintidós"),
    (r"\bRS-232\b", "erre ese dos treinta y dos"), (r"\bMIL-STD 1553\b", "mil estándar quince cincuenta y tres"),
    (r"\b1553\b", "quince cincuenta y tres"),
    (r"\bSEU\b", "ese e u"), (r"\bSEL\b", "ese e ele"), (r"\bSET\b", "ese e te"), (r"\bSEE\b", "ese e e"),
    (r"\bMBU\b", "eme be u"), (r"\bTID\b", "te i de"), (r"\bDD\b", "de de"),
    (r"\bDMR\b", "de eme erre"), (r"\bTMR\b", "te eme erre"), (r"\bSECDED\b", "sec ded"),
    (r"\bEDAC\b", "edac"), (r"\bECC\b", "e ce ce"), (r"\bBCH\b", "be ce hache"), (r"\bCRC\b", "ce erre ce"),
    (r"\bFRAM\b", "efe ram"), (r"\bMRAM\b", "eme ram"), (r"\bSRAM\b", "ese ram"), (r"\bRAM\b", "ram"),
    (r"\bEEPROM\b", "e e prom"), (r"\bLCL\b", "ele ce ele"), (r"\bFDIR\b", "efe de i erre"),
    (r"\bCOTS\b", "cots"), (r"\bTRL\b", "te erre ele"), (r"\bOBC\b", "o be ce"), (r"\bFPGAs\b", "efe pe ge as"),
    (r"\bFPGA\b", "efe pe ge a"), (r"\bSoC\b", "sok"), (r"\bCPU\b", "ce pe u"), (r"\bGPU\b", "ge pe u"),
    (r"\bMSP430\b", "eme ese pe cuatrocientos treinta"), (r"\bTMS570\b", "te eme ese quinientos setenta"),
    (r"\bRAD750\b", "rad setecientos cincuenta"), (r"\bLEON\b", "león"),
    (r"\bcFS\b", "ce efe ese"), (r"\bRTEMS\b", "ar tems"), (r"\bPREEMPT RT\b", "pri empt ar te"),
    (r"\bFreeRTOS\b", "fri ar tos"), (r"\bRTOS\b", "ar tos"),
    (r"\bMPU\b", "eme pe u"), (r"\bMMU\b", "eme eme u"), (r"\bNVIC\b", "en vic"), (r"\bALU\b", "a ele u"),
    (r"\bRISC\b", "risc"), (r"\bDSP\b", "de ese pe"), (r"\bFPU\b", "efe pe u"), (r"\bCMSIS\b", "ce em sis"),
    (r"\bMSP\b", "eme ese pe"), (r"\bPSP\b", "pe ese pe"), (r"\bTCB\b", "te ce be"),
    (r"\bVTOR\b", "ve tor"), (r"\bCFSR\b", "ce efe ese erre"), (r"\bNMI\b", "ene eme i"),
    (r"\bSysTick\b", "sis tic"), (r"\bPendSV\b", "pend ese ve"), (r"\bSVC\b", "ese ve ce"),
    (r"\bHardFault\b", "hard folt"), (r"\bMemManage\b", "mem mánach"), (r"\bBusFault\b", "bas folt"),
    (r"\bUsageFault\b", "iúsach folt"),
    (r"\bMISRA\b", "misra"), (r"\bNULL\b", "nal"), (r"\bstdio\b", "estándar i o"),
    (r"\bgcc\b", "ge ce ce"), (r"\bWall\b", "uol"), (r"\bWextra\b", "u extra"),
    (r"\buint8 t\b", "u int ocho te"), (r"\buint16 t\b", "u int dieciséis te"),
    (r"\buint32 t\b", "u int treinta y dos te"), (r"\bint16 t\b", "int dieciséis te"),
    (r"\bvTaskDelayUntil\b", "ve task delay until"), (r"\bvTaskDelay\b", "ve task delay"),
    (r"\bHAL Delay\b", "hal delay"), (r"\bHAL SPI Receive IT\b", "hal ese pe i receive i te"),
    (r"\bxSemaphoreGiveFromISR\b", "equis semáfor guiv from i ese erre"),
    (r"\bportYIELD FROM ISR\b", "port iild from i ese erre"), (r"\bFromISR\b", "from i ese erre"),
    (r"\bconfigMAX SYSCALL INTERRUPT PRIORITY\b", "config max sis col interrupt prióriti"),
    (r"\bISR\b", "i ese erre"), (r"\bAPI\b", "a pe i"), (r"\bHAL\b", "hal"),
    (r"\bIDE\b", "i de e"), (r"\bUSER CODE BEGIN\b", "iúser code biguín"), (r"\bUSER CODE END\b", "iúser code end"),
    (r"\bioc\b", "i o ce"), (r"\belf\b", "elf"), (r"\bjson\b", "yeison"), (r"\btoml\b", "tomel"),
    (r"\bNUCLEO C031C6\b", "núcleo ce cero treinta y uno ce seis"), (r"\bF446RE\b", "efe cuatro cuatro seis erre e"),
    (r"\bSTM32F446RE\b", "ese te eme treinta y dos efe cuatro cuatro seis erre e"),
    (r"\bSTM32CubeIDE\b", "ese te eme treinta y dos cub i de e"), (r"\bSTM32\b", "ese te eme treinta y dos"),
    (r"\bGPIO\b", "ge pe i o"), (r"\bADC\b", "a de ce"), (r"\bLEDs\b", "leds"), (r"\bLED\b", "led"),
    (r"\bSDA\b", "ese de a"), (r"\bSCL\b", "ese ce ele"), (r"\bSCLK\b", "ese clock"),
    (r"\bMOSI\b", "mosi"), (r"\bMISO\b", "miso"), (r"\bCS\b", "ce ese"), (r"\bCPOL\b", "ce pol"),
    (r"\bCPHA\b", "ce pe hache a"), (r"\bTX\b", "te equis"), (r"\bRX\b", "erre equis"),
    (r"\bCAN FD\b", "can efe de"), (r"\bLVDS\b", "ele ve de ese"), (r"\bESA\b", "esa"), (r"\bNASA\b", "nasa"),
    (r"\bV-R3x\b", "ve erre tres equis"), (r"\bICD\b", "i ce de"), (r"\bA5\b", "a cinco"),
    (r"\bBMP180\b", "be eme pe ciento ochenta"), (r"\bPL-A\b", "pe ele a"), (r"\bTIM6\b", "tim seis"),
    (r"\bTP(\d)\b", r"te pe \1"), (r"\bCubeSats\b", "kiub sats"), (r"\bCubeSat\b", "kiub sat"),
    (r"\bCONAE\b", "conae"), (r"\bUNSAM\b", "unsam"), (r"\bUNLP\b", "u ene ele pe"), (r"\bFIUBA\b", "fiuba"),
    (r"\bVENG\b", "veng"), (r"\bLabOSat\b", "lab o sat"), (r"\bKubOS\b", "kiub o ese"),
    (r"\bNanoSat MO Framework\b", "nano sat eme o freimuork"), (r"\bVxWorks\b", "ve equis uorks"),
    (r"\bCMOS\b", "ce mos"), (r"\bPC\b", "pe ce"), (r"\bIdle\b", "áidel"),
    # palabras en ingles, como las dice un estudiante argentino (medido por transcripcion: sin esto, "Mán de Tauri")
    (r"\bMotor Industry Software Reliability Association\b", "Motor Índastri Sóftuer Rilaiabíliti Asosiéishon"),
    (r"\bMandatory\b", "Mándatori"), (r"\bRequired\b", "Ricuáiard"), (r"\bAdvisory\b", "Adváisori"),
    (r"\bvolatile\b", "vólatail"), (r"\bmalloc\b", "mal lok"), (r"\bfree\b", "fri"), (r"\bwhile\b", "uáil"),
    (r"\bRelease\b", "Rilís"), (r"\bThread\b", "Zred"), (r"\bHandler\b", "Jándler"), (r"\bhandler\b", "jándler"),
    (r"\bround-robin\b", "raund róbin"), (r"\bhousekeeping\b", "jaus kíping"), (r"\bwatchdog\b", "uóchdog"),
    (r"\blockstep\b", "lók step"), (r"\blatch-up\b", "lách ap"), (r"\bscrubbing\b", "escrábing"),
    (r"\bpower cycle\b", "páuer sáikel"), (r"\bcheckpoints\b", "chék points"), (r"\bbootloader\b", "but lóuder"),
    (r"\bsingle-string\b", "síngel string"), (r"\bsingle-ended\b", "síngel énded"), (r"\bsuper-loop\b", "súper lup"),
    (r"\bdeadline\b", "dédlain"), (r"\bRunning\b", "Rráning"), (r"\bReady\b", "Rédi"), (r"\bBlocked\b", "Blókt"),
    (r"\bSuspended\b", "Suspéndid"), (r"\bcallback\b", "cól bak"), (r"\bdispatch table\b", "dispách téibol"),
    (r"\btemplate\b", "témpleit"), (r"\bworkspace\b", "uórk speis"), (r"\bbus lockup\b", "bus lók ap"),
    (r"\bopen-drain\b", "ópen dréin"), (r"\bpull-up\b", "pul ap"), (r"\bpush-pull\b", "push pul"),
    (r"\bfull-duplex\b", "ful dúplex"), (r"\bHalf-duplex\b", "Jaf dúplex"), (r"\bhalf-duplex\b", "jaf dúplex"),
    (r"\bFull-duplex\b", "Ful dúplex"), (r"\bchip select\b", "chip seléct"), (r"\bbaudrate\b", "bód reit"),
    (r"\bmulti-master\b", "multi máster"), (r"\bload-store\b", "loud stor"), (r"\bpipeline\b", "páip lain"),
    (r"\bstartup\b", "stártap"), (r"\blinker script\b", "línker script"), (r"\blinker\b", "línker"),
    (r"\bmemory leak\b", "mémori lik"), (r"\bdefault\b", "difólt"), (r"\bswitch\b", "suích"),
    (r"\bBuild\b", "Bild"), (r"\bstatic\b", "estátic"), (r"\bOld Space\b", "Old Speis"), (r"\bNew Space\b", "Niu Speis"),
    (r"\brad-hard\b", "rad jard"), (r"\bRad-hard\b", "Rad jard"), (r"\bRad-tolerant\b", "Rad tólerant"),
    (r"\bflight proven\b", "fláit prúven"), (r"\bframework\b", "fréimuork"), (r"\bFrameworks\b", "Fréimuorks"),
    (r"\bmiddleware\b", "mídel uer"), (r"\bpayloads\b", "péi louds"), (r"\bpayload\b", "péi loud"),
    (r"\bhost\b", "jóst"), (r"\bRate Monotonic\b", "Reit Monotónic"),
]


def pronunciar(t):
    for pat, rep in PRONUNCIA:
        t = re.sub(pat, rep, t)
    return t


def leer_guion():
    renglones = []
    texto = (AQUI / "guion.md").read_text(encoding="utf-8").split("## Guion", 1)[1]
    for linea in texto.splitlines():
        linea = linea.strip()
        if not linea:
            continue
        m = re.match(r"\[PAUSA (\d+(?:\.\d+)?)\]", linea)
        if m:
            renglones.append(("PAUSA", float(m.group(1))))
            continue
        m = re.match(r"(CARO|MARTIN):\s*(.+)", linea)
        if not m:
            raise SystemExit(f"renglon sin voz: {linea[:60]}")
        renglones.append((m.group(1), m.group(2)))
    return renglones


async def uno(sem, i, voz, texto, carpeta):
    destino = carpeta / f"{i:04d}.mp3"
    async with sem:
        for intento in range(4):
            try:
                await edge_tts.Communicate(pronunciar(texto), VOCES[voz], rate=RITMO[voz]).save(str(destino))
                if destino.stat().st_size > 1000:
                    return destino
            except Exception as e:  # la red falla de a ratos: se reintenta
                ultimo = e
            await asyncio.sleep(1.5 * (intento + 1))
        raise SystemExit(f"no se pudo sintetizar el renglon {i}: {texto[:60]} ({ultimo!r})")


def silencio(seg, destino):
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-f", "lavfi", "-i",
                    "anullsrc=r=24000:cl=mono", "-t", f"{seg:.2f}", "-c:a", "libmp3lame",
                    "-b:a", "48k", str(destino)], check=True)


async def main(salida):
    renglones = leer_guion()
    carpeta = Path(tempfile.mkdtemp(prefix="podcast-"))
    sem = asyncio.Semaphore(6)
    tareas = {i: asyncio.create_task(uno(sem, i, v, t, carpeta))
              for i, (v, t) in enumerate(renglones) if v != "PAUSA"}
    await asyncio.gather(*tareas.values())
    huecos = {}
    def hueco(seg):
        if seg not in huecos:
            huecos[seg] = carpeta / f"sil_{seg:.2f}.mp3"
            silencio(seg, huecos[seg])
        return huecos[seg]
    lista, anterior = [], None
    for i, (v, t) in enumerate(renglones):
        if v == "PAUSA":
            lista.append(hueco(t))
            anterior = None
            continue
        if anterior is not None:
            lista.append(hueco(HUECO_MISMO if anterior == v else HUECO_CAMBIO))
        lista.append(tareas[i].result())
        anterior = v
    indice = carpeta / "lista.txt"
    indice.write_text("".join(f"file '{p.as_posix()}'\n" for p in lista), encoding="utf-8")
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-f", "concat", "-safe", "0", "-i", str(indice),
                    "-af", "loudnorm=I=-16:TP=-1.5:LRA=11", "-ar", "44100", "-c:a", "aac", "-b:a", "96k",
                    salida], check=True)
    print(f"{len(tareas)} renglones, {sum(1 for v,_ in renglones if v=='PAUSA')} pausas -> {salida}")


if __name__ == "__main__":
    asyncio.run(main(sys.argv[1]))
