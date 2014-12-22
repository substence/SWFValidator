package com.cc.utils
{
	public class TestUtils
	{
		public function TestUtils()
		{
		}
		
		public static function assertMemberwiseEqual(input:Object, expected:Object, path:String=""):String
		{
			// Tests two objects for member-wise equality. Returns a string description of the first
			// instance where the two objects differ, or null if both objects are the same.
			
			var key:String;
			for (key in input)
			{
				// Present in input, missing in expected
				if (!expected.hasOwnProperty(key))
				{
					return "input" + path + "." + key + " could not be found in expected";
				}
			}
			
			for (key in expected)
			{
				// Present in input, missing in expected
				if (!input.hasOwnProperty(key))
				{
					return "input" + path + "." + key + " does not exist, but it is present in expected";
				}
				
				// Present in both; test for equality
				var result:String = assertMemberwiseEqual(input[key], expected[key], path + "." + key);
				if (result)
				{
					// Failure
					return result;
				}
			}
			
			if (!(typeof(input) == "object"))
			{
				// Present in both, but values differ
				if (input != expected)
				{
					return "input" + path + " = " + input + ", expected: " + expected;
				}
			}
			
			// Success
			return null;
		}
	}
}