package
{
	import properties.Property;

	public class XMLtoPopup
	{
		private var _properties:Vector.<Property>;
		private var _name:String;
		
		public function XMLtoPopup(name:String, properties:Vector.<Property>)
		{
			_name = name;
			_properties = properties;
		}

		public function get name():String
		{
			return _name;
		}

		public function get properties():Vector.<Property>
		{
			return _properties;
		}

	}
}