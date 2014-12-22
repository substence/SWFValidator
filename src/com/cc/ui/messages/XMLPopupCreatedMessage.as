package com.cc.ui.messages
{
	import com.cc.messenger.Message;
	import com.cc.ui.XMLtoPopup;
	
	public class XMLPopupCreatedMessage extends Message
	{
		private var _popup:XMLtoPopup;
		
		public function XMLPopupCreatedMessage(popup:XMLtoPopup)
		{
			_popup = popup;
		}

		public function get popup():XMLtoPopup
		{
			return _popup;
		}
	}
}