package com.cc.utils
{
	import com.kixeye.wc.resources.WCLocalizer;
	
	public class TextUtils
	{
		public static function colorFont(inputString:String, color:String):String
		{
			return "<font color=\"#" + color + "\">" + inputString + "</font>";
		}
		
		public static function combineStrings(strings:Vector.<String>) : String 
		{
			var finalString:String = '';
			switch (strings.length)
			{
				case 1:
					finalString = WCLocalizer.getString("common__list_constructor_1", {listitem1:strings[0]});
					break;
				case 2:
					finalString = WCLocalizer.getString("common__list_constructor_2", {listitem1:strings[0],listitem2:strings[1]});
					break;
				case 3:
					finalString = WCLocalizer.getString("common__list_constructor_3", {listitem1:strings[0],listitem2:strings[1],listitem3:strings[2]});
					break;
				case 4:
					finalString = WCLocalizer.getString("common__list_constructor_4", {listitem1:strings[0],listitem2:strings[1],listitem3:strings[2],listitem4:strings[3]});
					break;
				case 5:
					finalString = WCLocalizer.getString("common__list_constructor_5", {listitem1:strings[0],listitem2:strings[1],listitem3:strings[2],listitem4:strings[3],listitem5:strings[4]});
					break;
				default:
					finalString = WCLocalizer.getString("common__list_constructor_error");
					break;
			}
			/*
			for (var i:int = 0; i < strings.length; i++)
			{
				finalString += strings[i];
				if (i < strings.length - 2)
				{
					finalString += ', ';
				}
				else if (i == strings.length - 2)
				{
					if (strings.length > 2)
					{
						finalString += ",";
					}
					finalString += ' and ';
				}
			}*/
			return finalString;
		}
		
		public static function formatBonusPercent(percent:int) : String
		{
			return "+" + Math.max(0, percent - 100).toString() + "%";
		}
		
		public static function coalesce(string:String, defaultString:String) : String
		{
			return string ? string : defaultString;
		}
		
		// Trims leading and trailing whitespace
		public static function trimWhitespace(value:String) : String
		{
			if (value)
			{
				var trimExp:RegExp = /^ +| +$/g;
				return value.replace(trimExp, "");
			}
			
			return "";
		}
		
		public static function parseBoolean(value:Object) : Boolean
		{
			switch (trimWhitespace(String(value)).toLowerCase())
			{
				case "0":
				case "false":
				case "null":
				case "undefined":
				{
					return false;
				}
			}
			
			return true;
		}
	}
}