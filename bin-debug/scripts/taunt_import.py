'''
mission_import.py
J. Adrian Herbez

This will take in a CSV with mission data, and insert it into:
com/cc/units/Units.as (for units)
GLOBAL.as (for buildings)

'''

from Tkinter import *
import Tkinter, tkFileDialog
import json
import operator

root = Tkinter.Tk()

stream_posts = []
headings = {}
unitPosts = {}
buildingPosts = {}
miscPosts = {}

UNIT_FOOT_RIFLE = 2
UNIT_FOOT_SAW = 3
UNIT_FOOT_RPG = 4
UNIT_FOOT_FLAME = 5
UNIT_FOOT_SNIPER = 6
UNIT_FOOT_BOMBER = 7
UNIT_FOOT_TECH = 8
UNIT_FOOT_MEDIC = 9
UNIT_FOOT_MECH = 28
#Land
UNIT_VEHICLE_TANKDRONE = 10
UNIT_VEHICLE_BUGGY = 11
UNIT_VEHICLE_HUMVEE = 12
UNIT_VEHICLE_MAV = 13
UNIT_VEHICLE_TANK1 = 14
UNIT_VEHICLE_TANK2 = 15
UNIT_VEHICLE_TANK3 = 16
UNIT_VEHICLE_LASERTANK = 17
UNIT_VEHICLE_ANTIAIR = 18
UNIT_VEHICLE_JAMMER = 19
UNIT_VEHICLE_ANTIMISSILE = 20
UNIT_VEHICLE_MEGATANK = 21
# AIR
UNIT_AIR_WINGDRONE = 22
UNIT_AIR_CHOPPERDRONE = 23
UNIT_AIR_CHOPPER1 = 24
UNIT_AIR_CHOPPER2 = 25
UNIT_AIR_PLANE1 = 26
UNIT_AIR_PLANE2 = 27

unit_ids = {}
unit_ids['Rifleman']        = 'UNIT_FOOT_RIFLE'
unit_ids['Heavy Gunner']    = 'UNIT_FOOT_SAW'
unit_ids['Rocket Launcher'] = 'UNIT_FOOT_RPG'
unit_ids['Flame Thrower']   = 'UNIT_FOOT_FLAME'
unit_ids['Flamethrower']    = 'UNIT_FOOT_FLAME'
unit_ids['Sniper']          = 'UNIT_FOOT_SNIPER'
unit_ids['Tech']            = 'UNIT_FOOT_TECH'
unit_ids['Medic']           = 'UNIT_FOOT_MEDIC'
unit_ids['Hercules']        = 'UNIT_FOOT_MECH'
unit_ids['Suicide Bomber']  = 'UNIT_FOOT_BOMBER'
unit_ids['Jackrabbit']      = 'UNIT_VEHICLE_TANKDRONE'
unit_ids['Rocket Buggy']    = 'UNIT_VEHICLE_BUGGY'
unit_ids['Humvee']          = 'UNIT_VEHICLE_HUMVEE'
unit_ids['Razorback']       = 'UNIT_VEHICLE_MAV'
unit_ids['Rhino']           = 'UNIT_VEHICLE_TANK1' 
unit_ids['Paladin']         = 'UNIT_VEHICLE_TANK2' 
unit_ids['Challenger']      = 'UNIT_VEHICLE_TANK3' 
unit_ids['Laser Tank']      = 'UNIT_VEHICLE_LASERTANK' 
unit_ids['AA Gun']          = 'UNIT_VEHICLE_ANTIAIR' 
unit_ids['Jammer']          = 'UNIT_VEHICLE_JAMMER'
unit_ids['Interceptor']     = 'UNIT_VEHICLE_ANTIMISSILE' 
unit_ids['Mega Tank']       = 'UNIT_VEHICLE_MEGATANK' 
unit_ids['Wing Drones']     = 'UNIT_AIR_WINGDRONE'
unit_ids['Wing Drone']     = 'UNIT_AIR_WINGDRONE' 
unit_ids['Cobra']           = 'UNIT_AIR_CHOPPER1' 
unit_ids['UH-60 Chopper']   = 'UNIT_AIR_CHOPPER2'
unit_ids['Thunderbolt']     = 'UNIT_AIR_PLANE1'
unit_ids['Copter Drones']   = 'UNIT_AIR_CHOPPERDRONE'
unit_ids['Copter Drone']   = 'UNIT_AIR_CHOPPERDRONE'
unit_ids['Raptor']          = 'UNIT_AIR_PLANE2'

factions = {}
factions['Hell Hounds']     = 0
factions['Armored Corps']   = 1
factions['Mortal Force']    = 2
factions['Black Widows']    = 3
factions['Eastern Horde']   = 4
factions['Son of Saints']   = 5
factions['Sons of Saints']   = 5

as_header = ''
as_footer = ''
data_tab = ''

taunts = {}


