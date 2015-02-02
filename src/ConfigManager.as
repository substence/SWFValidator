package
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXLogger;
	import com.cc.ui.xbaux.messages.LogRequest;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import messages.SaveDirectory;

	//right now we only save one property, if we need more, we'll save an XML file instead
	public class ConfigManager
	{
		private static const CONFIG_FILE_NAME:String = "ValidatorConfig.xml";
		private var _configFile:File;
		private var _configXML:XML;
		private var _lastKnownDirectory:String = "";
		
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
				try
				{
					_lastKnownDirectory = fileStream.readUTF();
				}
				catch(error:Error)
				{
					Message.messenger.dispatch(new LogRequest("There was an error when trying to read your config file", XBAUXLogger.WARNING));
				}
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
			if (_lastKnownDirectory)
			{
				var vStream:FileStream = new FileStream();
				vStream.open(_configFile, FileMode.WRITE);
				vStream.writeUTF(_lastKnownDirectory);
				vStream.close();
			}
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