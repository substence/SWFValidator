package com.cc.utils
{
    import com.adverserealms.log.Logger;
    // Secure numbering for AS3 by the nice people at the Casual Collective.
    // Please encrypt in any SWF you publish to keep this private.
    // Any questions just email dave@casualcollective.com
    
    // Usage:
    // var score = new SecNum(1);
    // trace(score.Get()) > 1;
    // trace(score.Add(1)) > 2;
    // trace(score.Get()) > 2;
    
    public class SecNum
    {
        private static const RANDOM_POOL_MAX_SIZE       : int = 10;
        private static const SEED_MULTIPLIER            : int = 99999;
        private static const _MAX_BIT_SHIFT             : uint = 12;
        
        private static var _randomSeedPool              : Vector.<int>;
        private static var _randomShiftPool             : Vector.<int>;
        private static var _instanceCount               : uint = 0;        
        private static var _n1                          : Number = 0;
        private static var _n2                          : Number = 0;
        
        private var _shift                              : uint;
        private var _o                                  : SecObject;
        
        public function SecNum( num:int ) : void
        {
            if ( !_randomSeedPool ) initRandomPool();
            
            this.Set( num );
            
            _instanceCount++;
        }
        
        public static function initRandomPool():void
        {
            _randomSeedPool = new Vector.<int>( RANDOM_POOL_MAX_SIZE );
            _randomShiftPool = new Vector.<int>( RANDOM_POOL_MAX_SIZE );
            for ( var i:uint = 0; i < RANDOM_POOL_MAX_SIZE; i++ )
            {
                _randomSeedPool[ i ] = Math.random() * SEED_MULTIPLIER;
                _randomShiftPool[ i ] = ( ( _randomSeedPool[ i ] % _MAX_BIT_SHIFT ) + 1 );
            }
        }
        
        public function Set( num:int ) : void
        {
            this._shift = _randomShiftPool[ _instanceCount % RANDOM_POOL_MAX_SIZE ];
            var seed:int = _randomSeedPool[ _instanceCount % RANDOM_POOL_MAX_SIZE ];
            this._o = new SecObject( seed << this._shift, ( num + seed * 2 ) ^ seed, num ^ seed );
            
            DebugUtils.assert( ( ( this._o.x ^ seed ) == num), "SecNum::set x^seed == num" );
        }
        
        public function Add( num:int ):int
        {
            num += this.Get();
            this.Set(num);
            return num;
        }
        
        public function Get():int
        {
            var seed:uint = this._o.s >>> _shift;
            _n1 = this._o.x ^ seed;
            _n2 = (this._o.n ^ seed) - (seed * 2);
            
            if (_n1 == _n2)
            {
                return _n1;
            }
            else
            {
                BadNum(2);
                return 0;
            }
        }
        
        public function BadNum( n:int ):void
        {
            var tempError:Error = new Error();
            var stackTrace:String = tempError.getStackTrace();
            Logger.console(stackTrace);
            FrameworkLogger.Log('err', 'BadNum in SecNum' + n);
            GLOBAL.showErrorMessage(HaltErrorCodes.BAD_SEC_NUM, "SecNum::BadNum - " + n);
        }
    }
}

/**
 * This internal class is used because upon subsequent SecNum.Set calls it is re-instantiated, and
 * the memory address changes to make profiling these value-objects harder with memory profilers
 */
internal class SecObject
{
    public var s : uint;
    public var n : Number;
    public var x : Number;
    
    public function SecObject( _s:uint, _n:Number, _x:Number )
    {
        this.s = _s;
        this.n = _n;
        this.x = _x;
    }
}