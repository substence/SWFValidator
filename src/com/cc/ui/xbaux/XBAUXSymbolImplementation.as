package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.messages.SymbolLoaded;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	import com.cc.ui.xbaux.model.XBAUXSymbol;
	import com.cc.ui.xbaux.model.properties.Property;
	import com.cc.ui.xbaux.model.properties.PropertyTextfield;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class XBAUXSymbolImplementation extends Sprite
	{
		private var _symbol:XBAUXSymbol;
		private var _symbolName:String;
		
		public function XBAUXSymbolImplementation(contractName:String, symbolName:String)
		{
			_symbolName = symbolName;
			
			//listen for the desired symbol we're about to load
			Message.messenger.add(SymbolLoaded, loadedSymbol);
			
			//request the desired symbol
			Message.messenger.dispatch(new SymbolRequest(contractName, symbolName));
		}
		
		private function loadedSymbol(message:SymbolLoaded):void
		{
			if (message.symbol.path == _symbolName)
			{
				_symbol = message.symbol;
				addChild(_symbol.displayObject);
				Message.messenger.remove(SymbolLoaded, loadedSymbol);
				onLoadedContract();
			}
		}
		
		protected function onLoadedContract():void
		{
			
		}
		
		protected function getTextfield(name:String):TextField
		{
			return (getProperty(name) as PropertyTextfield).textField;
		}
		
		protected function getProperty(name:String):Property
		{
			for each (var property:Property in _symbol.properties) 
			{
				if (property.name == name)
				{
					return property;
				}
			}
			return null;
		}
	}
}