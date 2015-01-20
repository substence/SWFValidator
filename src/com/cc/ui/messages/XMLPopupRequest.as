package com.cc.ui.messages
{
	import com.cc.messenger.Message;
	import com.cc.ui.XMLtoPopup;
	
	public class XMLPopupRequest extends Message
	{
		private var _name:String;
		
		public function XMLPopupRequest(name:String)
		{
			_name = name;
		}
		
		public function get name():String
		{
			return _name;
		}
	}
}