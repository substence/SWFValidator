package com.cc.ui.properties
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
				button = _property as UIButton;
				if (!button)
				{
					return new Error("poperty is not a valid button");
				}
				onClickScript = xml.@onClick
			}
			return null;
		}
	}
}
class UIButton
{
	
}