'''
mission_import.py
J. Adrian Herbez

This will take in a CSV with mission data, and insert it into QUESTS.as

'''

from Tkinter import *
import Tkinter, tkFileDialog
from unit_list import *

root = Tkinter.Tk()

headings = {}
missions = []

as_header = ''
as_footer = ''
data_tab = ''

PRIORITY_NORMAL     = 1
PRIORITY_HIGH       = 5

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

def setHeadingIndices(line):
    parts = line.split('|')    
    for i in range(0,len(parts)):
        headings[parts[i].strip().replace(' ','')] = i
        
    print(headings)

def writeLine(ofile,text,tabs=0):
    ofile.write(data_tab)
    
    for i in range(tabs-1):
        ofile.write('\t')

    ofile.write(text)
    ofile.write('\n')

def writeMission(ofile,m,mission_count):

    writeLine(ofile,('Q'+str(m['id'])+': {'),2)
    writeLine(ofile,('order: '+str(mission_count)+','),3)
    writeLine(ofile,('priority: ' + str(m['priority']) + ','),3)
    writeLine(ofile,('name: "' + m['name'] + '",'),3)
    writeLine(ofile,('description: "' + m['mission'] + '",'),3)
    writeLine(ofile,('hint: "' + m['hint'] + '",'),3)
    writeLine(ofile,('rubi_pre: "' + m['rubi_pre'] + '",'),3)
    writeLine(ofile,('rubi_post: "' + m['rubi_post'] + '",'),3)
    
    if (m['res_metal'] and m['res_metal'].strip() != ''):
        m['res_metal'] = int(m['res_metal'].replace(',',''))
    else:
        m['res_metal'] = 0
        
    if (m['res_oil'] and m['res_oil'].strip() != ''):
        m['res_oil'] = int(m['res_oil'].replace(',',''))
    else:
        m['res_oil'] = 0
    
    rewards = '[' + str(m['res_metal']) + ',' + str(m['res_oil']) + ']'
    writeLine(ofile,('rewardRes: ' + rewards + ','),3)
    
    if (m['units'] != ''):
        writeLine(ofile,('rewardUnits: ' + m['units'] + ','),3)
    
    
    # writeLine(ofile,('questimage: \'' + m['img'] + '\', '),3)
    writeLine(ofile,('questicon: \'' + m['icon'] + '\', '),3)
    '''
    writeLine(ofile,('streamTitle: \'\','),3)
    writeLine(ofile,('streamDescription: \'\','),3)
    writeLine(ofile,('streamImage: \'\','),3)
    '''
    if (m['rules'] == ''):
        m['rules'] = "''"
    
    if (m['prereq'] != ''):
        writeLine(ofile,('rules: ' + m['rules'] + ','),3)
        writeLine(ofile,('prereq: "' + m['prereq'] + '"'),3)
    else:
        writeLine(ofile,('rules: ' + m['rules']),3)
    
    #ofile.write('\t}')
    #writeLine(ofile,'}')
    
    ofile.write(data_tab + '\t' + '}')


def loadData(filename):
    qdata = open(filename, 'r')
    
    line = qdata.readline()
    setHeadingIndices(line)
    
    line = qdata.readline()    
    while(line):
        line = line.replace('<fname>','#fname#')
        
        parts = line.split('|')
        parseLine(parts)
        line = qdata.readline()
    
    # set up proper prereqs
    for m in missions:
        if (m['prereq']):
            for n in missions:
                if (n['name'] == m['prereq']):
                    m['prereq'] = 'Q' + str(n['id'])      
        
def parseUnits(list):
    global unit_ids
    units = list.split(',')
    
    unitArray = []
    
    for unit in units:
        unit = unit.strip()
        #print(unit)
        
        parts = unit.split(' ')
        #count = int(parts[0].replace('x','').strip())
        count = int(parts[0].replace('x','').strip())
        
        unit_name = ' '.join(parts[1:])
        #print(count, unit_ids[unit_name])
        unitArray.append('{id:' + str(unit_ids[unit_name]) + ', count:' + str(count) + '}')
        
    output = '[' + ','.join(unitArray) + ']'
    print(output)
    return output
    
    

