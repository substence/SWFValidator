package com.cc.utils.network
{
    import com.adverserealms.log.Logger;
    import com.cc.models.Flags;
    import com.cc.utils.DateUtils;
    import com.cc.utils.Kmeans;
    import com.cc.utils.SecNum;
    
    import flash.events.TimerEvent;
    import flash.utils.Dictionary;
    import flash.utils.Timer;

    public class CDNAssetLatencyMonitor
    {
        /**
        * Magic Numbers
        */
        private static const LOAD_LATENCY_TIME_DELAY                    : SecNum = new SecNum( 10000 ); // 10 Seconds
        private static const MILLISECONDS_TO_SECONDS_CONVERSION         : SecNum = new SecNum( 1000 );
        private static const BYTES_TO_BYTES_CONVERSION                  : SecNum = new SecNum( 1024 );
        private static const BITS_TO_BITS_CONVERSION                    : SecNum = new SecNum( 1000 );
        private static const BYTES_TO_BITS_CONVERSION                   : SecNum = new SecNum( 8 );
        private static const CDN_ASSET_SAMPLE_SIZE                      : SecNum = new SecNum( 20 );
        private static const STATUS_CODE_UNCACHED                       : SecNum = new SecNum( 200 );
        private static const STATUS_CODE_PROFILE_WHITELIST              : Array = [ STATUS_CODE_UNCACHED.Get(), 0 ]; // 0 Represents Local Build Loads Status Code
        
        /**
        * CDN Asset Statistic Data Stores
        */
        // -- Quick Look-up Dict "url":<CDNAssetLoadLatencyVO>
        private static var _assetLoadLatencyStatistics                  : Dictionary = new Dictionary( true );
        // -- List of <CDNAssetLoadLatencyVO> based on load time in ms descending
        public  static var _loadLatencyList                             : Vector.<CDNAssetLoadLatencyVO> = new Vector.<CDNAssetLoadLatencyVO>();
        
        // Logging Flag to ensure no more than one log / type per game session
        private static var _loggedExcessiveLatency                      : Boolean = false;
        
        // Profile Asset Load Timer
        private static var _logTimer                                    : Timer = new Timer( LOAD_LATENCY_TIME_DELAY.Get(), 1 );
        
        public static function profileCDNAssetLoadStartByUrl( url:String ):void
        {
            startProfileTimer();
            getCDNAssetLoadLatencyVOByUrl( url ).startTime = DateUtils.currentEpochInMilliseconds;
        }
        
        public static function setCDNAssetStatusCodeByUrl( url:String, statusCode:int ):void
        {
            getCDNAssetLoadLatencyVOByUrl( url ).status = statusCode;
            
            if ( STATUS_CODE_PROFILE_WHITELIST.indexOf( getCDNAssetLoadLatencyVOByUrl( url ).status ) != -1 )
            {
                _loadLatencyList.push( getCDNAssetLoadLatencyVOByUrl( url ) );
                _loadLatencyList.sort( sortLatencyList );
            }
        }
        
        public static function setCDNAssetSizeInBytes( url:String, bytes:int ):void
        {
            getCDNAssetLoadLatencyVOByUrl( url ).bytes = bytes;
        }
        
        public static function setCDNAssetLoadCompleteByUrl( url:String ):void
        {
            getCDNAssetLoadLatencyVOByUrl( url ).endTime = DateUtils.currentEpochInMilliseconds;
        }
        
        private static function getCDNAssetLoadLatencyVOByUrl( url:String ):CDNAssetLoadLatencyVO
        {
            if ( _assetLoadLatencyStatistics[ url ] == null )
            {
                _assetLoadLatencyStatistics[ url ] = new CDNAssetLoadLatencyVO( url );
            }
            
            return _assetLoadLatencyStatistics[ url ] as CDNAssetLoadLatencyVO;
        }
        
        private static function startProfileTimer():void
        {
            if ( !_logTimer.running )
            {
                _logTimer.addEventListener( TimerEvent.TIMER, logAssetLoadLatencyAverage );
                _logTimer.start();
            }
        }
        
        public static function logAssetLoadLatencyAverage( event:TimerEvent ):void
        {
            // Cleanup Timer
            _logTimer.removeEventListener( TimerEvent.TIMER, logAssetLoadLatencyAverage );
            _logTimer.stop();
            
            // Only Report 1 time per play session, and only if Framework Flag is set
            if ( _loggedExcessiveLatency )
            {
                return;
            }
            
//            // Extract Mean Bandwidth
//            var meanBandwidthInMegabitsPerSecond:Number = averageList( extractMeanBandwidthCluster( Kmeans.proccessClusters( extractBandwidthProperties(), 3 ) ) );
//            
//            if ( Flags.cdnBandwidthLogThreshold != 0 &&
//                 Flags.cdnBandwidthLogThreshold >= ( meanBandwidthInMegabitsPerSecond * 1024 ) ) // Compare Framework flag in KBps to mean bandwidth in Mbps
//            {
//                //Logger.debug( "Mean Bandwidth: " + meanBandwidthInMegabitsPerSecond ); //why were we double loging this?
//                FrameworkLogger.Log( FrameworkLogger.KEY_CDN_BANDWIDTH_LATENCY, String( meanBandwidthInMegabitsPerSecond ) );
//                _loggedExcessiveLatency = true;
//            }
        }
        
        private static function extractMeanBandwidthCluster( clusters:Array ):Array
        {
            var meanList:Array;
            var longestListLength:int = 0;
            var longestClusterListIndex:uint = 0;
            for ( var i:uint = 0; i < clusters.length; i++ )
            {   
                // Determine largest cluster
                if ( clusters[ i ].length > longestListLength )
                {
                    longestClusterListIndex = i;
                
                // If Matching size cluster is found pick largest in bandwidth average
                } else if ( meanList &&
                            longestListLength != 0 &&
                            clusters[ i ].length == longestListLength )
                {
                    if ( averageList( clusters[ i ] ) > averageList( meanList ) )
                    {
                        longestClusterListIndex = i;
                    }
                }
                
                longestListLength = clusters[ longestClusterListIndex ].length;
                meanList = clusters[ longestClusterListIndex ] as Array;
            }
            return meanList;
        }
        
        private static function extractBandwidthProperties():Array
        {
            var list:Array = [];
            for ( var i:uint = 0; i < Math.min( _loadLatencyList.length, CDN_ASSET_SAMPLE_SIZE.Get() ); i++ )
            {
                list.push( calculateMegabitsPerSecond( CDNAssetLoadLatencyVO( _loadLatencyList[ i ] ).bytes,
                                                       CDNAssetLoadLatencyVO( _loadLatencyList[ i ] ).loadDuration ) );
            }
            return list;
        }
        
        private static function averageList( list:Array ):Number
        {
            var total:Number = 0;
            for ( var i:uint = 0; i < list.length; i++ )
            {
                total += list[ i ];
            }
            return total / list.length;
        }
        
        private static function sortLatencyList( item1:CDNAssetLoadLatencyVO, item2:CDNAssetLoadLatencyVO ):int
        {
            if ( item1.bytes < item2.bytes )
            { 
                return 1; 
                
            } else if ( item1.bytes > item2.bytes )
            { 
                return -1; 
                
            } else
            { 
                return 0; 
            }
        }
        
        private static function trimSignifigantDigits( number:Number, signifagant:int = 3 ):String // Results in 0.00 by default
        {
            return String( number ).substr( 0, String( number ).indexOf( "." ) + signifagant );
        }
        
        /**
        * BYTES
        */
        private static function calculateKilobytesPerSecond( bytes:int, milliseconds:int ):Number
        {
            return convertBytesToKiloBytes( bytes ) / convertMillisecondsToSeconds( milliseconds );
        }
        
        private static function calculateMegabytesPerSecond( bytes:int, milliseconds:int ):Number
        {
            return convertBytesToMegaBytes( bytes ) / convertMillisecondsToSeconds( milliseconds );
        }
        
        private static function convertBytesToMegaBytes( bytes:int ):Number
        {
            return convertBytesToKiloBytes( bytes ) / BYTES_TO_BYTES_CONVERSION.Get();
        }
        
        private static function convertBytesToKiloBytes( bytes:int ):Number
        {
            return bytes / BYTES_TO_BYTES_CONVERSION.Get();
        }
        
        
        /** BYTES => BITS */
        private static function convertBytesToBits( bytes:int ):Number
        {
            return bytes * BYTES_TO_BITS_CONVERSION.Get();
        }
        
        /**
        * BITS
        */
        private static function calculateKilobitsPerSecond( bits:int, milliseconds:int ):Number
        {
            return convertBitsToKillobits( bits ) / convertMillisecondsToSeconds( milliseconds );
        }
        
        private static function calculateMegabitsPerSecond( bits:int, milliseconds:int ):Number
        {
            return convertBitsToMegabits( bits ) / convertMillisecondsToSeconds( milliseconds );
        }
        
        private static function convertBitsToKillobits( bits:int ):Number
        {
            return bits / BITS_TO_BITS_CONVERSION.Get();
        }
        
        private static function convertBitsToMegabits( bits:int ):Number
        {
            return convertBitsToKillobits( bits ) / BITS_TO_BITS_CONVERSION.Get();
        }
        
        /**
        * TIME
        */
        private static function convertMillisecondsToSeconds( milliseconds:int ):Number
        {
            return milliseconds /  MILLISECONDS_TO_SECONDS_CONVERSION.Get();
        }
    }
}