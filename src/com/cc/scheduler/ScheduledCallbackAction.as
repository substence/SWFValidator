package com.cc.scheduler
{
	public class ScheduledCallbackAction extends ScheduledAction
	{
		private var _callback:Function;
		
		// signature of callback is fn():void
		public function ScheduledCallbackAction(scheduledTime:int, 
												token:SchedulerCancelToken, callback:Function)
		{
			super(scheduledTime, token);
			_callback = callback;
		}
		
		override public function doAction() : void
		{
			if (_callback != null)
			{
				_callback();
			}
		}
	}
}