package com.cc.ui
{
	import com.cc.messenger.Message;
	import com.cc.messenger.Messenger;
	import com.cc.ui.messages.XMLPopupRequest;
	import com.cc.ui.properties.Property;
	
	import flash.utils.Dictionary;

	public class XMLPopupManager
	{
		private var _popupData:Dictionary;

		private var _loader:XMLtoPopupLoader;
		
		public function XMLPopupManager()
		{
			_popupData = new Dictionary();
			Message.messenger.add(XMLPopupRequest, onDataRequested);
		}
		
		private function onDataRequested(message:XMLPopupRequest):void
		{
			var interpreter:Interpreter = new Interpreter(message.name);
			
		}
		
		private function getDataForPopup(popupName:String):Vector.<Property>
		{
			return _popupData[popupName]; 
		}
	}
}
class Contract
{
	private var _xml:XML;
	public var swfPath:String;
	public var symbols:Vector.<XMLtoPopupSymbol>;
	
	public function Contract(xml:XML)
	{
		swfPath = xml.@path;
		for each (var symbolXML:XML in xml.symbol) 
		{
			var symbol:XMLtoPopupSymbol = new XMLtoPopupSymbol(symbolXML);
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

	public function get swfPath():String
	{
		return _swfPath;
	}
}

class XMLtoPopupSymbol
{
	public path:String;
	
	public function XMLtoPopupSymbol(xml:XML)
	{
	}
}