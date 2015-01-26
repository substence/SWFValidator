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

	public class XMLValidatorView extends Sprite
	{
		private var _actionButton:Button;
		private var _symbolTextfield:TextField;
		private var _xmlTextfield:TextField;
		private var _defaultXMLPath:String;
		private var _defaultSymbolPath:String;
		private var _outputText:TextField;
		
		public function XMLValidatorView()
		{
			addChild(_xmlTextfield = getInputTextfield());
			
			addChild(_symbolTextfield = getInputTextfield());
			
			_actionButton = new Button();
			_actionButton.label = "Submit";
			_actionButton.buttonMode = true;
			_actionButton.addEventListener(MouseEvent.CLICK, clickedSubmit);
			addChild(_actionButton);
			
			_outputText = new TextField();
			_outputText.multiline = true;
			_outputText.wordWrap = true;
			addChild(_outputText);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
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
			_symbolTextfield.y = _xmlTextfield.height;
			_actionButton.y = _symbolTextfield.y + _symbolTextfield.height;
			_outputText.y = _actionButton.y + _actionButton.height;
			_outputText.width = this.stage.stageWidth;
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
		
		public function set output(value:String):void
		{
			_outputText.text = value;
		}
	}
}