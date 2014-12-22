package com.cc.utils.logging
{
	import com.cc.utils.signals.SignalMap;
	
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	public class LogGatherer
	{
		private static var _signalMap:SignalMap = new SignalMap();

		private var _logQueue:LogQueue;
		private var _categories:Vector.<String>; 
		
		public static function log(category:String, message:String) : void
		{
			var signal:Signal = _signalMap.find(category);
			
			if (signal)
			{
				signal.dispatch(message);
			}
		}
		
		public function LogGatherer(logQueue:LogQueue, categories:Vector.<String>)
		{
			_logQueue = logQueue;
			_categories = categories;
			add();
		}
		
		public function clear() : void
		{
			_logQueue.clear();
			remove();			
		}
		
		public function log(message:String) : void
		{
			_logQueue.log(message);
		}
		
		public function get queue() : LogQueue
		{
			return _logQueue;
		}
		
		private function add() : void
		{
			for each (var category:String in _categories)
			{
				var signal:Signal = _signalMap.find(category);
				
				if (!signal)
				{
					signal = _signalMap.create(category, String);
				}
				if (signal)
				{
					signal.add(log);
				}
			}
		}
		
		private function remove() : void
		{
			for each (var category:String in _categories)
			{
				var signal:Signal = _signalMap.find(category);
				
				if (signal)
				{
					signal.remove(log);
				}
			}
		}
	}
}
