package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.messages.ContractLoaded;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.messages.LogRequest;
	import com.cc.ui.xbaux.messages.SymbolLoaded;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	import com.cc.ui.xbaux.model.XBAUXContract;
	import com.cc.ui.xbaux.model.XBAUXSymbol;
	
	import flash.utils.Dictionary;

	//Listens for requests and dispatches that information when interpretation is complete.
	public class XBAUXManager
	{
		//todo clean this up?
		private var _contracts:Dictionary;
		public namespace desktop;
		
		public function XBAUXManager()
		{
			new XBAUXLogger();
			
			_contracts = new Dictionary();
			Message.messenger.add(SymbolRequest, onSymbolRequested);
			Message.messenger.add(ContractRequest, onContractRequest);
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
			var symbol:XBAUXSymbol;
			if (!request.contractName)
			{
				symbol = getSymbolFromCache(request.symbolName);
				if (!symbol)
				{
					Message.messenger.dispatch(new LogRequest("XBAUXManager - Couldn't load symbol '" + request.symbolName + "' from cache and no contract name was specified.", XBAUXLogger.ERROR));
				}
			}
			else
			{
				var contract:XBAUXContract = _contracts[request.contractName];
				if (contract)
				{
					symbol = contract.getSymbolByName(request.symbolName);
					if (!symbol)
					{
						Message.messenger.dispatch(new LogRequest("XBAUXManager - Couldn't load symbol '" + request.symbolName + "' from contract '" + request.contractName + "'.", XBAUXLogger.ERROR));
					}
				}
				else
				{
					loadContract(request.contractName);
				}
			}
			if (symbol)
			{
				Message.messenger.dispatch(new SymbolLoaded(symbol));
			}
		}
		
		private function getSymbolFromCache(symbolName:String):XBAUXSymbol
		{
			for each (var contract:XBAUXContract in _contracts) 
			{
				for each (var symbol:XBAUXSymbol in contract.symbols) 
				{
					if (symbol.name == symbolName)
					{
						return symbol;
					}
				}
			}
			return null;
		}
		
		private function loadContract(contractName:String):void
		{
			//todo does this guy get cleaned up on it's own?
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