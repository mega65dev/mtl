# ***************************************************************************************************************
# ***************************************************************************************************************
#
#      Name:       buildlist.py
#      Purpose:    Create linked list of routines in runtime
#      Created:    28th December 2020
#      Author:     Paul Robson (paul@robsons.org.uk)
#				   (Based on code by Marc Teufel)
#
# ***************************************************************************************************************
# ***************************************************************************************************************

import sys,os,re

#
#	Find all entries by scanning the list file - list of absolute addresses.
#
keywords = [x for x in open("main.lst").readlines() if x.find("+define") >= 0]
keywords = [int(re.match("^\\s+\\d+\\s*([0-9a-f]+)",x).group(1),16) for x in keywords]
#
#	Read main.prg binary
#
h = open("main.prg","rb")
binary = [x for x in h.read(-1)]
h.close()
loadAddress = binary[0]+binary[1]*256
print("Loads at ${0:04x}".format(loadAddress))
#
#	Add to absolute address to get offset in binary.
#
offset = -loadAddress+2
#
#	Work through.
#
lastPatchAddress = loadAddress+20 					
for addr in keywords:
	#
	#		Get information
	#
	paramCount = binary[addr+offset+2]
	paramStart = binary[addr+offset+3]
	p = addr+4
	s = ""
	while binary[p+offset] != 0:
		s = s + chr(binary[p+offset])
		p += 1
	code = (p + 3) & 0xFFFC
	print("\tAt ${0:04x} {1}() {2:1} params, start at ${3:04x}, run from ${4:04x}".format(addr,s,paramCount,paramStart,code))
	#
	#		Patch last link
	#	
	binary[lastPatchAddress+offset] = addr & 0xFF
	binary[lastPatchAddress+offset+1] = addr >> 8
	#
	#		This is new link
	#
	lastPatchAddress = addr
#
#		Write out.
#
h = open("main.prg","wb")
h.write(bytes(binary))
h.close()