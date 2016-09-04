#!/usr/bin/python

import os
import sys
import codecs
import numpy as np

def main():
  if len(sys.argv[1:]) < 3:
    print("Usage: ./ali2mlf <$train_keys> <ali.txt> <ali.txt_filter>")
    sys.exit(1)

  f_keys = sys.argv[1]
  f_in = sys.argv[2]
  f_out = sys.argv[3]

  # Get keys
  keys = []
  with open(f_keys, "r") as f:
    for line in f:
      keys.append(line.strip().split()[0])
  
  # Write output
  with open(f_out, "w") as f_o:
    with open(f_in, "r") as f_i:
      for line in f_i:
        if line.split()[0] in keys:
          f_o.write(line)
    

if __name__ == "__main__":
  main()

