package com.cc.utils.signals
{
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	public class SignalMap
	{
		// map from signalType:String to Signal(argumentClass:Class)
		private const _signalsMap:Dictionary = new Dictionary();
		
		public function add(signalType:String, listener:Function) : void
		{
			var signal:Signal = find(signalType);
			
			if (signal)
			{
				signal.add(listener);
			}
		}
		
		public function remove(signalType:String, listener:Function) : void
		{
			var signal:Signal = find(signalType);
			
			if (signal)
			{
				signal.remove(listener);
			}
		}

		public function find(signalType:String) : Signal
		{
			return _signalsMap[signalType];
		}
		
		public function create(signalType:String, argumentClass:Class) : Signal
		{
			var signal:Signal = new Signal(argumentClass);
			
			_signalsMap[signalType] = signal;
			return signal;
		}
	}
}