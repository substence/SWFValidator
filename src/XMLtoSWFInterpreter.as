package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import properties.PropertyFactory;

	public class XMLtoSWFInterpreter extends Sprite
	{
		private var _swf:*;
		private var _xml:XML;
		private var _propertyFactory:PropertyFactory;
		
		public function XMLtoSWFInterpreter(swf:*, xml:XML)
		{
			_propertyFactory = new PropertyFactory();
		}
		
		public function validatePopups():void
		{
			for each (var popup:XML in _xml.popup) 
			{
				var path:String = popup.@path;
				if (path)
				{
					if (MovieClip(_swf).loaderInfo.applicationDomain.hasDefinition(path))//_swf.contentLoaderInfo.applicationDomain.hasDefinition(path))
					{
						var mcClass:Class = _swf.loaderInfo.applicationDomain.getDefinition( path ) as Class;
						var mc:MovieClip = new mcClass() as MovieClip;
						validateProperties(mc, popup.property);
					}
					else
					{
						error("popup has an invalid linkage name");
					}
				}
				else
				{
					error("no popup linkage name");
					return;
				}
			}			
		}
		
		private function validateProperties(movieclip:DisplayObjectContainer, properties:XMLList):void
		{
			_propertyFactory = new PropertyFactory();
			_propertyFactory.getProperties(movieclip, properties);
		}
		
		private function error(message:String):void
		{
			
		}
	}
}