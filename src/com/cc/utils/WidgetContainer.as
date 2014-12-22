package com.cc.utils
{
	import flash.display.Sprite;
	
	public class WidgetContainer extends Sprite
	{
		private var _content:Sprite;
		private var _outline:Sprite;
		
		public function WidgetContainer()
		{
			super();
			_content = new Sprite();
			_outline = new Sprite();
			_outline.mouseEnabled = false;
			addChild(_content);
			addChild(_outline);
		}
		
		public function get content() : Sprite
		{
			return _content;
		}
		
		public function get outline() : Sprite
		{
			return _outline;
		}
	}
}