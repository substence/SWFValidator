package com.cc.ui.xbaux.messages
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.Contract;

	public class ContractLoaded extends Message
	{
		private var _contract:Contract;
		
		public function ContractLoaded(contract:Contract)
		{
			_contract = contract;
		}

		public function get contract():Contract
		{
			return _contract;
		}
	}
}