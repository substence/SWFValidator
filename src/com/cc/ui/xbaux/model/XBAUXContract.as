package com.cc.ui.xbaux.model
{
	public class XBAUXContract
	{
		public var path:String;
		public var symbols:Vector.<XBAUXSymbol>;
		public var name:String;
		
		public function getSymbolByName(name:String):XBAUXSymbol
		{
			for each (var symbol:XBAUXSymbol in symbols) 
			{
				if (symbol.path == name)
				{
					return symbol;
				}
			}
			return null;
		}
	}
}