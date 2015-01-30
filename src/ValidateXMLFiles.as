package
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXLogger;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.LogRequest;
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class ValidateXMLFiles
	{
		private var _targetDirectory:File;
		
		public function ValidateXMLFiles()
		{
			_targetDirectory = new File();
			
			Message.messenger.dispatch(new LogRequest("ValidateXMLFiles - Opening file picker", XBAUXLogger.VERBOSE));
			
			try
			{
				_targetDirectory.addEventListener(FileListEvent.SELECT_MULTIPLE, selectedFiles); 
				_targetDirectory.browseForOpenMultiple("Select XML Contracts(s)", [new FileFilter("XML Contracts", "*.xml")]);
			}
			catch(error:Error)
			{
				Message.messenger.dispatch(new LogRequest("ValidateXMLFiles - " + error.message, XBAUXLogger.WARNING));
			}
		}
		
		protected function selectedFiles(event:FileListEvent):void
		{
			for (var i:uint = 0; i < event.files.length; i++) 
			{
				var fileName:String = event.files[i].name;
				requestContract(fileName);
			}
			_targetDirectory = null;
		}
		
		private function requestContract(contractName:String):void
		{
			Message.messenger.dispatch(new LogRequest("ValidateXMLFiles - Attemping to load : " + contractName, XBAUXLogger.DEBUG));
			Message.messenger.dispatch(new ContractRequest(contractName));
		}
	}
}