package com.cc.utils
{
	import flash.utils.Dictionary;

	public class GenericUtils
	{
		public static function isArrayEmpty(array:Array):Boolean
		{
			for each(var i:Object in array)
			{
				if (i)
				{
					return false;
				}
			}
			return true;
		}
		
		public static function countObjectElements(object:Object):int
		{
			var count:int = 0;
			
			if (object != null)
			{
				for (var key:String in object)
				{
					count++;
				}
			}
			
			return count;
		}
		
		public static function countDictionaryElements(dictionary:Dictionary):int
		{
			var count:int = 0;
			
			if (dictionary != null)
			{
				for (var key:Object in dictionary)
				{
					count++;
				}
			}
			
			return count;
		}
	}
}