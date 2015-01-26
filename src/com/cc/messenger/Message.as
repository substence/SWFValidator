package com.cc.messenger
{
	import com.cc.scheduler.Scheduler;
	import com.cc.scheduler.SchedulerCancelToken;
	
	public class Message
	{
		private static var _messenger:Messenger = null;
		
		public static function get messenger() : Messenger
		{
			if (!_messenger)
			{
				_messenger = new Messenger();
			}
			return _messenger;
		}

		public function dispatch() : void
		{
			if (_messenger)
			{
				_messenger.dispatch(this);
			}
		}

		public function makePending(cancelToken:SchedulerCancelToken = null) : MessageScheduledAction
		{
			return makeSchedulable(Scheduler.instance.getLastTime(), cancelToken);
		}
		
		public function makeSchedulable(timeSec:int, cancelToken:SchedulerCancelToken = null) : MessageScheduledAction
		{
			return new MessageScheduledAction(timeSec, cancelToken, this);
		}
		
		/***************************
		 * For unit testing
		 ***************************/
		
		public static function setMessager(messenger:Messenger) : void
		{
			_messenger = messenger;
		}
		
		public static function clearMessenger() : void
		{
			_messenger = null;
		}

	}
}