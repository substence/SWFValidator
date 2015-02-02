package com.cc.ui.xbaux.model.properties
{
	import com.cc.utils.GraphicUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class Property
	{
		protected var _xml:XML;
		protected var _property:DisplayObject;
		private var _name:String;
		
		public function get name():String
		{
			return _name;
		}

		public function initialize(container:DisplayObjectContainer, xml:XML):void // throws ContractError
		{
			_xml = xml;
			_name = _xml.@name;
			var path:String = _xml.@path;
			
			if (!path)
			{
				throw new ContractError("path is empty for control '" + _name + "'");
			}
			else
			{
				if (!_name)
				{
					_name = path;
				}
				
				_property = GraphicUtils.getNestedChild(container, path);
			
				if (!_property)
				{
					throw new ContractError("no path '" + path + "' found in the correponding .swf file for control '" + _name + "'");
				}
			}
		}
		
		public function implement():void
		{
			
		}
	}
}