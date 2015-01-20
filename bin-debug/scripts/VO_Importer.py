from Tkinter import *
import Tkinter, tkFileDialog
import json
from constants import *
from VO_legacy_unit_sound_data import *
import csv
import os
import pdb
from GetDoc import *

EXPORT_PACKAGE_NAME =	"com.cc.sound"

KEY_BASE_PATH = 		"base"

KEY_GROUP_VO =	 		"vo"
KEY_GROUP_SFX = 		"sfx"

KEY_SFX_MOVE =			"move"
KEY_SFX_MELEE =			"melee"
KEY_SFX_DIG =			"dig"

KEY_VO_SELECT = 		"select"
KEY_VO_MOVE =			"move"
KEY_VO_MOVE_BATTLE =	"movebattle"
KEY_VO_ATTACK =			"atk"
KEY_VO_DIE =			"die"

KEY_SOUND_NAME =		"name"
KEY_SOUND_FREQUENCY =	"freq"

KEY_ROW_ACTION =		"Action"
KEY_ROW_LINE =			"Line"
KEY_ROW_FILE =			"File"


CSV_Data = []
UsedNameList = {}
Units = {}

UnusedAccents = {}

UsedFiles = {}

def Load_GDoc(email="",password = ""):
	spreadsheet_id = "0Aot1m-4cPFR_dFNpMDlHbEVkUmNHcFNYNm8xMHpyZkE"
	gid = 1
	# Request a file-like object containing the spreadsheet's contents
	csv_file = GetCSV(spreadsheet_id,gid,email,password)
	ProcessCSV(csv_file)

def Load_CSV():

	root = Tkinter.Tk()
	path = tkFileDialog.askopenfilename(parent = root, title = "Select the tower data CSV")
	
	with open(path, "rb") as csv_file:
		ProcessCSV(csvfile)

def Load_CSV():
	path = tkFileDialog.askopenfilename(parent = root, title = "Select the VO CSV")
	with open(path, "rb") as csv_file:
		ProcessCSV(csvfile)
	
def ProcessCSV(csv_file):
	csv_reader = csv.DictReader(csv_file)
	for row in csv_reader:
		if row[KEY_ROW_ACTION] != "":
			CSV_Data.append(row)
		else:
			usedBaseNames = row
	
	# Remove the "Line" key from all the rows
	for i in range(len(CSV_Data)):
		row = CSV_Data[i]
		del row[KEY_ROW_LINE]
	
	
	del usedBaseNames[KEY_ROW_ACTION]
	del usedBaseNames[KEY_ROW_LINE]
	del usedBaseNames[KEY_ROW_FILE]
	RenameNameValues(usedBaseNames)


def RenameNameValues(usedBaseNames):
	
	baseNameList = {}
	lineNameList = {}
	
	# Load the Base Name list
	with open("VO_Basename_List.json", "r") as fin:
		obj = json.loads(fin.read())
	
	for key in obj.iterkeys():
		baseNameList[key] = obj[key]
	
	
	# Load the Line Name list
	with open("VO_Linename_List.json", "r") as fin:
		obj = json.loads(fin.read())
	
	for key in obj.iterkeys():
		lineNameList[key] = obj[key]
	
	
	# Get the formatted base name from the loaded base name key/values
	for unitName in usedBaseNames.iterkeys():
		baseName = usedBaseNames[unitName]
		if baseName in baseNameList:
			UsedNameList[unit_ids[unitName]] = baseNameList[baseName]
	
	
	# Rename each row's "Line" data to the formatted one
	for i in range(len(CSV_Data)):
		row = CSV_Data[i]
		
		if KEY_ROW_FILE in row:
			row[KEY_ROW_FILE] = lineNameList[row[KEY_ROW_FILE]]


def SetupUnitsData():
	
	# Get the Units & Voice names
	for unitId in UsedNameList.iterkeys():
		
		base_sound_name = UsedNameList[unitId]
		
		dictVO = { KEY_VO_SELECT:[], KEY_VO_MOVE:[], KEY_VO_MOVE_BATTLE:[], KEY_VO_ATTACK:[], KEY_VO_DIE:[] }
		
		Units[unitId] = { KEY_BASE_PATH:base_sound_name, KEY_GROUP_VO:dictVO }


