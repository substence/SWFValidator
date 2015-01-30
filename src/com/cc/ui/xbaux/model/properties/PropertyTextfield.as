package com.cc.ui.xbaux.model.properties
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	public class PropertyTextfield extends Property
	{
		public var textField:TextField;
		
		override public function validate(container:DisplayObjectContainer, xml:XML):Error
		{
			var error:Error = super.validate(container, xml);
			
			if (error)
			{
				return error;
			}
			else if (_property)
			{
				textField = _property as TextField;

				if (!textField)
				{
					return new Error("poperty is not a textfield");
				}
				else
					return null;
			}
			else
				return new Error("TextField failed to initialize");
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