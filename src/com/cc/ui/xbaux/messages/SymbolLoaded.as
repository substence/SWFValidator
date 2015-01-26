package com.cc.ui.xbaux.messages
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.XBAUXSymbol;

	public class SymbolLoaded extends Message
	{
		private var _symbol:XBAUXSymbol;
		
		public function SymbolLoaded(symbol:XBAUXSymbol)
		{
			_symbol = symbol;
		}

		public function get symbol():XBAUXSymbol
		{
			return _symbol;
		}
	}
}