from Tkinter import *
import Tkinter, tkFileDialog
import os
import json
import pdb

root = Tkinter.Tk()
parent_dir = tkFileDialog.askdirectory(parent = root, title = "Select the directory the VO subdirectories")

_baseNames = {}
_lineNames = {}

def loadNameLists():
	
	with open("VO_Basename_List.json", "r") as fin:
		baseNames = json.loads(fin.read())
	
	with open("VO_Linename_List.json", "r") as fin:
		lineNames = json.loads(fin.read())
	
	
	for key in baseNames.iterkeys():
		_baseNames[key.lower().replace(" ", "_")] = baseNames[key]
	
	for key in lineNames.iterkeys():
		_lineNames[key] = lineNames[key]


def convertNames():
	
	for fileName in os.listdir(parent_dir):
		
		if fileName == ".DS_Store":
			continue
		
	
		srcPath = parent_dir + "/" + fileName
		
		if not os.path.isfile(srcPath):
			continue
	
		
		dstFileName = fileName
		
		
		for key in _baseNames.iterkeys():
			if key in dstFileName:
				dstFileName = dstFileName.replace(str(key), str(_baseNames[key]))
				break
		
		
		if "_sir_yes_sir.wav" in dstFileName:
			key = "_sir_yes_sir.wav"
			dstFileName = dstFileName.replace(key, _lineNames[key])
			
		if "_yes_sir.wav" in dstFileName:
			key = "_yes_sir.wav"
			dstFileName = dstFileName.replace(key, _lineNames[key])
		
		if "_sir.wav" in dstFileName:
			key = "_sir.wav"
			dstFileName = dstFileName.replace(key, _lineNames[key])
		
		if "_come_get_some.wav" in dstFileName:
			key = "_come_get_some.wav"
			dstFileName = dstFileName.replace(key, _lineNames[key])
		
		if "_get_some.wav" in dstFileName:
			key = "_get_some.wav"
			dstFileName = dstFileName.replace(key, _lineNames[key])
		
		for key in _lineNames.iterkeys():
			if "_sir.wav" in key or "_get_some.wav" in key:
				continue
			
			if key in dstFileName:
				
				dstFileName = dstFileName.replace(key, _lineNames[key])
				break
		
		dstPath = parent_dir + "/" + dstFileName
		
		os.rename(srcPath, dstPath)

	
def oldImport():
	for curr_dir_name in os.listdir(parent_dir):
		
		if curr_dir_name == ".DS_Store":
			continue
		
	
		curr_dir = parent_dir + "/" + curr_dir_name
		print "current dir:", curr_dir
	
		
		name = curr_dir_name[:-2].lower().replace(" ", "_")
		number = curr_dir_name[-1:]
	
		
		# Format the new base file name:
		#	dir:		British Sniper 1
		#	base_src:	british_sniper1
		#	base_dst:	british_sniper_1
		base_src = name + number
		base_dst = name + "_" + number
		print "src base name:", base_src
		print "dst base name:", base_dst
		
		
		# Rename each file in the subdir:
		#	oldName:	british_sniper1_affirmitive.wav
		#	newName:	british_sniper_1_affirmitive.wav
		for curr_file_name in os.listdir(curr_dir):
			
			if curr_file_name.startswith(base_src):
				rest_name = curr_file_name[len(base_src):]
				src_file_path = curr_dir + "/" + curr_file_name
				dst_file_path = curr_dir + "/" + base_dst + rest_name
				
				os.rename(src_file_path, dst_file_path)
				print "Renaming", src_file_path, "to", dst_file_path
		
		print "___________________"


loadNameLists()
convertNames()