package com.cc.messenger
{
	import com.cc.utils.signals.SignalMap;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.Signal;
	
	public class Messenger
	{
		private const _signalMap:SignalMap = new SignalMap();
		
		public function add(messageClass:Class, listener:Function) : void
		{
			var className:String = getQualifiedClassName(messageClass);
			var signal:Signal = _signalMap.find(className);
			
			if (!signal)
			{
				signal = _signalMap.create(className, messageClass);
			}
			if (signal)
			{
				signal.add(listener);
			}
			else
			{
			}
		}
		
		public function remove(messageClass:Class, listener:Function) : void
		{
			var className:String = getQualifiedClassName(messageClass);
			var signal:Signal = _signalMap.find(className);
			
			if (signal)
			{
				signal.remove(listener);
			}
			else
			{
			}
		}
		
		public function dispatch(message:Message) : void
		{
			var className:String = getQualifiedClassName(message);
			var signal:Signal = _signalMap.find(className);
			
			log("dispatch: " + className);
			
			if (signal)
			{
				signal.dispatch(message);
			}
		}
		
		private static function log(message:String) : void
		{

		}
	}
}