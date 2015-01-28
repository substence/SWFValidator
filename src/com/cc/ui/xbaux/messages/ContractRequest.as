package com.cc.ui.xbaux.messages
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.model.XBAUXSymbol;
	
	public class ContractRequest extends Message
	{
		private var _contractName:String;
		
		public function ContractRequest(contractName:String)
		{
			_contractName = contractName;
		}
		
		public function get contractName():String
		{
			return _contractName;
		}
	}
}