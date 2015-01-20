'''
mission_import.py
J. Adrian Herbez

This will take in a CSV with mission data, and insert it into:
com/cc/units/Units.as (for units)
GLOBAL.as (for buildings)

'''

from Tkinter import *
import Tkinter, tkFileDialog
#import json
import operator

from unit_list import *

root = Tkinter.Tk()

stream_posts = []
headings = {}
unitPosts = {}
buildingPosts = {}
eventPosts = {}
miscPosts = {}

'''
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
unit_ids['Rifleman']        = UNIT_FOOT_RIFLE
unit_ids['Heavy Gunner']    = UNIT_FOOT_SAW
unit_ids['Rocket Launcher'] = UNIT_FOOT_RPG
unit_ids['Flame Thrower']   = UNIT_FOOT_FLAME
unit_ids['Flamethrower']    = UNIT_FOOT_FLAME
unit_ids['Sniper']          = UNIT_FOOT_SNIPER
unit_ids['Tech']            = UNIT_FOOT_TECH
unit_ids['Medic']           = UNIT_FOOT_MEDIC
unit_ids['Hercules']        = UNIT_FOOT_MECH
unit_ids['Suicide Bomber']  = UNIT_FOOT_BOMBER
unit_ids['Jackrabbit']      = UNIT_VEHICLE_TANKDRONE
unit_ids['Rocket Buggy']    = UNIT_VEHICLE_BUGGY
unit_ids['Humvee']          = UNIT_VEHICLE_HUMVEE
unit_ids['Razorback']       = UNIT_VEHICLE_MAV
unit_ids['Rhino']           = UNIT_VEHICLE_TANK1 
unit_ids['Paladin']         = UNIT_VEHICLE_TANK2 
unit_ids['Challenger']      = UNIT_VEHICLE_TANK3 
unit_ids['Laser Tank']      = UNIT_VEHICLE_LASERTANK 
unit_ids['AA Gun']          = UNIT_VEHICLE_ANTIAIR 
unit_ids['Jammer']          = UNIT_VEHICLE_JAMMER 
unit_ids['Interceptor']     = UNIT_VEHICLE_ANTIMISSILE 
unit_ids['Mega Tank']       = UNIT_VEHICLE_MEGATANK 
unit_ids['Wing Drones']     = UNIT_AIR_WINGDRONE 
unit_ids['Cobra']           = UNIT_AIR_CHOPPER1 
unit_ids['UH-60 Chopper']   = UNIT_AIR_CHOPPER2
unit_ids['Thunderbolt']     = UNIT_AIR_PLANE1
unit_ids['Copter Drones']   = UNIT_AIR_CHOPPERDRONE
unit_ids['Raptor']          = UNIT_AIR_PLANE2
''' 
b_ids = {}
b_ids['Command Center'] = 14
b_ids['Metal Factory'] = 1
b_ids['Oil Pump'] = 2
b_ids['Metal Storage'] = 3 
b_ids['Oil Storage'] = 4
b_ids['Mine Factory'] = 5
b_ids['Power Plant'] = 6
b_ids['Junkyard']   = 9
b_ids['Barracks'] = 29
b_ids['Academy'] = 26
b_ids['Tech Center'] = 31
b_ids['War Factory'] = 30
b_ids['Airfield'] = 13
b_ids['Gun Turret'] = 21
b_ids['Missile Turret'] = 20
b_ids['Go-Go Bar'] = 19
b_ids['War Room'] = 11
b_ids['Tesla Coil'] = 25
b_ids['Laser Cannon'] = 23
b_ids['Bunker'] = 22
b_ids['Communication Tower'] = 28
b_ids['Long Range Strike Mortar 1'] = 33
b_ids['Long Range Strike Mortar 2'] = 33
b_ids['Long Range Strike EMP 1'] = 33
b_ids['Long Range Strike Howitzer 1'] = 33 
b_ids['Long Range Strike Biochem 1'] = 33
b_ids['Long Range Strike Howitzer 2'] = 33
b_ids['Long Range Strike EMP 2'] = 33
b_ids['Long Range Strike Cruise Missile 1'] = 33
b_ids['Long Range Strike Biochem 2'] = 33
b_ids['Long Range Strike Cruise Missile 2'] = 33
b_ids['Mortar Tower'] = 20
b_ids['Warehouse'] = 7
b_ids['Staging Area'] = 7

