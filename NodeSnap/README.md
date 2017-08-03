# README #

### WiringPi
* If you have not wiringpi, like raspbian-jessie-lite.
```
#!bash
$ sudo apt-get install git-core
$ git clone git://git.drogon.net/wiringPi
$ cd wiringPi
$ ./build
```

### Install nodesnap
* tested v.5.x.. [Details](https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
```
#!bash

$ curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
$ sudo apt-get install -y build-essential
$ sudo apt-get install -y nodejs
```

### Clone Source
```
#!bash
$ git clone https://github.com/rasplay/nodesnap.git
$ cd nodesnap
```

### Setup nodesnap
```
#!bash
$ npm install
```

### Run nodesnap Server
```
#!bash
$ ./run
```

### Connect on your browser
```
http://raspberrypi.local:3000/snap
```
