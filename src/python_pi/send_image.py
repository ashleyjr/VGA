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
   parser.add_option('-I', '--image',dest="image")
   parser.add_option('-H', '--height',dest="height")
   parser.add_option('-W', '--width',dest="width")
   options, remainder = parser.parse_args()

   if(options.width == None):
      print("\nPlease specify image width (-W)")
      sys.exit(0)
   else:
      width = int(options.width)

   if(options.height == None):
      print("\nPlease specify image height (-H)")
      sys.exit(0)
   else:
      height = int(options.height)

   if(options.image == None):
      print("\nPlease specify image (-I)")
      sys.exit(0)
   else:
      image = options.image

   # spi
   spi = spidev.SpiDev()
   spi.open(0,0)
   spi.max_speed_hz = 8000000


   # Resize, B&W and save image
   os.chdir("../../test_data")
   im = Image.open(image)
   name,ext = image.split('.')
   im = im.convert('L')
   im = im.resize((width,height),Image.ANTIALIAS)
   sized = name + "Size." + ext
   im.save("OutRaw.png")


   print ("\nResized image: %s" % str(sized))


   # Convert to mat and do stuff
   imMat = numpy.asarray(im)

   im = numpy.zeros((height,width))
   im.setflags(write=True)


   ## Open file and write verilog
   for i in range(0,height):
      temp = spi.xfer(imMat[i].tolist())
      for j in range(0,width):
         im[i][j] = temp[j]
         #print "Out:" + str(int(im[i][j])) + " " + bin(int(im[i][j]))
         #print " In:" + str(imMat[i][j]) + " " + bin(imMat[i][j])
   spi.close()


   img = Image.fromarray(im.astype(numpy.uint8), 'L')      # Cast to get rid of errors
   img.save("InRaw.png")
