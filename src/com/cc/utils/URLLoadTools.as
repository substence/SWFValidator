package com.cc.utils
{
	public class URLLoadTools
	{
		public static function AssembleLoadVars(loadObjects:Object, fields:Array) : Array
		{
			// Sort object vars into array;
			var loadVars:Array = [];
			for each (var field:Object in fields)
			{
				var property:String = "";
				if(field is SecString)
				{
					property = (field as SecString).get();
				}
				else
				{
					property = field as String;
				}
				
				if(loadObjects.hasOwnProperty(property)) 
				{
					loadVars.push([property, loadObjects[property]]);
				}
			}			
			return loadVars;
		}	
	}
}