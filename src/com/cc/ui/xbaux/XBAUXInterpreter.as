package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.messages.LogRequest;
	import com.cc.ui.xbaux.model.properties.Property;
	
	import flash.display.MovieClip;
	
	import org.osflash.signals.Signal;
	import com.cc.ui.xbaux.model.XBAUXContract;
	import com.cc.ui.xbaux.model.XBAUXSymbol;

	internal class XBAUXInterpreter
	{
		private static const _ATTRIBUTE_PATH:String = "path";
		private static const _ATTRIBUTE_PROPERTY_TYPE:String = "type";
		private static const _ATTRIBUTE_NAME:String = "name";
		private static const _NODE_SYMBOL:String = "symbol";
		private static const _NODE_PROPERTY:String = "property";
		private static var _propertyFactory:XBAUXPropertyFactory;
		private var _contract:XBAUXContract;
		private var _xml:XML;
		private var _name:String;
		private var _loader:XBAUXLoader;
		private var _signalInterpretationComplete:Signal;
		
		public function XBAUXInterpreter(name:String)
		{
			_name = name;
			_loader = new XBAUXLoader(name);
			_loader.signalLoaded.addOnce(loadedXML);
			_propertyFactory = new XBAUXPropertyFactory();
			_signalInterpretationComplete = new Signal();
		}
		
		public function startInterpretation():void
		{
			_loader.loadXML();
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
			_contract = new XBAUXContract();
			_contract.path = _xml.attribute(_ATTRIBUTE_PATH);
			_contract.name = _xml.attribute(_ATTRIBUTE_NAME).length == 0 ? _xml.attribute(_ATTRIBUTE_NAME) : _contract.path;
			if (_contract.path)
			{
				_loader.signalLoaded.addOnce(loadedSWF);
				_loader.loadSWF(_contract.path);
			}
			else
			{
				throwError("Contract '" + _name + "' doesn't contain a swf path.");
			}
			
		}
		
		private function loadedSWF(loaded:String):void
		{
			if (_loader.swf)
			{
				_contract.symbols = interpretSymbols(_xml.child(_NODE_SYMBOL));
				Message.messenger.dispatch(new LogRequest("Interpretation Finished", XBAUXLogger.DEBUG));
				_signalInterpretationComplete.dispatch(this);
			}
		}
		
		private function interpretSymbols(symbolsList:XMLList):Vector.<XBAUXSymbol> 
		{
			var symbols:Vector.<XBAUXSymbol> = new Vector.<XBAUXSymbol>();
			for each (var symbolXML:XML in symbolsList) 
			{
				var symbol:XBAUXSymbol = new XBAUXSymbol();
				symbol.path = symbolXML.attribute(_ATTRIBUTE_PATH);
				symbol.name = symbolXML.attribute(_ATTRIBUTE_NAME).length == 0 ? symbolXML.attribute(_ATTRIBUTE_NAME) : symbol.path;
				if (symbol.path)
				{
					if (_loader.swf.loaderInfo.applicationDomain.hasDefinition(symbol.path))
					{
						var mcClass:Class = _loader.swf.loaderInfo.applicationDomain.getDefinition(symbol.path) as Class;
						var mc:MovieClip = new mcClass() as MovieClip;
						symbol.displayObject = mc;
						symbol.properties = interpretProperties(symbolXML.child(_NODE_PROPERTY), mc);
						symbols.push(symbol);
					}
					else
					{
						throwError("Symbol could not find in the library");
					}
				}
				else
				{
					throwError("Symbol has no path.");
					return null;
				}
			}
			return symbols;
		}
		
		private function interpretProperties(propertiesList:XMLList, movieClip:MovieClip):Vector.<Property> 
		{
			var properties:Vector.<Property> = new Vector.<Property>();
			for each (var propertyXML:XML in propertiesList) 
			{
				var typeString:String = propertyXML.attribute(_ATTRIBUTE_PROPERTY_TYPE);
				var type:Class = _propertyFactory.getTypeFromTypeString(typeString);
				if (type)
				{
					var property:Property = new type() as Property;
					var error:Error = property.validate(movieClip, propertyXML);
					
					if (error)
					{
						throwError(error.message);
					}
					else
					{
						property.implement();	//we may not want to implement in non-warlords builds
						properties.push(property);
					}						
				}
				else
				{
					throwError("Unknown property type '" + typeString + "'");
				}
			}
			return properties;
		}
		
		private function throwError(message:String):void
		{
			Message.messenger.dispatch(new LogRequest("Interpreter error - " + message, XBAUXLogger.ERROR));
		}
		
		public function get contract():XBAUXContract
		{
			return _contract;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get signalInterpretationComplete():Signal
		{
			return _signalInterpretationComplete;
		}
	}
}