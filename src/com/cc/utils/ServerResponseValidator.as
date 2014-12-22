package com.cc.utils
{
	import com.adobe.crypto.MD5;
	import com.cc.models.Flags;
	import com.kixeye.wc.resources.WCLocalizer;
	
	import flash.utils.Dictionary;
	
	public class ServerResponseValidator
	{
		private static const MAX_VALID_MESSAGE_FUTURE_AGE:SecNum = new SecNum(120);
		private static const MAX_VALID_MESSAGE_AGE:SecNum = new SecNum(120);
		private static var _recentSignatures:Dictionary = new Dictionary();
		
		// Returns null if the response if valid.
		private static function validateResponse(wrapper:Object) : ResponseValidation
		{
			if (wrapper == null)
			{
				return new ResponseValidation(HaltErrorCodes.INVALID_WRAPPER, "Invalid wrapper");
			}
			
			var timestamp:Number = wrapper.ts;
			var expectedSignature:String = MD5.hash(wrapper.body + timestamp + wrapper.signatureVersion + URLLoaderApi.getSalt());
			var signature:String = wrapper.signature;
			
			// Response has been tampered with
			if (signature != expectedSignature)
			{
				return new ResponseValidation(HaltErrorCodes.INVALID_SIGNATURE, "Invalid signature");
			}
			
			// Response is too old
			if (GLOBAL.getServerTimestampSeconds() - timestamp > MAX_VALID_MESSAGE_AGE.Get())
			{
				return new ResponseValidation(HaltErrorCodes.MESSAGE_TOO_OLD, "Message too old: " + (GLOBAL.getServerTimestampSeconds() - timestamp));
			}
			
			// Response is from the future
			if (timestamp - GLOBAL.getServerTimestampSeconds() > MAX_VALID_MESSAGE_FUTURE_AGE.Get())
			{
				return new ResponseValidation(HaltErrorCodes.MESSAGE_NOT_OLD_ENOUGH, "Message not old enough: " + (timestamp - GLOBAL.getServerTimestampSeconds()));
			}
			
			// We have seen this response before
			if (_recentSignatures.hasOwnProperty(signature))
			{
				return new ResponseValidation(HaltErrorCodes.DUPLICATE_SIGNATURE, "Duplicate signature");
			}
			
			_recentSignatures[signature] = true;
			
			return new ResponseValidation(HaltErrorCodes.VALID, "Valid message");
		}
		
		private static function hasSignatureVersion(wrapper:Object) : Boolean
		{
			if (wrapper == null)
			{
				return false;
			}
			
			return wrapper.hasOwnProperty("signatureVersion");
		}
		
		public static function processServerResponse(responseString:String) : String
		{
			// If it has a signature version, unwrap it and use the new flow
			if (Flags.responseChecksumEnabled)
			{
				var response:Object = URLLoaderApi.json_decode(responseString);
				if (hasSignatureVersion(response))
				{
					var responseValidation:ResponseValidation = validateResponse(response);
					if (shouldLogError(responseValidation.errorCode))
					{
						FrameworkLogger.Log(FrameworkLogger.KEY_CHECKSUM_MISMATCH, "Checksum mismatch. Error: " + responseValidation.message); 
					}
					
					if (shouldHalt(responseValidation.errorCode))
					{
						GLOBAL.showErrorMessage(responseValidation.errorCode, "Checksum mismatch", false);
					}
					
					if (Flags.responseEncryptionEnabled)
					{
						return BlowfishDecryption.decryptBase64EncodedMessage(response.body);
					}
					else
					{
						return response.body;
					}
				}
			}
			
			return responseString;
		}
		
		private static function shouldLogError(errorCode:int) : Boolean
		{
			return errorCode != HaltErrorCodes.VALID;
		}
		
		private static function shouldHalt(errorCode:int) : Boolean
		{
			// Expand this if we add error types that shouldn't halt the game.
			return errorCode != HaltErrorCodes.VALID;
		}
	}
}
import com.cc.utils.ServerResponseValidator;
import com.kixeye.wc.resources.WCLocalizer;

internal class ResponseValidation
{
	public var errorCode:int;
	public var message:String;
	
	public function ResponseValidation(error:int, msg:String)
	{
		errorCode = error;
		message = msg;
	}
}