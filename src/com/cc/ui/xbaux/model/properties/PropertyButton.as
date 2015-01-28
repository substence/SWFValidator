package com.cc.ui.xbaux.model.properties
{
	import flash.display.DisplayObjectContainer;

	public class PropertyButton extends Property
	{
		public var button:UIButton;
		public var onClickScript:String;
		
		override public function validate(container:DisplayObjectContainer, xml:XML):Error
		{
			super.validate(container, xml);
			if (_property)
			{
//				button = _property as UIButton;
//				if (!button)
//				{
//					return new Error("Property is not a valid button");
//				}
			}
			return null;
		}
		
		override public function implement():void
		{
			if (_xml)
			{
				var clickScript:String = _xml.@onClick;
				if (clickScript)
				{
					onClickScript = clickScript;
				}
			}
		}
	}
}
class UIButton
{
	
}