def writeLine(ofile,text,tabs):
    for i in range(tabs-1):
        ofile.write('\t')
    ofile.write(text)
    ofile.write('\n')

def setHeadingIndices(line):
    parts = line.split('|')    
    for i in range(0,len(parts)):
        headings[parts[i].strip().replace(' ','')] = i
        
    print(headings)

def parseLine(input):
    
    name = input[headings['Faction']].strip()
    faction_id = factions[name]
    
    taunt = input[headings['Taunt']].strip()
    win = input[headings['WinResponse']].strip()
    lose = input[headings['LossResponse']].strip()
    
    if (not taunts.has_key(faction_id)):
        taunts[faction_id] = {}
        taunts[faction_id]['taunts'] = []
        taunts[faction_id]['win'] = []
        taunts[faction_id]['lose'] = []
                    
    
    taunts[faction_id]['taunts'].append(taunt)
    if (win != ''):
        taunts[faction_id]['win'].append(win)
    if (lose != ''):
        taunts[faction_id]['lose'].append(lose)
        
    
    
        
def loadData(filename):
    print(filename)
    qdata = open(filename,'r')
    
    line = qdata.readline()
    setHeadingIndices(line)
    print(headings)
    
    line = qdata.readline()    
    while(line):        
        parts = line.split('|')
        parseLine(parts)
        line = qdata.readline()
    
    #print(json.dumps(buildingPosts))
    
    qdata.close()
        
def setInput():
    qdatafile = tkFileDialog.askopenfilename(parent=root,title='Specify Stream Post Data')
    print(qdatafile)
    loadData(qdatafile)

def processAS(filename):
    global as_header
    global as_footer
    global data_tab
    
    as_header = ''
    as_footer = ''
    
    start_as = open(filename,'r')
    
    writing = True
    data = False
    
    for line in start_as:
        if (line.strip() == '// START DATA BLOCK'):
            as_header = as_header + line
            data_tab = line.split('/')[0]
            writing = False
        elif (line.strip() == '// END DATA BLOCK'):
            writing = True
            data = True
            
        if (writing):
            if (data):
                as_footer += line
            else:
                as_header += line

    start_as.close()    

def writeAttack(outfile,at):
    #print(data)
    
    outfile.write(data_tab + '\t' + "{name: '" + at['name'] + "',\n")
    outfile.write(data_tab + '\t\t' + "units:[\n")
    
    lines = []
    
    for g in at['attacks']:
        newline = data_tab + '\t\t\t'
        newline += '[' + str(g['delay']) + ', ' + g['unit'] + ', ' + str(g['number']) + ', ' + str(g['direction']) + ']'
        lines.append(newline)
    
    outfile.write(',\n'.join(lines))
    outfile.write('],\n')
    outfile.write(data_tab + '\t\twarningTime:6000}')
    
    
def saveData(filename):
    processAS(filename)
    print('---------------------------------------------')
    outfile = open(filename,'w')    
    outfile.write(as_header)

    outfile.write(data_tab + '_dialog = new Array();\n\n')

    for faction in taunts:
        outfile.write(data_tab + '_dialog[' + str(faction) + '] = [\n')
        
        count = 0
        outfile.write(data_tab + '\t[\n')
        for t in taunts[faction]['taunts']:
            outfile.write(data_tab + '\t\t"' + t + '"')
            if (count < len(taunts[faction]['taunts']) - 1):
                outfile.write(',')
            outfile.write('\n')
            count += 1         
        outfile.write(data_tab + '\t],\n')
        
        count = 0
        outfile.write(data_tab + '\t[\n')
        for w in taunts[faction]['win']:
            outfile.write(data_tab + '\t\t"' + w + '"')
            if (count < len(taunts[faction]['win']) - 1):
                outfile.write(',')
            outfile.write('\n')
            count += 1         
        outfile.write(data_tab + '\t],\n')
        
        count = 0
        outfile.write(data_tab + '\t[\n')
        for l in taunts[faction]['lose']:
            outfile.write(data_tab + '\t\t"' + l + '"')
            if (count < len(taunts[faction]['lose']) - 1):
                outfile.write(',')
            outfile.write('\n')
            count += 1         
        outfile.write(data_tab + '\t]\n')
        
        outfile.write(data_tab + '];\n\n')
    
    outfile.write(as_footer)
    outfile.close()
    
def saveOutput():
    print('saving output')
    outdat = tkFileDialog.asksaveasfilename(parent=root,filetypes=[('text','*.txt'),('Actionscript','*.as')],title='Specify Save File')
    #print(outdat)
    saveData(outdat)    

'''
loadData('/Volumes/Disk Image/documents/wm_attacks/taunts.csv')
saveData('/Volumes/Disk Image/documents/wm_attacks/taunts.as')

'''
inputButton = Button(root,text="Open Faction Dialog Data",command=setInput)
inputButton.pack()

outputButton = Button(root,text="Save Faction Dialog  Data to AS",command=saveOutput)
outputButton.pack()

mainloop()
