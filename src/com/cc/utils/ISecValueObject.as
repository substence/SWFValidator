package com.cc.utils
{
    public interface ISecValueObject
    {
        function secure():void;
        function secValidateStats():Boolean;
        function secLogInvalidStats(logType:String):void;
        function get secStatDump():String;
        function get secProtectedStatValues():Array;
        function get secPublicStatValues():Array;
        function get secPropertyCount():int;
    }
}