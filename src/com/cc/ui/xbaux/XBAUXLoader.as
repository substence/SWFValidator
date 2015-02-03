package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.messages.LogRequest;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
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
		private var _contractURL:String;
		private var _xml:XML;
		private var _swf:MovieClip;
		private var _signalLoaded:Signal;
		private var _directory:String;
		
		public function XBAUXLoader(contractURL:String)
		{
			_signalLoaded = new Signal(String);
			_contractURL = contractURL;
			_directory = _contractURL.substring(0, _contractURL.lastIndexOf("/") + 1);
		}
		
		/*public function loadXML():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadedXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(_contractURL));
		}
		
		public function loadedXML(event:Event = null):void
		{
			try
			{
				_xml = new XML(event.target.data);
			}
			catch(error:Error)
			{
				throwError(error.message);
			}
			finishedXML();
		}*/
		
		public  function loadXML():void
		{
			var file:File = new File(_contractURL) 
			var fileStream:FileStream = new FileStream(); 
			fileStream.open(file, FileMode.READ); 
			var prefsXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable)); 
			fileStream.close();
			_xml = prefsXML;
			finishedXML();
		}
		
		private function finishedXML():void
		{
			signalLoaded.dispatch(LOADED_XML);
		}
		
		public function loadSWF(url:String):void
		{
			var loader:Loader = new Loader(); 
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedSWF); 
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.load(new URLRequest(_directory + url), new LoaderContext(false, ApplicationDomain.currentDomain));		
		}
		
		protected function loadedSWF(event:Event):void
		{
			_swf = MovieClip(event.target.content);
			_signalLoaded.dispatch(LOADED_SWF);
		}
		
		protected function onLoadError(event:ErrorEvent):void
		{
			throwError(event.text);
		}
		
		private function throwError(error:String):void
		{
			Message.messenger.dispatch(new LogRequest("XBAUXLoader - " + error, XBAUXLogger.ERROR));
		}
		
		public function cleanUp():void
		{
			_xml = null;
			_swf = null;
			_signalLoaded = null;
		}
		
		public function get swf():MovieClip
		{
			return _swf;
		}
		
		public function get xml():XML
		{
			return _xml;
		}
		
		public function get signalLoaded():Signal
		{
			return _signalLoaded;
		}
	}
}