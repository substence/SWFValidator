package com.cc.ui.xbaux.messages
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.model.XBAUXContract;

	public class ContractLoaded extends Message
	{
		private var _contract:XBAUXContract;
		
		public function ContractLoaded(contract:XBAUXContract)
		{
			_contract = contract;
		}

		public function get contract():XBAUXContract
		{
			return _contract;
		}
	}
}