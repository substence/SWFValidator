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
	
	import org.osmf.elements.SWFLoader;
	
	[SWF(backgroundColor="0x333333", width="760" , height="750", frameRate="40")]
	
	public class Main extends Sprite
	{
		private var _loadedXML:XML;
		private var _loadedSWF:*;
		
		public function Main()
		{
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
			var loader:Loader = new Loader();
			//loader.addEventListener(Event.COMPLETE, loadedSWF);		
			loader.load(new URLRequest(url));
			loader.x = -(200);
			loader.y = -(200);
			//addChild(loader);
			addChild(new DataDrivenSWF(loader, _loadedXML));
		}
	}
}