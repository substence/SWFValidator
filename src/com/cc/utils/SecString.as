package com.cc.utils
{
	import com.adobe.crypto.MD5;
	
	/*
	* Stores a string and ensures that it hasn't been tampered with 
	* Creates an MD5 hash for it and ensures that hash is valid on any subsequent requests. 
	*/
	public class SecString
	{
		private var _hash:String;
		private var _seed:String;
		private var _value:String
		private var _length:int;
		private var _stringID:String;
		
		public function SecString(value:String, stringID:String = "")
		{
			_stringID = stringID;
			//Get some random string 
			this.set(value);
		}
		
		private function getHash():String
		{
			return MD5.hash(LOGIN.getSalt() + _value);
		}
		
		public function get():String
		{
			if(getHash() == _hash)
			{
				return _value;
			}
			else
			{
				FrameworkLogger.Log(FrameworkLogger.KEY_HACK, 'Bad string in SecString ' + _stringID + " " + _value);
				GLOBAL.showErrorMessage(HaltErrorCodes.BAD_SEC_STRING, "SecString::get - Secured String Hack detected " + _stringID);
			}
			return "";
		}
		
		public function set(newValue:String):void
		{
			_value = newValue;
			_hash = getHash();
			if(_value != null)
			{
				_length = _value.length;	
			}
			else
			{
				_length = 0;
			}
		}
		
		public function get length():int
		{
			return _length;
		}	
	}
}