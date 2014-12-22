package com.cc.utils.intrusivelist
{
	public class IntrusiveListNode
	{
		private var _prev:IntrusiveListNode;
		private var _next:IntrusiveListNode;
		
		public function IntrusiveListNode()
		{
			_prev = _next = this;
		}
		
		public function addAfterNode(node:IntrusiveListNode) : void
		{
			removeFromList();
			
			_prev = node;
			_next = node._next;
			node._next._prev = this;
			node._next = this;
		}
		
		public function addBeforeNode(node:IntrusiveListNode) : void
		{
			removeFromList();
		
			_prev = node._prev;
			_next = node;
			node._prev._next = this;
			node._prev = this;
		}
		
		public function removeFromList() : void
		{
			var prev:IntrusiveListNode = _prev;
			var next:IntrusiveListNode = _next;
			
			prev._next = next;
			next._prev = prev;
			_next = _prev = this;
		}
		
		public function get Next() : IntrusiveListNode
		{
			return _next;
		}
	}
}