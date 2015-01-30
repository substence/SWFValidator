package
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXLogger;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.LogRequest;
	
	import flash.events.Event;
	import flash.filesystem.File;

	//goes through a directory and tries to load all the XML files
	public class ValidateXMLInDirectory
	{
		private var _targetDirectory:File;
		
		public function ValidateXMLInDirectory(directory:String = null)
		{
			_targetDirectory = new File(); 

			if (directory != null)
			{
				_targetDirectory.nativePath = directory;
				selectedDirectory();
			}
			else
			{
				try
				{
					_targetDirectory.addEventListener(Event.SELECT, selectedDirectory); 
					_targetDirectory.browseForDirectory("Select your XML Directory");
					Message.messenger.dispatch(new LogRequest("ValidateXMLInDirectory - Opening file picker", XBAUXLogger.VERBOSE));
				}
				catch(error:Error)
				{
					Message.messenger.dispatch(new LogRequest("ValidateXMLInDirectory - " + error.message, XBAUXLogger.WARNING));
				}
			}
		}
		
		private function selectedDirectory(event:Event = null):void
		{
			Message.messenger.dispatch(new LogRequest("ValidateXMLInDirectory - Selecting directory : " + _targetDirectory.nativePath, XBAUXLogger.DEBUG));
			
			scanDirectory(_targetDirectory);
		}
		
		private function scanDirectory(directory:File):void
		{
			var contents:Array = directory.getDirectoryListing();  
			for (var i:uint = 0; i < contents.length; i++)  
			{ 
				var file:File = contents[i];
				if (file.extension == "xml")
				{
					requestContract(file.name);
				}
			}
			_targetDirectory = null;
		}
		
		private function requestContract(contractName:String):void
		{
			Message.messenger.dispatch(new LogRequest("ValidateXMLInDirectory - Attemping to load : " + contractName, XBAUXLogger.DEBUG));
			Message.messenger.dispatch(new ContractRequest(contractName));
		}
	}
}