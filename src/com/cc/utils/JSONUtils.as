package com.cc.utils
{
	import com.adobe.crypto.MD5;
	import com.cc.utils.js_utils.WCJSON;
	
	import flash.utils.ByteArray;

	public class JSONUtils
	{
		public static function getEmbeddedJSON(embeddedClass:Class):Object
		{
			var bytes:ByteArray = new embeddedClass() as ByteArray;
			var string:String = bytes.readUTFBytes(bytes.length);
			return WCJSON.decode(string);
		}
		
		public static function getEmbeddedCompressedJSON(embeddedClass:Class):Object
		{
			var bytes:ByteArray = new embeddedClass() as ByteArray;
			
			return getCompressedJSON(bytes);
		}
		
		public static function getCompressedJSON(bytes:ByteArray) : Object
		{
			bytes.uncompress();
			
			var string:String = bytes.readUTFBytes(bytes.length);
			
			return WCJSON.decode(string);
		}
		
		private static function assertIfStringFailsVerify(string:String, embeddedVerifyClass:Class):void
		{
			var verifyBytes:ByteArray = new embeddedVerifyClass() as ByteArray;
			var verifyString:String = verifyBytes.readUTFBytes(verifyBytes.length);
			
			DebugUtils.assert(MD5.hash(string) == MD5.hash(verifyString), "Obfuscated data doesn't match.");
		}
	}
}