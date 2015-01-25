package com.cc.ui.xbaux.properties
{
	import flash.display.DisplayObjectContainer;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class PropertyFactory extends EventDispatcher
	{
		private var _propertyTypes:Dictionary;
		
		public function PropertyFactory()
		{
			_propertyTypes = new Dictionary();
			_propertyTypes["text"] = PropertyTextfield;
			_propertyTypes["button"] = PropertyButton;
		}
		
		public function getTypeFromTypeString(typeString:String):*
		{
			return _propertyTypes[typeString];
		}
	}
}