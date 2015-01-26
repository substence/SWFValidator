package com.cc.ui.xbaux.messages
{
	public class SymbolRequest extends ContractRequest
	{
		private var _symbolName:String;
		
		public function SymbolRequest(contractName:String, symbolName:String)
		{
			super(contractName)
			_symbolName = symbolName;
		}

		public function get symbolName():String
		{
			return _symbolName;
		}
	}
}