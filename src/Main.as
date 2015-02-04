package
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXLogger;
	import com.cc.ui.xbaux.XBAUXManager;
	import com.cc.ui.xbaux.messages.LogDisplay;
	import com.cc.ui.xbaux.messages.LogRequest;
	import com.cc.ui.xbaux.messages.SymbolLoaded;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	
	import commands.ValidateXMLFiles;
	import commands.ValidateXMLInDirectory;
	import commands.ValidateXMLonDnD;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import messages.SaveDirectory;
	
	[SWF(backgroundColor="0xFFFFFF", width="760" , height="750", frameRate="40")]
	
	public class Main extends Sprite
	{
		private static const _DEFAULT_SYMBOL:String = "Symbol Name";
		private var _directoryToScan:String;
		private var _view:XMLValidatorView;
		private var _testSymbol:DisplayObjectContainer;
		private var _config:ConfigManager;
		
		public function Main()
		{
			_config = new ConfigManager();
			
			new XBAUXManager();
			
			_view = new XMLValidatorView();
			_view.defaultSymbolPath = _DEFAULT_SYMBOL;
			_view.signaChangeDirectory.add(clickedChangeDirectory);
			_view.signalValidate.add(clickedValidate);
			_view.signalShowSymbol.add(clickedShowSymbol);
			_view.directoryToScan = _config.lastKnownDirectory;
			addChild(_view);				
			
			Message.messenger.add(SymbolLoaded, onSymbolLoaded);
			
			Message.messenger.add(LogDisplay, onLogDisplay);

			Message.messenger.add(SaveDirectory, onDirectoryChange);
			
			new ValidateXMLonDnD(_view.outputContainer);
			
			scanLastKnownDirectory();
		}
		
		private function onDirectoryChange(message:SaveDirectory):void
		{
			_directoryToScan = message.directory;
			_view.directoryToScan =  _directoryToScan;
			_config.lastKnownDirectory = _directoryToScan;
		}
		
		private function scanLastKnownDirectory():void
		{
			if (_config.lastKnownDirectory)
			{
				_view.clearLog();
				const message:String = "Found a saved XML directory, automatically running validation on '" + _config.lastKnownDirectory + "'";
				Message.messenger.dispatch(new LogRequest(message, XBAUXLogger.DEBUG));
				new ValidateXMLInDirectory(new File(_config.lastKnownDirectory));
			}
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
				_testSymbol = new Sprite();
				_testSymbol.addChild(message.symbol.displayObject);
				_testSymbol.mouseChildren = false;
				_testSymbol.x = stage.stageWidth * .5;
				_testSymbol.y = stage.stageHeight * .5;
				_testSymbol.addEventListener(MouseEvent.CLICK, clickedTestSymbol, false, 0, true);
				addChild(_testSymbol);
			}
			Message.messenger.dispatch(new LogDisplay(new LogRequest("Symbol '" + message.symbol.name + "' is Valid!", XBAUXLogger.DEBUG)));
			_view.showSymbolButton();
		}
		
		protected function clickedTestSymbol(event:Event):void
		{
			if (_testSymbol && contains(_testSymbol))
			{
				removeChild(_testSymbol);
			}
			_testSymbol = null;
		}
		
		private function clickedChangeDirectory():void
		{
			new ValidateXMLInDirectory();
		}
		
		private function clickedValidate():void
		{
			_view.clearLog();
			if (_directoryToScan)
			{
				new ValidateXMLInDirectory(new File(_directoryToScan));
			}
			else
			{
				new ValidateXMLInDirectory();
			}
		}
		
		private function clickedShowSymbol():void
		{
			_view.clearLog();
			Message.messenger.dispatch(new SymbolRequest(_view.symbolPath));
		}
		
		private function onLogDisplay(message:LogDisplay):void
		{
			var messageLog:LogRequest = message.message;
			var constructedMessage:String = messageLog.timeStamp + " : " + messageLog.message;
			if (messageLog.level == XBAUXLogger.ERROR)
			{
				constructedMessage = "<font color='#FF0000'>" + constructedMessage + "</font>";
			}
			else if (messageLog.level == XBAUXLogger.WARNING)
			{
				constructedMessage = "<font color='#ffff00'>" + constructedMessage + "</font>";
			}
			_view.showLog(constructedMessage); 
			trace(constructedMessage);
		}
	}
}