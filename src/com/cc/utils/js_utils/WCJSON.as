package com.cc.utils.js_utils
{
	import com.cc.utils.DebugUtils;

	//import com.adobe.serialization.json.JSON;
	
	public class WCJSON 
	{
		
		public static  function encode(any:Object) : String
		{
			return JSON.stringify(any);
			//return com.adobe.serialization.json.JSON.encode(any);			
		}
		
		public static function decode(s:String) : *
		{
			return JSON.parse(s);
			//return com.adobe.serialization.json.JSON.decode(s);			
		}
		
		public static function decodeSafe(encodedString:String, errorMsg:String) : Object
		{
			var data:Object = null;
			try
			{
				data = WCJSON.decode(encodedString);
			}
			catch (e:Error)
			{
				DebugUtils.assert(false, errorMsg + "\n" + encodedString);
			}
			
			return data;
		}
		
	}
}