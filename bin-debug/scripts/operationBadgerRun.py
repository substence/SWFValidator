import json
from openCSV import *
from GetDoc import *
import getpass
	
SPREADSHEET_URL = "0AlqIAVH6r5vJdHQ2dGhZSWt1dkhISkpkV1RUUTlPakE";
GENERAL_DATA_GID = 0;
PROMO_GID = 1;
MISSION_DATA_GID = 7;
OUTPUT_PATH = "../src/com/cc/operations/BadgerRunData.json"

def Load_GDoc(url, gid, email="",password = ""):
    return ProcessCSV(GetCSV(url,gid,email,password))

email = ""
password = ""

if __name__=="__main__":
    if(email == ""):
	    email = raw_input("email:")
    if(password == ""):
        password = getpass.getpass()

	csv_dictionary = []
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, GENERAL_DATA_GID, email, password))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, PROMO_GID, email, password))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, MISSION_DATA_GID, email, password))
	json_file = open(OUTPUT_PATH,'w')
	json_data = json.dumps( [ row for row in csv_dictionary ] )
	json_file.write(json_data)
	print json_data
