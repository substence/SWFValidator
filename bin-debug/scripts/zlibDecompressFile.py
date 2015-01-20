import os, zlib, sys

def ExportZLIBData(source, dest):
  sourcestr = open( source, "rb" ).read()
  destFile = open( dest, "wb" )
  zlib_data = zlib.decompress( sourcestr )
  destFile.write( zlib_data )
  destFile.close()

def Run(sourceFile, compressedFile):
  print "Decompressing File from Zlib to native format"
  ExportZLIBData(sourceFile, compressedFile)

if __name__=="__main__":
  compressedFile = sys.argv[1]
  uncompressedFile = sys.argv[2]
  Run(compressedFile, uncompressedFile)
