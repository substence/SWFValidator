package com.cc.utils
{
	import com.adobe.crypto.MD5;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.NullPad;
	import com.hurlant.util.Base64;
	
	import flash.utils.ByteArray;

	public class BlowfishDecryption
	{
		public static function decryptBase64EncodedMessage(base64EncodedMessage:String) : String
		{
			var cipherBytes:ByteArray = com.hurlant.util.Base64.decodeToByteArray(base64EncodedMessage);
			return decryptBytes(cipherBytes);
		}
		
		public static function decryptUTFMessage(encryptedText:String) : String
		{
			var cipherBytes:ByteArray = new ByteArray();
			cipherBytes.writeUTFBytes(encryptedText);
			return decryptBytes(cipherBytes);
		}
		
		protected static function decryptBytes(cipherBytes:ByteArray) : String
		{
			// Configure the key
			var keyString:String = MD5.hash(URLLoaderApi.getSalt());
			var key:ByteArray = new ByteArray();
			key.writeUTFBytes(keyString);
			
			// Configure cipher.
			// The 'simple' prefix indicates that the IV is prepended to the body, so 
			// they should be separated and parsed individually when calling decrypt()
			var pad:IPad = new NullPad();
			var cipher:ICipher = Crypto.getCipher("simple-blowfish-cbc", key, pad);
			
			// Pad body with null characters at the end so it's a multiple of the block size.
			// This is automatically done by php's MCRYPT when it's encrypted
			cipherBytes.position = cipherBytes.length;
			var ivSize:int = cipher.getBlockSize();
			var modulus:int = cipherBytes.length % ivSize;
			
			// Only pad bytes if the body is not a multiple of the ivSize (8)
			if (modulus != 0)
			{
				// Pad up to a multiple of the ivSize (8)
				var bytesToPad:uint = ivSize - modulus;
				for (var i:int = 0; i < bytesToPad; i++)
				{
					cipherBytes.writeByte(0);
				}
			}
			
			cipher.decrypt(cipherBytes);
			cipherBytes.position = 0;
			return cipherBytes.readUTFBytes(cipherBytes.bytesAvailable)
		}
	}
}