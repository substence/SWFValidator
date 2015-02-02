package commands
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXLogger;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.LogRequest;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.Sprite;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import messages.SaveDirectory;

	public class ValidateXMLonDnD
	{
		private var _target:Sprite;
		
		public function ValidateXMLonDnD(target:Sprite)
		{
			_target = target;
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn);
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
		}
		
		protected function onDrop(event:NativeDragEvent):void
		{
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			for each (var file:File in files) 
			{
				requestContract(file.url);
			}
			if (file)
			{
				//get the directory of the last file and send it out to be saved
				const directory:String = file.nativePath.replace(file.name, "");
				Message.messenger.dispatch(new SaveDirectory(directory));
			}
		}
		
		protected function onDragIn(event:NativeDragEvent):void
		{
			if(event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				for each (var file:File in files) 
				{
					if (file.extension == "xml")
					{
						NativeDragManager.acceptDragDrop(_target);
					}
					else
					{
						Message.messenger.dispatch(new LogRequest("ValidateXMLonDnD - " + file.name + " is not a valid XML contract", XBAUXLogger.ERROR));
					}
				}
			}	
		}
		
		private function requestContract(contractName:String):void
		{
			Message.messenger.dispatch(new LogRequest("ValidateXMLonDnD - Attemping to load : " + contractName, XBAUXLogger.DEBUG));
			Message.messenger.dispatch(new ContractRequest(contractName));
		}
	}
}