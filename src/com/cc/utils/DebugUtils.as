package com.cc.utils
{
	import com.adverserealms.log.Logger;
	import com.cc.display.Fonts;
	import com.cc.utils.console.ConsoleController;
	import com.cc.widget.WidgetTools;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class DebugUtils
	{
		public static const SHORT_MAX:int = 65536; //2^16
		public static const BYTE_MAX:int = 256;
		private static var _errorText:TextField;

	CONFIG::debug
	{
		ConsoleController.Instance.RegisterCommand("toggleErrorText",debugToggleErrorText,"Toggles the error text that's centered on the screen");
	}
		
		public static function assert(expression:Boolean, message:String):void
		{
			if( !expression )
			{
				FrameworkLogger.Log( FrameworkLogger.KEY_ASSERT, message );
				CONFIG::debug 
				{
					Logger.error("Assertion failed! " + message);
					displayError(message);
					
					var tempError:Error = new Error();
					Logger.console("DebugUtils::assert\n" + tempError.getStackTrace());
					//POPUPS.DisplayMessage("Assertion failed!","Check the console(~) for more information.");		
				}
			}
		}
		
		CONFIG::debug
		public static function displayError(errorMessage:String):void
		{
			if (GLOBAL._layerTop)
			{
				if (!_errorText)
				{
					_errorText = WidgetTools.GetTextField(Fonts.VERDANA, 12, Colors.WHITE, true);
					_errorText.multiline = true;
					_errorText.width = GLOBAL._layerTop.stage.width;
					_errorText.height = GLOBAL._layerTop.stage.height;
					GLOBAL._layerTop.addChild(_errorText);
				}
				_errorText.htmlText += errorMessage + "\n";
			}
		}
		
		
		CONFIG::debug
		public static function debugToggleErrorText(args:Array = null):void
		{
			if(_errorText != null)
			{
				_errorText.visible = !_errorText.visible;
			}
		}
	}
}