def parseLine(data):
    
    for i in range(0,len(data)):
        data[i] = data[i].strip()
        data[i] = data[i].replace('"','\\"')
    
    
    if (data[headings['Enabled']] == 'NO'):
        return
    
    new = {}
    new['enabled'] = data[headings['Enabled']]
    new['id'] = data[headings['ID']]
    new['order'] = len(missions) + 1
    new['cat'] = data[headings['Category']]
    new['name'] = data[headings['Name']]
    new['mission'] = data[headings['Mission']]
    new['img'] = data[headings['ImageURL']]
    if (new['img'] == '' ):
        new['img'] = 'missions/generic_l.jpg'
    
    
    new['icon'] = data[headings['IconURL']]
    if (new['icon'] == ''):
        new['icon'] = 'missions/generic_s.jpg'
        
    new['prereq'] = data[headings['Prerequisite']]
    new['rules'] = data[headings['Rules']]
    new['rubi_pre'] = data[headings['Pre-completionRUBIDialogue']]
    new['rubi_post'] = data[headings['Post-completionRUBIDialogue']]
    new['hint'] = data[headings['Hint']]
    new['res_metal'] = data[headings['Metal']]
    new['res_oil'] = data[headings['Oil']]
    new['units'] = data[headings['Units']]
    
    new['priority'] = data[headings['Priority']]
    if (new['priority'] == 'HIGH' or new['priority'] == 'High'):
        new['priority'] = PRIORITY_HIGH
    else:
        new['priority'] = PRIORITY_NORMAL
    
    if (new['units'] != ''):
        new['units'] = parseUnits(new['units'])
    missions.append(new)
        
def loadDataOld(filename):
    qdata = open(filename,'r')
    print(filename)
    counter = 1
    
    for line in qdata:
        #missions.append(line)
        line = line.replace('"','\\"')
        parts = line.split('|')
        if (len(parts) > 14):
            if (parts[0].strip() != 'SAVE FOR LATER' and parts[0].strip() != 'Order' and parts[0].strip() != ''):
                new = {}
                new['order']        = counter
                new['id']           = parts[0]
                new['cat']          = parts[1]
                new['name']         = parts[2]
                new['mission']      = parts[3]
                new['img']          = parts[5]
                if (new['img'] == ''):
                    new['img'] = 'missions/generic_l.jpg'
                
                new['icon']         = parts[6]
                if (new['icon'] == ''):
                    new['icon'] = 'missions/generic_s.jpg'
                
                new['enabled']      = (parts[7] == 'YES')
                new['prereq']       = parts[8]
                new['rules']        = parts[9]
                new['hint']         = parts[10]
                new['rubi_pre']     = parts[11]
                new['rubi_post']    = parts[12]
                new['res_metal']    = parts[13]
                new['res_oil']      = parts[14]
                #print('IMAGE: ' + new['img'] + ' ICON: ' + new['icon'])
                missions.append(new)
                counter += 1
                #print(str(new['order']) + ' ' + str(new['id']))
        
    qdata.close()
    
    # set up proper prereqs
    for m in missions:
        if (m['prereq']):
            for n in missions:
                if (n['name'] == m['prereq']):
                    m['prereq'] = 'Q' + str(n['id'])    


def setInput():
    qdatafile = tkFileDialog.askopenfilename(parent=root,title='Specify Quest Data')
    print(qdatafile)
    loadData(qdatafile)

def saveData(filename):
    processAS(filename)
    
    outfile = open(filename,'w')    
    outfile.write(as_header)    
    
    writeLine(outfile,'_quests = {')
    
    mission_count = 1
    for m in missions:
        if (m['enabled']):
            writeMission(outfile,m,mission_count)
            mission_count += 1
            if (mission_count < len(missions)-1):
                outfile.write(',\n')
            else:
                outfile.write('\n')
            
    outfile.write(data_tab + '};\n')
    outfile.write(as_footer)
    outfile.close()

def saveOutput():
    print('saving output')
    outdat = tkFileDialog.asksaveasfilename(parent=root,filetypes=[('text','*.txt'),('Actionscript','*.as')],title='Specify Save File')
    print(outdat)
    saveData(outdat)    

'''
loadData('/Volumes/Disk Image/documents/mission_docs/mis_10_18_03.csv')
saveData('/Volumes/Disk Image/documents/mission_docs/mission_start.as')

'''
inputButton = Button(root,text="Open Mission Data",command=setInput)
inputButton.pack()

outputButton = Button(root,text="Save Mission Data to AS",command=saveOutput)
outputButton.pack()

mainloop()
