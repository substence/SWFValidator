package com.cc.utils.js_utils
{
	import flash.events.Event;
	
	internal class JS_Call_Event extends Event
	{
		public static const TIMEOUT:String = "js_call_timeout";
		public static const RESPONSE:String = "js_call_response";
		
		
		private var _JsCall:JS_Call;
		
		
		public function JS_Call_Event(_type:String, jsCall:JS_Call)
		{
			super(_type);
			
			_JsCall = jsCall;
		}
		
		override public function clone() : Event
		{
			return new JS_Call_Event(this.type, _JsCall);
		}
		
		
		public function get JsCall() : JS_Call
		{
			return _JsCall;
		}
	}
}