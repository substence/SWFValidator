from Tkinter import *
import Tkinter, tkFileDialog
import os
import json
import shutil
import pdb

root = Tkinter.Tk()

usedBaseNames_dir = tkFileDialog.askopenfile(parent = root, title = "Select the JSON file with used base names")
parent_dir = tkFileDialog.askdirectory(parent = root, title = "Select the VO dir")
output_dir = tkFileDialog.askdirectory(parent = root, title = "Select the output dir")


# Get the used file names
usedFileNames = []

with open(usedBaseNames_dir, "r") as fin:
	obj = json.loads(fin.read())
	
for key in obj.iterkeys():
	usedFileNames.append(key)


notFile = []
notUsed = []
used = []

# Copy used files into output dir
for fileName in os.listdir(parent_dir):
	print fileName
	if fileName == ".DS_Store":
		notFile.append(fileName)
		print "--------------\n\n"
		continue
	
	srcPath = parent_dir + "/" + fileName
	print "srcPath:", srcPath
	
	if os.path.isfile(srcPath):
		print "is file"
		if fileName in usedFileNames:
			print "file is used, copying"
			used.append(fileName)
			shutil.copy(srcPath, output_dir)
		else:
			notUsed.append(fileName)
	
	print "--------------\n\n"

used.sort()
with open("out_Used.txt", "w") as fout:
	for line in used:
		fout.write(str(line) + "\n")

notFile.sort()
with open("out_NotFile.txt", "w") as fout:
	for line in notFile:
		fout.write(str(line) + "\n")

notUsed.sort()
with open("out_NotUsed.txt", "w") as fout:
	for line in notUsed:
		fout.write(str(line) + "\n")