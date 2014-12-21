package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.osmf.elements.SWFLoader;
	import com.cc.ui.XMLtoSWFInterpreter;
	
	[SWF(backgroundColor="0x333333", width="760" , height="750", frameRate="40")]
	
	public class Main extends Sprite
	{
		private var _loadedXML:XML;
		private var _loadedSWF:*;
		private var _interpeter:XMLtoSWFInterpreter;
		
		public function Main()
		{
			_interpeter = new XMLtoSWFInterpreter();
			loadXML("TestXML.xml");
		}
		
		private function loadXML(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadedXML);
			loader.load(new URLRequest(url));
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
			var ldr:Loader = new Loader(); 
			var req:URLRequest = new URLRequest(url); 
			var ldrContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain); 
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler); 
			ldr.load(req, ldrContext);  			//loader.addEventListener(Event.COMPLETE, loadedSWF);		
		}
		
		protected function completeHandler(event:Event):void
		{
			_loadedSWF = event.target.content;
			addChild(_loadedSWF);
			_interpeter.getPopups(_loadedSWF, _loadedXML);		
		}
	}
}