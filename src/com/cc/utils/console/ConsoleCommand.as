package com.cc.utils.console
{
	internal class ConsoleCommand
	{
		private var _Name:String;
		private var _Callback:Function;
		private var _HelpText:String;
		
		public function ConsoleCommand(name:String, callback:Function, helpText:String = null)
		{
			_Name = name;
			_Callback = callback;
			_HelpText = helpText;
		}
		
		public function Execute(args:Array = null) : void
		{
			if (_Callback != null)
			{
				_Callback(args);
			}
		}
		
		public function get Name() : String
		{
			return _Name;
		}
		
		public function get HelpText() : String
		{
			return _HelpText;
		}
		
		public function get Callback() : Function
		{
			return _Callback;
		}
	}
}