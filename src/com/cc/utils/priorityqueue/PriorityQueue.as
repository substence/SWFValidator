package com.cc.utils.priorityqueue
{	
	public class PriorityQueue
	{
		private var _items:Vector.<PriorityQueueItem> = new Vector.<PriorityQueueItem>();
		
		public function enqueue(item:PriorityQueueItem) : void
		{
			if (item)
			{
				_items.push(item);
				heapifyUp(_items.length - 1);
			}
			else
			{
				//DebugUtils.assert(false, "Priority queue: enqueue: Enqueuing null item.");
			}
		}

		public function peek() : PriorityQueueItem
		{
			if (_items.length > 0)
			{
				return _items[0];
			}
			return null;
		}
		
		public function dequeue() : PriorityQueueItem
		{
			if (_items.length > 0)
			{
				var result:PriorityQueueItem = _items[0];
				var lastIndex:int = _items.length - 1;
				
				_items[0] = _items[lastIndex];
				_items.length = lastIndex;
				if (lastIndex > 0)
				{
					heapifyDown(0);
				}
				return result;
			}
			return null;
		}
		
		public function clear() : void
		{
			_items.length = 0;
		}
		
		public function filter(predicate:Function) : void
		{
			if (compactWithPredicate(predicate))
			{
				restoreHeapProperty();
			}
		}
		
		private function heapifyUp(index:int) : void
		{
			var item:PriorityQueueItem = _items[index];
			
			do
			{
				if (index == 0)
				{
					_items[index] = item;
					break;
				}
				
				var parentIndex:int = (index - 1) / 2;
				var parentItem:PriorityQueueItem = _items[parentIndex];
					
				if (parentItem.less(item))
				{
					_items[index] = item;
					break;
				}
				
				_items[index] = parentItem;
				index = parentIndex;
			}
			while (true);			
		}
		
		private function heapifyDown(index:int) : void
		{
			var item:PriorityQueueItem = _items[index];
			var length:int = _items.length;
			
			do
			{
				var leftIndex:int = 2 * index + 1;
				var rightIndex:int = leftIndex + 1;
				var minIndex:int;
				var minItem:PriorityQueueItem;
				
				if (leftIndex < length && rightIndex < length)
				{
					var leftItem:PriorityQueueItem = _items[leftIndex];
					var rightItem:PriorityQueueItem = _items[rightIndex];
					
					if (leftItem.less(rightItem))
					{
						minIndex = leftIndex;
						minItem = leftItem;
					}
					else
					{
						minIndex = rightIndex;
						minItem = rightItem;
					}
				}
				else if (leftIndex < length)
				{
					minIndex = leftIndex;
					minItem = _items[leftIndex];
				}
				else
				{
					_items[index] = item;
					break;
				}
					
				if (minItem.less(item))
				{
					_items[index] = minItem;
					index = minIndex;
				}
				else
				{
					_items[index] = item;
					break;
				}
			}
			while (true);
		}

		private function compactWithPredicate(predicate:Function) : Boolean
		{
			var length:int = 0;
			
			for (var i:int = 0; i < _items.length; ++i)
			{
				var item:PriorityQueueItem = _items[i];
				
				if (predicate(item))
				{
					_items[length] = item;
					++length;
				}
			}
			if (_items.length != length)
			{
				_items.length = length;
				return true;
			}
			return false;
		}		
		
		private function restoreHeapProperty() : void
		{
			function compareItems(a:PriorityQueueItem, b:PriorityQueueItem) : int
			{
				if (a.less(b))
				{
					return -1;
				}
				else if (b.less(a)) 
				{
					return 1;
				}
				
				//DebugUtils.assert(false, "Priority queue: fill: equal priority items found.");
				return 0;
			}
			
			_items.sort(compareItems);
		}
		
//		CONFIG::debug
//		{		
//			public function printPriorities() : void
//			{
//				Logger.debug(">>>priorities start:");
//				for each (var item:PriorityQueueItem in _items)
//				{
//					if (item != null)
//					{	
//						Logger.debug("    " + item.priority);
//					}
//					else
//					{
//						Logger.debug("    NO ITEM");
//					}
//				}
//				Logger.debug(">>>priorities end: heap? " + checkHeapProperty());
//			}
//		}
		
		/***************************
		 * For unit testing
		 ***************************/
		
		public function checkHeapProperty() : Boolean
		{
			var length:int = _items.length;
			
			for (var index:int = 0; index < length; ++index)
			{
				var item:PriorityQueueItem = _items[index];
				var leftIndex:int = 2 * index + 1;
				var rightIndex:int = leftIndex + 1;
					
				if (leftIndex < length && !item.less(_items[leftIndex]))
				{
					return false;
				}
				if (rightIndex < length  && !item.less(_items[rightIndex]))
				{
					return false;
				}
			}
			return true;
		}
		
		public function get length() : int
		{
			return _items.length;
		}
		
	}
}