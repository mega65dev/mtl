# ***************************************************************************************************************
# ***************************************************************************************************************
#
#      Name:       addheader.py
#      Purpose:    Convert CBM Code PRG to runnable BASIC PRG by adding 255 byte header.
#      Created:    27th December 2020
#      Author:     Paul Robson (paul@robsons.org.uk)
#				   (Based on code by Marc Teufel)
#
# ***************************************************************************************************************
# ***************************************************************************************************************

import sys,os

for f in sys.argv[1:]:
	header = [ 0 ] * 256 										# 255 byte header goes on the front.
	h = open(f,"rb")											# open and read file in.
	code = bytes(h.read(-1))
	h.close()
	loadAddress = code[0] + (code[1] << 8) 						# where it loads.
	print("{0} loads at ${1:04x}".format(f,loadAddress))
	code = code[2:]												# strip 2 byte header off.
	#
	header[3] = 1 												# line number 1.
	header[4] = 0
	#
	tokens = ""
	tokens = tokens + chr(0xFE)+chr(0x02)+"0:" 					# BANK 0:
	#
	tokens = tokens + chr(0x9E)+str(loadAddress) 				# SYS <run address>
	#
	for i in range(0,len(tokens)):
		header[i+5] = ord(tokens[i])
	header[len(tokens)+5] = 0 									# end of line.
	#
	header[1] = len(tokens)+6 									# link to next line (next link zero already)
	header[2] = (loadAddress >> 8) - 1							# in the previous page.
	#
	h = open(f,"wb") 											# now write file back out.
	h.write(bytes([1,header[2]]))								# start with load address.
	h.write(bytes(header[1:]))									# then header
	h.write(bytes(code))										# then the body
	h.close()
	#
#	for i in range(1,19):
#		print(i,header[i])