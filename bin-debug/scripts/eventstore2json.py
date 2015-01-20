from Tkinter import *
import Tkinter, tkFileDialog
from constants import *
import csv
import os
import pdb
from GetDoc import *
import json

KEY_ID = "prizeType"
KEY_NAME = "PackName"
KEY_DESCRIPTION_SHORT = "PackDescriptionShort"
KEY_DESCRIPTION_LONG = "PackDescriptionLong"
KEY_PRICE = "PackPrice"
KEY_BUFF_ID_SET = "BuffIDSet"
KEY_BUFF_PIC = "BuffPic"

CSV_Data = []

def Load_GDoc(email="",password = ""):
    spreadsheet_id = "0AmkRLUo1W1CfdHVDQjBKSlpVVFZxd1V4aXBKaUFRaEE"
    old_id = "0AnZ_ilakSY4sdFRVSmxaelh0aDg2eFUyMV9aanZpeUE"
    gid = 0
    old_gid = 42
    # Request a file-like object containing the spreadsheet's contents
    csv_file = GetCSV(spreadsheet_id,gid,email,password)
    ProcessCSV(csv_file)

def Load_CSV():
	root = Tkinter.Tk()
	path = tkFileDialog.askopenfilename(parent = root, title = "Select the bunker data CSV")
	
	with open(path, "rb") as csv_file:
		csv_reader = csv.DictReader(csv_file)
		for row in csv_reader:
			if row[KEY_ID] != "":
				CSV_Data.append(row)

def ProcessCSV(csv_file):
	csv_reader = csv.DictReader(csv_file)
	for row in csv_reader:
		if row[KEY_ID] != "":
			CSV_Data.append(row)

def ExportData():
        data = json.dumps(CSV_Data,  sort_keys=True,
                  indent=4, separators=(',', ': '))

        # Get the file to write to
        path = "jsondata.php"

        path, extension = os.path.splitext(path)
        extension = ".json"
        path = path + extension

        # Write the output file
        with open(path, "w") as writer:
                writer.write(data)

        print "success!"


def xExportData():
	
	# Add the first couple of lines
	data = ("//EXPORTED BY 'buffpacks_import.py'\n"
			+ "package com.cc.buffs\n"
			+ "{\n"
			+ "\tpublic class BuffPackData\n"
			+ "\t{\n"
			+ "\t\tpublic static const BUFF_PACKS:Array = [\n")
	
	# Format the data for the buff packs
	for i in range(len(CSV_Data)):
		row = CSV_Data[i]
		data += ("{id:\"" + row[KEY_ID] + "\","
				+ "name:\"" + row[KEY_NAME] + "\","
				+ "description_short:\"" + row[KEY_DESCRIPTION_SHORT] + "\","
				+ "description_long:\"" + row[KEY_DESCRIPTION_LONG] + "\","
				+ "price:\"" + row[KEY_PRICE] + "\","
				+ "buff_set:\"" + row[KEY_BUFF_ID_SET] + "\","
				+ "pic:\"" + row[KEY_BUFF_PIC] + "\""
				+ "},\n")
	
	# end the file
	data += ("];\n"
			+ "\t}\n"
			+ "}")
	
	# Get the file to write to
	path = "BuffPackData.as"
	
	path, extension = os.path.splitext(path)
	extension = ".as"
	path = path + extension
	
	# Write the output file
	with open(path, "w") as writer:
		writer.write(data)
	
	print "success!"

def Run(email="",password = ""):
	print "Importing Bunker data"
	Load_GDoc(email,password)
	ExportData()

if __name__=="__main__":
	print "processing data..."
	if len(sys.argv) == 2 and sys.argv[1] == '-local':
		Load_CSV()
	else:
		Load_GDoc('ntemple@kixeye.com')
	ExportData()
