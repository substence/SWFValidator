package
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.Manager;
	import com.cc.ui.xbaux.XMLtoPopup;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(backgroundColor="0xFFFFFF", width="760" , height="750", frameRate="40")]
	
	public class Main extends Sprite
	{
		private static const _DEFAULT_XML:String = "TestXML.xml";
		private var _view:XMLValidatorView;
		
		public function Main()
		{
			new Manager();
			_view = new XMLValidatorView();
			_view.defaultXMLPath = _DEFAULT_XML;
			_view.addEventListener(Event.CHANGE, updatedViewInfo);
			addChild(_view);
		}
		
		protected function updatedViewInfo(event:Event):void
		{
			new XMLtoPopup(_view.xmlPath, "XPEarnedBracket");
		}
		
		private function showOutput(message:String):void
		{
			_view.output = message + "\n";
		}
	}
}