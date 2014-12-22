package com.cc.utils
{
	
	import flash.utils.getTimer;
	
	public class SeedRandom
	{
		
		private static const MAX_RATIO:Number = 1/uint.MAX_VALUE;
		private var _random:uint;
		
		public function SeedRandom( seed:uint = 0)
		{
			_random = seed || getTimer();
		}
		
		/**
		 * This gets a value from 0 - 1
		 */
		public function getNext():Number
		{
			_random ^= (_random<<21);
			_random ^= (_random>>>35);
			_random ^= (_random<<4);
			return (_random*MAX_RATIO);
		}
	}
}