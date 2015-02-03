package
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXLogger;
	import com.cc.ui.xbaux.messages.LogRequest;
	
	import fl.controls.Button;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.osflash.signals.Signal;

	public class XMLValidatorView extends Sprite
	{
		private static const _BUFFER:int = 5;
		private var _symbolButton:Button;
		private var _symbolTextfield:TextField;
		private var _defaultSymbolPath:String;
		
		private var _directoryScan:Button;
		private var _directoryToScan:String;
		private var _directory:TextField;
		private var _directoryContainer:Sprite;

		private var _outputText:TextField;
		private var _outputContainer:Sprite;

		public var signaChangeDirectory:Signal;
		public var signalValidate:Signal;
		public var signalShowSymbol:Signal;
		
		public function XMLValidatorView()
		{
			_directoryContainer = new Sprite();
			{
				_directory = getInputTextfield();
				_directory.autoSize = TextFieldAutoSize.LEFT;
				_directory.addEventListener(MouseEvent.CLICK, clickedChangeDirectory);
				_directoryContainer.addChild(_directory);
				_directoryContainer.buttonMode = true;
				_directoryContainer.mouseChildren = false;
			}
			addChild(_directoryContainer);
			signaChangeDirectory = new Signal();
			
			_symbolTextfield = getInputTextfield();
			_symbolTextfield.addEventListener(KeyboardEvent.KEY_UP, onKeyPressOnSymbolName);
			addChild(_symbolTextfield);
			
			_symbolButton = new Button();
			_symbolButton.label = "Show Symbol";
			_symbolButton.buttonMode = true;
			_symbolButton.addEventListener(MouseEvent.CLICK, clickedShowSymbol);
			addChild(_symbolButton);
			signalShowSymbol = new Signal();
			
			_directoryScan = new Button();
			_directoryScan.label = "Validate";
			_directoryScan.buttonMode = true;
			_directoryScan.addEventListener(MouseEvent.CLICK, clickedValidate);
			addChild(_directoryScan);
			signalValidate = new Signal();
			
			_outputContainer = new Sprite();
			{
				_outputText = new TextField();
				_outputText.mouseEnabled = false;
				_outputText.defaultTextFormat = new TextFormat(null, 16);
				_outputText.multiline = true;
				_outputText.borderColor = 0x808080;
				_outputText.border = true;
				_outputText.wordWrap = true;
				_outputContainer.addChild(_outputText);
			}
			addChild(_outputContainer);
			
			hideSymbolButton();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		protected function clickedChangeDirectory(event:MouseEvent):void
		{
			signaChangeDirectory.dispatch();
		}
		
		public function get directoryToScan():String
		{
			return _directoryToScan;
		}

		public function set directoryToScan(value:String):void
		{
			_directoryToScan = value;
			_directory.text = _directoryToScan;
			if (parent)
			{
				resize();
			}
		}

		protected function onKeyPressOnSymbolName(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				clickedShowSymbol();
			}
		}
		
		protected function clickedValidate(event:MouseEvent):void
		{
			signalValidate.dispatch();
		}
		
		protected function clickedShowSymbol(event:MouseEvent = null):void
		{
			if (symbolPath)
			{
				signalShowSymbol.dispatch();
			}
			else
			{
				Message.messenger.dispatch(new LogRequest("No symbol name specified", XBAUXLogger.ERROR));
			}
		}
		
		private function getInputTextfield(defaultText:String = ""):TextField
		{
			var inputTextfield:TextField = new TextField();
			inputTextfield.type = TextFieldType.INPUT;
			//inputTextfield.autoSize = TextFieldAutoSize.LEFT;
			inputTextfield.border = true;
			inputTextfield.borderColor = 0;
			inputTextfield.textColor = 0x808080;
			inputTextfield.text = defaultText;
			return inputTextfield;
		}
		
		private function addedToStage(event:Event):void
		{
			resize();
		}
		
		private function resize():void
		{
			var y:Number = _directory.height + _BUFFER;
			var x:Number = _directory.width + _BUFFER;
			
			//_fileScan.x = x;			
			_symbolTextfield.y = y;
			_directoryContainer.x = _directoryScan.width + _BUFFER;
			
			_symbolButton.y = y;
			
			_symbolTextfield.x = _symbolButton.width + _BUFFER;
			_symbolTextfield.height = _symbolButton.height;
			
			y += _symbolButton.height;
			
			_outputContainer.y = y + _BUFFER;
			_outputText.width = this.stage.stageWidth - 2;
			_outputText.height = this.stage.stageHeight - _outputContainer.y - 2;
		}
		
		public function showLog(value:String):void
		{
			_outputText.htmlText += value + "\n";
		}
		
		public function clearLog():void
		{
			_outputText.text = "";
		}
		
		public function get symbolPath():String
		{
			return _symbolTextfield.text != _defaultSymbolPath ? _symbolTextfield.text : "";
		}
		
		public function set defaultSymbolPath(value:String):void
		{
			_defaultSymbolPath = value;
			if (!_symbolTextfield.text)
			{
				_symbolTextfield.text = _defaultSymbolPath;
			}
		}
		
		public function get outputContainer():Sprite
		{
			return _outputContainer;
		}
		
		public function showSymbolButton():void
		{
			_symbolButton.alpha = 1;
			_symbolTextfield.alpha = 1;
		}
		
		private function hideSymbolButton():void
		{
			_symbolButton.alpha = .25;
			_symbolTextfield.alpha = .25;
		}
	}
}