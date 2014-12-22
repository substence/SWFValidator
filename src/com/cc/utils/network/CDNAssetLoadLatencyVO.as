package com.cc.utils.network
{
    public class CDNAssetLoadLatencyVO
    {
        public var url:String = "";
        public var startTime:int = 0;
        public var endTime:int = 0;
        public var bytes:int = 0;
        public var status:int = 0;
        
        public function CDNAssetLoadLatencyVO( _url:String )
        {
            this.url = _url;
        }
        
        public function get loadDuration():int
        {
            return this.endTime > this.startTime ? this.endTime - this.startTime : 0;
        }
    }
}