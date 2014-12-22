package com.cc.utils
{
	import flash.geom.Point;

	public class MathUtils
	{
		public static const RADIANS_TO_DEGREES:Number = 180 / Math.PI;
		public static const DEGREES_TO_RADIANS:Number = Math.PI / 180;

		public static function toRadians(degrees:Number) : Number
		{
			return degrees * DEGREES_TO_RADIANS;
		}
		
		public static function getDistanceBetween(a:Point, b:Point):Number
		{
			const distX:Number = a.x - b.x;
			const distY:Number = a.y - b.y;
			return Math.sqrt(distX * distX + distY * distY);
		}
		
		public static function getSquaredDistanceBetween(a:Point, b:Point):Number
		{
			const distX:Number = a.x - b.x;
			const distY:Number = a.y - b.y;
			return distX * distX + distY * distY;
		}
		
		public static function xyDistSquared(x1:Number, y1:Number, x2:Number, y2:Number) : Number
		{
			return (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
		}
				
		/**
		 * Returns the angle between two points(in radians).
		 * @return angle in radians
		 */   
		public static function getAngleBetween(a:Point, b:Point):Number
		{
			return Math.atan2(b.y - a.y, b.x - a.x);
		}
		
		public static function getRandomNumberBetween(min:Number, max:Number):Number
		{
			return Math.random() * (max - min) + min;
		}
		
		/**
		 * Get's the sign of the Number n returning:
		 * -1 : negative Numbers
		 *  0 : 0
		 *  1 : positive Numbers 
		 * @param n: Number
		 * @return : int sign
		 */		
		public static function getSign(n:Number) : int
		{
			if (n > 0)
			{
				return 1;
			}
			else if (n < 0)
			{
				return -1;
			}
			
			return 0;
		}
		
		public static function floatEquals(a:Number, b:Number, epsilon:Number = 0.01):Boolean
		{
			return (Math.abs(a - b) < epsilon);
		}
		
		public static function hoverUnitSineWaveMotion(currentY:Number, currentFrame:int, numFrameSteps:int, frameStepMultiplier:int):Number
		{
			var newY:Number = currentY + Math.sin(currentFrame / numFrameSteps) * frameStepMultiplier;
			return newY;
		}
		
		public static function clampNumber(value:Number, min:Number, max:Number) : Number
		{
			return Math.min(Math.max(value, min), max);
		}
		
		public static function easeInOutSine(time:Number, startingValue:Number, change:Number, durationMS:Number):Number
		{
			return -change/2 * (Math.cos(Math.PI*time/durationMS) - 1) + startingValue;
		}
	}
}