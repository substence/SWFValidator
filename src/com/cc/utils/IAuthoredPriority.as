package com.cc.utils
{
	public interface IAuthoredPriority
	{
		// Returns the priority of the Author or -1 if the Author does not exist
		function getPriority(author:String) : Number;
	}
}