package com.cc.utils.localConfig
{
	import com.cc.assets.AssetLoadingComponent;
	import com.cc.utils.DebugUtils;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LocalConfigLoader
	{
		public function LocalConfigLoader()
		{}
		
		CONFIG::local
		{
			private var _loadCompleteCallback:Function;
			
			public function loadConfig(configPath:String, loadCallback:Function) : void
			{
				_loadCompleteCallback = loadCallback;
				
				var request:URLRequest = new URLRequest(configPath);
				
				var urlLoader:URLLoader = new URLLoader();
				
				urlLoader.addEventListener( Event.COMPLETE, onLoadComplete);
				urlLoader.addEventListener( IOErrorEvent.IO_ERROR, onLoadError);
				
				urlLoader.load( request );
			}
			
			private function onLoadError(e:Event) : void
			{
				DebugUtils.assert(false, "LocalConfigLoader::onLoadError- Config file not found in /client directory");
			}
			
			private function onLoadComplete(e:Event) : void
			{
				var result:String = e.target.data as String;
				LocalConfigs.instance.loadConfigData(result);
				
				DebugUtils.assert(_loadCompleteCallback != null, "LocalConfigLoader::onLoadComplete- No loadComplete callback provided");
		
				_loadCompleteCallback();
			}
		} // CONFIG::local
	}
}