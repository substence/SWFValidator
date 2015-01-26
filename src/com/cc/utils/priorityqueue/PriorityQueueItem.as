package com.cc.utils.priorityqueue
{
	public class PriorityQueueItem
	{
		private static var _guid:int = 0;
		
		private var _priority:int;
		private var _itemGuid:int;
		
		public function PriorityQueueItem(priority:int)
		{
			_priority = priority;
			
			++_guid;			
			_itemGuid = _guid;
		}

		public function get priority() : int
		{
			return _priority;
		}
		
		public function less(other:PriorityQueueItem) : Boolean
		{
			return (_priority < other._priority) || (_priority == other._priority && _itemGuid < other._itemGuid); 
		}
	}
}