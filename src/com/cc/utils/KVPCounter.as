package com.cc.utils
{
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	public class KVPCounter
	{
		private var _keysToInt:Dictionary = new Dictionary();
		
		public var valueChangeSignal:Signal = new Signal(String,int);
		
		public function KVPCounter()
		{
		}
		
		public function getKeys():Vector.<String>
		{
			var keys:Vector.<String> = new Vector.<String>();
			for (var key:String in _keysToInt)
			{
				if(key != null)
				{
					keys.push(key);
				}
			}
			return keys;
		}
		
		public function addValue(key:String, value:int):void
		{
			if(!_keysToInt.hasOwnProperty(key) )
			{
				setValue(key, value);
			}
			else
			{
				setValue(key, getValue(key) + value);
			}
		}
		
		public function getValue(key:String):int
		{
			if(!_keysToInt.hasOwnProperty(key) )
			{
				return 0;
			}
			return _keysToInt[key];
		}
		
		public function setValue(key:String, value:int):void
		{
			var changed:Boolean = false;
			if(!_keysToInt.hasOwnProperty(key) )
			{
				_keysToInt[key] = value;
				changed = true;
			}
			else
			{
				if (_keysToInt[key] != value)
				{
					_keysToInt[key]  = value;
					changed = true;
				}
			}
			
			if(changed)
			{
				valueChangeSignal.dispatch(key,value);
			}
		}
	}
}