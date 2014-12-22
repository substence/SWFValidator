package com.cc.scheduler
{
	import com.adverserealms.log.Logger;
	
	public class SchedulerCancelToken
	{
		private var _canceled:Boolean = false;
		private var _debugName:String = "unnamed";
		
		public function SchedulerCancelToken(dbgName:String)
		{
			if (dbgName)
			{
				_debugName = dbgName;
			}
		}
		
		public function isCanceled() : Boolean
		{
			return _canceled;
		}
		
		public function cancel() : void
		{
			Scheduler.log("cancel: " + _debugName);
			
			_canceled = true;
		}
		
		public function get debugName() : String
		{
			return _debugName;
		}
	}
}