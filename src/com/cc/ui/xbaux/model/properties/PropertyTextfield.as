package com.cc.ui.xbaux.model.properties
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	public class PropertyTextfield extends Property
	{
		public var textField:TextField;
		
		override public function initialize(container:DisplayObjectContainer, xml:XML):void
		{
			super.initialize(container, xml);
			
			textField = _property as TextField;

			if (!textField)
			{
				throw new ContractError("property '" + name + "' is not actually a TextField");
			}
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