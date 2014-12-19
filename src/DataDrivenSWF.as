package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.xml.XMLNode;

	public class DataDrivenSWF extends Sprite
	{
		private var _swf:*;
		private var _xml:XML;
		
		public function DataDrivenSWF(swf:*, xml:XML)
		{
			addChild(swf);
			_xml = xml;
			_swf = swf;
			//validatePopups();
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
						validateProperties(mc, popup.properties);
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
			for each (var property:* in properties) 
			{
				var type:String = properties.@type;
				trace(type);
			}
		}
		
		private function error(message:String):void
		{
			
		}
	}
}