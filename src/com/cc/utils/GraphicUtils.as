package com.cc.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class GraphicUtils
	{
		public static function getNestedChild(parent:DisplayObjectContainer, childDefinition:String):DisplayObject
		{
			if (!parent)
			{
				return null;
			}
			
			var childDefinitions:Array = childDefinition.split(".");
			var currentParent:DisplayObjectContainer = parent;
			var currentChild:DisplayObject;
			for each (var definition:String in childDefinitions) 
			{
				currentChild = currentParent.getChildByName(definition);
				if (currentChild != null && currentChild is DisplayObjectContainer)
				{
					currentParent = currentChild as DisplayObjectContainer;
				}
				else
				{
					break;
				}
			}
			return currentChild;
		}
	}
}