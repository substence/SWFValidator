package com.cc.scheduler
{
	import com.cc.utils.DebugUtils;
	import com.cc.utils.logging.LogGatherer;
	import com.cc.utils.priorityqueue.PriorityQueue;
	import com.cc.utils.priorityqueue.PriorityQueueItem;
	
	import flash.utils.getQualifiedClassName;
	
	import org.osflash.signals.Signal;
	
	public class Scheduler
	{
		private static var _instance:Scheduler = null;

		public static function get instance() : Scheduler
		{
			if (!_instance)
			{
				_instance = new Scheduler();				
			}
			return _instance;
		}
		
		private var _priorityQueue:PriorityQueue = new PriorityQueue();
		private var _canceled:Boolean = false;
		private var _lastTime:int = 0;
		
		public function add(action:ScheduledAction) : void
		{
			_priorityQueue.enqueue(action);
		}
		
		public function tick(time:int) : void
		{
			_lastTime = time;
			
			do
			{
				var item:PriorityQueueItem = _priorityQueue.peek();
			
				if (!item)
				{
					break;
				}

				var action:ScheduledAction = item as ScheduledAction;
				
				if (!action)
				{
					DebugUtils.assert(false, "Scheduler: tick: priority queue item is not a scheduled action");
					break;
				}
				
				if (action.time > time)
				{
					CONFIG::debug
					{
						logPendingAction(action, time);
					}
					break;
				}

				_priorityQueue.dequeue();
				if (!action.isCancelled())
				{
					CONFIG::debug
					{
						log("Scheduler: tick: do action " + getQualifiedClassName(action) + " at " + action.time);
					}
					action.doAction();
				}
			}
			while (true);
			
			removeCanceled();
		}
		
		public function cancel(cancelToken:SchedulerCancelToken) : void
		{
			if (cancelToken)
			{
				cancelToken.cancel();
				_canceled = true;
			}
		}

		public function getLastTime() : int
		{
			return _lastTime;
		}
		
		private function removeCanceled() : void
		{
			if (_canceled)
			{
				function isNotCancelled(item:PriorityQueueItem) : Boolean
				{
					var action:ScheduledAction = item as ScheduledAction;
					
					if (!action)
					{
						DebugUtils.assert(false, "Scheduler: cancel: priority queue item is not a scheduled action");
						return false;
					}
					
					CONFIG::debug
					{
						if (action.isCancelled())
						{
							log("Action " + getQualifiedClassName(action) + ", " + action.debugName + " is canceled.");
						}
					}
					
					return !action.isCancelled();
				}
				
				_priorityQueue.filter(isNotCancelled);
				_canceled = false;
			}
		}
		
		public static function log(message:String) : void
		{
			CONFIG::debug
			{
				LogGatherer.log("Scheduler", "Scheduler: " + message);
			}
		}
		
		CONFIG::debug
		{
			private static const PENDING_LOG_TIME:int = 5;
			
			private function logPendingAction(action:ScheduledAction, time:int) : void
			{
				var timeUntil:int = action.time - time; 
				
				if (timeUntil < PENDING_LOG_TIME)
				{
					log("Pending action in " + timeUntil + ", at " + time + ", action " + getQualifiedClassName(action));
				}
			}
		}
		
		/***************************
		 * For unit testing
		 ***************************/
		
		public function getNumActions() : int
		{
			return _priorityQueue.length;
		}
	}
}