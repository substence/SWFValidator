package com.cc.ui.xbaux.messages
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XMLtoPopup;
	
	public class XMLPopupRequest extends Message
	{
		private var _name:String;

		public function get callback():Function
		{
			return _callback;
		}

		private var _callback:Function;
		
		public function XMLPopupRequest(name:String, callback:Function)
		{
			_name = name;
			_callback = callback;
		}
		
		public function get name():String
		{
			return _name;
		}
	}
}