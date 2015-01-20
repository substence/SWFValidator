#!/usr/bin/python

import csv

lastReadCSV="."

def LoadCSV(path):
	global lastReadCSV
	lastReadCSV=path
	with open(path, "rb") as csv_file:
		return ProcessCSV(csv_file)

def ProcessCSV(csv_file):
	csv_reader = csv.DictReader(csv_file)
	csv_data = []
	for row in csv_reader:
		csv_data.append(row)
	return csv_data

def SafeReadCSV(currentRow, function):
	try:
		function()
	except Exception as ex:
		print "Error: Found bad data in '" + lastReadCSV + "' on data row: " + str(currentRow)
		raise ex