package commands
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXLogger;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.LogRequest;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import messages.SaveDirectory;

	//goes through a directory and tries to load all the XML files
	public class ValidateXMLInDirectory
	{
		private var _targetDirectory:File;
		
		public function ValidateXMLInDirectory(directory:File = null)
		{
			_targetDirectory = directory; 

			if (directory != null)
			{
				//_targetDirectory = _targetDirectory.resolvePath(_
				selectedDirectory();
			}
			else
			{
				_targetDirectory = new File();
				try
				{
					_targetDirectory.addEventListener(Event.SELECT, selectedDirectory); 
					_targetDirectory.browseForDirectory("Select your XML Directory");
					Message.messenger.dispatch(new LogRequest("Opening file picker", XBAUXLogger.VERBOSE));
				}
				catch(error:Error)
				{
					Message.messenger.dispatch(new LogRequest(error.message, XBAUXLogger.WARNING));
				}
			}
		}
		
		private function selectedDirectory(event:Event = null):void
		{
			Message.messenger.dispatch(new LogRequest("Selecting directory : " + _targetDirectory.nativePath, XBAUXLogger.DEBUG));
			
			Message.messenger.dispatch(new SaveDirectory(_targetDirectory.nativePath));

			scanDirectory(_targetDirectory);
		}
		
		private function scanDirectory(directory:File):void
		{
			var contents:Array = directory.getDirectoryListing(); 
			var didFindFiles:Boolean;
			for (var i:uint = 0; i < contents.length; i++)  
			{ 
				var file:File = contents[i];
				if (file.extension == "xml")
				{
					requestContract(file.url);
					didFindFiles = true;
				}
			}
			if (!didFindFiles)
			{
				Message.messenger.dispatch(new LogRequest("Couldn't find any valid XML files in '" + _targetDirectory.nativePath + "'", XBAUXLogger.WARNING));
			}
			_targetDirectory = null;
		}
		
		private function requestContract(contractName:String):void
		{
			Message.messenger.dispatch(new LogRequest("Attemping to load : " + contractName, XBAUXLogger.DEBUG));
			Message.messenger.dispatch(new ContractRequest(contractName));
		}
	}
}
