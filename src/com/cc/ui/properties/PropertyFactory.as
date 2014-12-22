package com.cc.ui.properties
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
		
		public function getProperties(movieclip:DisplayObjectContainer, propertiesList:XMLList):Vector.<Property>
		{
			var finalProperties:Vector.<Property> = new Vector.<Property>();
			for each (var propertyXML:XML in propertiesList) 
			{
				var typeString:String = propertyXML.@type;
				var type:Class = getTypeFromTypeString(typeString);
				if (type)
				{
					//todo: im assuming this is of type Property
					var property:Property = new type() as Property;
					var error:Error = property.validate(movieclip, propertyXML);
					if (error)
					{
						dispatchError(error.message);
					}
					finalProperties.push(property);
				}
				else
				{
					dispatchError("Unknown property type '" + typeString + "'");
				}
			}
			return finalProperties;
		}
		
		private function getTypeFromTypeString(typeString:String):Class
		{
			return _propertyTypes[typeString];
		}
		
		private function dispatchError(message:String):void
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false, false, message));
		}
	}
}