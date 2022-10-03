```
+------------------------------------------------------------------------------+
                                                         +-----+-------+-----+
                                                         |     | |     |     |
                                                         |     | |     |     |
                                                         |     +-------+     |
    San Floppy, a cyberciruja odyssey                    |                   |
                                                         |     #       #     |
                                                         |                   |
   Demo 256 bytes intro for the glorious                 |        ---        |
           Magnavox Odyssey 2                            |                  .|
                                                         +-------------------+

+------------------------------------------------------------------------------+
```

## Flash Party?
Flashparty is an event based on the "demoparty" model, which in turn has its origin on
the demoscene subculture.
https://flashparty.rebelion.digital/index.php?lang=en

This humble 250-byte demo was shown at that party, which took place during the first days of October 2022. It appeared as part of the "Demos using 256 bytes" category.

Video of the demo: 
https://github.com/perez-alejandrodaniel/cyberciruja_odyssey/blob/main/video/flashparty_2022.mkv

## The machine

The Magnavox Odyssey 2 was a machine based on an Intel 8048 microcontroller (not even a microprocessor). By that time it was already a quite limited chip but it managed to appear in this console and in some others, as both the main processing unit and as a support chip.
Fun fact, it's the same microcontroller that was used as an internal controller in the keyboard used in the first IBM PCs.

## Specs

* CPU:
    * Intel 8048 8-bit clocked at 5.37 MHz (NTSC regions) or 5.91 MHz (PAL regions)
* Memory:
    * Built-in to the microcontroller: 64 bytes
    * External: 128 bytes
    * Audio/video RAM: 128 bytes
    * BIOS ROM: 1024 bytes
* Video:
    * Intel 8244 (NTSC) o 8245 (PAL) custom IC
    * Resolution of 160×200 pixels (NTSC)
      Fixed 16-color pallete (8 basic colors: black, blue, green, cyan, red,
      magenta, yellow and white) con an intensity bit that can be used to cut the brightness in half.
* Audio:
   * The same video chip can generate mono sound using a 24-bit shift register, with a
    configurable two frequency noise generator

## Why this machine?

Why not? Thinking about the cyberciruja ideas that involve reusing legacy hardware
I wanted to use this low spec machine. Very interesting things can be made with very simple hardware and software, or at least learn a bit and spend some time developing as we used to.

## Compiling the demo

In order to compile the source code, you need a Windows computer and to follow these steps:

1. Download and decompress the compiler (aswcurr.zip). In the example<br>
```
C:\temp
```
2. Copy both source files to the decompressed directory (C:\temp\aswcurr)
3. Open a PowerShell window in that directory and run:<br>
```
.\bin\asw.exe .\flashparty_2022.asm
```

This will generate an intermediate file flashparty_2022.p. 
That file then needs to be processed once more.

4. Without changing directories, run:<br>
   ```
   .\bin\p2bin .\flashparty_2022.p .\flashparty_2022.raw
   ```

This will generate a 250-byte file with the demo executable.
The problem is that the emulator is expecting a valid ROM size. 
In order to solve this problem we can tell the tool to fill out the rest of the binary so it matches the expected cartridge size.

5. In the same directory, run:<br>
   ```
   .\bin\p2bin .\flashparty_2022.p -r 1024-3071
   ```

This will generate a 2048 byte file that matches the structure of the cartridges. 

## Running the demo

