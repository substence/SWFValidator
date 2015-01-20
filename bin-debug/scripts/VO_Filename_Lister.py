from Tkinter import *
import Tkinter, tkFileDialog
import os
import json

root = Tkinter.Tk()
parent_dir = tkFileDialog.askdirectory(parent = root, title = "Select the directory the VO subdirectories")
output_dir = tkFileDialog.asksaveasfilename(parent = root, title = "Select the output file")


names = {}

nameCounter = 1

for curr_dir_name in os.listdir(parent_dir):
	
	if curr_dir_name == ".DS_Store":
		continue
	
	curr_dir = parent_dir + "/" + curr_dir_name
	if not os.path.isdir(curr_dir):
		continue
	
	names[curr_dir] = "vo_" + str(nameCounter) + "_"
	nameCounter += 1

with open(output_dir, "w") as fout:
	fout.write(json.dumps(names, False, True, True, True, None, 4))