package com.cc.ui.xbaux.model.properties
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public class PropertyMovieClip extends Property
	{
		public var movieClip:MovieClip;
		
		override public function validate(container:DisplayObjectContainer, xml:XML):Error
		{
			super.validate(container, xml);
			if (_property)
			{
				movieClip = _property as MovieClip;
				if (!movieClip)
				{
					return new Error("poperty is not a movieclip");
				}
			}
			return null;
		}
	}
}