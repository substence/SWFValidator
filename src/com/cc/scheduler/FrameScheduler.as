package com.cc.scheduler
{
	public class FrameScheduler
	{
		private static var _instance:FrameScheduler = null;
		
		public static function get instance() : FrameScheduler
		{
			if (!_instance)
			{
				_instance = new FrameScheduler();				
			}
			return _instance;
		}		
		
		private var _scheduler:Scheduler = new Scheduler();
		private var _lastTime:int = 0;

		public function getLastTime() : int
		{
			return _lastTime;
		}
		
		public function add(action:ScheduledAction) : void
		{
			_scheduler.add(action);
		}
		
		public function tickFast() : void
		{
			_scheduler.tick(_lastTime);
			++_lastTime;
		}
		
		public function cancel(cancelToken:SchedulerCancelToken) : void
		{
			_scheduler.cancel(cancelToken);
		}		
	}
}