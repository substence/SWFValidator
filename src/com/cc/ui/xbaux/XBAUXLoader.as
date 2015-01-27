package com.cc.ui.xbaux
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.osflash.signals.Signal;
	
	//loads and stores the raw XML and SWF for a contract
	internal class XBAUXLoader
	{
		public static const LOADED_XML:String = "loadedXML";
		public static const LOADED_SWF:String = "loadedSWF";
		public static const LOAD_COMPLETE:String = "loadedEverything";
		private static const _CONTRACT_DIRECTORY:String = "";
		private var _contractURL:String;
		private var _xml:XML;
		private var _swf:MovieClip;
		private var _signalLoaded:Signal;
		
		public function XBAUXLoader(contractURL:String)
		{
			_signalLoaded = new Signal(String);
			_contractURL = _CONTRACT_DIRECTORY + contractURL;
		}
		
		public function get swf():MovieClip
		{
			return _swf;
		}

		public function get xml():XML
		{
			return _xml;
		}
		
		public function loadXML():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadedXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(_contractURL));
		}
		
		protected function loadedXML(event:Event):void
		{
			_xml = new XML(event.target.data);
			signalLoaded.dispatch(LOADED_XML);
		}
		
		public function loadSWF(url:String):void
		{
			var loader:Loader = new Loader(); 
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedSWF); 
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(url), new LoaderContext(false, ApplicationDomain.currentDomain));		
		}
		
		protected function loadedSWF(event:Event):void
		{
			_swf = MovieClip(event.target.content);
			_signalLoaded.dispatch(LOADED_SWF);
		}
		
		protected function onLoadError(event:Event):void
		{
			// TODO Auto-generated method stub
		}
		
		public function get signalLoaded():Signal
		{
			return _signalLoaded;
		}
	}
}