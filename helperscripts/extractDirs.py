
import os
import sys

# total arguments
n = len(sys.argv)

if n < 3: exit

infname = sys.argv[1]
outfname = sys.argv[2]

infh=open(infname,"r")
outfh=open(outfname,"w")

for i in infh:
    i=i.strip("\n")
    if os.path.isdir(i) == True:
        outfh.write(i+"\n")
  #  else:
   #     print(i, " not a dir")


