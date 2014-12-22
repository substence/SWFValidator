package com.cc.utils
{
    import com.adobe.crypto.MD5;
    import com.adverserealms.log.Logger;
    import com.cc.models.Flags;
    import com.cc.models.SecLevelDataVO;
    
    import flash.events.TimerEvent;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    public class SecByteArray
    {
        private static const SHIFT_TIMER            : uint = 250; // Milliseconds delay for shifting ByteArray in memory
        private static const SHIFT_RANDOM_SEED      : uint = 32; // Random Seed for Bitwise shift during run-time
        
        private static var _blob                    : ByteArray = new ByteArray();
        private static var _shiftTimer              : Timer = new Timer( SHIFT_TIMER, 0 );
        private static var _byteArrayChecksum       : int = 0;
        private static var _checksumDeltaed         : Boolean = false;
        private static var _shift                   : uint = Math.ceil( Math.random() * SHIFT_RANDOM_SEED );
        
        private static var _loggedInvalidChecksum   : Boolean = false;
        
        public static function addInt( value:int ):uint
        {
            // Flag to validate checksum broken when writing new data
            _checksumDeltaed = true;
            
            // Start Memory move timer if not already started
            if ( !_shiftTimer.running &&
                !_shiftTimer.hasEventListener( TimerEvent.TIMER ) )
            {  
                _shiftTimer.addEventListener( TimerEvent.TIMER, handleShiftTimerFired );
                _shiftTimer.start();
            }
            
            // Move bytearray.location to end if not already there
            if ( _blob.position != _blob.length ) _blob.position = _blob.length;
            
            // Record byte array position for requestor storage 
            var position:int = _blob.position;
            
            // Write object to bytearray
            _blob.writeInt( BitwiseCircularOperation.shift( value, _shift ) );
            
            return position;
        }
        
        public static function getInt( location:uint ):int
        {
            // Move bytearray.location to requested position if not already there
            if ( _blob.position != location ) _blob.position = location;
            
            // Attempt to read the object out of the bytearray if available
            try
            {
                return BitwiseCircularOperation.unshift( _blob.readInt(), _shift );
                
            } catch ( e:Error )
            {
                if ( !SecLevelDataVO.hasLoggedStats )
                    DebugUtils.assert( false, "Unable to look-up int in SecByteArray" + location );
                
                SecLevelDataVO.hasLoggedStats = true; // Disable logging if a look-up miss is detected
            }
            
            // Default return due to invalid look-up: 2,147,483,647
            return int.MAX_VALUE;
        }
        
        public static function handleShiftTimerFired( event:TimerEvent ):void
        {
            event.stopPropagation();

            // Avoid Running Security during sync battles for performance
            if ( ActiveState.IsSyncBattle() )
            {
                return;
            }
            
            if ( _checksumDeltaed || _byteArrayChecksum == 0 )
            {
                _byteArrayChecksum = createBlobHash();
            
            } else
            {
                var checksum:int = createBlobHash();
                if ( checksum != _byteArrayChecksum ) logInvalidStatChecksum();
            }
            
            // Create new byte-array to move all bytes to
            var shiftedByteArray:ByteArray = new ByteArray();
            
            // Write all bytes to new bytearray
            shiftedByteArray.writeBytes(_blob, 0, _blob.length);
            
            // Cleanup old bytearray
            _blob.clear();
            _blob = null;
            
            // Swap reference to new bytearray
            _blob = shiftedByteArray;
        }
        
        private static function createBlobHash():int
        {
            var value:int = 0;
            _blob.position = 0;
            while ( _blob.position < _blob.length )
            {
                value ^= _blob.readInt();
            }
            
            return value;
        }
        
        private static function logInvalidStatChecksum():void
        {
            if ( !Flags.validateStats || // Don't log stat validation
                 _loggedInvalidChecksum ) // Don't log more than 1 time per session
            {
                return;
                
            } else
            {
                _loggedInvalidChecksum = true;
                FrameworkLogger.Log( FrameworkLogger.KEY_STAT_CHECKSUM_VALIDATION, "Invalid Checksum" );
            }
        }
    }
}