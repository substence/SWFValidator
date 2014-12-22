package com.cc.utils
{
	import flash.utils.Dictionary;
	
	public class AuthoredPriority implements IAuthoredPriority
	{
		// Key: Lower cased author string
		// Value: Priority (Number)
		private var _authors:Dictionary;
		
		public function AuthoredPriority()
		{
			_authors = new Dictionary();
		}
		
		public function addAuthor(author:String, priority:Number) : void
		{
			if(author == null)
			{
				throw new Error("author must be valid");
			}
			
			_authors[author.toLowerCase()] = priority;
		}
		
		public function getPriority(author:String) : Number
		{
			for (var key:String in _authors)
			{
				if(key == author.toLowerCase())
				{
					return _authors[key];
				}
			}
			
			return -1;
		}
	}
}