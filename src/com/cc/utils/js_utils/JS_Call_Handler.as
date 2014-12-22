package com.cc.utils.js_utils
{
	import com.adverserealms.log.Logger;
	import com.cc.utils.HaltErrorCodes;
	
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.getTimer;

	public class JS_Call_Handler
	{
		// Holds all the JS_Call objects that are currently pending a response from JS
		private var _PendingCalls:Vector.<JS_Call>;
		
		// Counter used for UUID function name creation
		private var _NameCounter:int;
		
		
		public function JS_Call_Handler()
		{
			_PendingCalls = new Vector.<JS_Call>();
			
			_NameCounter = 0;
		}
		
		// Should be called per frame with the elapsed time between frames
		public function TickFast(elapsedTime:int) : void
		{
			// Update the pending JS Calls
			for (var i:int = _PendingCalls.length - 1; i > -1; --i)
			{
				var jsCall:JS_Call = _PendingCalls[i];
				if (jsCall)
				{
					jsCall.Update(elapsedTime);
				}
			}
		}
		
		// Standard call to a JS function with the passed in JS Function name with optional args.
		public function Call(jsFuncName:String, jsFuncArgs:Array = null, exitFullscreen:Boolean = true) : void
		{
			// Error checking
			if (jsFuncName == null || jsFuncName == "")
			{
				Logger.error("ERROR: JS_Call_Handler::Call : Failed to execute call. jsFuncName is null or invalid.");
				return;
			}
			
			
			if (GLOBAL.LOCAL)
			{
				var msgDebug:String = "JS_Call_Handler::Call invoked with data: {";
				msgDebug += '"jsFuncName":"' + jsFuncName + '", ';
				if (jsFuncArgs)
				{
					msgDebug += '"jsFuncArgs":[' + WCJSON.encode(jsFuncArgs) + "], ";
				}
				else
				{
					msgDebug += '"jsFuncArgs":null, ';
				}
				msgDebug += '"exitFullscreen":' + exitFullscreen + "}";
				//Logger.debug(msgDebug);
			}
			else
			{
				InvokeCall(jsFuncName, jsFuncArgs, exitFullscreen);
			}
		}
		
		// Calls a JS function that provides JS with a temporarily exposed callback. There is the option
		// to provide a timeout threshold and timeout handler.
		// * jsFuncArgs is be an Object with key value pairs
		// * timeoutThreshold is in Milliseconds
		// * callback method must match signature:		function (args:Array = null) : void
		// * onTimeout handler must match signature:	function () : void
		public function Call_WithCallback(jsFuncName:String, jsFuncArgs:Object, callback:Function,
										  exitFullscreen:Boolean = true, timeoutThreshold:int = 0, onTimeout:Function = null) : void
		{
			// Clamp timeoutThreshold to 0
			timeoutThreshold = (timeoutThreshold < 0) ? 0 : timeoutThreshold;
			
			
			// Error checking
			var hasInvalidParams:Boolean = false;
			var msgError:String = "";
			if (jsFuncName == null || jsFuncName == "")
			{
				msgError += ' "jsFuncName" is null or empty.';
				hasInvalidParams = true;
			}
			
			if (callback == null)
			{
				msgError += ' "callback" is null.';
				hasInvalidParams = true;
			}
			
			if (hasInvalidParams)
			{
				Logger.error("ERROR: JS_Call_Handler::Call_WithCallback : Failed to call." + msgError);
				return;
			}
			
			
			// Check if theres no onTimeout handler with a timeoutThreshold
			if (timeoutThreshold > 0 && onTimeout == null)
			{
				Logger.warn("WARNING: JS_Call_Handler::Call_WithCallback : timeoutThreshold is provided without an onTimeout handler");
			}
			
			
			if (GLOBAL.LOCAL)
			{
				var msgDebug:String = "JS_Call_Handler::Call_WithCallback invoked with data: {";
				msgDebug += '"jsFuncName":"' + jsFuncName + '", ';
				if (jsFuncArgs)
				{
					msgDebug += '"jsFuncArgs":' + WCJSON.encode(jsFuncArgs) + ", ";
				}
				else
				{
					msgDebug += '"jsFuncArgs":null, ';
				}
				msgDebug += '"callback":' + callback + ", ";
				msgDebug += '"exitFullscreen":' + exitFullscreen + ", ";
				msgDebug += '"timeoutThreshold":' + timeoutThreshold + ", ";
				msgDebug += '"onTimeout":' + onTimeout + "}";
				Logger.debug(msgDebug);
			}
			else
			{
				InvokeCall_WithCallback(jsFuncName, jsFuncArgs, callback, exitFullscreen, timeoutThreshold, onTimeout);
			}
		}
		
		private function InvokeCall(jsFuncName:String, jsFuncArgs:Array = null, exitFullscreen:Boolean = true) : void
		{
			/*if (exitFullscreen)
			{
				GLOBAL.SetFullscreen(false);
			}*/
			
			try
			{
				if (jsFuncArgs)
				{
					ExternalInterface.call("callFunc", jsFuncName, jsFuncArgs);
				}
				else
				{
					ExternalInterface.call("callFunc", jsFuncName);
				}
			}
			catch (error:Error)
			{
				var msgError:String = "JS_Call_Handler::InvokeCall : Failed to execute: ";
				msgError += "[" + jsFuncName + "] with args: ";
				if (jsFuncArgs)
				{
					msgError += "[" + WCJSON.encode(jsFuncArgs) + "]";
				}
				else
				{
					msgError += "null";
				}
				msgError += ". " + error.toString();
				
				// Log error and oops
				Logger.error("ERROR: " + msgError);
				GLOBAL.showErrorMessage(HaltErrorCodes.JS_CALL_FAILED, "JS_Call_Handler::InvokeCall - " + msgError);
			}
		}
		
		private function InvokeCall_WithCallback(jsFuncName:String, jsFuncArgs:Object, callback:Function,
												 exitFullscreen:Boolean = true, timeoutThreshold:int = 0, onTimeout:Function = null) : void
		{
			// Create a UUID function name to expose to JS
			var callbackName:String = GenerateFuncName();
			var jsCall:JS_Call = new JS_Call(jsFuncName, jsFuncArgs, callbackName, callback, timeoutThreshold, onTimeout);
			
			
			var wasAddSuccessful:Boolean = AddPendingCall(jsCall);
			if (wasAddSuccessful)
			{
				/*if (exitFullscreen)
				{
					GLOBAL.SetFullscreen(false);
				}*/
				
				try
				{
					ExternalInterface.call("cc.clientCallWithCallback", callbackName, jsCall.JsFuncName, jsFuncArgs);
				}
				catch (error:Error)
				{
					var msgError:String = "JS_Call_Handler::InvokeCall_WithCallback : Failed to execute: ";
					msgError += "[" + jsFuncName + "] with args: ";
					if (jsFuncArgs)
					{
						msgError += WCJSON.encode(jsFuncArgs);
					}
					else
					{
						msgError += "null";
					}
					msgError += ". " + error.toString();
					
					// Log error and oops
					Logger.error("ERROR: " + msgError);
					GLOBAL.showErrorMessage(HaltErrorCodes.JS_CALL_WITH_CALLBACK_FAILED, "JS_Call_Handler::InvokeCall_WithCallback - " + msgError);
				}
			}
		}
		
		// Adds a pending JS_Call object, temporarily exposing its callback, and listens for its events.
		// Returns if the call was able to be added.
		private function AddPendingCall(jsCall:JS_Call) : Boolean
		{
			if (jsCall == null)
			{
				Logger.error("ERROR JS_Call_Handler::AddPendingCall : Failed to add. 'jsCall' is null.");
				return false;
			}
			
			
			try
			{
				// Try to expose the JS_Call's function to JS
				ExternalInterface.addCallback(jsCall.CallbackName, jsCall.OnResponse);
			} 
			catch(error:Error) 
			{
				var msgError:String = "Failed to expose func: ";
				msgError += "[" + jsCall.CallbackName + "]";
				msgError += ". " + error.toString();
				FrameworkLogger.Log(FrameworkLogger.KEY_ERROR, "JS_Call_Handler::AddPendingCall - " + msgError); 
				
				msgError = "ERROR: JS_Call_Handler::AddPendingCall : Pending call not added. " + msgError;
				Logger.error(msgError);
				GLOBAL.showErrorMessage(HaltErrorCodes.JS_ADD_CALLBACK_EXPOSURE_FAILED, "JS_Call_Handler::AddPendingCall - " + msgError);
				
				return false;
			}
			
			
			_PendingCalls.push(jsCall);
			jsCall.addEventListener(JS_Call_Event.RESPONSE, OnResponse);
			jsCall.addEventListener(JS_Call_Event.TIMEOUT, OnTimeout);
			
			return true;
		}
		
		// Attempts to remove a pending JS_Call object, unexpose it's callback, and stop listening for its events.
		private function RemovePendingCall(jsCall:JS_Call) : void
		{
			if (jsCall == null)
			{
				Logger.error("ERROR: JS_Call_Handler::RemovePendingCall : Failed to remove. 'jsCall' is null");
				return;
			}
			
			
			try
			{
				// Try to unexpose the function
				ExternalInterface.addCallback(jsCall.CallbackName, null);
			}
			catch (error:Error)
			{
				var msgError:String = "ERROR: JS_Call_Handler::RemovePendingCall : Could not remove pending call: ";
				msgError += "[" + jsCall.JsFuncName + "]";
				msgError += ". ExternalInterface is not available.";
				Logger.error(msgError);
			}
			
			
			// Try to remove it from the pending list
			var lastIndex:int = _PendingCalls.length - 1;
			for (var i:int = lastIndex; i > -1; --i)
			{
				var currentCall:JS_Call = _PendingCalls[i];
				if (currentCall == jsCall)
				{
					_PendingCalls[i] = _PendingCalls[lastIndex];
					_PendingCalls.length = lastIndex;
					break;
				}
			}
			
			
			// Clean up the event handlers
			jsCall.removeEventListener(JS_Call_Event.RESPONSE, OnResponse);
			jsCall.removeEventListener(JS_Call_Event.TIMEOUT, OnTimeout);
		}
		
		// Removes the JS_Call object when it gets a response from JS.
		private function OnResponse(event:Event = null) : void
		{
			var jsCallEvent:JS_Call_Event = event as JS_Call_Event;
			if (jsCallEvent)
			{
				RemovePendingCall(jsCallEvent.JsCall);
			}
		}
		
		// Removes the JS_Call object when it times out.
		private function OnTimeout(event:Event = null) : void
		{
			var jsCallEvent:JS_Call_Event = event as JS_Call_Event;
			if (jsCallEvent)
			{
				RemovePendingCall(jsCallEvent.JsCall);
			}
		}
		
		// Generates a UUID String to be used for the name for a response callback to be exposed to JS.
		private function GenerateFuncName() : String
		{
			var uuid:String = _NameCounter.toString(16) + new Date().getTime().toString(16) + getTimer().toString(16);
			
			++_NameCounter;
			if (_NameCounter > 999)
			{
				_NameCounter = 0;
			}
			
			return uuid;
		}
	}
}