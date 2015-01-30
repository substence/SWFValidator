package com.cc.ui.xbaux.messages
{
	public class SymbolRequest extends ContractRequest
	{
		private var _symbolName:String;
		
		public function SymbolRequest(symbolName:String, contractName:String = "")
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