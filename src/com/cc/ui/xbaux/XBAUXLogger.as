package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.messages.LogDisplay;
	import com.cc.ui.xbaux.messages.LogRequest;

	public class XBAUXLogger
	{
		public static const ERROR:uint = 5;
		public static const WARNING:uint = 3;
		public static const DEBUG:uint = 2;
		public static const VERBOSE:uint = 1;
		private static const _LOG_LIMIT:uint = 500;
		private var _level:uint;
		private var _log:Vector.<LogRequest>
		
		public function XBAUXLogger()
		{
			_level = VERBOSE;
			_log = new Vector.<LogRequest>(_LOG_LIMIT);
			Message.messenger.add(LogRequest, onLogRequest);
		}
		
		//todo, only record in debug builds
		private function onLogRequest(request:LogRequest):void
		{
			_log.push(request);
			if (isMessageAppropiate(request))
			{
				//Message.messenger.dispatch(new LogDisplay(request));
				trace(request.timeStamp + " : XBAUXLogger - " + request.message)
			}
		}
		
		public function getLog(level:uint):Vector.<LogRequest>
		{
			var log:Vector.<LogRequest> = new Vector.<LogRequest>();
			for each (var message:LogRequest in _log) 
			{
				if (isMessageAppropiate(message))
				{
					log.push(message);
				}
			}
			return log;
		}
		
		private function isMessageAppropiate(message:LogRequest):Boolean
		{
			return message.level >= _level;
		}
	}
}