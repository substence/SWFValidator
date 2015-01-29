package
{
	import fl.controls.Button;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import org.osflash.signals.Signal;

	public class XMLValidatorView extends Sprite
	{
		private var _actionButton:Button;
		private var _directoryScan:Button;
		private var _fileScan:Button;
		private var _symbolTextfield:TextField;
		private var _xmlTextfield:TextField;
		private var _defaultXMLPath:String;
		private var _defaultSymbolPath:String;
		private var _outputText:TextField;
		private var _signalValidateDirectory:Signal;
		private var _signalValidateFiles:Signal;
		
		public function XMLValidatorView()
		{
			_xmlTextfield = getInputTextfield()
			//addChild(_xmlTextfield);
			
			_symbolTextfield = getInputTextfield()
			//addChild(_symbolTextfield);
			
			_actionButton = new Button();
			_actionButton.label = "Submit";
			_actionButton.buttonMode = true;
			_actionButton.addEventListener(MouseEvent.CLICK, clickedSubmit);
			//addChild(_actionButton);
			
			_directoryScan = new Button();
			_directoryScan.label = "Validate Directory";
			_directoryScan.buttonMode = true;
			_directoryScan.addEventListener(MouseEvent.CLICK, clickedScanDirectory);
			addChild(_directoryScan);
			_signalValidateDirectory = new Signal();
			
			_fileScan = new Button();
			_fileScan.label = "Validate File(s)";
			_fileScan.buttonMode = true;
			_fileScan.addEventListener(MouseEvent.CLICK, clickedValidateFiles);
			addChild(_fileScan);
			_signalValidateFiles = new Signal();
			
			_outputText = new TextField();
			_outputText.multiline = true;
			_outputText.wordWrap = true;
			addChild(_outputText);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		protected function clickedValidateFiles(event:MouseEvent):void
		{
			_signalValidateFiles.dispatch();
		}
		
		protected function clickedScanDirectory(event:MouseEvent):void
		{
			_signalValidateDirectory.dispatch();
		}
		
		protected function clickedSubmit(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function getInputTextfield(defaultText:String = ""):TextField
		{
			var inputTextfield:TextField = new TextField();
			inputTextfield.type = TextFieldType.INPUT;
			inputTextfield.autoSize = TextFieldAutoSize.LEFT;
			inputTextfield.border = true;
			inputTextfield.borderColor = 0;
			inputTextfield.text = defaultText;
			return inputTextfield;
		}
		
		private function addedToStage(event:Event):void
		{
			var y:Number = _directoryScan.height;
			var x:Number = _directoryScan.width;
			_fileScan.x = x;			
			//_symbolTextfield.y = _xmlTextfield.height;
			//_actionButton.y = _symbolTextfield.y + _symbolTextfield.height;
			_outputText.y = y;
			_outputText.width = this.stage.stageWidth;
		}
		
		public function showLog(value:String):void
		{
			_outputText.appendText(value + "\n");
		}
		
		public function get xmlPath():String
		{
			return _xmlTextfield.text;
		}
		
		public function set defaultXMLPath(value:String):void
		{
			_defaultXMLPath = value;
			if (!_xmlTextfield.text)
			{
				_xmlTextfield.text = _defaultXMLPath;
			}
		}
		
		public function get symbolPath():String
		{
			return _symbolTextfield.text;
		}
		
		public function set defaultSymbolPath(value:String):void
		{
			_defaultSymbolPath = value;
			if (!_symbolTextfield.text)
			{
				_symbolTextfield.text = _defaultSymbolPath;
			}
		}
		
		public function get signalScanDriectory():Signal
		{
			return _signalValidateDirectory;
		}
		
		public function get signalValidateFiles():Signal
		{
			return _signalValidateFiles;
		}
	}
}