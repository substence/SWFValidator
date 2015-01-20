package com.cc.ui
{
	class Interpreter
	{
		private var _contract:Contract;
		private var _xml:XML;
		private var _name:String;
		private var _loader:XMLtoPopupLoader;
		
		public function Interpreter(name:String)
		{
			_name = name;
			_loader = new XMLtoPopupLoader(name);
			_loader.signalLoaded.addOnce(loadedXML);
		}
		
		private function loadedXML(loaded:String):void
		{
			if (_loader.xml)
			{
				_xml = _loader.xml;
				//parse the xml to get the SWF then load the swf
			}
		}
		
		public function get contract():Contract
		{
			return _contract;
		}
		
		public function interpret()
		{
			_contract = new Contract();
			_contract.swfPath = _xml.@path;
			if (_contract.swfPath)
			{
				_contract.symbols = new Vector.<XMLtoPopupSymbol>();
				for each (var symbolXML:XML in _xml.symbol) 
				{
					var symbol:XMLtoPopupSymbol = new XMLtoPopupSymbol(symbolXML);
					symbol.path = symbolXML.@path;
					if (symbol.path )
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
			else
			{
				error("no swf path");
			}
		}
	}
}