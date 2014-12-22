package com.cc.utils 
{
	import flash.utils.ByteArray;
	
	// Secure numbering for AS3 by the nice people at the Casual Collective.
	// Please encrypt in any SWF you publish to keep this private.
	// Any questions just email dave@casualcollective.com
	
	//Larger number support by don@kixeye.com
	//Your feeble mind cannot possibly comprehend the magic here.
	
	// Usage:
	// var score = new SecNum64(1000);
	// trace(score.Get()) = 1000;
	// score.Add(100);
	// trace(score.Get()) = 1100;
    //
    // @update: eketcham || removed static ref to ba:ByteArray - Caused contention on objects reading / writing to same ba.position(0)
    // 
    
	
	
	public class SecNum64
	{
		private var _secureNumber:Object;
		private var ba:ByteArray = new ByteArray();
		
		public function SecNum64( num:Number = 0 ) 
		{
			this.Set( num );
		}
		
		public function Set(num:Number) : Number
		{
			var seed:int = Math.random() * 99999;
			ba.position = 0;
			ba.writeDouble(num);
			ba.position = 0;
			var read:int = ba.readInt();
//            debug.assert( ((read ^ seed) == num) );
			_secureNumber = { s:seed, n:read ^ seed, x:(read-seed) ^ seed };
         
			return num;
		}
		
		public function Add( num:Number ):Number 
		{
			return Set( num + Get() );
		}
		
		public function Mult( num:Number ):Number
		{
			if ( isNaN( num ) || !isFinite( num ) ) 
			{
				BadNum();
				return int.MIN_VALUE;
			}
			else {
				return Set( num * Get() );
			}
		}
		
		public function Get():Number
		{
			ba.position = 0;
			ba.writeInt(_secureNumber.n ^ _secureNumber.s);
			ba.position = 0;
			var n:Number = ba.readDouble();
			
			ba.position = 0;
			ba.writeInt((_secureNumber.x ^ _secureNumber.s) + _secureNumber.s);
			ba.position = 0;
			var n2:Number = ba.readDouble();
			
			if ( n == n2 ) {
				
				return n;
			} else {
				BadNum();
				return int.MIN_VALUE;
			}
			
			
		}
		
		private function BadNum():void 
		{
			FrameworkLogger.Log(FrameworkLogger.KEY_ERROR, "SecNum64::BadNum - bad number attempt" );
		}
		
		public static function secureArray( arr:Array ) : Vector.<SecNum>
		{
			var sarr:Vector.<SecNum> = new Vector.<SecNum>();
			
			if ( arr != null )
			{
				try
				{
					for each( var i:int in arr )
					{
						sarr.push( new SecNum( i ) );
					}
				}
				catch (e:Error)
				{
					FrameworkLogger.Log( FrameworkLogger.KEY_ERROR, "SecNum64::secureArray - ERROR.SecNum.secureArray", "name: " + e.name + " message: " + e.message + " stack: " + e.getStackTrace() );
					
				}
			}
			return sarr;
		}
		
		public static function unsecureArray( arr:Vector.<SecNum> ) : Array
		{
			var uarr:Array = [];
			if ( arr != null )
			{
				try
				{
					for each(var i:SecNum in arr)
					{
						uarr.push( i.Get() );
					}
				} catch (e:Error) {
					FrameworkLogger.Log(FrameworkLogger.KEY_ERROR, "SecNum64::unsecureArray");
					
				}
			}
			return uarr;
		}
	}
}