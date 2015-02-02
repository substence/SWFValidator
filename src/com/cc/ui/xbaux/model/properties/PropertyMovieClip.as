package com.cc.ui.xbaux.model.properties
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public class PropertyMovieClip extends Property
	{
		public var movieClip:MovieClip;
		
		override public function initialize(container:DisplayObjectContainer, xml:XML):void
		{
			super.initialize(container, xml);
			
			movieClip = _property as MovieClip;
				
			if (!movieClip)
			{
				throw new ContractError("property + '" + name + "' is not actualy a MovieClip");
			}
		}
	}
}