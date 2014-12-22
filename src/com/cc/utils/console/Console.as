package com.cc.utils.console
{
	import com.adverserealms.log.Logger;
	
	import flash.utils.Dictionary;

	public class Console
	{
		private var _RegistredCommands:Dictionary;	// Key: cmd name, Value: ConsoleCommand
		
		private var _CurrInput:String;				// Currently held input text
		
		private var _EntryList:Vector.<String>;		// List of previous inputed entries. ***The last element will always be an empty string
		private var _MaxEntryLimit:int = 100;		// Number of entries to keep
		private var _SelectedEntry:int = -1;		// Index of the currently selected entry in the _EntryList
		
		
		public function Console()
		{
			_RegistredCommands = new Dictionary(true);
			
			_CurrInput = "";
			
			_EntryList = new Vector.<String>();
			_EntryList.push("");
			
			_MaxEntryLimit = (_MaxEntryLimit < 1) ? 1 : _MaxEntryLimit;
		}
		
		public function CleanUp() : void
		{
			_RegistredCommands = new Dictionary(true);
			Logger.console("Unregistered all commands");
		}
		
		public function RegisterCommand(name:String, callback:Function, helpMsg:String = "") : void
		{
			_RegistredCommands[name.toLowerCase()] = new ConsoleCommand(name, callback, helpMsg);
		}
		
		public function UnregisterCommand(name:String) : void
		{
			_RegistredCommands[name.toLowerCase()] = null;
		}
		
		public function ExecuteCommand(name:String, args:Array = null) : void
		{
			var cmd:ConsoleCommand = _RegistredCommands[name.toLowerCase()];
			if (cmd)
			{
				cmd.Execute(args);
			}
		}
		
		public function CycleEntryNext() : void
		{
			var lastIndex:int = _EntryList.length - 1;
			var index:int = _SelectedEntry + 1;
			if (index > lastIndex)
			{
				index = lastIndex;
			}
			
			SetIndex(index);
		}
		
		public function CycleEntryPrev() : void
		{
			var index:int = _SelectedEntry - 1;
			if (index < 0)
			{
				index = 0;
			}
			
			SetIndex(index);
		}
		
		public function ComitInput() : void
		{
			if (_CurrInput == null || _CurrInput == "")
			{
				return;
			}
			
			
			// Add the input and swap with the previous (Keep the empty input at the end)
			_EntryList.push(_CurrInput);
			var lastIndex:int = _EntryList.length - 1;
			if (lastIndex > 0)
			{
				_EntryList[lastIndex] = _EntryList[lastIndex - 1];
				_EntryList[lastIndex - 1] = _CurrInput;
			}
			
			
			// Limit entries
			if (_EntryList.length > _MaxEntryLimit)
			{
				_EntryList.shift();
			}
			
			
			SetIndex();
		}
		
		private function SetIndex(index:int = -1) : void
		{
			var inputCount:int = _EntryList.length;
			var input:String = "";
			
			if (index == -1)
			{
				// Set the index to the end
				_SelectedEntry = inputCount - 1;
				input = _EntryList[_SelectedEntry];
			}
			else if (index >= 0 && index <= inputCount)
			{
				_SelectedEntry = index;
				input = _EntryList[_SelectedEntry];
			}
			else
			{
				_SelectedEntry = 0;
			}
			
			_CurrInput = input;
		}
		
		public function get CurrentInput() : String
		{
			return _CurrInput;
		}
		
		public function set CurrentInput(input:String) : void
		{
			_CurrInput = input;
		}
		
		public function GetHelpText(name:String) : String
		{
			var result:String;
			
			var cmd:ConsoleCommand = _RegistredCommands[name.toLowerCase()];
			if (cmd)
			{
				result = cmd.HelpText;
			}
			
			return result;
		}
		
		public function IsDuplicate(name:String, callback:Function) : Boolean
		{
			name = name.toLowerCase();
			return (_RegistredCommands[name] != null && _RegistredCommands[name].Callback == callback);
		}
		
		public function HasCommand(name:String) : Boolean
		{
			if (name)
			{
				return (_RegistredCommands[name.toLowerCase()] != null);
			}
			
			return false;
		}
		
		public static function StringToBoolean(str:String):Boolean
		{
			switch (str.toLowerCase())
			{
				case "true":
				case "yes":
					return true;
				default:
					return Boolean(int(str));
			}
		}
		
		public function get RegisteredCommandNames() : Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			
			for each (var cmd:ConsoleCommand in _RegistredCommands)
			{
				if (cmd)
				{
					result.push(cmd.Name);
				}
			}
			
			return result;
		}
		
		public function GetMatchingCmdNames(pattern:String, matchExtra:Boolean = false) : Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			
			if (pattern)
			{
				pattern = pattern.toLowerCase();
				
				for each (var cmd:ConsoleCommand in _RegistredCommands)
				{
					if (cmd)
					{
						var index:int = cmd.Name.toLowerCase().search(pattern);
						if (index == 0 || (matchExtra && index > 0))
						{
							result.push(cmd.Name);
						}
					}	
				}
			}
			
			return result.sort(Array.CASEINSENSITIVE);
		}
	}
}