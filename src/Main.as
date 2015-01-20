package
{
	import com.cc.ui.XMLtoSWFInterpreter;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.osmf.elements.SWFLoader;
	
	[SWF(backgroundColor="0xFFFFFF", width="760" , height="750", frameRate="40")]
	
	public class Main extends Sprite
	{
		private static const _DEFAULT_XML:String = "TestXML.xml";
		private var _loadedXML:XML;
		private var _loadedSWF:MovieClip;
		private var _interpeter:XMLtoSWFInterpreter;
		private var _view:XMLValidatorView;
		
		public function Main()
		{
			_interpeter = new XMLtoSWFInterpreter();
			_interpeter.addEventListener(ErrorEvent.ERROR, onInterpeterError);
			_view = new XMLValidatorView();
			_view.defaultXMLPath = _DEFAULT_XML;
			_view.addEventListener(Event.CHANGE, updatedViewInfo);
			addChild(_view);
		}
		
		protected function onInterpeterError(event:ErrorEvent):void
		{
			showOutput(event.text);
		}
		
		protected function updatedViewInfo(event:Event):void
		{
			loadXML(_view.xmlPath);
		}
		
		private function loadXML(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadedXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(url));
		}
		
		protected function onLoadError(event:IOErrorEvent):void
		{
			showOutput(event.text);
		}
		
		protected function loadedXML(event:Event):void
		{
			_loadedXML = new XML(event.target.data);
			var swfPath:String = _loadedXML.@path;
			if (swfPath)
			{
				loadSWF(swfPath);
			}
		}
		
		private function loadSWF(url:String):void
		{
			var loader:Loader = new Loader(); 
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler); 
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));		
		}
		
		protected function completeHandler(event:Event):void
		{
			_loadedSWF = MovieClip(event.target.content);
			addChild(_loadedSWF);
			_interpeter.getPopups(_loadedSWF, _loadedXML);
			//showOutput("Success!");
		}
		
		private function showOutput(message:String):void
		{
			_view.output = message + "\n";
		}
	}
}