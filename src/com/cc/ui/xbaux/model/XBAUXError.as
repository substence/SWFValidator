package com.cc.ui.xbaux.model
{
	public class XBAUXError extends Error
	{
		public function get messageList():Vector.<String>
		{
			return _messageList;
		};
		
		public function appendErrorMessage(message:String):void
		{
			_messageList.push(message);
		};
		
		private var _messageList:Vector.<String> = new Vector.<String>();
	}
}