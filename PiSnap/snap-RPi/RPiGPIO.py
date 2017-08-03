#!/usr/bin/python

"""
Snap! extension to support Raspberry Pi -- server component.
Copyright (C) 2014  Paul C. Brown <p_brown@gmx.com>.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

import SimpleHTTPServer
import RPi.GPIO as GPIO
import os
import re
import SocketServer
import urllib2

class CORSHTTPRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    pwm = {}
    pwmstatus = {}   # 0:NoPWM, 1:PWM Stop, 2:PWM Running

    def send_head(self):
        GPIO.setwarnings(False)
        path = self.path
        
        # path looks like this: 
        # /pinwrite?pin=1&state=LOW
        # or
        # /pinread?pin=1&state=LOW
        
        self.pin=0
        self.state=False
        self.duty=0

        GPIO.setmode(GPIO.BCM)                                                                                                                                                                                                      

        ospath = os.path.abspath('')

        regex = re.compile(".*pin=([0-9]*).*state=(LOW|HIGH)")
        m = regex.match(path)

        print (path)
        print (m)
        if 'pinwrite' in path: # write HIGH or LOW to pin

            self.pin = int(m.group(1))
            self.state = True
            if m.group(2) == 'LOW':
                self.state = False

            if self.pin in self.pwm :
                print ("Is pwm")
                self.pwm[self.pin].ChangeDutyCycle(0)
                self.pwm[self.pin].stop()
                del self.pwm[self.pin]
                del self.pwmstatus[self.pin]

            GPIO.setup(self.pin, GPIO.OUT)
            GPIO.output(self.pin, self.state)
                    
        elif 'pinread'in path: # Read state of pin.
            
                """
                This function contains code borrowed heavily from 
                Technoboy10 (https://github.com/technoboy10). Look
                him up. His stuff is amazing!
                """
                self.pin = int(m.group(1))
                self.state = True
                if m.group(2) == 'LOW':
                        self.state = False
                
                f = open(ospath + '/return', 'w+')
                
                GPIO.setup(self.pin, GPIO.IN)
                if(GPIO.input(self.pin) == self.state):
                    f.write(str(True))
                else:
                    f.write(str(False))
                    
                f.close()
                f = open(ospath + '/return', 'rb')
                ctype = self.guess_type(ospath + '/rpireturn')
                self.send_response(200)
                self.send_header("Content-type", ctype)
                fs = os.fstat(f.fileno())
                self.send_header("Content-Length", str(fs[6]))
                self.send_header("Last-Modified", self.date_time_string(fs.st_mtime))
                self.send_header("Access-Control-Allow-Origin", "*")
                self.end_headers()
                return f

        elif 'pinpwm' in path: # PWM to pin
            regex = re.compile(".*pin=([0-9]*).*duty=([0-9]*)")
            m = regex.match(path)

            print (m.group(1)+':'+m.group(2))
            self.pin = int(m.group(1))
            self.duty = int(m.group(2))

            if self.pin not in self.pwm :
                GPIO.setup(self.pin, GPIO.OUT)
                self.pwm[self.pin] = GPIO.PWM(self.pin, 50)
                self.pwm[self.pin].start(self.duty)
                self.pwmstatus[self.pin] = 2

            elif self.pwmstatus[self.pin] is 1 :
                self.pwm[self.pin].start(self.duty)
            elif self.pwmstatus[self.pin] is 2 :
                self.pwm[self.pin].ChangeDutyCycle(self.duty)


if __name__ == "__main__":
    PORT = 8280 #R+P in ASCII Decimal
    Handler = CORSHTTPRequestHandler

    httpd = SocketServer.TCPServer(("", PORT), Handler)

    print "serving at port", PORT
    print "Go ahead and launch Snap!"
    httpd.serve_forever()


