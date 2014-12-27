#!/usr/bin/python

import string
import sys
import optparse
import os
from PIL import Image
import numpy
import spidev

if __name__ == "__main__":
   # Get image options
   parser = optparse.OptionParser()
   parser.add_option('-s', '--send',dest="send")
   options, remainder = parser.parse_args()

   if(options.send == None):
      print("\nPlease specify char to send (-s)")
      sys.exit(0)
   else:
      send = options.send

   # spi
   spi = spidev.SpiDev()
   spi.open(0,0)
   spi.max_speed_hz = 8000000

   print "{0:b}".format(ord(send)) + " " + send
   got = spi.xfer([ord(send)])
   print "{0:b}".format(got[0]) + " " + chr(got[0])
   spi.close()