ranks = {}
ranks['Private']    = 3
ranks['Private First Class'] = 99
ranks['Specialist'] = 99
ranks['Corporal']   = 7
ranks['Sergeant']   = 11
ranks['Staff Sergeant'] = 99
ranks['Master Sergeant'] = 99
ranks['Sergeant Major'] = 99
ranks['Command Sergeant Major'] = 99
ranks['Officer']    = 15
ranks['Lieutenant'] = 19
ranks['Captain']    = 23
ranks['Major']      = 27
ranks['Lieutenant Colonel'] = 99
ranks['Colonel']    = 31
ranks['Brigadier General']  = 99
ranks['Major General'] = 99
ranks['Lieutenant General'] = 99
ranks['General']    = 39
ranks['General of the Army'] = 99
ranks['Commander-in-Chief'] = 43

minetypes = {}
minetypes['Flatiron'] = 1
minetypes['Claymore'] = 2
minetypes['Bouncing Betty'] = 3
minetypes['Shaped Charge']  = 4

text = {}
text['Thanked'] = 0

as_header = ''
as_footer = ''
data_tab = ''

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
    
    newItem = {}
    newItem['popup_title'] = input[headings['PopupHeader']].strip()
    newItem['popup_body'] = input[headings['PopupBody']].strip()
    newItem['stream_title'] = input[headings['StreamHeader']].strip()
    newItem['stream_body'] = input[headings['StreamBody']].strip()
    newItem['stream_image'] = input[headings['StreamImageURL']].strip()
    newItem['stream_button'] = input[headings['StreamButton']].strip()
    newItem['stream_flag'] = input[headings['StreamFlag']].strip()
    enabled = input[headings['Active']].strip()

    
    if (enabled == 'NO' or enabled == 'no'):
        return
    
    
    type = input[headings['Category']].strip()
    sections = input[headings['Action']].split(',')
    
    if (type == 'Unit'):
        print('UNIT')
        unit = sections[0]
        uid = unit_ids[unit]
        
        level = 1
        if (sections[1].strip() != 'Unlocked'):
            levelparts = sections[1].strip().split(' ')
            level = int(levelparts[1])       
        
        #print(str(unit_ids[unit]) + ' ' + str(level))
        newItem['popup_image'] = 'units/portrait/' + str(uid) + '-90.jpg'
        
        if (not unitPosts.has_key(uid)):
            unitPosts[uid] = {}
            unitPosts[uid]['stream'] = {}
        
        #if (enabled == 'YES'):
        unitPosts[uid]['stream'][level] = newItem
        
        
    elif (type == 'Building'):
        #print('BUILDING')
        
        building = sections[0].strip()
        
        level = 1
        
        if (building == 'Long Range Strike'):
            building += ' ' + sections[1].replace('Unlocked','').strip()
        else:
            if (sections[1].strip() != 'Built'):
                levelparts = sections[1].strip().split(' ')
                print(levelparts)
                level = int(levelparts[1])
        bid = b_ids[building]
        
        if (not buildingPosts.has_key(bid)):
            buildingPosts[bid] = {}
            buildingPosts[bid]['stream'] = {}
        newItem['popup_image'] = 'buildings/' + str(bid) + '-90.jpg'
                
        #if (enabled == 'YES'):
        buildingPosts[bid]['stream'][level] = newItem
    elif (type == 'Mine'):
        if (not miscPosts.has_key('MINE')):
            miscPosts['MINE'] = {}
        mine = sections[0].strip()
        miscPosts['MINE'][minetypes[mine]] =  newItem
    elif (type == 'Gift'):
        if (not miscPosts.has_key('GIFTS')):
            miscPosts['GIFTS'] = {}
        
        if (sections[1].strip() == 'Metal'):
            miscPosts['GIFTS'][1] = newItem
        elif (sections[1].strip() == 'Oil'):
            miscPosts['GIFTS'][2] = newItem
    elif (type == 'Event'):
        print('EVENT')
        event_number = sections[0].split(' ')
        event_number = int(event_number[1])
        
        wave = sections[1].strip().split(' ')
        wave = int(wave[1])
        print(event_number, wave)
        
        if (not eventPosts.has_key(event_number)):
            eventPosts[event_number] = {}
        
        newItem['stream_flag'] = newItem['stream_flag'].replace('[level]', str(wave))    
        eventPosts[event_number][wave] = newItem
        
        
    else:
        print('MISC')
        
        if (sections[0].strip() == 'Battle won'):
            print('BATTLE')
            if (not miscPosts.has_key('BATTLE')):
                miscPosts['BATTLE'] = {}
            if (sections[1].strip() == 'PvP'):
                miscPosts['BATTLE'][0] = newItem
            elif (sections[1].strip() == 'PvE'):
                miscPosts['BATTLE'][1] = newItem
            else:
                miscPosts['BATTLE'][2] = newItem

        elif (sections[0].strip() == 'Promoted'):
            if (not miscPosts.has_key('LEVEL')):
                miscPosts['LEVEL'] = {}
            print(ranks[sections[1].strip()])
            miscPosts['LEVEL'][ranks[sections[1].strip()]] = newItem
        elif (sections[0].strip() == 'Gift'):
            if (not miscPosts.has_key('GIFTS')):
                miscPosts['GIFTS'] = {}
            miscPosts['GIFTS'][text[sections[1].strip()]] = newItem
            

    #print(newItem)

        
