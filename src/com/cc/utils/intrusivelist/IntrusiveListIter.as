package com.cc.utils.intrusivelist
{
	public class IntrusiveListIter
	{
		private var _sentinel:IntrusiveListNode;
		private var _current:IntrusiveListNode;
		
		public function IntrusiveListIter(sentinel:IntrusiveListNode)
		{
			_sentinel = sentinel;
			_current = sentinel.Next;
		}

		public function get Done() : Boolean
		{
			return _current == _sentinel;
		}
		
		public function get Current() : IntrusiveListNode
		{
			return _current;
		}
		
		public function goNext() : void
		{
			if (!Done)
			{
				_current = _current.Next;
			}
		}
	}
}