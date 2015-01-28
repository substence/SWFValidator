package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.messages.ContractLoaded;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.LogRequest;
	import com.cc.ui.xbaux.messages.SymbolLoaded;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	
	import flash.utils.Dictionary;
	import com.cc.ui.xbaux.model.XBAUXContract;
	import com.cc.ui.xbaux.model.XBAUXSymbol;

	//Listens for requests and dispatches that information when interpretation is complete.
	public class XBAUXManager
	{
		private var _contracts:Dictionary;
		
		public function XBAUXManager()
		{
			new XBAUXLogger();
			
			_contracts = new Dictionary();
			Message.messenger.add(SymbolRequest, onSymbolRequested);
			Message.messenger.add(XBAUXContract, onContractRequest);
		}
		
		private function onContractRequest(request:ContractRequest):void
		{
			var contract:XBAUXContract = _contracts[request.contractName];
			if (contract)
			{
				Message.messenger.dispatch(new ContractLoaded(contract));
			}
			else
			{
				loadContract(request.contractName);
			}
		}
		
		private function onSymbolRequested(request:SymbolRequest):void
		{
			var contract:XBAUXContract = _contracts[request.contractName];
			if (contract)
			{
				var symbol:XBAUXSymbol = contract.getSymbolByName(request.symbolName);
				if (symbol)
				{
					Message.messenger.dispatch(new SymbolLoaded(symbol));
				}
			}
			else
			{
				loadContract(request.contractName);
			}
		}
		
		private function loadContract(contractName:String):void
		{
			var interpreter:XBAUXInterpreter = new XBAUXInterpreter(contractName);
			interpreter.signalInterpretationComplete.addOnce(onInterpretationComplete);
			interpreter.startInterpretation();
		}
		
		private function onInterpretationComplete(interpreter:XBAUXInterpreter):void
		{
			var contract:XBAUXContract = interpreter.contract;
			_contracts[interpreter.name] = contract;
			
			Message.messenger.dispatch(new ContractLoaded(contract));
			for each (var symbol:XBAUXSymbol in contract.symbols) 
			{
				Message.messenger.dispatch(new SymbolLoaded(symbol));
			}
		}
	}
}