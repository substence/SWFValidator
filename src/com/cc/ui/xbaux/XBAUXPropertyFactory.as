package com.cc.ui.xbaux
{
	import com.cc.ui.xbaux.model.properties.PropertyButton;
	import com.cc.ui.xbaux.model.properties.PropertyMovieClip;
	import com.cc.ui.xbaux.model.properties.PropertyTextfield;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	internal class XBAUXPropertyFactory extends EventDispatcher
	{
		private var _propertyTypes:Dictionary;
		
		public function XBAUXPropertyFactory()
		{
			_propertyTypes = new Dictionary();
			_propertyTypes["text"] = PropertyTextfield;
			_propertyTypes["button"] = PropertyButton;
			_propertyTypes["mc"] = PropertyMovieClip;
		}
		
		public function getTypeFromTypeString(typeString:String):*
		{
			return _propertyTypes[typeString];
		}
	}
}