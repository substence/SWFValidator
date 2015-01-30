package com.cc.ui.xbaux.model.properties
{
	import flash.display.DisplayObjectContainer;

	public class PropertyButton extends Property
	{
		public var button:UIButton;
		public var onClickScript:String;
		
		override public function validate(container:DisplayObjectContainer, xml:XML):Error
		{
			var error:Error = super.validate(container, xml);
			
			if (error)
			{
				return error;
			}
			else if (_property)
			{
//				button = _property as UIButton;
//				if (!button)
//				{
//					return new Error("Property is not a valid button");
//				}
				return null; // now let's assume everything's Ok
			}
			else
				return new Error("Image failed to initialize");
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