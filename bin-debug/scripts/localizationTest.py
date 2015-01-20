import json
from openCSV import *
from GetDoc import *
import zlib
import os, sys
import re

# NOTE: THIS SCRIPT HAS BEEN AUTOMATED VIA CONCON, AND NOW RESIDES IN THE WC-DATA REPO AT
# importers/client/localizationTest.py

# DO NOT USE THIS SCRIPT TO GENERATE GAME DATA, IT HAS ONLY BEEN LEFT HERE FOR LOCAL TESTING
	
EMAIL = "c-mchinn@kixeye.com"
PASSWORD = "xeftjiljraczobuu"
STRINGTABLE_SPREADSHEET_URL = "0ApgPvAkokLyzdEgtTTFVNjRJTzV6c1h3S2RnTmFVS3c";

CATEGORY = "main"
LOCATION = ["en_US", "de_DE", "fr_FR", "it_IT"]
NAME_HEADER = "name"
LOCALE_HEADER = "locale"
CONTENT_HEADER = "content"
KEY_COLUMN = "key"
STRING_COLUMN = "value"
NOTE_COLUMN = "note"
MAXLENGTH_COLUMN = "maxlength"
GENERAL_DATA_GID = 0;

DATADIR = '../../../wc-data-feature-localization/bin/'
CLIENTDIR = '../'
OUTPUT_SCRIPT_FILE = CLIENTDIR + "src/com/kixeye/wc/resources/WCLocalizerTesting.as"

duplicatesList = {}
	
def Load_GDoc():
    return ProcessCSV(GetCSV(STRINGTABLE_SPREADSHEET_URL, GENERAL_DATA_GID, EMAIL, PASSWORD))
    
def GetDuplicatesDict(csvData, asKeysList = []):
	usedKeys = []
	usedStrings = []
	for row in csvData:
		tIgnoreKeys = ('eventstore','streampost','tech__','units__')
		if (row[KEY_COLUMN] != '' and row[KEY_COLUMN].startswith(tIgnoreKeys) is False):
			#store used keys and strings for duplicate debugging later
			usedKeys.append(row[KEY_COLUMN])
			usedStrings.append(row[STRING_COLUMN])
			
	#make list of dupe keys and strings to check against
	key_dupes = set([x for x in usedKeys if usedKeys.count(x) > 1])
	string_dupes = set([x for x in usedStrings if usedStrings.count(x) > 1])
	
	#Find suspected orphaned keys
	pathList = GetFilteredFilePaths( DATADIR, ['csv'], ['.svn'])
	
	# csvOut = {}
	orphanDict = {}
	dupeDict = {}
	rowNum = 1
	for row in csvData:
		dupeType = 0
		isKeyDupe = row[KEY_COLUMN] in key_dupes
		isStringDupe = row[STRING_COLUMN] in string_dupes
		isOrphan = False
		
		if os.path.exists(DATADIR):
			isOrphan = IsKeyOrphan(row[KEY_COLUMN], asKeysList, pathList)
			if isOrphan:
				orphanDict[row[KEY_COLUMN]] = row[STRING_COLUMN]
		if (isKeyDupe or isStringDupe):
			if (isKeyDupe and isStringDupe):
				dupeType = 3
			if (isStringDupe):
				dupeType = 2
			else:
				dupeType = 1
				
			dupeDict[rowNum] = {'key':row[KEY_COLUMN], 'string': row[STRING_COLUMN], 'type':dupeType, 'orphan':isOrphan}
		rowNum += 1
	# print json.dumps(dupeDict)
	return (dupeDict, orphanDict)

def GetFilteredFilePaths(dir, extens, ignore):

	found = [] # lists of found files
	# search client dir for files, ignore unwanted dirs
	for dirpath, dirnames, files in os.walk(dir):
		# Remove directories in ignore
		for idir in ignore:
			if idir in dirnames:
				dirnames.remove(idir)

		# Loop through the file names for the current step
		for name in files:
			# Split the name by '.' & get the last element
			ext = name.lower().rsplit('.', 1)[-1]
			if ext in extens:
				found.append(os.path.join(dirpath, name))

	#remove duplicates
	return list(set(found))
	
	
def IsKeyOrphan(key, asKeysList, pathList):

	# First check our actionscript keys, then start scraping the csvs
	if key in asKeysList:
		return False
	else:
		return True
	# for asKey in asKeysList:
		# if key == asKey:
			# return False
		# else
			# return True
			
	strings = [] # list of regex matched strings
	regex = re.compile('"'+key+'"') # regex to capture key values from all WCLocalizer.getString() calls in code
	
	# loop through path results
	for path in pathList:
		if ( os.path.basename(path) != "LocalizationTable.csv" ):
			#scrape files for key
			with open(path, 'r') as file:
				for line in file:
					matches = regex.findall(line)
					if matches:
						return False
	return True
	
	