The demo was tested using the O2EM emulator (http://o2em.sourceforge.net/#)
Once decompressed, the emulator waits for the BIOS of the odyssey to be present in the
BIOS directory, and the ROM in the same folder.
In the given folder those are already provided, so after extracting them
we can open a PowerShell terminal and run<br>
  ```
  .\o2em.exe -wsize=1 -scanlines flashparty_2022.bin
  ```

After running that, the emulator should start, ask for a digit (0-9) and then
it starts. The demo doesn't have any sound and it's endless, I hope you like it. :D

## Next steps (?)

* ~~Translate this text to English.~~
* I'd like to use this and keep on studying the platform, then create a game using the gained knowledge.

---

## ¿Flash Party?
Flashparty es un evento basado en el modelo “demoparty” que tiene su origen en
la sub-cultura de la demoscene.
https://flashparty.rebelion.digital/index.php?lang=es

El pasado primero de Octubre fue mostrada esta humilde demo de 250 bytes, como
parte de la categoria "Demo en 256 bytes"

Video de la demo: 
https://github.com/perez-alejandrodaniel/cyberciruja_odyssey/blob/main/video/flashparty_2022.mkv

## La maquina

La Magnavox Odyssey 2 era una maquina basada en un microcontrolador (ni siquiera
un microprocesador) Intel 8048, que ya para la epoca era limitado pero supo dar
batalla en esta consola y algunas otras ya sea como unidad de procesamiento
central como tambien como chip de soporte. Nota curiosa, es el mismo micro que
se usaba como controlador de teclado en las primeras PCs, micro que fue usado
mucho tiempo cumpliendo esta funcion.

## Caracteristicas

* CPU
    * Intel 8048 8-bit funcionando a 5.37 MHz (NTSC) o 5.91 MHz (PAL)
* Memoria:
    * En el microcontrolador: 64 bytes
    * Externa: 128 bytes
    * Audio/video RAM: 128 bytes
    * BIOS ROM: 1024 bytes
* Video:
    * Intel 8244 (NTSC) o 8245 (PAL) custom IC
    * Resolucion 160×200 (NTSC)
      Paleta de 16 colores fija (8 colores basicos negro, azul, verde, cyan, rojo,
      magenta, amarillo y blanco) con un valor que le baja el brillo a la mitad.
* Audio:
   * El mismo chip de video puede generar sonido mono 24-bit shift register, con
    un generador de ruido de dos frecuencias configurable

## ¿Por que la maquina?

¿Por que no? Pensando en el animo cyberciruja de reutilizar todo lo que se puede
quise darle un nuevo uso a una maquina con minimo recursos, con hardware muy
humilde se pueden hacer cosas interesantes, o al menos aprender en el proceso y
pasar un tiempo explorando como se pensaba el soft y hard en el pasado.

## Compilar la demo

Si quieren compilar el ejemplo, necesitan tener una maquina con windows y
seguir los siguentes pasos.

1. Descargar el compilador aswcurr.zip y descomprimir. En el ejemplo<br>
```
C:\temp
```
2. Copiar los dos archivos fuentes en la carpeta descomprimida (C:\temp\aswcurr)
3. Abrir una ventana de Powershell en esa carpeta y correr:<br>
```
.\bin\asw.exe .\flashparty_2022.asm
```

Esto va a generar un archivo de codigo intermedio flashparty_2022.p. Este
archivo necesita ser procesado una vez mas.

4. Sin movernos de carpeta correr:<br>
   ```
   .\bin\p2bin .\flashparty_2022.p .\flashparty_2022.raw
   ```

Esto nos genera un archivo de 250 bytes que es el ejecutable de la demo.
El problema es que el emulador que tengo valida el tamaño del rom, esperando
un tamaño de cartucho valido. Para resolver este problema, podemos decirle
al programa que rellene un sector del binario para que coincida con la
estructura del cartucho

5. En la misma carpeta correr:<br>
   ```
   .\bin\p2bin .\flashparty_2022.p -r 1024-3071
   ```

Esto nos genera un archivo de 2048 bytes que corresponde con el formato
base de los cartuchos.


## Correr la demo

La demo fue probada en el emulador O2EM (http://o2em.sourceforge.net/#)
Una vez descomprimido, el emulador espera la bios de la odyssey en la 
carpeta BIOS y la ROM en la carpeta del mismo nombre.
En la carpeta que les comparto ya esta armado, descomprimiendolo en la
PC abrimos una terminal Powershell y escribimos<br>
  ```
  .\o2em.exe -wsize=1 -scanlines flashparty_2022.bin
  ```

Con eso deberia arrancar el emulador, preguntar por un digito (0-9) y
arranca. La demo no tiene sonido ni fin, espero que les guste. :D


## pasos futuros (?)

~~La idea es subir los fuentes y el binario a github, pero no he tenido tiempo
todavia, por lo pronto no quiero colgar el tema de pasarles mi mini demo.~~

* Pasar este texto a ingles.
* Me gustaria tomar esto, seguir estudiando un poco mas la plataforma y crear un
juego tratando de aprovechar el conocimiento adquirido.

