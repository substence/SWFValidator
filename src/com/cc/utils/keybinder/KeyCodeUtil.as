package com.cc.utils.keybinder
{
	import flash.ui.Keyboard;

	internal class KeyCodeUtil
	{
		public function KeyCodeUtil(blocker:InstantiationBlocker) { }
		
		// NOTE: This is only for characters which can't be converted with String.toLowerCase()
		private static const SPECIAL_CHAR_LOWER:Object = {
			":":";",
			"?":"/",
			">":".",
			"<":",",
			"~":"`",
			"!":"1",
			"@":"2",
			"#":"3",
			"$":"4",
			"%":"5",
			"^":"6",
			"&":"7",
			"*":"8",
			"(":"9",
			")":"0",
			"_":"-",
			"+":"=",
			"{":"[",
			"}":"]",
			"|":"\\",
			"\"":"'"
		};
		
		public static function toLower(char:String):String
		{
			if (SPECIAL_CHAR_LOWER.hasOwnProperty(char))
			{
				return SPECIAL_CHAR_LOWER[char];
			}
			
			return char.toLowerCase();
		}
	}
}

class InstantiationBlocker { }