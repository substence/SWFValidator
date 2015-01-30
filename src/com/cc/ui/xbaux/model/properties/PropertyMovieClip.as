package com.cc.ui.xbaux.model.properties
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public class PropertyMovieClip extends Property
	{
		public var movieClip:MovieClip;
		
		override public function validate(container:DisplayObjectContainer, xml:XML):Error
		{
			var error:Error = super.validate(container, xml);
			
			if (error)
			{
				return error;
			}
			else if (_property)
			{
				movieClip = _property as MovieClip;
				
				if (!movieClip)
				{
					return new Error("poperty is not a movieclip");
				}
				else
					return null;
			}
			else
				return new Error("MovieClip failed to initialize");
		}
	}
}