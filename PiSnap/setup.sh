#!/bin/sh
#
# Copyright (C) 2015 by Goldbassist, member of OpenMake.cc
# http://www.rasplay.org, https://github.com/rasplay
#
#    This file is part of PiSnap.
#
#    PiSnap is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of
#    the License, or (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

OPTION=$1
SOURCE_DIR="/home/pi/multisnap/PiSnap"
HOME_DIR="/usr/share/nginx"

myIP=$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

######
# Setup Desktop Service
# change default web-browser
######
setup_desktop() {
    sudo apt-get install chromium -y
    sudo sh $SOURCE_DIR/init/boot-desktop
}

######
# Install Web Server
######
install_webserver() {
    sudo apt-get install nginx -y
}

######
# Install Snap!
######
install_snap() {
    sudo cp -r $SOURCE_DIR/snap/* $HOME_DIR/www/
    sudo rm /usr/share/nginx/www/index.html
}

######
# Install PiSnap
######
install_pisnap() {
    sudo cp -r $SOURCE_DIR/snap-RPi $HOME_DIR/
    sudo ln -s $HOME_DIR/snap-RPi/RPiGPIO.xml $HOME_DIR/www/libraries/RPiGPIO.xml
    sudo sed -i '$a\RPiGPIO\tRaspberrypi GPIO' $HOME_DIR/www/libraries/LIBRARIES
    sudo cp $SOURCE_DIR/pisnap $HOME_DIR/
    
    sudo chmod +x $HOME_DIR/pisnap
    sudo ln -s $HOME_DIR/pisnap /etc/init.d/pisnap
    sudo update-rc.d pisnap defaults

    sudo sed -i "s/index index.html index.htm;/index index.html index.htm snap.html;/" /etc/nginx/sites-enabled/default
    sudo sed -i "/naxsi.rules/ a\                autoindex on;" /etc/nginx/sites-enabled/default
}

######
# Setup Korean
######
setup_korean() {
    sh $SOURCE_DIR/init/change-locale
    sudo apt-get install ttf-unfonts-core ibus ibus-hangul -y
}

######
# Install Nailduino and S2A Firmata
######
install_nailduino_s2a() {
    sudo apt-get install python-pip -y
    sudo pip install pyserial
    sudo pip install pymata

    sudo cp -r $SOURCE_DIR/s2a_fm $HOME_DIR/

    cd $SOURCE_DIR
    git clone https://github.com/rasplay/nail_duino.git
    cd nail_duino/
    sudo sh nail_duino.sh

    echo "you can run like"
    echo "cd s2a_fm"
    echo "sudo python s2a_fm.py /dev/ttyS0"
    echo "you must reboot"
}

######
# Change IP
# If raspberrypi changed, run this function.
######
change_ip() {
    echo "your ip : " $myIP

    ## Can connect 192.168.0.xxx
    sudo sed -i 's/server_name [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/server_name '$myIP'/g' /etc/nginx/sites-enabled/default
    sudo sed -i 's/server_name localhost/server_name '$myIP'/g' /etc/nginx/sites-enabled/default

    sh $SOURCE_DIR/init/change-default-browser

    ## PiSnap
    sudo sed -i 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/'$myIP'/g'  $HOME_DIR/www/libraries/RPiGPIO.xml

    ## PiSnapND
    sudo sed -i 's/localhost/'$myIP'/g' $HOME_DIR/www/libraries/NailDuino.xml
    sudo sed -i 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/'$myIP'/g' $HOME_DIR/www/libraries/NailDuino.xml

#    sudo sed -i 's/localhost/'$myIP'/g' $HOME_DIR/s2a_fm/Snap\!Files/blink.xml 
#    sudo sed -i 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/'$myIP'/g' $HOME_DIR/s2a_fm/Snap\!Files/blink.xml 
#    sudo sed -i 's/localhost/'$myIP'/g' $HOME_DIR/s2a_fm/Snap\!Files/s2a_fm_Snap_base.xml
#    sudo sed -i 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/'$myIP'/g' $HOME_DIR/s2a_fm/Snap\!Files/s2a_fm_Snap_base.xml
  

}

#
# Main Script
#
sudo mkdir -p $HOME_DIR/www

if [ -z $OPTION ]; then

    sudo apt-get update; sudo apt-get upgrade -y
    
    install_webserver
    install_snap
    install_pisnap
    #install_nailduino_s2a
    setup_desktop
    #setup_korean
    change_ip

    echo "you can reboot like"
    echo "sudo reboot"
fi

if [ $OPTION="changeIP" ]; then
    change_ip
fi

sudo service nginx restart

