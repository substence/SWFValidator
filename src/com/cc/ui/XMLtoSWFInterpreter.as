package com.cc.ui
{
	import com.cc.ui.properties.Property;
	import com.cc.ui.properties.PropertyFactory;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;

	public class XMLtoSWFInterpreter extends Sprite
	{
		private var _propertyFactory:PropertyFactory;
		
		public function XMLtoSWFInterpreter()
		{
			_propertyFactory = new PropertyFactory();
			_propertyFactory.addEventListener(ErrorEvent.ERROR, caughtPropertyError);
		}
		
		protected function caughtPropertyError(event:ErrorEvent):void
		{
			error(event.text);
		}
		
		public function getPopups(swf:MovieClip, xml:XML):void
		{
			var popups:Vector.<XMLtoPopup> = new Vector.<XMLtoPopup>();
			for each (var popupXML:XML in xml.popup) 
			{
				const path:String = popupXML.@path;
				if (path)
				{
					if (swf.loaderInfo.applicationDomain.hasDefinition(path))
					{
						var mcClass:Class = swf.loaderInfo.applicationDomain.getDefinition( path ) as Class;
						var mc:MovieClip = new mcClass() as MovieClip;
						var properties:Vector.<Property> = _propertyFactory.getProperties(mc, popupXML.property);
						var name:String = popupXML.@name ? popupXML.@name : path;
						var popup:XMLtoPopup = new XMLtoPopup(name);
						popups.push(popup);
					}
					else
					{
						error("Popup(" + popupXML.@name + ") could not find '" + path + "' in the library");
					}
				}
				else
				{
					error("Popup(" + popupXML.@name + ") has no path.");
					return;
				}
			}			
		}
		
		private function error(message:String):void
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false, false, message));
		}
	}
}