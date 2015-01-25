package com.cc.ui.xbaux.properties
{
	import com.cc.utils.GraphicUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class Property
	{
		protected var _property:DisplayObject;
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}

		public function validate(container:DisplayObjectContainer, xml:XML):Error
		{
			_name = xml.@name;
			var path:String = xml.@path;
			if (path)
			{
				_property = GraphicUtils.getNestedChild(container, path);
				if (!_name)
				{
					_name = path;
				}
			}
			else
			{
				return new Error("property has no path");
			}
			return null;
		}
	}
}