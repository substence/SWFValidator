import json
from openCSV import *
from GetDoc import *
import zlib
import os

# NOTE: THIS SCRIPT HAS BEEN AUTOMATED VIA CONCON, AND NOW RESIDES IN THE WC-DATA REPO AT
# importers/client/concon_localization.py

# DO NOT USE THIS SCRIPT TO GENERATE GAME DATA, IT HAS ONLY BEEN LEFT HERE FOR LOCAL TESTING

EMAIL = "c-mchinn@kixeye.com"
PASSWORD = "xeftjiljraczobuu"
STRINGTABLE_SPREADSHEET_URL = "0ApgPvAkokLyzdEgtTTFVNjRJTzV6c1h3S2RnTmFVS3c";
CATEGORY = "main"
LOCATION = "en_US"
NAME_HEADER = "name"
LOCALE_HEADER = "locale"
CONTENT_HEADER = "content"
KEY_COLUMN = "key"
STRING_COLUMN = "value"
NOTE_COLUMN = "note"
MAXLENGTH_COLUMN = "maxlength"
GENERAL_DATA_GID = 0;
OUTPUT_DIR = "../src/staging/assets/localization/"
OUTPUT_FILE = LOCATION + "_test.json"
OUTPUT_PATH = OUTPUT_DIR + OUTPUT_FILE
COMPRESSION = True
	
def Load_GDoc(url, gid, email="",password = ""):
    return ProcessCSV(GetCSV(url,gid,email,password))
    
def GetRelevantColumns(url, gid, email="",password = ""):
	unitData = ProcessCSV(GetCSV(url,gid,email,password))

	relevantData = {}
	relevantData[NAME_HEADER] = CATEGORY
	relevantData[LOCALE_HEADER] = LOCATION
	content = {}
	for row in unitData:
		if (row[KEY_COLUMN] != '' ):		
			keyStringData = {}			
			keyStringData[STRING_COLUMN] 	= row[STRING_COLUMN]
			keyStringData[NOTE_COLUMN] 	= row[NOTE_COLUMN]
			if (row[MAXLENGTH_COLUMN] != ''):
				keyStringData[MAXLENGTH_COLUMN] 	= row[MAXLENGTH_COLUMN]
			else:
				keyStringData[MAXLENGTH_COLUMN] = -1
			content[row[KEY_COLUMN]] = keyStringData

	relevantData[CONTENT_HEADER] = content
	return relevantData
	
if __name__=="__main__":
	if EMAIL == "":
		EMAIL = raw_input("email:")
	if PASSWORD == "":
		PASSWORD = getpass.getpass()

	print "Exporting Localization Data"
	csv_dictionary = []	
	csv_dictionary.append(GetRelevantColumns(STRINGTABLE_SPREADSHEET_URL, GENERAL_DATA_GID, EMAIL, PASSWORD))	
	json_data = json.dumps( [ row for row in csv_dictionary ] )
	json_data = json_data.replace('[','')
	json_data = json_data.replace(']','')
		
	if not os.path.exists(OUTPUT_DIR):
		os.makedirs(OUTPUT_DIR)
	
	if (COMPRESSION):
		json_file_zip = open(OUTPUT_PATH,'wb')
		json_file_zip.write(zlib.compress(json_data,9))
		json_file_zip.close()
	else:
		json_file = open(OUTPUT_PATH,'w')
		json_file.write(json_data)
		json_file.close()
	
	print "Finished"
