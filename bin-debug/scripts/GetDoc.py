#!/usr/bin/python

import re, urllib, urllib2, getpass

class Spreadsheet(object):
    def __init__(self, key):
        super(Spreadsheet, self).__init__()
        self.key = key

class Client(object):
    def __init__(self, email, password):
        super(Client, self).__init__()
        self.email = email
        self.password = password

    def _get_auth_token(self, email, password, source, service):
        url = "https://www.google.com/accounts/ClientLogin"
        params = {
            "Email": email, "Passwd": password,
            "service": service,
            "accountType": "HOSTED_OR_GOOGLE",
            "source": source
        }
        req = urllib2.Request(url, urllib.urlencode(params))
        return re.findall(r"Auth=(.*)", urllib2.urlopen(req).read())[0]

    def get_auth_token(self):
        source = type(self).__name__
        return self._get_auth_token(self.email, self.password, source, service="wise")

    def download(self, spreadsheet, gid=0, format="csv"):
        url_format = "https://spreadsheets.google.com/feeds/download/spreadsheets/Export?key=%s&exportFormat=%s&gid=%i"
        headers = {
            "Authorization": "GoogleLogin auth=" + self.get_auth_token(),
            "GData-Version": "3.0"
        }
        req = urllib2.Request(url_format % (spreadsheet.key, format, gid), headers=headers)
        return urllib2.urlopen(req)


def GetCSV(spreadsheet_id, gid, email = "", password = ""):
    if(email == ""):
	    email = raw_input("email:")
    if(password == ""):
        password = getpass.getpass()

    print "Downloading...."

    # Create client and spreadsheet objects
    gs = Client(email, password)
    ss = Spreadsheet(spreadsheet_id)

    # Request a file-like object containing the spreadsheet's contents
    return gs.download(ss, gid)

if __name__ == "__main__":
    import getpass
    import csv

    email = "korosz@kixeye.com" # (your email here)
    password = getpass.getpass()
    spreadsheet_id = "0Ao6HDplYn_6MdDRBWFlXNFd3OHhCZU1XcmlMTHNzVmc" # (spreadsheet id here)

    # Create client and spreadsheet objects
    gs = Client(email, password)
    ss = Spreadsheet(spreadsheet_id)

    # Request a file-like object containing the spreadsheet's contents
    csv_file = gs.download(ss, 7)

    # Parse as CSV and print the rows
    for row in csv.reader(csv_file):
        print ", ".join(row)