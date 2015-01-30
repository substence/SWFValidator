package
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXManager;
	import com.cc.ui.xbaux.XBAUXSymbolImplementation;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.LogDisplay;
	import com.cc.ui.xbaux.messages.LogRequest;
	import com.cc.ui.xbaux.messages.SymbolLoaded;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	import com.cc.ui.xbaux.model.XBAUXSymbol;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	[SWF(backgroundColor="0xFFFFFF", width="760" , height="750", frameRate="40")]
	
	public class Main extends Sprite
	{
		private static const _DEFAULT_XML:String = "TestXML.xml";
		private static const _DEFAULT_SYMBOL:String = "Symbol Name";
		private var _view:XMLValidatorView;
		private var _testSymbol:DisplayObject;
		
		public function Main()
		{
			new XBAUXManager();
			
			Message.messenger.add(LogDisplay, onLogDisplay);
			
			_view = new XMLValidatorView();
			_view.defaultSymbolPath = _DEFAULT_SYMBOL;
			_view.signalScanDriectory.add(clickedValidateDirectory);
			_view.signalValidateFiles.add(clickedValidateFiles);
			_view.signalValidateSymbol.add(clickedValidateSymbol);
			_view.scaleX = 2;
			_view.scaleY = 2;
			addChild(_view);			
			
			new ValidateXMLonDnD(_view.outputContainer);
			
			Message.messenger.add(SymbolLoaded, onSymbolLoaded);
		}
		
		private function onSymbolLoaded(message:SymbolLoaded):void
		{
			//show whatever symbol is loaded only if there isn't one specified
			if (!_view.symbolPath || _view.symbolPath == message.symbol.path)
			{
				if (_testSymbol)
				{
					removeChild(_testSymbol);
				}
				_testSymbol = message.symbol.displayObject;
				_testSymbol.x = stage.stageWidth * .5;
				_testSymbol.y = stage.stageHeight * .5;
				addChild(_testSymbol);
				
				Message.messenger.remove(SymbolLoaded, onSymbolLoaded);
			}
		}
		
		private function clickedValidateDirectory():void
		{
			new ValidateXMLInDirectory();
		}
		
		private function clickedValidateFiles():void
		{
			new ValidateXMLFiles();
		}
		
		private function clickedValidateSymbol():void
		{
			Message.messenger.dispatch(new SymbolRequest(_view.symbolPath));
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