#!/usr/bin/env python

# This script rebuilds the aibox SWC, assuming the build directory is
# exactly the last 'build' in the path to the aibox SWC in the project
# configuration.
#
# This is a simpler way of doing:
# cd <ENYO>
# rm -rf build
# mkdir build
# cd build
# cmake ..
# make aibox
#
# The string we are looking for inside the project config file looks something like
# path="/Users/dbergman/proj/kixeye/games/enyo/build/aibox.swc"
#
# Author: David Bergman (dbergman)
#

import re
import os
import subprocess
import shutil

CONFIG_FILE = os.path.dirname(os.path.realpath(__file__)) + "/../.actionScriptProperties"
BUILD_PATH_EXTRACTOR = re.compile("path\s*\=\"(.+)/build/aibox.swc\"")

def get_enyo_dir():
  with open(CONFIG_FILE, 'r') as config_file:
      content = config_file.read()
  # TODO: exit with an error if the file could not be read
  m = BUILD_PATH_EXTRACTOR.search(content)
  return m.group(1) if m else None
    
def rebuild_aibox(enyo_path):
  build_dir = enyo_path + "/build"
  # 1. rm -rf build
  shutil.rmtree(build_dir)
  # 2. mkdir build
  os.makedirs(build_dir)
  # 3. cd build && cmake .. && make aibox
  old_dir = os.getcwd()
  os.chdir(build_dir)
  print "# Starting cmake"
  subprocess.check_call(['cmake', '..'])
  print "# Starting make aibox"
  subprocess.check_call(['make', '-j8', '-B', 'VERBOSE=1', 'aibox'])
  print "# Make completed!"
  os.chdir(old_dir)
  
rebuild_aibox(get_enyo_dir())
