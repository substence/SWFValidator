package com.cc.messenger
{
	import com.cc.scheduler.ScheduledAction;
	import com.cc.scheduler.SchedulerCancelToken;

	public class MessageScheduledAction extends ScheduledAction
	{
		private var _message:Message;
		
		public function MessageScheduledAction(timeSec:int, cancelToken:SchedulerCancelToken, message:Message)
		{
			super(timeSec, cancelToken);
			_message = message;
		}
		
		public function get deliveryTime() : int
		{
			return priority;
		}
		
		override public function doAction() : void
		{
			if (_message)
			{
				_message.dispatch();
			}
		}
	}
}