def ProcessRows():
	
	# Grab the values from the rows[1]..rows.lenth
	for i in range(len(CSV_Data)):
		row = CSV_Data[i]
		
		
		# Get the action and rest of the file name. ex: "select"
		action = row[KEY_ROW_ACTION].lower()
		
		
		# Go through all the column pairs
		for key in row.iterkeys():
			if key == "Action" or key == "File":
				continue
			
			
			# Skip frequency values that are "X" or "N/A"
			frequency = row[key]
			if frequency == "X" or frequency == "N/A":
				continue
			try:
				frequency = int(frequency)
			except ValueError:
				print("Error on")
				print("\tRow:", i)
				print("\tKey:", key)
				print("\tFreq:", frequency)
				print("\tRow Data:", str(row))
				print("----\n")
			
			
			unitId = unit_ids[key]
			
			
			# Get the unit's file name. ex: "_sir.wav"
			sound_name = row[KEY_ROW_FILE]
			
			
			# Format a sound_info object with the file name and frequency
			sound_info = { KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:frequency }
			
			
			# Add the sound_info to each of the unit's types if applicable
			unit = Units[unitId]
			if "select" in action:
				unit[KEY_GROUP_VO][KEY_VO_SELECT].append(sound_info)
			
			if "move" in action:
				
				if "base" in action:
					unit[KEY_GROUP_VO][KEY_VO_MOVE].append(sound_info)
				
				if "battle" in action:
					unit[KEY_GROUP_VO][KEY_VO_MOVE_BATTLE].append(sound_info)
			
			if "attack" in action:
				unit[KEY_GROUP_VO][KEY_VO_ATTACK].append(sound_info)
			
			if "death" in action:
				unit[KEY_GROUP_VO][KEY_VO_DIE].append(sound_info)


