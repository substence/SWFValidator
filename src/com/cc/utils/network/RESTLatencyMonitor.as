package com.cc.utils.network
{
    import com.cc.utils.SecNum;
    
    import flash.utils.Dictionary;
    
    public class RESTLatencyMonitor extends Object
    {
        private static var _instance:RESTLatencyMonitor; // Singleton
        
        private var _requestTimeDeltaMax:SecNum = new SecNum(30);
        private var _apiLoggingCache:Dictionary = new Dictionary();
        
        public function RESTLatencyMonitor()
        {
            if (_instance)
            {
                // Do nothing.. Singleton is already constructed,
                throw new Error("RESTLatencyMonitor Singleton attempted new instantiation");
            }
        }
        
        public static function get instance():RESTLatencyMonitor
        {
            if (!_instance)
            {
                _instance = new RESTLatencyMonitor();
            }
            return _instance;
        }
        
        
        /**
        * Evaluate method is only as good as it's input, so if we've allowed false timestamps to reset our internal
        * Flash cachedEpoch, then we're comparing against a number that is already incorrect.  In the future we should
        * red-box as soon as a epoch in a response is out of latency range to prevent invlaid caching of server time.
        */
        public function evaluate(cachedEpoch:int, requestEpoch:int, api:String):Boolean
        {
            var timeDelta:int = Math.abs(cachedEpoch - requestEpoch);
            
            // Process API - ( remove paras, and domain )
            var apiEndpoint:String = "";
            var urlBase:String = api.split("?")[0];
            apiEndpoint = urlBase.split(".com")[1];
            
            // BASE API CALLS ONLY RIGHT NOW
            // Currently we're only evaluating BASE - CRUD, so return if it's not the BASE API slug
            if ( apiEndpoint.indexOf("/api/wc/base/") == -1 )
            {
                return false;
            }
            
            if ( cachedEpoch > this._requestTimeDeltaMax.Get() && // Ensure client time is set before evaluating against it
                timeDelta > this._requestTimeDeltaMax.Get() )
            {
                this.logExsessiveLatency(cachedEpoch, apiEndpoint, timeDelta);
                return true;
            }
            
            return false;
        }
        
        private function logExsessiveLatency(currentEpoch:int, api:String, delta:int):void
        {
            var clientTime:int = new Date().time;
            
            // Log Throttling
            if ( this._apiLoggingCache[api] )
            {
                var lastReportedLogOfAPI:int = this._apiLoggingCache[api] as int;
                if ( clientTime - lastReportedLogOfAPI < 60 )
                {
                    return;
                }
            }
            
            // Record Log Timestamp for log throttling
            this._apiLoggingCache[api] = clientTime;
            
            var logMessage:String = "";
            
            switch ( api )
            {
                case "/api/wc/base/load":
                    logMessage = FrameworkLogger.KEY_BASE_LOAD_TS_DELTA;
                    break;
                case "/api/wc/base/save":
                    logMessage = FrameworkLogger.KEY_BASE_SAVE_TS_DELTA;
                    break;
                case "/api/wc/base/updatesave":
                    logMessage = FrameworkLogger.KEY_BASE_UPDATE_TS_DELTA;
                    break;
                default:
                    return; // Return if we don't match known api's for logging
                    break;
            }
            
            FrameworkLogger.Log( logMessage, String(delta) );
        }
    }
}