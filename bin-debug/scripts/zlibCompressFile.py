import os, zlib, sys

ZLIB_COMPRESSION_LEVEL = 9 # 0..9 - default 6 zlib.compress(data:string, level:int)

def ExportZLIBData(source, dest):
  sourceFile = open( source, "r" )
  destFile = open( dest, "w" )
  zlib_data = zlib.compress( sourceFile.read(), ZLIB_COMPRESSION_LEVEL )
  destFile.write( zlib_data )
  destFile.close()

def Run(sourceFile, compressedFile):
  print "Compress File to ZLib"
  ExportZLIBData(sourceFile, compressedFile)

if __name__=="__main__":
  uncompressedFile = sys.argv[1]
  compressedFile = sys.argv[2]
  Run(uncompressedFile, compressedFile)