def HandleLegacyData():
	
	customUnitKeys = [UNIT_WORKER, UNIT_VEHICLE_TANKDRONE, UNIT_AIR_WINGDRONE, UNIT_AIR_CHOPPERDRONE, UNIT_FOOT_BOMBER, UNIT_FOOT_DOG, UNIT_VEHICLE_TANKBUSTER, UNIT_VEHICLE_DEMO_TRUCK]
	
	# If the unit has a legacy "move" sfx add a sfx sound group for it
	for key in Units.iterkeys():
		if key in legacy_sound_data:
			legacyData = legacy_sound_data[key]
				
			if not key in customUnitKeys:
				if len(legacyData["move"]) > 0:
					sound_info = { KEY_SOUND_NAME:legacyData["move"][0], KEY_SOUND_FREQUENCY:1 }
					Units[key][KEY_GROUP_SFX] = { KEY_SFX_MOVE:[sound_info] }
	
	
	#######################################
	# Set legacy UNIT_WORKER data
	#######################################
	legacyData = legacy_sound_data[UNIT_WORKER]
	dictVO = GenerateLegacy_DictVO(legacyData)
	dictSFX = GenerateLegacy_DictSFX(legacyData)
	Units[UNIT_WORKER] = { KEY_BASE_PATH:"", KEY_GROUP_VO:dictVO, KEY_GROUP_SFX:dictSFX }
	
	
	#######################################
	# Set legacy Jackrabbit data
	#######################################
	legacyData = legacy_sound_data[UNIT_VEHICLE_TANKDRONE]
	dictVO = GenerateLegacy_DictVO(legacyData)
	dictSFX = GenerateLegacy_DictSFX(legacyData)
	Units[UNIT_VEHICLE_TANKDRONE] = { KEY_BASE_PATH:"", KEY_GROUP_VO:dictVO, KEY_GROUP_SFX:dictSFX }
	
	
	#######################################
	# Set legacy Wing Drone data
	#######################################
	legacyData = legacy_sound_data[UNIT_AIR_WINGDRONE]
	dictVO = GenerateLegacy_DictVO(legacyData)
	Units[UNIT_AIR_WINGDRONE] = { KEY_BASE_PATH:"", KEY_GROUP_VO:dictVO }
	
	
	#######################################
	# Set legacy Chopper Drone data
	#######################################
	legacyData = legacy_sound_data[UNIT_AIR_CHOPPERDRONE]
	dictVO = GenerateLegacy_DictVO(legacyData)
	Units[UNIT_AIR_CHOPPERDRONE] = { KEY_BASE_PATH:"", KEY_GROUP_VO:dictVO }
	
	
	#######################################
	# Set legacy UNIT_FOOT_BOMBER data
	#######################################
	legacyData = legacy_sound_data[UNIT_FOOT_BOMBER]	
	dictVO = GenerateLegacy_DictVO(legacyData)
	Units[UNIT_FOOT_BOMBER] = { KEY_BASE_PATH:"", KEY_GROUP_VO:dictVO }
	
	
	#######################################
	# Set legacy UNIT_VEHICLE_DEMO_TRUCK data
	#######################################
	legacyData = legacy_sound_data[UNIT_VEHICLE_DEMO_TRUCK]	
	dictVO = GenerateLegacy_DictVO(legacyData)
	Units[UNIT_VEHICLE_DEMO_TRUCK] = { KEY_BASE_PATH:"", KEY_GROUP_VO:dictVO }
	
	
	#######################################
	# Set legacy UNIT_FOOT_DOG data
	#######################################
	legacyData = legacy_sound_data[UNIT_FOOT_DOG]
	dictVO = GenerateLegacy_DictVO(legacyData)
	dictSFX = GenerateLegacy_DictSFX(legacyData)
	Units[UNIT_FOOT_DOG] = { KEY_BASE_PATH:"", KEY_GROUP_VO:dictVO, KEY_GROUP_SFX:dictSFX }
	
	
	#######################################
	# Set legacy Honey Badger data
	#######################################
	legacyData = legacy_sound_data[UNIT_VEHICLE_TANKBUSTER]
	dictVO = GenerateLegacy_DictVO(legacyData)
	dictSFX = GenerateLegacy_DictSFX(legacyData)
	Units[UNIT_VEHICLE_TANKBUSTER] = { KEY_BASE_PATH:"", KEY_GROUP_VO:dictVO, KEY_GROUP_SFX:dictSFX }


def GenerateLegacy_DictVO(legacyData):
	if legacyData == None:
		print "GenerateLegacy_DictVO ERROR: param legacyData is null"
		return
	
	dictVO = {}
	
	legacyKey = "voselect"
	if legacyKey in legacyData:
		for i in range(len(legacyData[legacyKey])):
			if not KEY_VO_SELECT in dictVO:
				dictVO[KEY_VO_SELECT] = []
				
			sound_name = legacyData[legacyKey][i]
			dictVO[KEY_VO_SELECT].append({ KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:1 })
	
	
	legacyKey = "voorder"
	if legacyKey in legacyData:
		for i in range(len(legacyData[legacyKey])):
			if not KEY_VO_MOVE in dictVO:
				dictVO[KEY_VO_MOVE] = []
				
			if not KEY_VO_MOVE_BATTLE in dictVO:
				dictVO[KEY_VO_MOVE_BATTLE] = []
				
			sound_name = legacyData[legacyKey][i]
			dictVO[KEY_VO_MOVE].append({ KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:1 })
			dictVO[KEY_VO_MOVE_BATTLE].append({ KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:1 })
	
	
	legacyKey = "voattack"
	if legacyKey in legacyData:
		for i in range(len(legacyData[legacyKey])):
			if not KEY_VO_ATTACK in dictVO:
				dictVO[KEY_VO_ATTACK] = []
				
			sound_name = legacyData[legacyKey][i]
			dictVO[KEY_VO_ATTACK].append({ KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:1 })
	
	
	legacyKey = "die"
	if legacyKey in legacyData:
		sound_name = legacyData[legacyKey]
		dictVO[KEY_VO_DIE] = [{ KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:1 }]
	
	return dictVO


