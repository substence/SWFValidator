import json
from openCSV import *
from GetDoc import *
import zlib
	
INPUT_PATH = "../../OperationData.csv"

EMAIL = ""
PASSWORD = ""
BRANCH = ""
SPREADSHEET_URL = "0AlqIAVH6r5vJdC1UZW9hbVFBcVY4N3pveDhmU3FidWc";
GENERAL_DATA_GID = 0;
PROMO_GID = 1;
MISSION_DATA_GID = 7;
HUD_DATA_GID = 2;
OBJECTIVE_DATA_GID = 9;
BASE_SPAWN_DATA_GID = 14;
DESIGN_DATA_GID = 18;

OUTPUT_PATH_COMPRESSED = "../src/com/cc/operations/OperationData.data"

def filter_by_branch(csv_file, branch):
	csv_reader = csv.DictReader(csv_file)
	csv_data = []
	for row in csv_reader:
		# this doesn't actually work, if branch is a substring of a tag, e.g. "broke" in "broken",
		# this row will be added incorrectly
		if row["branches"].find(branch) != -1:
			csv_data.append(row)
	return csv_data
	
def Load_GDoc(url, gid, email="",password = "", branch = ""):
	return filter_by_branch(GetCSV(url,gid,email,password), branch)

def compress_data(json_data):
	data = zlib.compress(json_data)
	return data

if __name__=="__main__":
	if EMAIL == "":
		EMAIL = raw_input("email:")
	if PASSWORD == "":
		PASSWORD = getpass.getpass()
	if BRANCH == "":
		BRANCH = raw_input("branch:")

	print "Importing Operation Data"
	csv_dictionary = []
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, GENERAL_DATA_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, PROMO_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, MISSION_DATA_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, HUD_DATA_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, OBJECTIVE_DATA_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, BASE_SPAWN_DATA_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, DESIGN_DATA_GID, EMAIL, PASSWORD, BRANCH))
	json_data = json.dumps( [ row for row in csv_dictionary ] )
	print json_data
	data = compress_data(json_data)
	data_file = open(OUTPUT_PATH_COMPRESSED,'wb')
	data_file.write(data)
	data_file.close()
	print "Operation Data imported"
