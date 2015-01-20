#!/usr/bin/python
# Usage: python validate.py ../path/to/base/dir ../path/to/config ../path/to/xfl/directory
import sys
import xml.etree.ElementTree as ET
import os
import fnmatch
import os.path

baseDir = sys.argv[1]
configPath = sys.argv[2]
checkAgainstXfl = len(sys.argv) > 3

if os.path.exists(configPath) == False:
	sys.exit("ERROR: Could not find configuration file at " + configPath)

print configPath

configXML = ET.parse(configPath).getroot()

def find_files(directory, pattern):
	for root, dirs, files in os.walk(directory):
		for basename in files:
			if fnmatch.fnmatch(basename, pattern):
				filename = os.path.join(root, basename)
				yield filename

if checkAgainstXfl:
	xfls = []
	print 'Searching for XFL configuration files recursively in ' + sys.argv[3]
	for filename in find_files(sys.argv[3], 'DOMDocument.xml'):
		print "Found XFL configuration file at path: " + filename
		xfls.append(ET.parse(filename).getroot())

# http://stackoverflow.com/questions/3031219/python-recursively-access-dict-via-attributes-as-well-as-index-access
class dotdictify(dict):
    marker = object()
    def __init__(self, value=None):
        if value is None:
            pass
        elif isinstance(value, dict):
            for key in value:
                self.__setitem__(key, value[key])
        else:
            raise TypeError, 'expected dict'

    def __setitem__(self, key, value):
        if isinstance(value, dict) and not isinstance(value, dotdictify):
            value = dotdictify(value)
        dict.__setitem__(self, key, value)

    def __getitem__(self, key):
        found = self.get(key, dotdictify.marker)
        if found is dotdictify.marker:
            found = dotdictify()
            dict.__setitem__(self, key, found)
        return found

    __setattr__ = __setitem__
    __getattr__ = __getitem__

def checkAudioDupes(id):
	matches = 0
	for audio in configXML.find('sounds').getchildren():
		audioAttrs = dotdictify(audio.attrib)
		if(audioAttrs.id == id):
			matches = matches + 1
	if matches > 1:
		errors.append("More than one audio reference uses id '" + id + "'. This is not allowed.")

def checkEffect(effectId):
	for effect in configXML.iter('effect'):
		effectAttrs = dotdictify(effect.attrib)
		if effectAttrs.id == effectId:
			return True
	return False

def checkRef(refId):
	for sound in configXML.iter('sound'):
		soundAttrs = dotdictify(sound.attrib)
		if soundAttrs.id == refId:
			return True
	for music in configXML.iter('music'):
		musicAttrs = dotdictify(music.attrib)
		if musicAttrs.id == refId:
			return True
	return False

def checkGroup(groupId):
	for group in configXML.iter('group'):
		groupAttrs = dotdictify(group.attrib)
		if groupAttrs.id == groupId:
			return True
	return False

def checkReferences(node):
	for ref in node.iter('ref'):
		refAttrs = dotdictify(ref.attrib)
		if refAttrs.target == {}:
			errors.append("Reference exists that does not specify a target")
		if checkRef(refAttrs.target) == False:
			errors.append("Reference specifies a target '" + refAttrs.target + "' that does not exist in the audio list")

def checkExistence(audioAttrs):
	if checkAgainstXfl:
		isLinked = False
		# Note that xmlns attribute in root element declares a namespace that 
		# ET expects to be specified in {} for all child node lookups
		# TODO: Is this brittle? Should be derived from attribute when xml is parsed
		for xflXML in xfls:
			namespace = xflXML.get("xmlns") # doesn't find it
			namespace = "http://ns.adobe.com/xfl/2008/"
			for soundItem in xflXML.iter('{' + namespace + '}DOMSoundItem'):
				soundItemAttrs = dotdictify(soundItem.attrib)
				if soundItemAttrs.linkageClassName == audioAttrs.id:
					isLinked = True
					break
		if not isLinked:
			errors.append("Audio asset '" + audioAttrs.id + "' could not be found in XFL configuration")
	else:
		for directory in configXML.iter('directory'):
			directoryAttrs = dotdictify(directory.attrib)
			path =  baseDir + "/" + str(directoryAttrs.path) + str(audioAttrs.url)
			if os.path.exists(path) == False:
				errors.append("Audio asset '" + audioAttrs.id + "' does not reside at expected path: " + path)