def GetAllKeysInActionscriptFiles():
	found = [] # lists of found files
	strings = [] # list of regex matched strings

	extens = ['as'] # the extensions to search for
	ignore = ['.svn', '.idea','scripts','wc'] # Directories to ignore

	regex = re.compile('WCLocalizer.getString\([\'"](.*?)[\'"]') # regex to capture key values from all WCLocalizer.getString() calls in code

	# search client dir for files, ignore unwanted dirs
	for dirpath, dirnames, files in os.walk(CLIENTDIR):
		# Remove directories in ignore
		for idir in ignore:
			if idir in dirnames:
				dirnames.remove(idir)

		# Loop through the file names for the current step
		for name in files:
			# Split the name by '.' & get the last element
			ext = name.lower().rsplit('.', 1)[-1]
			if ext in extens:
				found.append(os.path.join(dirpath, name))

	#remove duplicates
	found = list(set(found))
	
	# loop through path results
	for path in found:
		#scrape file for getString() keys
		with open(path, 'r') as file:
			for line in file:
				matches = regex.findall(line)
				if matches:
					for m in matches:
						strings.append(m)
						
	#remove dupes and sort
	strings = list(set(strings))
	strings.sort()
	return strings
	
	
def GenerateDuplicatesCSVList( dupeDict = {}):
	
	csvPath = os.path.realpath('DuplicateStrings.csv')
	print('\nGenerating  %s \n' % csvPath)
	print json.dumps(dupeDict)
	with open(csvPath, "wb+") as csvFile:
		csvWriter = csv.writer(csvFile)
		# csvFile.writerow(["key fix", "key", "value"])
		tIgnoreKeys = ('eventstore','streampost','tech__','units__')
		for row in dupeDict:
			if dupeDict[row]["key"].startswith(tIgnoreKeys) is False:
				csvWriter.writerow(["", dupeDict[row]["key"], dupeDict[row]["string"]])
			
def GenerateOrphansCSVList( orphanDict = {}):
	
	csvPath = os.path.realpath('OrphanStrings.csv')
	print('\nGenerating  %s \n' % csvPath)
	# print json.dumps(orphanDict)
	with open(csvPath, "wb+") as csvFile:
		csvWriter = csv.writer(csvFile)
		# csvFile.writerow(["key fix", "key", "value"])
		for key in orphanDict:
			csvWriter.writerow(["", key, orphanDict[key]])
		
def GenerateTestASFile( dupeDict = {}, asKeysList = []):

	print('\nGenerating  %s \n' % os.path.realpath(OUTPUT_SCRIPT_FILE))
	
	# Start text for our scriptfile
	textbody = ''
	textbody += '///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n'
	textbody += '//\n'
	textbody += '// DO NOT EDIT BY HAND!\n'
	textbody += '// This file is autogenerated from client/scripts/Localization.py\n'
	textbody += '//\n'
	textbody += '///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n'

	textbody += '\npackage com.kixeye.wc.resources\n{'
	textbody += '\n\tfinal public class WCLocalizerTesting\n\t{'
	
	#start getKeysUsed()
	textbody += '\n\t\tstatic public function getKeysUsed():Array\n\t\t{'
	textbody += '\n\t\t\tCONFIG::debug\n\t\t\t{'
	textbody += '\n\t\t\t\treturn [\n\t\t'

	#print array of used loc strings
	for string in asKeysList:				
		textbody += '\n\t\t\t\t\t"' + string + '",'
		
	#chop off the last comma
	textbody = textbody[:-1]
	
	#end getKeysUsed()
	textbody += '\n\t\t\t\t];'
	textbody += '\n\t\t\t}'
	textbody += '\n\t\t\treturn [];'
	textbody += '\n\t\t}'
	
	#start getDuplicatesObj()
	textbody += '\n\t\tstatic public function getDuplicatesObj():Object\n\t\t{'
	textbody += '\n\t\t\tCONFIG::debug\n\t\t\t{'
	textbody += '\n\t\t\t\treturn '
	
	textbody += json.dumps(dupeDict, sort_keys=True, indent=20, separators=(',', ': '))
	
	#end getDuplicatesObj()
	# textbody += '\n\t\t\t\t};'
	textbody += ';'
	textbody += '\n\t\t\t}'
	textbody += '\n\t\t\treturn {};'
	textbody += '\n\t\t}'
	
	#end class and package
	textbody += '\n\t}'
	textbody += '\n}'

	# Write results to the script
	with open(OUTPUT_SCRIPT_FILE, 'w') as scriptfile:
		scriptfile.write('{}'.format(textbody))

if __name__=="__main__":
	if EMAIL == "":
		EMAIL = raw_input("email:")
	if PASSWORD == "":
		PASSWORD = getpass.getpass()
		
	print "Exporting Localization Data"
	
	# scrape actionscript for getString() calls with keys
	print "\nSearching for keys in actionscripts"
	asKeysList = GetAllKeysInActionscriptFiles()
	
	# print asKeysList[:20]
	
	# get duplicates and orphans
	print "\nGetting string table online"
	csvData = Load_GDoc()
	# print csvData[:20]
	print "\nProcessing data... this can take a minute..."
	(duplicatesDict, orphanDict) = GetDuplicatesDict( csvData, asKeysList)
	
	# write files
	print "\nWriting files"
	GenerateOrphansCSVList( orphanDict )
	GenerateDuplicatesCSVList( duplicatesDict )
	GenerateTestASFile( duplicatesDict, asKeysList )
	
	print "Finished"