package com.cc.ui.xbaux
{
	public class Contract
	{
		private var _xml:XML;
		public var swfPath:String;
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