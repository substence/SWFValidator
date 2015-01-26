package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.messages.ContractLoaded;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.SymbolLoaded;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	import com.cc.ui.xbaux.properties.Property;
	import com.cc.ui.xbaux.properties.PropertyTextfield;
	
	import flash.text.TextField;

	public class XMLtoPopup
	{
		//lets make this a dictionary for easy lookup
		private var _properties:Vector.<Property>;
		//private var _contract:Contract;
		private var _symbol:XBAUXSymbol;
		private var _symbolName:String;
		
		public function XMLtoPopup(contractName:String, symbolName:String)
		{
			_symbolName = symbolName;
			
			//listen for the desired symbol to be loaded
			Message.messenger.add(SymbolLoaded, loadedSymbol);
			
			//request the desired symbol
			Message.messenger.dispatch(new SymbolRequest(contractName, symbolName));
		}
		
		private function loadedSymbol(message:SymbolLoaded):void
		{
			if (message.symbol.path == _symbolName)
			{
				_symbol = message.symbol;
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
			for each (var property:Property in _properties) 
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