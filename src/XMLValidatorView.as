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
	import flash.text.TextFormat;

	public class XMLValidatorView extends Sprite
	{
		private var _actionButton:Shape;
		private var _swfTextfield:TextField;
		private var _xmlTextfield:TextField;
		
		public function XMLValidatorView()
		{
			addChild(_xmlTextfield = getInputTextfield("TestXML.xml"));
			
			addChild(_swfTextfield = getInputTextfield("Enter SWF name"));
			
			_actionButton = new Shape();
			_actionButton.graphics.beginFill(0xFF0000);
			_actionButton.graphics.drawRect(0,0,100,20);
			_actionButton.addEventListener(MouseEvent.CLICK, clickedSubmit);
			addChild(_actionButton);
			
			init();
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
		
		private function init():void
		{
			_swfTextfield.y = _xmlTextfield.height;
			_actionButton.y = _swfTextfield.y + _swfTextfield.height;
		}
		
		public function get xmlPath():String
		{
			return _xmlTextfield.text;
		}
	}
}