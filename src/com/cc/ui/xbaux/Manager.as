package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.ui.xbaux.messages.ContractLoaded;
	import com.cc.ui.xbaux.messages.SymbolLoaded;
	import com.cc.ui.xbaux.messages.SymbolRequest;
	
	import flash.utils.Dictionary;

	public class Manager
	{
		private var _contracts:Dictionary;
		
		public function Manager()
		{
			_contracts = new Dictionary();
			Message.messenger.add(SymbolRequest, onSymbolRequested);
		}
		
		private function onSymbolRequested(request:SymbolRequest):void
		{
			var contract:Contract = _contracts[request.contractName];
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
				var interpreter:Interpreter = new Interpreter(request.contractName);
				interpreter.signalInterpretationComplete.addOnce(intetpretedXML);
				interpreter.startInterpretation();
			}
		}
		
		private function intetpretedXML(interpreter:Interpreter):void
		{
			var contract:Contract = interpreter.contract;
			_contracts[interpreter.name] = contract;
			Message.messenger.dispatch(new ContractLoaded(contract));
			for each (var symbol:XBAUXSymbol in contract.symbols) 
			{
				Message.messenger.dispatch(new SymbolLoaded(symbol));
			}
		}
	}
}