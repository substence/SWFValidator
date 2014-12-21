package com.cc.ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import com.cc.ui.properties.Property;
	import com.cc.ui.properties.PropertyFactory;

	public class XMLtoSWFInterpreter extends Sprite
	{
		private var _propertyFactory:PropertyFactory;
		
		public function XMLtoSWFInterpreter()
		{
			_propertyFactory = new PropertyFactory();
		}
		
		public function getPopups(swf:MovieClip, xml:XML):void
		{
			var popups:Vector.<XMLtoPopup> = new Vector.<XMLtoPopup>();
			for each (var popupXML:XML in xml.popup) 
			{
				var path:String = popupXML.@path;
				if (path)
				{
					if (swf.loaderInfo.applicationDomain.hasDefinition(path))
					{
						var mcClass:Class = swf.loaderInfo.applicationDomain.getDefinition( path ) as Class;
						var mc:MovieClip = new mcClass() as MovieClip;
						var properties:Vector.<Property> = _propertyFactory.getProperties(mc, popupXML.property);
						var name:String = popupXML.@name ? popupXML.@name : path;
						var popup:XMLtoPopup = new XMLtoPopup(name, properties);
						popups.push(popup);
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
		
		private function error(message:String):void
		{
			
		}
	}
}