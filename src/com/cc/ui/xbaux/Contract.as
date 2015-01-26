package com.cc.ui.xbaux
{
	public class Contract
	{
		private var _xml:XML;
		public var swfPath:String;
		public var symbols:Vector.<XMLtoPopupSymbol>;
		public var name:String;
		
		public function getSymbolByName(name:String):XMLtoPopupSymbol
		{
			for each (var symbol:XMLtoPopupSymbol in symbols) 
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
class XMLtoPopupSymbol
{
	public var path:String;
	
	public function XMLtoPopupSymbol(xml:XML)
	{
	}
}