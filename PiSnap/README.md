# We are OpenMake Team on the RaspberryPi Village (http://www.rasplay.org)

## PiSnap
Snap! on RaspberryPi , Web and local education platform.

If you want to PiSnap IMG File Download, [here](http://downloads.rasplay.org/pisnap/PiSnap_beta.tar.gz) to Click

![Alt Text](http://i2.wp.com/www.rasplay.org/wp-content/uploads/Pisnap_3.png?resize=768%2C432)

### Used OSS
--

#### Snap!
* http://snap.berkeley.edu
* Modified
    * Direct Export Project on File
    * Change Logo Image
    * Change Main Costume
    * Add Menu for Raspberrypi, NailDuino(Arduino Firmata)
    
#### FileSaver.js
* https://github.com/eligrey/FileSaver.js
* File Export Library.

#### snap-RPi
* https://github.com/pbrown66/snap-RPi
* Enables us to use the GPIOs on a Raspberry Pi from Snap!.

--

### Setup
* First, must check this basic raspberrypi configuration.
    * run raspi-config
    * Resize SD Card
    * Set Start xwindow at raspberrypi boot-up.
    * International configuration
* Clone Source
```
$ mkdir ~/multisnap
$ cd ~/multisnap
$ git clone https://github.com/rasplay/PiSnap.git
$ cd PiSnap
$ sh setup.sh
```

--

### Run
* Restart RPi
* Double Click PiSnap Desktop Icon
 
### korean language post here : How to install on the Raspberry-Pi
* http://www.rasplay.org/?p=23946

#### Pi Snap Block Sample 

##### RC-Car block

![Alt Text](https://github.com/rasplay/PiSnap/blob/master/image/PiSnap_RCCar.png) 

##### Fruit Piano block

![Alt Text](https://github.com/rasplay/PiSnap/blob/master/image/pi_piano_final.png)
