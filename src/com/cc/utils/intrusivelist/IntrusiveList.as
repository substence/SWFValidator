package com.cc.utils.intrusivelist
{
	public class IntrusiveList
	{
		private var _sentinel:IntrusiveListNode = new IntrusiveListNode();
		
		public function addFront(item:IntrusiveListNode) : void
		{
			item.addAfterNode(_sentinel);
		}
		
		public function addBack(item:IntrusiveListNode) : void
		{
			item.addAfterNode(_sentinel);
		}
		
		public function getIter() : IntrusiveListIter
		{
			return new IntrusiveListIter(_sentinel);
		}
	}
}