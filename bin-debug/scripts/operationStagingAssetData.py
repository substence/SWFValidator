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
HUD_DATA_GID = 2;
OBJECTIVE_DATA_GID = 9;

exportDirPath = "../src/staging/assets/"

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

OUTPUT_PATH_PREFIX = "gamedata/od."
OUTPUT_PATH_SUFFIX = ".data"
OUTPUT_PATH_JOIN = "."

def compress_data(json_data):
	data = zlib.compress(json_data)
	return data

class GeneralDataRowError:
	"""Too much general data"""
	def __str__(self):
		return "There should be one row in general data, check tags"

def get_output_relative_path(general_data_csv):
	if len(general_data_csv) != 1:
		raise GeneralDataRowError		
	row = general_data_csv[0]
	event_id = row['id']
	version = row['version']
	output_path = OUTPUT_PATH_PREFIX + event_id + OUTPUT_PATH_JOIN + version + OUTPUT_PATH_SUFFIX
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
	general_data_csv = Load_GDoc(SPREADSHEET_URL, GENERAL_DATA_GID, EMAIL, PASSWORD, BRANCH)
	csv_dictionary.append(general_data_csv)
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, PROMO_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, HUD_DATA_GID, EMAIL, PASSWORD, BRANCH))
	csv_dictionary.append(Load_GDoc(SPREADSHEET_URL, OBJECTIVE_DATA_GID, EMAIL, PASSWORD, BRANCH))
	json_data = json.dumps( [ row for row in csv_dictionary ] )
	print json_data
	data = compress_data(json_data)
	output_path = exportDirPath + get_output_relative_path(general_data_csv)
	print "Writing to " + output_path
	data_file = open(output_path,'wb')
	data_file.write(data)
	data_file.close()
	print "Staging Asset Operation Data imported"
