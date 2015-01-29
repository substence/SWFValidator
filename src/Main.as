package
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXManager;
	import com.cc.ui.xbaux.XBAUXSymbolImplementation;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.LogDisplay;
	import com.cc.ui.xbaux.messages.LogRequest;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	import com.cc.ui.xbaux.model.XBAUXSymbol;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	[SWF(backgroundColor="0xFFFFFF", width="760" , height="750", frameRate="40")]
	
	public class Main extends Sprite
	{
		private static const _DEFAULT_XML:String = "TestXML.xml";
		private static const _DEFAULT_SYMBOL:String = "XPEarnedBracket";
		private var _view:XMLValidatorView;
		
		public function Main()
		{
			new XBAUXManager();
			
			Message.messenger.add(LogDisplay, onLogDisplay);
			
			_view = new XMLValidatorView();
			_view.defaultXMLPath = _DEFAULT_XML;
			_view.defaultSymbolPath = _DEFAULT_SYMBOL;
			_view.addEventListener(Event.CHANGE, updatedViewInfo);
			_view.signalScanDriectory.add(clickedValidateDirectory);
			_view.signalScanDriectory.add(clickedValidateFiles);
			addChild(_view);
		}
		
		private function clickedValidateDirectory():void
		{
			new ValidateXMLInDirectory();
		}
		
		private function clickedValidateFiles():void
		{
			new ValidateXMLFiles();
		}
		
		private function updatedViewInfo(event:Event):void
		{
			var symbol:XBAUXSymbolImplementation = new XBAUXSymbolImplementation(_view.xmlPath, _view.symbolPath);
			symbol.x = stage.stageWidth * .5;
			symbol.y = stage.stageHeight * .5;
			addChild(symbol);
		}
		
		private function onLogDisplay(message:LogDisplay):void
		{
			var messageLog:LogRequest = message.message;
			var constructedMessage:String = messageLog.timeStamp + " : " + messageLog.message;
			_view.showLog(constructedMessage); 
			trace(constructedMessage);
		}
	}
}