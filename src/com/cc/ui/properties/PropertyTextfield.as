package com.cc.ui.properties
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
				var key:String = xml.@key;
				if (key)
				{
					textField.htmlText = key;
				}
			}
			return null;
		}
	}
}