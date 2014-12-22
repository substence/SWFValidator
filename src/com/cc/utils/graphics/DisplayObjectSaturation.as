package com.cc.utils.graphics
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	public class DisplayObjectSaturation
	{
		
		public static const MAX_AMOUNT:Number = 100;
		
		private static function getGrayScaleFilter(newAmount:Number):ColorMatrixFilter
		{
			newAmount = newAmount/MAX_AMOUNT;
			var newColorFilter:ColorMatrixFilter = new ColorMatrixFilter();
			var redMatrix:Array = [1, 0, 0, 0, 0];
			var greenMatrix:Array = [0, 1, 0, 0, 0];
			var blueMatrix:Array = [0, 0, 1, 0, 0];
			var alphaMatrix:Array = [0, 0, 0, 1, 0];
			var grayScale:Array = [.3, .59, .11, 0, 0];
			var colormatrix:Array = new Array();
			colormatrix = colormatrix.concat(interpolateArrays(grayScale, redMatrix, newAmount));
			colormatrix = colormatrix.concat(interpolateArrays(grayScale, greenMatrix, newAmount));
			colormatrix = colormatrix.concat(interpolateArrays(grayScale, blueMatrix, newAmount));
			colormatrix = colormatrix.concat(alphaMatrix);
			newColorFilter.matrix = colormatrix;
			return newColorFilter;
		}
		
		public static function setGrayScaleSaturation(object:DisplayObject, newAmount:Number):void 
		{
			if (newAmount >= MAX_AMOUNT)
			{
				// Remove color matrix filter
				object.filters = [];
			}
			else
			{
				object.filters = [ getGrayScaleFilter(newAmount) ];
			}
		}
		
		private static function interpolateArrays(array1:Array, array2:Array, delta:Number):Object 
		{
			//pick array 1 or 2 based on length
			var result:Array = (array1.length>=array2.length) ? array1.slice() : array2.slice();
			
			var i:int = result.length;
			while (i--) 
			{
				result[i] = array1[i]+(array2[i]-array1[i])*delta;
			}
			
			return result;
		}	
	}
}