package com.cc.utils
{
    public class BitwiseCircularOperation
    {
        private static const FIXED_BITS:uint = 32;
        
        public static function shift( value:int, shift:uint ):int
        {
            var savedHighBits:int = value >>> ( FIXED_BITS - shift );
            var leftShift:int = value << shift;
            var circularValue:int = leftShift | savedHighBits;
            
            return circularValue;
        }
        
        public static function unshift( value:int, shift:uint ):int
        {
            var highBitsRestored:int = value << ( FIXED_BITS - shift );
            var unshiftedLowBits:int = value >>> shift;
            var restoredValue:int = unshiftedLowBits | highBitsRestored;
            
            return restoredValue;
        }
    }
}