package com.cc.ui
{
	import com.cc.messenger.Message;
	import com.cc.ui.messages.XMLPopupCreatedMessage;
	import com.cc.ui.properties.Property;
	import com.cc.ui.properties.PropertyTextfield;
	
	import flash.text.TextField;

	public class XMLtoPopup
	{
		//lets make this a dictionary for easy lookup
		private var _properties:Vector.<Property>;
		private var _name:String;
		
		public function XMLtoPopup(name:String)
		{
			_name = name;
			Message.messenger.dispatch(new XMLPopupCreatedMessage(this));
		}
		
		protected function getTextfield(name:String):TextField
		{
			return (getProperty(name) as PropertyTextfield).textField;
		}
		
		protected function getProperty(name:String):Property
		{
			for each (var property:Property in _properties) 
			{
				if (property.name == name)
				{
					return property;
				}
			}
			return null;
		}
		
		protected function onDataLoaded():void
		{
			// TODO Auto Generated method stub
		}

		internal function set properties(value:Vector.<Property>):void
		{
			if (value && value !=_properties)
			{
				_properties = value;
				onDataLoaded();
			}
		}
		
		public function get name():String
		{
			return _name;
		}
	}
}