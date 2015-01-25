package com.cc.ui.xbaux
{
	import com.cc.ui.xbaux.properties.Property;
	import com.cc.ui.xbaux.properties.PropertyFactory;
	
	import flash.display.MovieClip;

	internal class Interpreter
	{
		private var _contract:Contract;
		private var _xml:XML;
		private var _name:String;
		private var _loader:XBAUXLoader;
		private var _signalInterpretationComplete:Signal;
		private static var _propertyFactory:PropertyFactory;
		
		public function Interpreter(name:String)
		{
			_name = name;
			_loader = new XBAUXLoader(name);
			_loader.signalLoaded.addOnce(loadedXML);
			_propertyFactory = new PropertyFactory();
			_signalInterpretationComplete = new Signal();
		}
		
		public function get name():String
		{
			return _name;
		}

		public function startInterpretation():void
		{
			_loader.loadXML();
		}
		
		public function get signalInterpretationComplete():Signal
		{
			return _signalInterpretationComplete;
		}

		private function loadedXML(loaded:String):void
		{
			if (_loader.xml)
			{
				_xml = _loader.xml;
				interpretSWF();
			}
		}
		
		private function interpretSWF():void
		{
			_contract = new Contract();
			_contract.swfPath = _xml.@path;
			if (_contract.swfPath)
			{
				_loader.loadSWF(_contract.swfPath);
				_loader.signalLoaded.addOnce(loadedSWF);
			}
			else
			{
				error("no swf path");
			}
		}
		
		private function loadedSWF():void
		{
			if (_loader.swf)
			{
				_contract.symbols = interpretSymbols(_xml.symbol);
				_signalInterpretationComplete.dispatch();
			}
		}
		
		private function interpretSymbols(symbols:XMLList):Vector.<XBAUXSymbol> 
		{
			var symbols:Vector.<XBAUXSymbol> = new Vector.<XBAUXSymbol>();
			for each (var symbolXML:XML in symbols) 
			{
				var symbol:XBAUXSymbol = new XBAUXSymbol(symbolXML);
				symbol.path = symbolXML.@path;
				if (symbol.path)
				{
					if (_loader.swf.loaderInfo.applicationDomain.hasDefinition(symbol.path))
					{
						var mcClass:Class = _loader.swf.loaderInfo.applicationDomain.getDefinition(symbol.path) as Class;
						var mc:MovieClip = new mcClass() as MovieClip;
						symbol.properties = interpretProperties(symbolXML.property, mc);
						symbols.push(symbol);
					}
					else
					{
						error("Symbol could not find in the library");
					}
				}
				else
				{
					error("Symobl has no path.");
					return;
				}
			}
			return symbols;
		}
		
		private function interpretProperties(properties:XMLList, movieClip:MovieClip):Vector.<Property> 
		{
			var properties:Vector.<Property> = new Vector.<Property>();
			for each (var propertyXML:XML in properties.property) 
			{
				var typeString:String = propertyXML.@type;
				var type:Class = _propertyFactory.getTypeFromTypeString(typeString);
				if (type)
				{
					//todo: im assuming this is of type Property
					var property:Property = new type() as Property;
					var error:Error = property.validate(movieClip, propertyXML);
					if (error)
					{
						error(error.message);
					}
					properties.push(property);
				}
				else
				{
					error("Unknown property type '" + typeString + "'");
				}
			}
			return properties;
		}
		
		private function error(message:String):void
		{
			
		}
		
		public function get contract():Contract
		{
			return _contract;
		}
	}
}