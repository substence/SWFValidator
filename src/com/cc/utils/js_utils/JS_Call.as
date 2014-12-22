package com.cc.utils.js_utils
{
	import flash.events.EventDispatcher;
	
	internal class JS_Call extends EventDispatcher
	{
		private var _JsFuncName:String;		// Name of the JS function
		private var _JsFuncArgs:Object;		// Contains key value pairs
		
		private var _CallbackName:String;	// Callback name exposed to JS
		private var _Callback:Function;		// Callback function to be executed on response
		
		private var _TimeoutThreshold:int;	// Number of milliseconds to wait for a response before timing out
		private var _OnTimeout:Function;	// Function to be executed on timeout
		
		private var _IsActive:Boolean;		// Active flag that prevents timed out calls to not update/invoke their callback
		private var _ElapsedTime:int;		// Time elapsed since the call to JS was executed
		
		
		public function JS_Call(jsFuncName:String, jsFuncArgs:Object, callbackName:String, callback:Function, timeoutThreshold:int = 0, onTimeout:Function = null)
		{
			_JsFuncName = (jsFuncName) ? jsFuncName : "";
			_JsFuncArgs = jsFuncArgs;
			
			_CallbackName = (callbackName) ? callbackName : "";
			_Callback = callback;
			
			_TimeoutThreshold = timeoutThreshold;
			_OnTimeout = onTimeout;
			
			_IsActive = true;
			_ElapsedTime = 0;
		}
		
		// Updates the the JS_Call with the elapsed time since the previous update.
		// If the call times out before it gets a response it:
		// - Sets itself as inactive
		// - Trys to invoke its onTimeout handler
		// - Dispatches a "TIMEOUT" JS_Call_Event
		public function Update(elapsedTime:int) : void
		{
			if (_IsActive)
			{
				if (_TimeoutThreshold != 0)
				{
					_ElapsedTime += elapsedTime;
					
					// Reached timeout threshold?
					if (_ElapsedTime >= _TimeoutThreshold)
					{
						_IsActive = false;
						
						if (_OnTimeout != null)
						{
							_OnTimeout();
						}
						
						// Dispatch a timeout event
						var event:JS_Call_Event = new JS_Call_Event(JS_Call_Event.TIMEOUT, this);
						dispatchEvent(event);
					}
				}
			}
		}
		
		// This is the actual function that get's exposed to JS. It has the ability to be passed a variable amount of
		// args to pass onto the supplied callback.
		// When this is invoked by JS it:
		// - Sets itself as inactive
		// - Trys to invoke its callback with the supplied args
		// - Dispatches a "RESPONSE" JS_Call_Event
		public function OnResponse(...args) : void
		{
			if (_IsActive)
			{
				_IsActive = false;
				
				// Try to invoke the callback with the args from JS
				if (_Callback != null)
				{
					if (args)
					{
						_Callback(args as Array);
					}
					else
					{
						_Callback();
					}
				}
				
				// Dispatch a response event
				var event:JS_Call_Event = new JS_Call_Event(JS_Call_Event.RESPONSE, this);
				dispatchEvent(event);
			}
		}
		
		public function get JsFuncName() : String
		{
			return _JsFuncName
		}
		
		public function get CallbackName() : String
		{
			return _CallbackName;
		}
	}
}