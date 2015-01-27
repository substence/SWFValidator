package com.cc.ui.xbaux.messages
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXLogger;
	
	import flash.utils.getTimer;
	
	public class LogRequest extends Message
	{
		private var _timeStamp:uint;
		private var _message:String;
		private var _level:int;
		
		public function LogRequest(message:String, level:int = XBAUXLogger.DEBUG)
		{
			_message = message;
			_level = level;
			_timeStamp = getTimer();
		}

		public function get timeStamp():uint
		{
			return _timeStamp;
		}

		public function get message():String
		{
			return _message;
		}

		public function get level():int
		{
			return _level;
		}
	}
}