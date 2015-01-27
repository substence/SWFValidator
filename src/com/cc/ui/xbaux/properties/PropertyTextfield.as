package com.cc.ui.xbaux.properties
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	public class PropertyTextfield extends Property
	{
		public var textField:TextField;
		
		override public function validate(container:DisplayObjectContainer, xml:XML):Error
		{
			super.validate(container, xml);
			if (_property)
			{
				textField = _property as TextField;
				if (!textField)
				{
					return new Error("poperty is not a textfield");
				}
			}
			return null;
		}
		
		override public function implement():void
		{
			if (_xml)
			{
				var key:String = _xml.@key;
				if (key)
				{
					textField.htmlText = key;
				}
			}
		}
	}
}