package properties
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	public class PropertyFactory
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
						error;
					}
					finalProperties.push(property);
				}
				else
				{
					new Error("unknown property type " + typeString);
				}
			}
			return finalProperties;
		}
		
		private function getTypeFromTypeString(typeString:String):Class
		{
			return _propertyTypes[typeString];
		}
	}
}