def loadData(filename):
    qdata = open(filename,'r')
    
    line = qdata.readline()
    setHeadingIndices(line)
    print(headings)
    
    line = qdata.readline()    
    while(line):
        line = line.replace('<fname>','#fname#')
        
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

def writeData(outfile,data):
    #print(data)
    
    lines = []
    
    for val in data:
        data[val] = data[val].replace('"','\\"')
        newline = ''
        newline += (data_tab + '\t')
        newline += (val + ': ')
        newline += ('"' + data[val] + '"')
        lines.append(newline)
        
    outfile.write(',\n'.join(lines))
    outfile.write('\n'+data_tab + '\t}')
        
def saveData(filename):
    processAS(filename)
    print('---------------------------------------------')
    outfile = open(filename,'w')    
    outfile.write(as_header)

    for unit in unitPosts:
        outfile.write(data_tab)
        outfile.write('_postData[UNITS][' + str(unit) + '] = { \n')
        print('UNIT ID: ' + str(unit))
        
        #sort the stream posts by level reached        
        posts = sorted(unitPosts[unit]['stream'].iteritems(),key=operator.itemgetter(1))
        #posts = sorted(unitPosts[unit]['stream'].iteritems())
        
        for i in range(0,len(posts)):
            outfile.write(data_tab+'\t')
            outfile.write(str(int(posts[i][0])) + ': {\n')                
            writeData(outfile,posts[i][1])            

            if (i < len(posts)-1):
                outfile.write(',')
            outfile.write('\n')
        outfile.write(data_tab + '};\n')
    
    for building in buildingPosts:
        print('BUILDING ID: ' + str(building))
        
        outfile.write(data_tab)
        outfile.write('_postData[BUILDINGS][' + str(building) + '] = {\n')
        
        posts = sorted(buildingPosts[building]['stream'].iteritems(),key=operator.itemgetter(1))
        
        for i in range(0,len(posts)):
            #print(posts[i])
            outfile.write(data_tab+'\t')
            outfile.write(str(int(posts[i][0])) + ': {\n')                
            #json.dump(posts[i][1],outfile,False,True,True,True,None,4)
            writeData(outfile,posts[i][1])            

            if (i < len(posts)-1):
                outfile.write(',')
            outfile.write('\n')
        outfile.write(data_tab + '};\n')


    for event in eventPosts:
        print('EVENT ID: ' + str(event))
        
        outfile.write(data_tab)
        outfile.write('_postData[EVENT_WAVE][' + str(event) + '] = {\n')
        
        # posts = sorted(eventPosts[event]['stream'].iteritems(),key=operator.itemgetter(1))
        
        posts = eventPosts[event]
        print(len(eventPosts[event]))
        
        count = 1
        
        for wave in eventPosts[event]:
            print(wave)
            outfile.write(data_tab+'\t')
            outfile.write(str(wave) + ': {\n')
            writeData(outfile, eventPosts[event][wave])
            
            if (count < len(eventPosts[event])):
                outfile.write(',')
            outfile.write('\n')
            count += 1
        outfile.write(data_tab + '};\n')


    for type in miscPosts:
        print(type)
        outfile.write(data_tab)
        outfile.write('_postData[' + type + '] = {\n')
        
        count = 0
        for item in miscPosts[type]:
            print(item)
            outfile.write(data_tab+'\t')
            outfile.write(str(item) + ': {\n')
            writeData(outfile,miscPosts[type][item])
            if (count < len(miscPosts[type])-1):
                outfile.write(',')
            count += 1
            outfile.write('\n')
        outfile.write(data_tab + '};\n')
        
    outfile.write(as_footer)
    outfile.close()
    
def saveOutput():
    print('saving output')
    outdat = tkFileDialog.asksaveasfilename(parent=root,filetypes=[('text','*.txt'),('Actionscript','*.as')],title='Specify Save File')
    #print(outdat)
    saveData(outdat)    

'''
loadData('/Volumes/Disk Image/documents/steam_posts/stp_01_17_12_2.csv')
saveData('/Volumes/Disk Image/documents/steam_posts/output_new.txt')

#globalAS = '/Volumes/Disk Image/warlords/branches/1/client/src/GLOBAL.as'
'''

inputButton = Button(root,text="Open Stream Post Data",command=setInput)
inputButton.pack()

outputButton = Button(root,text="Save Stream Post Data to AS",command=saveOutput)
outputButton.pack()

mainloop()
