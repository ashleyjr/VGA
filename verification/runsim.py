#!/usr/bin/python

import sys
import os

if __name__ == "__main__":
    os.system("iverilog -o design.dat -c filelist.txt")
    os.system("vvp design.dat -vcd")