def GenerateLegacy_DictSFX(legacyData):
	if legacyData == None:
		print "GenerateLegacy_DictSFX ERROR: param legacyData is null"
		return
	
	dictSFX = {}
	
	if "move" in legacyData:
		sound_name = legacyData["move"][0]
		dictSFX[KEY_SFX_MELEE] = [{ KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:1 }]
		
	if "melee" in legacyData:
		sound_name = legacyData["melee"][0]
		dictSFX[KEY_SFX_MELEE] = [{ KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:1 }]
	
	if "dig" in legacyData:
		sound_name = legacyData["dig"][0]
		dictSFX[KEY_SFX_DIG] = [{ KEY_SOUND_NAME:sound_name, KEY_SOUND_FREQUENCY:1 }]

	return dictSFX


def ExportData():
	
	# Read in the template file
	with open("VO_Template_Sound_Units_Data.txt", "r") as reader:
		template = reader.read()
	
	
	# Remove empty lists from the Units data
	for unit in Units.itervalues():
		if KEY_GROUP_VO in unit:
			groupVO = unit[KEY_GROUP_VO]
			keysToRemove = []
			for key in groupVO.iterkeys():
				if len(groupVO[key]) == 0:
					keysToRemove.append(key)
			
			for i in range(len(keysToRemove)):
				key = keysToRemove[i]
				del groupVO[key]
	
	
	# JSON encode the data, split it into lines, add tabs to them, and make them all one string again
	data = ""
	lines = json.dumps(Units, True, True, True, True, None, 4).splitlines(True)
	lineCount = len(lines)
	for i in range(lineCount):
		if i == 0:
			data += "{\n"
		elif i == lineCount - 1:
			data += "\t\t\t}"
		else:
			data += "\t\t\t" + lines[i];
	
	
	
	# Format the data to write
	template = template.replace("#data", data)
	
	
	path = tkFileDialog.asksaveasfilename(parent = Tkinter.Tk(), title = "AS3 File to export to")
	
	path, extension = os.path.splitext(path)
	extension = ".as"
	path = path + extension
	
	# Write the output file
	with open(path, "w") as writer:
		writer.write(template)
	
	#soundInfos = {}
	# Write out the used VO
	#for unitKey in Units.iterkeys():
	#	unit = Units[unitKey]
	#	
	#	baseName = unit[KEY_BASE_PATH]
	#	
	#	if KEY_GROUP_VO in unit:
	#		groupVO = unit[KEY_GROUP_VO]
	#		
	#		for group in groupVO.itervalues():
	#			for i in range(len(group)):
	#				
	#				fullKey = baseName + str(group[i][KEY_SOUND_NAME])
	#				if fullKey in soundInfos:
	#					soundInfos[fullKey] = soundInfos[fullKey] + 1
	#				else:
	#					soundInfos[fullKey] = 1
	#
	#with open("usedBaseNames.txt", "w") as fout:
	#	fout.write(json.dumps(soundInfos, True, True, True, True, None, 4))
	
	print "success!"


def PrintDebugExport():
	for unitKey in Units.iterkeys():
		unit = Units[unitKey]
		
		print unitKey, ":"
		
		print "\tbase sound name:", unit[KEY_BASE_PATH]
		print "\ttypes:"
		
		for typeKey in unit[KEY_SOUND_TYPES].iterkeys():
			print "\t\t", typeKey, ":"
			
			for i in range(len(unit[KEY_SOUND_TYPES][typeKey])):
				sound_info = unit[KEY_SOUND_TYPES][typeKey][i]
				print "\t\t\tsound name:", sound_info[KEY_SOUND_NAME]
				print "\t\t\tfrequency:", sound_info[KEY_SOUND_FREQUENCY]
		
		print "______________"



def Run(email="",password = ""):
	print "Importing Voice Over data..."
	Load_GDoc(email,password)
	SetupUnitsData()
	ProcessRows()
	HandleLegacyData()
	ExportData()

if __name__=="__main__":
	print "Importing Voice Over data..."
	if len(sys.argv) == 2 and sys.argv[1] == '-local':
		Load_CSV()
	else:
		Load_GDoc()
SetupUnitsData()
ProcessRows()
HandleLegacyData()
ExportData()