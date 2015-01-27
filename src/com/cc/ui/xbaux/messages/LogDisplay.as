package com.cc.ui.xbaux.messages
{
	import com.cc.messenger.Message;
	
	public class LogDisplay extends Message
	{
		private var _message:LogRequest;
		
		public function LogDisplay(message:LogRequest)
		{
			_message = message;
		}

		public function get message():LogRequest
		{
			return _message;
		}
	}
}