package com.cc.ui.xbaux.model.properties
{
	import flash.display.DisplayObjectContainer;

	public class PropertyButton extends Property
	{
		// public var button:UIButton;
		public var onClickScript:String;
		
		override public function initialize(container:DisplayObjectContainer, xml:XML):void
		{
			super.initialize(container, xml);

			// // _property is initialized, now let's process button's specific initialization
			//button = _property as UIButton;
			//if (!button)
			//{
			//	return new Error("Property is not a valid button");
			//}
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