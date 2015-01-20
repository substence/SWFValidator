import json
from openCSV import *
import zlib
	
OUTPUT_PATH_COMPRESSED = "../cc/operations/OperationData.data"

def compress_data(json_data):
	data = zlib.compress(json_data)
	return data

def Run():
	print "Importing Operation Data"
	csv_dictionary = []
	csv_dictionary.append(LoadCSV("../../GeneralOperationData.csv"))
	csv_dictionary.append(LoadCSV("../../PromoOperationData.csv"))
	csv_dictionary.append(LoadCSV("../../OperationDataMissionObjectives.csv"))
	csv_dictionary.append(LoadCSV("../../HudOperationData.csv"))
	csv_dictionary.append(LoadCSV("../../ObjectiveOperationData.csv"))
	csv_dictionary.append(LoadCSV("../../BaseSpawnOperationData.csv"))
	csv_dictionary.append(LoadCSV("../../OperationDesignData.csv"))
	json_data = json.dumps( [ row for row in csv_dictionary ] )
	print json_data
	data = compress_data(json_data)
	data_file = open(OUTPUT_PATH_COMPRESSED,'wb')
	data_file.write(data)
	data_file.close()
	print "Operation Data imported"
