package
{
	import com.cc.messenger.Message;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import messages.SaveDirectory;

	public class ConfigManager
	{
		private static const CONFIG_FILE_NAME:String = "conddfigf.xml";
		private var _configFile:File;
		private var _configXML:XML;
		private var _lastKnownDirectory:String;
		
		public function ConfigManager()
		{
			Message.messenger.add(SaveDirectory, configUpdated);
			load();
		}
		
		private function configUpdated(message:SaveDirectory):void
		{
			lastKnownDirectoy = message.directory;
		}
		
		private function load():void
		{
			_configFile = new File(File.applicationStorageDirectory.resolvePath(CONFIG_FILE_NAME).nativePath);
			if (_configFile.exists)
			{
				var fileStream:FileStream = new FileStream(); 
				fileStream.open(_configFile, FileMode.READ); 
				_lastKnownDirectory = fileStream.readUTF(); 
				fileStream.close();
			}
			else
			{
				//_configXML = new XML();
			}
			save();
		}
		
		private function save():void
		{
			var vStream:FileStream = new FileStream();
			vStream.open(_configFile, FileMode.WRITE);
			vStream.writeUTF(_lastKnownDirectory);
			vStream.close();
		}
		
		public function get lastKnownDirectory():String
		{
			return _lastKnownDirectory;//_configXML.lastKnownDirectory;
		}
		
		public function set lastKnownDirectoy(value:String):void
		{
			_lastKnownDirectory = value;
			save();
		}
	}
}