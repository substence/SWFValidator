package com.cc.utils.logging
{
	import com.adverserealms.log.Logger;
	
	public class LogQueue
	{
		private var _logMessages:Vector.<String>;
		private var _currentLogIndex:int = 0;
		
		public function LogQueue(max:int)
		{
			max = (max > 0) ? max : 1;
			_logMessages = new Vector.<String>(max, true);
		}

		public function log(message:String) : void
		{
			_logMessages[_currentLogIndex] = message;
			_currentLogIndex = (_currentLogIndex + 1) % _logMessages.length;
		}
		
		public function dump() : void
		{
			var i:int = _currentLogIndex;
			
			do
			{
				var message:String = _logMessages[i]; 
				
				if (message)
				{
					Logger.debug(message);	
				}
				i = (i + 1) % _logMessages.length;
			}
			while (i != _currentLogIndex);
		}
		
		public function clear() : void
		{
			var max:int = _logMessages.length;
			
			_currentLogIndex = 0;
			_logMessages = new Vector.<String>(max, true);
		}
	}
}
