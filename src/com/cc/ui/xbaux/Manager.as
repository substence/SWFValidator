package com.cc.ui.xbaux
{
	import com.cc.messenger.Message;
	import com.cc.messenger.Messenger;
	import com.cc.ui.xbaux.messages.ContractRequest;
	import com.cc.ui.xbaux.properties.Property;
	
	import flash.utils.Dictionary;

	public class Manager
	{
		private var _contracts:Dictionary;
		private var _loader:XBAUXLoader;
		private var _requests:Dictionary;
		
		public function Manager()
		{
			_requests = new Dictionary();
			_contracts = new Dictionary();
			Message.messenger.add(ContractRequest, onDataRequested);
		}
		
		private function onDataRequested(request:ContractRequest):void
		{
			var name:String = request.callbackName;
			if (_contracts[name])
			{
				request.callback(_contracts[name]);
			}
			else
			{
				if (!_requests[name])
				{
					var interpreter:Interpreter = new Interpreter(request.callbackName);
					interpreter.signalInterpretationComplete.addOnce(intetpretedXML);
					_requests[name] = request;
					interpreter.startInterpretation();
				}
			}
		}
		
		private function intetpretedXML(interpreter:Interpreter):void
		{
			_contracts[interpreter.name] = interpreter.contract;
			var request:ContractRequest = _requests[interpreter.name];
			if (request)
			{
				request.callback(interpreter.contract);
			}
			delete _requests[interpreter.name];
		}
	}
}