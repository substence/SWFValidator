package com.cc.utils.keybinder
{
	import com.adverserealms.log.Logger;
	import com.cc.utils.DebugUtils;
	import com.cc.utils.console.ConsoleController;
	
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	public class KeyBinder
	{
		private static var _instance:KeyBinder;
		
		private var _bindings:Dictionary;
		
		private static const VERBOSE:Boolean = false;
		
		// NOTES:
		// 1. Bindings that use Alt are unsupported, as they will not work properly, at least one Mac
		// 2. Cmd and Ctrl both generate the same keycode (17) and set the ctrlKey member of a KeyboardEvent.
		// 3. Alt does not generate a KeyboardEvent by itself, but Shift, Ctrl, and Cmd do.
		
		public function KeyBinder(blocker:SingletonBlocker)
		{
			_bindings = new Dictionary();
			
			CONFIG::debug
			{
				ConsoleController.Instance.RegisterCommand("listBindings", listBindings, "listBindings - Show a list of all current dynamic key bindings");
				ConsoleController.Instance.RegisterCommand("unbindAll", unbindAll, "unbindAll - Removes all current dynamic key bindings");
				ConsoleController.Instance.RegisterCommand("unbind", unbind, "unbind <key signature> - Unbinds the command mapped to a particular key signature (see: listBindings)");
			}
		}
		
		public static function get instance():KeyBinder
		{
			if (_instance == null)
			{
				_instance = new KeyBinder(new SingletonBlocker());
			}
			
			return _instance;
		}
		
		public function parseBindCommand(input:String):void
		{
			var parts:Array = input.split("\"");
			if (parts != null && parts.length >= 2)
			{
				var sig:String = KeySignature.generateFromString(String(parts[0]));
				_bindings[sig] = String(parts[1]);
				
				if (VERBOSE)
				{
					Logger.debug("KEYBINDER: Adding new binding -- sig: " + sig + ", command: " + _bindings[sig]);
				}
			}
			else
			{
				DebugUtils.assert(false, "KeyBinder.parseBindCommand() -- Input must consist of a list of keys followed by a command in quotes");
			}
		}
		
		public function processKeyboardEvent(keyEvent:KeyboardEvent):Boolean
		{
			if (VERBOSE)
			{
				Logger.debug("KEYBINDER: Keycode = " + keyEvent.keyCode + ", charcode = " + keyEvent.charCode);
			}

			var sig:String = KeySignature.generateFromEvent(keyEvent);
			if (_bindings.hasOwnProperty(sig))
			{
				var command:String = _bindings[sig] as String;
				if (command != null)
				{
					ConsoleController.Instance.ParseInput(command);
					if (VERBOSE)
					{
						Logger.debug("KEYBINDER: Processed command \"" + command + "\"");
					}
					return true;
				}
			}
			
			if (VERBOSE)
			{
				Logger.debug("KEYBINDER: No binding for key signature " + sig);
			}
			return false;
		}
		
		CONFIG::debug
		{
			private function listBindings(args:Array = null):void
			{
				var count:int = 0;
				
				var output:String = "\nCurrent key bindings:\n";
				for (var sig:String in _bindings)
				{
					output += "  " + sig + " - \"" + _bindings[sig] + "\"\n";
					++count;
				}
				
				if (count > 0)
				{
					Logger.debug(output);
				}
				else
				{
					Logger.debug("No current bindings");
				}
			}
		} // CONFIG::debug
		
		CONFIG::debug
		{
			private function unbindAll(args:Array = null):void
			{
				Logger.debug("Removing all key bindings");
				
				_bindings = new Dictionary();
			}
		} // CONFIG::debug
		
		CONFIG::debug
		{
			private function unbind(args:Array = null):void
			{
				if (args && args.length > 0)
				{
					var keys:String = args.join(" ");
					var sig:String = KeySignature.generateFromString(keys);
					if (_bindings.hasOwnProperty(sig))
					{
						delete _bindings[sig];
					}
				}
			}
		} // CONFIG::debug
	}
}

class SingletonBlocker { public function SingletonBlocker() {} }
