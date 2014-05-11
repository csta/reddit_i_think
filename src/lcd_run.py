#!/usr/bin/python
import optparse as op
import os
import sys
from time import sleep
from Adafruit_CharLCDPlate import Adafruit_CharLCDPlate
from lcdScroll import Scroller
    
class App(Adafruit_CharLCDPlate):
  """
  Example app to display scrolling text.  Wrapper around the adafruit lcd object.
  """
  def __init__(self):
    Adafruit_CharLCDPlate.__init__(self)
    # setup the LCD:
    self.clear()
    self.backlight(self.WHITE)
    self.speed = 0.35
    p = op.OptionParser()
    p.add_option('--sentence','-s',default=None)
    options,arguments = p.parse_args()
    msg_tmp = options.sentence.decode('utf8').strip()
    msg = ''.join([x for x in msg_tmp  if ord(x) < 128])
    pad = "           "
    n_tot = 2*len(pad)+len(msg)
    top = pad + pad + msg
    bot = ""
    # Set some lines to display:
    lines=[top,bot]
    # Create our scroller instance:
    scroller = Scroller(lines=lines)
    # Display the first unscrolled message:
    message = "\n".join(lines)
    self.clear()
    #self.message(message)
    sleep(self.speed)
    i = 0
    while i < n_tot:
      i = i+1
      # Get the updated scrolled lines, and display:
      message = scroller.scroll()
      self.message(message)
      sleep(self.speed)
    self.clear()
	
if __name__ == "__main__":
  App()