errors = []

# Validate audio (sounds/music nodes)

for audio in configXML.find('sounds').getchildren():
	audioAttrs = dotdictify(audio.attrib)
	if audioAttrs.id == {}:
		errors.append("An audio node did not specify an id")
	else:
		# No longer required since bundle support was enabled
		# errors.append("Audio of id '" + audioAttrs.id + "' does not specify a path")
		if audioAttrs.url != {}:
			if audioAttrs.version == {}:
				errors.append("Audio of id '" + audioAttrs.id + "' does not specify a version")
			if audioAttrs.effect != {}:
				if checkEffect(audioAttrs.effect) == False:
					errors.append("Audio of id '" + audioAttrs.id + "' specifies an effect that does not exist")
			checkExistence(audioAttrs)
			checkAudioDupes(audioAttrs.id)

# Validate effects
# TODO: Validate child nodes specify any of fadeIn, fadeOut, volume, pan (no other supported types)

for effect in configXML.iter('effect'):
	effectAttrs = dotdictify(effect.attrib)
	if effectAttrs.id == {}:
		errors.append("Effect node specified without an id")

# Validate groups

for group in configXML.iter('group'):
	groupAttrs = dotdictify(group.attrib)
	if groupAttrs.id == {}:
		errors.append("A group node did not specify an id")
	else:
		if groupAttrs.effect != {}:
			if checkEffect(groupAttrs.effect) == False:
				errors.append("Group of id '" + groupAttrs.id + "' specifies an effect that does not exist")
		if groupAttrs.playMode != {}:
			# TODO: use reflection on a constants list
			if groupAttrs.playMode != "random" and groupAttrs.playMode != "randomNoRepeat" and groupAttrs.playMode != "shuffle" and groupAttrs.playMode != "sequential":
				errors.append("Group of id '" + groupAttrs.id + "' specifies an unsupported play mode: '" + groupAttrs.playMode + "'")
			checkReferences(group)

# Validate occurrences

for occurrence in configXML.iter('occurrence'):
	occurrenceAttrs = dotdictify(occurrence.attrib)
	if occurrenceAttrs.id == {}:
		errors.append("An occurrence node did not specify an id")
	else:
		for playAction in occurrence.iter('play'):
			playActionAttrs = dotdictify(playAction.attrib)
			if checkRef(playActionAttrs.target) == False:
				errors.append("Occurrence '" + occurrenceAttrs.id + "' is directed to play nonexistent audio: " + playActionAttrs.target)
		for playGroupAction in occurrence.iter('playGroup'):
			playGroupActionAttrs = dotdictify(playGroupAction.attrib)
			if checkGroup(playGroupActionAttrs.target) == False:
				errors.append("Occurrence '" + occurrenceAttrs.id + "' is directed to play nonexistent group: " + playGroupActionAttrs.target)

# Validate bundles

for bundle in configXML.iter('bundle'):
	bundleAttrs = dotdictify(bundle.attrib)
	if bundleAttrs.url == {}:
		errors.append("Bundle specified without a url")

# Validate directories

for directory in configXML.iter('directory'):
	directoryAttrs = dotdictify(directory.attrib)
	if directoryAttrs.path == {}:
		errors.append("Directory specified without a path")

print "==============================================="
print "Audio engine configuration validation complete."
print "==============================================="
for error in errors:
	print error
print "==============================================="
print "Total errors: " + str(len(errors))
print "==============================================="

if len(errors) > 0:
	sys.exit("Audio configuration file failed validation")