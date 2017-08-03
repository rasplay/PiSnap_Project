snap-RPi
========

## What is this

A set of blocks (currently only 2) and code which enables us to use the GPIOs on a Raspberry Pi from Snap!.

## Bits

- The blocks (currently 2 'blocks') in RPiGPIO.xml. Blocks are located in Looks and Operators.

- The server the blocks connect to: RPiGPIO.py 

## How to install

Copy the server RPiGPIO.py onto your Pi. Copy RPiGPIO.xml onto your main computer.

## How to run

Run the python script from your Pi (with sudo!). Access Snap! from the browser on your main computer. Import RPiGPIO.xml file into Snap!.

You may have to change the IP address in the blocks (right click + _Edit_) so it points to your Raspberry Pi on your network.

## Caveat

Snap! runs like molasses on the RPi. Don't do that. Until the performance issues are solved, you can run Snap! from a server on the Pi (I use lighttpd) and access it from a more powerful computer on your network. Or just connect to the official implementation at Berkeley:

http://snap.berkeley.edu/snapsource/snap.html

## Why does this exist?

Because Snap! is easy and intuitive to extend, which makes it ideal for educational purposes, i.e., you can use this to teach students how to meta-program, developing the language that they can then use to program the Rpi. This leads to many interesting possibilities.
