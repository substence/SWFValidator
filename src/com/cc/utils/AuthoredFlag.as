package com.cc.utils
{
	import flash.utils.Dictionary;
	
	// This class contains the logic necessary to manage several systems
	// competing for setting the value of a given flag.
	//
	// This class can be used anytime a flag is needed that can be
	// changed by several systems. Most of the time, a flag under 
	// these circumstances can cause unwanted behavior since it's not being 
	// managed by any higher power.
	//
	// For example, the front end scripting system might set a flag
	// (ie _baseSaveEnabled) to false during the running of a test.
	// Another system may set that flag to true, which would cause
	// that test to fail or not operate correctly. In this case we want
	// front end scripting system to have the highest privilege when
	// setting this flag. The IAuthoredInterface allows us to define
	// a set of priorities by subsystem, and pass them to the AuthoredFlag
	// class for it to determine what the value is.
	//
	// To use this class, pass it an IAuthoredPriority object that defines
	// the priority set for each subsystem, as well as a default value.
	// The default value will be used when no other authored value is provided.
	// To set the flag's value, the author calls assign(). When an author no
	// longer requires their value to be part of the pool, they call release().
	// This will cause other subsystem's values to 'bubble' up to the top of
	// the priority list.
	//
	public class AuthoredFlag
	{
		private var _priority:IAuthoredPriority;
		private var _default:Boolean;
		
		// Key: Author Priority
		// Value: Boolean value
		private var _authoredValues:Dictionary;		
		
		public function AuthoredFlag(priority:IAuthoredPriority, value:Boolean)
		{
			if(priority == null)
				throw new Error("Priority must be valid");
			
			_priority = priority;
			_default = value;
			_authoredValues = new Dictionary();
		}
		
		public function assign(author:String, value:Boolean) : void
		{
			var priority:Number = _priority.getPriority(author);
			
			if(priority == -1)
			{
				throw new Error("The Author " + author +" does not have the privilege to set this flag");
			}
			
			_authoredValues[priority] = value;
		}
		
		public function release(author:String) : void
		{
			var priority:Number = _priority.getPriority(author);
			
			if(priority != -1)
			{
				delete _authoredValues[priority];
			}
		}
		
		public function get value() : Boolean
		{
			var max:Number = -1;
			for (var priority:String in _authoredValues)
			{
				max = Math.max(max, Number(priority));
			}
			
			return (max > -1) ? _authoredValues[max] : _default;
		}		
	}	
}