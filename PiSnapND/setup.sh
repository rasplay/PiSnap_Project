#!/bin/sh
#
# Copyright (C) 2015 by Goldbassist, member of OpenMake.cc
# http://www.rasplay.org, https://github.com/rasplay
#
#    This file is part of PiSnapND.
#
#    PiSnapND is free software: you can redistribute it and/or modify
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
SOURCE_DIR="/home/pi/multisnap/PiSnapND"
HOME_DIR="/usr/share/nginx"

myIP=$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

######
# Install Nailduino and S2A Firmata
######
install_nailduino_s2a() {
    sudo apt-get install python-pip -y
    sudo pip install pyserial
    sudo pip install pymata

    cd $SOURCE_DIR
    git clone https://github.com/rasplay/nail_duino.git
    cd nail_duino/
    sudo sh nail_duino.sh
    sudo sh nail_duino_update.sh

    sudo cp -r $SOURCE_DIR/s2a_fm $HOME_DIR/
    sudo cp $HOME_DIR/s2a_fm/Snap\!Files/NailDuino.xml $HOME_DIR/www/libraries/
    sudo sed -i '$a\NailDuino\tNailduino S2A' $HOME_DIR/www/libraries/LIBRARIES
}

######
# Create Nailduino Icon
######
create_ndsnap_icon() {
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Name=NailDuino Snap
GenericName[en_GB]=Terminal
Comment[en_GB]=NailDuino Snap
Exec=sudo python /usr/share/nginx/s2a_fm/s2a_fm.py /dev/ttyS0
Terminal=true
Type=Application
Icon=/usr/share/nginx/www/snap_logo_sm.png
StartupNotify=true
" > /home/pi/Desktop/ndsnap.desktop
}

######
# Change IP
# If raspberrypi changed, run this function.
######
change_ip() {
    echo "your ip : " $myIP
    sudo sed -i 's/localhost/'$myIP'/g' $HOME_DIR/www/libraries/NailDuino.xml
    sudo sed -i 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/'$myIP'/g' $HOME_DIR/www/libraries/NailDuino.xml
    sudo sed -i 's/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/'$myIP'/g'  $HOME_DIR/www/libraries/RPiGPIO.xml
    ## Can connect 192.168.0.xxx
    sudo sed -i 's/server_name [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/server_name '$myIP'/g' /etc/nginx/sites-enabled/default
    sudo sed -i 's/server_name localhost/server_name '$myIP'/g' /etc/nginx/sites-enabled/default

    sh $SOURCE_DIR/init/change-default-browser
}

#
# Main Script
#
if [ -z $OPTION ]; then
    install_nailduino_s2a
    create_ndsnap_icon
    change_ip
fi

if [ $OPTION="changeIP" ]; then
    change_ip
fi

sudo service nginx restart

echo "you can reboot like"
echo "sudo reboot"
