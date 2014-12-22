package com.cc.utils.keybinder
{
	import com.adverserealms.log.Logger;
	
	import flash.events.KeyboardEvent;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;

	internal class KeySignature
	{
		private static const STR_SHIFT:String = "shift";
		private static const STR_CTRL:String = "ctrl";
		private static const STR_ALT:String = "alt";
		private static const STR_CMD:String = "cmd";

		// Provided a keycode (i.e. from a KeyboardEvent), return a standardized string for the signature
		private static const KEYCODE_TEXT_MAP:Object = {
			8  : "backspace",
			9  : "tab",
			13 : "enter",
			27 : "escape",
			32 : "space",
			46 : "delete"
		};
		
		// This lookup will be done somewhat backwards - if the text provided matches anything on the right side, we will standardize to the left side
		private static const TEXT_STANDARD_MAP:Object = {
			"backspace"	: ["bs", "backspace"],
			"delete"	: ["del", "delete"],
			"enter"		: ["ent", "enter", "ret", "return"],
			"escape"	: ["esc", "escape"],
			"space"		: ["sp", "space"],
			"tab"		: ["tab"]
		};
		
		private static const MODIFIER_STANDARD_MAP:Object = {
			"shift"		: ["sh", "shift"],
			"ctrl"		: ["ctrl", "control", "cmd", "command"],
			"alt"		: ["alt", "opt", "option"]
		};
		
		public function KeySignature(blocker:InstantiationBlocker) { }
		
		public static function generateFromEvent(keyEvent:KeyboardEvent):String
		{
			var signature:String = "";
			// Don't add the keycode for modifiers which generate keyboard events (it will mess up the matching)
			if (keyEvent.keyCode != Keyboard.SHIFT && keyEvent.keyCode != Keyboard.COMMAND && keyEvent.keyCode != Keyboard.CONTROL)
			{
				if (keyEvent.keyLocation == KeyLocation.NUM_PAD)
				{
					signature += "num" + String.fromCharCode(keyEvent.charCode);
				}
				else if (KEYCODE_TEXT_MAP.hasOwnProperty(keyEvent.keyCode))
				{
					signature += KEYCODE_TEXT_MAP[keyEvent.keyCode];
				}
				else
				{
					signature += KeyCodeUtil.toLower(String.fromCharCode(keyEvent.charCode));
				}
			}
			
			// NOTE: THE ORDER OF THESE MUST MATCH THE ORDER OF THE CHECKS IN generateFromString()
			
			if (keyEvent.shiftKey)
			{
				signature += "-" + STR_SHIFT;
			}
			
			// Note: Cmd and Ctrl both set the ctrKey member of the KeyboardEvent, so let's just put ctrl in the signature
			if (keyEvent.ctrlKey)
			{
				signature += "-" + STR_CTRL;
			}
			
			if (keyEvent.altKey)
			{
				signature += "-" + STR_ALT;
			}
			
			return signature;
		}
		
		public static function generateFromString(unmodifiedKeys:String):String
		{
			var keys:String = unmodifiedKeys.toLowerCase();
			var signature:String = "";
			var keyArray:Array = keys.split(/\s+/);
			var key:String;
			var variant:String;
			
			for each (key in keyArray)
			{
				if (key.match(/num\d/))
				{
					signature = key;
					break;
				}
				else if (key.length == 1)
				{
					signature = KeyCodeUtil.toLower(key);
					break;
				}
				else
				{
					var standard:String = standardizeInput(key);
					if (standard != null)
					{
						signature = standard;
						break;
					}
				}
			}
			
			// Note: The order of MODIFIER_STANDARD_MAP isn't guaranteed (and changing it to an array made it kinda nasty looking), so I'm looping each member separately
			// NOTE: THE ORDER OF THESE MUST MATCH THE ORDER OF THE CHECKS IN generateFromEvent()
			
			for each (variant in MODIFIER_STANDARD_MAP[STR_SHIFT])
			{
				if (keyArray.indexOf(variant) != -1)
				{
					signature += "-" + STR_SHIFT;
				}
			}
			
			for each (variant in MODIFIER_STANDARD_MAP[STR_CTRL])
			{
				if (keyArray.indexOf(variant) != -1)
				{
					signature += "-" + STR_CTRL;
				}
			}
			
			for each (variant in MODIFIER_STANDARD_MAP[STR_ALT])
			{
				if (keyArray.indexOf(variant) != -1)
				{
					Logger.console("WARNING: Mappings with 'Alt' will not work on Mac (results may vary on other OSes)");
					signature += "-" + STR_ALT;
				}
			}
			
			return signature;
		}
		
		// Do a reverse lookup in the standardization table to convert input to a standard format for the signature
		private static function standardizeInput(input:String):String
		{
			for (var standard:String in TEXT_STANDARD_MAP)
			{
				for each (var option:String in TEXT_STANDARD_MAP[standard])
				{
					if (input == option)
					{
						return standard;
					}
				}
			}
			
			return null;
		}
	}
}

class InstantiationBlocker { }