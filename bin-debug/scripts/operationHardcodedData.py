import json
from openCSV import *
from GetDoc import *
import zlib
	
EMAIL = ""
PASSWORD = ""
BRANCH = ""
SPREADSHEET_URL = "0AlqIAVH6r5vJdC1UZW9hbVFBcVY4N3pveDhmU3FidWc";
MISSION_DATA_GID = 7;
BASE_SPAWN_DATA_GID = 14;
DESIGN_DATA_GID = 18;

exportDirPath = "../src/com/"

def filter_by_branch(csv_file, branch):
	csv_reader = csv.DictReader(csv_file)
	csv_data = []
	for row in csv_reader:
		# this doesn't actually work, if branch is a substring of a tag, e.g. "broke" in "broken",
		# this row will be added incorrectly
		if row['branches'].find(branch) != -1:
			csv_data.append(row)
	return csv_data
	
def Load_GDoc(url, gid, email="",password = "", branch = ""):
	return filter_by_branch(GetCSV(url,gid,email,password), branch)

OUTPUT_PATH_SUFFIX = "cc/operations/OperationData.data"

def compress_data(json_data):
	data = zlib.compress(json_data)
	return data
	
def get_output_filename(general_data_csv):
	if len(general_data_csv) != 1:
		raise GeneralDataRowError		
	row = general_data_csv[0]
	event_id = row['id']
	version = row['version']
	output_path = OUTPUT_FILE_PREFIX + event_id + "." + version + OUTPUT_FILE_SUFFIX
	return output_path

if __name__=="__main__":
	if EMAIL == "":
		EMAIL = raw_input("email:")
	if PASSWORD == "":
		PASSWORD = getpass.getpass()
	if BRANCH == "":
		BRANCH = raw_input("branch:")

	print "Importing Operation Data"
	csv_dictionary = []
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, MISSION_DATA_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, BASE_SPAWN_DATA_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, DESIGN_DATA_GID, EMAIL, PASSWORD, BRANCH))
	json_data = json.dumps( [ row for row in csv_dictionary ] )
	print json_data
	data = compress_data(json_data)
	output_path = exportDirPath + OUTPUT_PATH_SUFFIX
	print "Writing to " + output_path
	data_file = open(output_path,'wb')
	data_file.write(data)
	data_file.close()
	print "Client Hardcoded Operation Data imported"
