package com.cc.utils
{
	import com.adobe.utils.DateUtil;

    public class DateUtils extends Object
    {
        // TIME CONSTANTS
        public static const MILLISECONDS_IN_A_SECOND : int = 1000;
        public static const SECONDS_IN_A_DAY                : int = 86400;
        public static const SECONDS_IN_A_HOUR               : int = 3600;
        public static const SECONDS_IN_A_MINUTE             : int = 60;
        
        public static function get currentEpochInMilliseconds():Number
        {
            return new Date().time;
        }
        
        public static function get currentEpochInSeconds():Number
        {
            return new Date().time / MILLISECONDS_IN_A_SECOND;
        }
        
        public static function convertMillisecondsToSeconds( millisecondsInput:Number ):Number
        {
            return millisecondsInput / MILLISECONDS_IN_A_SECOND;
        }

		public static function convertSecondsToMilliseconds( secondsInput:Number ):Number
		{
			return secondsInput * Number(MILLISECONDS_IN_A_SECOND);
		}
		
        public static function tokenizeSeconds( seconds:Number ):Vector.<int> // | DAYS | HOURS | MIN | SEC |
        {
            var tokens:Vector.<int> = new Vector.<int>(4, true);
            tokens[ 0 ] = extractDaysFromSeconds( seconds );
            tokens[ 1 ] = extractHoursFromSeconds( seconds -= tokens[ 0 ] * SECONDS_IN_A_DAY );
            tokens[ 2 ] = extractMinutesFromSeconds( seconds -= tokens[ 1 ] * SECONDS_IN_A_HOUR );
            tokens[ 3 ] = int( Math.floor( seconds -= tokens[ 2 ] * SECONDS_IN_A_MINUTE ) );
            return tokens;
        }
        
        public static function extractDaysFromSeconds( seconds:Number ):int
        {
            return int( Math.floor( seconds / SECONDS_IN_A_DAY ) );
        }
        
        public static function extractHoursFromSeconds( seconds:Number ):int
        {
            return int( Math.floor( seconds / SECONDS_IN_A_HOUR ) );
        }
        
        public static function extractMinutesFromSeconds( seconds:Number ):int
        {
            return int( Math.floor( seconds / SECONDS_IN_A_MINUTE ) );
        }
        
        public static function formatRemainingTimeUsingTwoDigitValuesAndColons( endEpoch:int, currentEpoch:int ):String
        {
            var resultString:String;
            var tokenizedRemainingTime:Vector.<int> = tokenizeSeconds( remainingSeconds( currentEpoch, endEpoch ) );
            resultString = tokenizedRemainingTime[ 0 ] > 0 ? numberToTwoDigitString( tokenizedRemainingTime[ 0 ] ) + ":" : "";
            resultString += numberToTwoDigitString( tokenizedRemainingTime[ 1 ] ) + ":";
            resultString += numberToTwoDigitString( tokenizedRemainingTime[ 2 ] );
            resultString += tokenizedRemainingTime[ 0 ] > 0 ? "" : ":" + numberToTwoDigitString( tokenizedRemainingTime[ 3 ] );
            return resultString;
        }
        
        public static function formatRemainingTimeUsingTimeAbbreviations( endEpoch:int, currentEpoch:int ):String
        {
            var resultString:String;
            var tokenizedRemainingTime:Vector.<int> = tokenizeSeconds( remainingSeconds( currentEpoch, endEpoch ) );
            resultString = tokenizedRemainingTime[ 0 ] > 0 ? String( tokenizedRemainingTime[ 0 ] ) + "d " : "";
            resultString += tokenizedRemainingTime[ 1 ] > 0 ? String( tokenizedRemainingTime[ 1 ] ) + "h " : "";
            resultString += tokenizedRemainingTime[ 2 ] > 0 && tokenizedRemainingTime[ 0 ] == 0 ? String( tokenizedRemainingTime[ 2 ] ) + "m" : "";
            resultString += tokenizedRemainingTime[ 0 ] > 0 || tokenizedRemainingTime[ 1 ] > 0 ? "" : " " + String( tokenizedRemainingTime[ 3 ] ) + "s";
            return resultString;
        }
        
        public static function numberToTwoDigitString( input:Number ):String
        {
            return input > 9 ? String( Math.round( input ) ) : "0" + String( Math.round( input ) );
        }
        
        public static function remainingSeconds( currentEpoch:int, endEpoch:int ):Number
        {
            return endEpoch - currentEpoch;
        }
        
        public static function remainingPercentage( currentEpoch:int, startEpoch:int, endEpoch:int ):Number
        {
            return ( endEpoch - currentEpoch ) / ( endEpoch - startEpoch ); 
        }
		
		//Expected format Day Mon DD HH:MM:SS TZD YYYY
		public static function convertToUnixTime(str:String):Number
		{
			return Date.parse(str);
		}
		
		//Return Data Mon 
		public static function convertUnixTimeToString(timeMS:Number):String
		{
			var date:Date = new Date();
			date.time = timeMS;
			return date.toString();				
		}
    }
}