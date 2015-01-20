from Tkinter import *
import Tkinter, tkFileDialog
from constants import *
import csv
import os
import pdb
from GetDoc import *
import json

KEY_ID = "id"

CSV_Data = []

def Load_CSV(path):
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


if __name__=="__main__":
	print "processing data..."
        Load_CSV(sys.argv[1]);
	ExportData()
