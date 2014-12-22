package com.cc.ui
{
	import com.cc.messenger.Message;
	import com.cc.messenger.Messenger;
	import com.cc.ui.messages.XMLPopupCreatedMessage;
	import com.cc.ui.properties.Property;
	
	import flash.utils.Dictionary;

	public class XMLPopupManager
	{
		private var _popupData:Dictionary;
		
		public function XMLPopupManager()
		{
			_popupData = new Dictionary();
			Message.messenger.add(XMLPopupCreatedMessage, popupCreated);
		}
		
		private function loadData():void
		{
			//start up XMLtoSWFInterpreter
		}
		
		private function popupCreated(message:XMLPopupCreatedMessage):void
		{
			message.popup.properties = getDataForPopup(message.popup.name);
		}
		
		private function getDataForPopup(popupName:String):Vector.<Property>
		{
			return _popupData[popupName]; 
		}
	}
}