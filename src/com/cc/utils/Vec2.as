package com.cc.utils
{
	public class Vec2
	{
		private var _x:Number;
		private var _y:Number;
		
		public function Vec2(x:Number, y:Number)
		{
			_x = x;
			_y = y;
		}
		
		public function clone() : Vec2
		{
			return new Vec2(_x, _y);
		}
		
		public function get x() : Number
		{
			return _x;
		}
		public function get y() : Number
		{
			return _y;
		}
		
		public function get length() : Number
		{
			return Math.sqrt(_x * _x + _y * _y);
		}
		
		public function get lengthSqrd() : Number
		{
			return _x * _x + _y * _y;
		}
		
		public function set x(x:Number) : void
		{
			_x = x;
		}
		public function set y(y:Number) : void
		{
			_y = y;
		}
		
		public function setTo(x:Number, y:Number) : Vec2
		{
			_x = x;
			_y = y;
			return this;
		}
		
		public function setToVec(v:Vec2) : Vec2
		{
			_x = v.x;
			_y = v.y;
			return this;
		}
		
		public function zero() : Vec2
		{
			_x = 0.0;
			_y = 0.0;
			return this;
		}
		
		public function equals(v:Vec2) : Boolean
		{
			return _x == v.x && _y == v.y;
		}
		
		public function normalize() : Vec2
		{
			var inv:Number = 1 / length;
			_x *= inv;
			_y *= inv;
			return this;
		}
		
		public function add(v:Vec2) : Vec2
		{
			_x += v.x;
			_y += v.y;
			return this;
		}
			
		public function subtract(v:Vec2) : Vec2
		{
			_x -= v.x;
			_y -= v.y;
			return this;
		}
		
		public function multiply(v:Vec2) : Vec2
		{
			_x *= v.x;
			_y *= v.y;
			return this;
		}
		
		public function multiplyXY(n:Number) : Vec2
		{
			_x *= n;
			_y *= n;
			return this;
		}
		
		public function divide(v:Vec2) : Vec2
		{
			_x /= v.x;
			_y /= v.y;
			return this;
		}
		
		public function divideXY(n:Number) : Vec2
		{
			_x /= n;
			_y /= n;
			return this;
		}
		
		public function dot(v:Vec2) : Number
		{
			return _x * v.x + _y * v.y;
		}
	}
}
