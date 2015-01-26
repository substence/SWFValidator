package com.cc.scheduler
{
	import com.cc.utils.priorityqueue.PriorityQueueItem;

	public class ScheduledAction extends PriorityQueueItem
	{
		private var _cancelToken:SchedulerCancelToken;
		
		public function ScheduledAction(scheduledTime:int, token:SchedulerCancelToken) 
		{
			super(scheduledTime);
			_cancelToken = token;
		}
		
		public function get time() : int
		{
			return priority;
		}
		
		public function isCancelled() : Boolean
		{
			return _cancelToken && _cancelToken.isCanceled();
		}
		
		public function doAction() : void
		{
			//DebugUtils.assert(false, "Scheduled action is abstract. Subclass and override doAction.");
		}
		
		public function get debugName() : String
		{
			if (_cancelToken)
			{
				return _cancelToken.debugName;
			}
			return "unnamed";
		}
	}
}