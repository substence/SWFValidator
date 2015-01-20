import json
from openCSV import *
from GetDoc import *
import zlib
	
EMAIL = "orlando@kixeye.com"
PASSWORD = "fpbayganlujbvopt"
SPRITESHEET_SPREADSHEET_URL = "0AlqIAVH6r5vJdC1FRTlRT3BCQ3A2UnlyVGRTeTFUWGc";
SKINSHEET_SPREADSHEET_URL = "0AlqIAVH6r5vJdC1FRTlRT3BCQ3A2UnlyVGRTeTFUWGc";
SKIN_COLUMN = "skin"
ELITE_SKIN_COLUMN = "eliteSkin"
PORTRAIT_KEY = "portraitKey"
ID_COLUMN = "-id"
LEVEL_COLUMN = "lvl"
OUTPUT_PATH = "../src/com/cc/units/UnitSpriteSheetData_COMPRESSED.data"
	
def Load_GDoc(url, gid, email="",password = ""):
    return ProcessCSV(GetCSV(url,gid,email,password))
	
def DeleteEmptyCells(csv):
	for row in csv:
		for column in row.keys():
			if (row[column] == ''):
				del row[column]
	return csv
    
if __name__=="__main__":
	if EMAIL == "":
		EMAIL = raw_input("email:")
	if PASSWORD == "":
		PASSWORD = getpass.getpass()
	csv_dictionary = []
	csv_dictionary.append(DeleteEmptyCells(Load_GDoc(SPRITESHEET_SPREADSHEET_URL, 0, EMAIL, PASSWORD)))	
	csv_dictionary.append(DeleteEmptyCells(Load_GDoc(SKINSHEET_SPREADSHEET_URL, 14, EMAIL, PASSWORD)))
	json_data = json.dumps( [ row for row in csv_dictionary ] )
	data = zlib.compress(json_data)
	data_file = open(OUTPUT_PATH,'wb')
	data_file.write(data)
	data_file.close()