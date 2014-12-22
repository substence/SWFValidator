package com.cc.utils.logging
{
    public class StackTraceParser
    {
        public function StackTraceParser(){}
        
        public static function stackTraceParser( stackTrace:String ):String
        {
            var pattern:RegExp = /[a-zA-Z]{1,}\/[a-zA-Z]{1,}\(\)/gismx;
            var result:Array = stackTrace.match(pattern);
            var output:String = "";
            
            output += "---------------------\n";
            output += "STACK TRACE\n";
            output += "---------------------\n";
            for ( var i:int = 0; i < result.length; i++ )
            {
                output += String( result[i] ) + "\n";
            }
            output += "---------------------\n";
            
            return output;
        }
    }
}