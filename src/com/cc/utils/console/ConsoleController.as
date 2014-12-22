package com.cc.utils.console
{
	import com.adverserealms.log.Logger;
	import com.cc.utils.TextUtils;
	import com.cc.utils.keybinder.KeyBinder;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getQualifiedClassName;

	public class ConsoleController
	{
		private static var _Instance:ConsoleController;
		
		private var _Model:Console;
		private var _View:ConsoleView;
		
		
		public function ConsoleController(key:SingletonBlocker) {}
		
		public static function get Instance() : ConsoleController
		{
			if (_Instance == null)
			{
				_Instance = new ConsoleController(new SingletonBlocker());
				
				CONFIG::debug
				{
					_Instance.Init();
				} //CONFIG::debug
			}
			
			return _Instance;
		}
		
		public function Init() : void
		{
			CONFIG::debug
			{
				_Model = new Console();
				_View = null;
				
				
				RegisterDefaultCommands();
			} //CONFIG::debug
		}
		
		private function RegisterDefaultCommands() : void
		{
			CONFIG::debug
			{
				RegisterCommand("clear", CmdClear, "Clears the screen");
				RegisterCommand("help", CmdHelp, "Type \"list\" to get a list of all the registered commands\nType \"help name\" to find out more information about command \"name\"");
				RegisterCommand("bind", BindKey, "bind <key> <[modifiers]> \"<command>\"\n\tDynamically bind a key to a console command");
				RegisterCommand("runScript", RunScript, "runScript <scriptname>\n\tRuns a script of console commands");
				RegisterCommand("echo", CmdEcho, "echo <text>\n\tEchoes text back to the console (mostly for testing purposes");
				
				var helpMsg:String = "list:\n\n\tDisplays a list of the currently registered commands by default. Can also pass in a type to list information from.\n"
				helpMsg += "\n\tArgs:\n";
				helpMsg += "\n\t\t\t[0] (Optional) Type:\tType of info to list. Default is the list of commands. Current lists are:\n";
				helpMsg += "\t\t\t\t\tcommands\n";
				helpMsg += "\t\t\t\t\tunit_ids\n";
				helpMsg += "\t\t\t\t\tunit_names\n";
				helpMsg += "\t\t\t\t\tbuilding_ids\n";
				helpMsg += "\t\t\t\t\thotkeys\n";
				RegisterCommand("list", CmdList, helpMsg);
				
				RegisterCommand("exit", CmdExit, "exit:\n\n\tCloses the console window.");
				RegisterCommand("kickup", CmdKickup, "kickup:\n\n\tArg0 Mode: 4d3d3d3");
				RegisterCommand("setAlpha", CmdSetAlpha, "setAlpha <alpha>\nSets the background alpha");
				RegisterCommand("isObfuscated", CmdIsObfuscated, "isObfuscated\nReturns true if the client has been built in obfuscated mode, false otherwise.");
				
			} //CONFIG::debug
		}
		
		public function RegisterCommand(name:String, callback:Function, helpMsg:String = "") : void
		{
			CONFIG::debug
			{
				if (_Model.IsDuplicate(name, callback))
				{
					/*Logger.console("Attempting to register \"" + name + "\". which is already registered with the same callback.");*/
					//do nothing in this case
				}
				else if (_Model.HasCommand(name))
				{
					Logger.error("Console: Could not register command \"" + name + "\". Name is already taken!");
				}
				else
				{
					_Model.RegisterCommand(name, callback, helpMsg);
				}
			} //CONFIG::debug
		}
		
		public function UnregisterCommand(name:String) : void
		{
			CONFIG::debug
			{
				if (_Model.HasCommand(name))
				{
					_Model.UnregisterCommand(name);
				}
				else
				{
					/*Logger.error("Console: Could not unregister command \"" + name + "\". Command not found!");*/
					//do nothing in this case
				}
			} //CONFIG::debug
		}
		
		private function ExecuteCommand(name:String, args:Array = null) : Boolean
		{
			CONFIG::debug
			{
				if (_Model.HasCommand(name))
				{
					_Model.ExecuteCommand(name, args);
					return true;
				}
				else
				{
					Logger.error("Console: Could not find command \"" + name + "\"");
					return false;
				}
			} //CONFIG::debug
			
			return false;
		}
		
		public function IsVisible() : Boolean
		{
			CONFIG::debug
			{
				return _View != null;
			} //CONFIG::debug
			return false;
		}
		
		public function HideDisplay() : void
		{
			CONFIG::debug
			{
				if (_View)
				{
					GLOBAL._ROOT.stage.removeChild(_View);
					
					Logger.getInstance().removeEventListener("logUpdated", OnLogUpdate);
					
					_View.Cleanup();
					_View = null;
				}
			}
		}
		
		public function ShowDisplay() : void
		{
			CONFIG::debug
			{
				if (!_View)
				{
					_View = new ConsoleView();
					_View.x = 25;
					_View.y = 100;
					
					Logger.getInstance().addEventListener("logUpdated", OnLogUpdate);
					
					GLOBAL._ROOT.stage.addChild(_View);
				}
			}
		}
		
		public function ToggleDisplay() : void
		{
			CONFIG::debug
			{
				if (_View)
				{
					HideDisplay();
				}
				else
				{
					ShowDisplay();
				}
			} //CONFIG::debug
		}
		
		private function OnLogUpdate(event:Event = null) : void
		{
			CONFIG::debug
			{
				if (_View)
				{
					_View.UpdateOutput();
				}
			} //CONFIG::debug
		}
		
		public function get OutputText() : String
		{
			CONFIG::debug
			{
				return Logger.getInstance().text;
			} //CONFIG::debug
			
			return "";
		}
		
		public function CycleEntryNext() : void
		{
			CONFIG::debug
			{
				_Model.CycleEntryNext();
				
				if (_View)
				{
					_View.UpdateInput();
				}
			} //CONFIG::debug
		}
		
		public function CycleEntryPrev() : void
		{
			CONFIG::debug
			{
				_Model.CycleEntryPrev();
				
				if (_View)
				{
					_View.UpdateInput();
				}
			} //CONFIG::debug
		}
		
		public function get CurrentInput() : String
		{
			CONFIG::debug
			{
				return _Model.CurrentInput;
			} //CONFIG::debug
			
			return "";
		}
		
		public function set CurrentInput(input:String) : void
		{
			CONFIG::debug
			{
				if (input == null)
				{
					input = "";
				}
				
				_Model.CurrentInput = input;
			} //CONFIG::debug
		}
		
		public function CommitInput() : void
		{
			CONFIG::debug
			{
				var input:String = _Model.CurrentInput;
				
				
				// Display the inputted text
				Logger.console(input);
				
				_Model.ComitInput();
				
				ParseInput(input);
				
				
				if (_View)
				{
					_View.UpdateInput();
				}
			} //CONFIG::debug
		}
		
		public function TryAutocomplete(matchExtra:Boolean = false) : void
		{
			CONFIG::debug
			{
				var tokens:Array = TextUtils.trimWhitespace(_Model.CurrentInput).split(" ");
				if (tokens.length > 0)
				{
					var pattern:String = tokens[tokens.length - 1];
					
					// Get registered command names matching the last input token:
					// [Input: case-insensitive String]
					// [Output: case-insensitive alphanumeric sorted Vector.<String> of intact Command Names]
					var matches:Vector.<String> = _Model.GetMatchingCmdNames(pattern, matchExtra);
					
					if (matches.length == 1)
					{
						// We only found 1 match, so autocomplete the user's input
						var input:String = _Model.CurrentInput;
						_Model.CurrentInput = input.substring(0, input.lastIndexOf(pattern)) + matches[0];
						
						if (_View)
						{
							_View.UpdateInput();
						}
					}
					else if (matches.length > 1)
					{
						// Found more than 1 match, so display them all to the user
						var output:String = "";
						var smallestString:int = 0;
						for (var i:int = 0, length:int = matches.length; i < length; ++i)
						{
							output += "\t" + matches[i] + "\n";
							if(smallestString < matches[i].length)
							{
								smallestString = matches[i].length;
							}
						}
						
						if (!matchExtra)
						{
							//Auto complete in the console to common string in matches 
							var commonLength:int = 0;
							var char:String;
							var finished:Boolean = false;
							for (i = 0; i < smallestString; ++i)
							{
								char = matches[0].substr(i,1);
								for (var j:int = 1; j < matches.length; ++j)
								{
									if(matches[j].substr(i,1) != char )
									{
										finished = true;
										break;
									}
								}
								
								if(!finished)
								{
									++commonLength;
								}
								else
								{
									break;
								}
							}
						
							_Model.CurrentInput = matches[0].substr(0,commonLength);
						}
						else
						{
							_Model.CurrentInput = pattern;
						}
						
						if (_View)
						{
							_View.UpdateInput();
						}
						
						Logger.console("\n\n[" + matches.length + " matches found]:\n\n" + output);
					}
				}
			} //CONFIG::debug
		}
		
		public function ParseInput(input:String) : void
		{
			CONFIG::debug
			{
				input = TextUtils.trimWhitespace(input);
				
				var cmdName:String;
				var cmdArgs:Array;
				
				// Try to get the command name & args
				var indexCmdEnd:int = input.indexOf(" ");
				if (indexCmdEnd == -1)
				{
					cmdName = input;
				}
				else
				{
					cmdName = input.slice(0, indexCmdEnd);
					cmdArgs = input.substring(indexCmdEnd + 1).split(" ");
				}
				
				if (cmdName == null || cmdName == "")
				{
					Logger.error("Console: Failed to parse input: " + input);
					return;
				}
				
				
				ExecuteCommand(cmdName, cmdArgs);
			} //CONFIG::debug
		}

		private function BindKey(args:Array = null) : void
		{
			// There must be at least two arguments for the key and the command
			if (args != null && args.length >= 2)
			{
				KeyBinder.instance.parseBindCommand(args.join(" "));
			}
			else
			{
				Logger.console("Invalid bind input");
			}
		}
		
		public function RunScript(args:Array = null) : void
		{
			if (CONFIG::local && CONFIG::debug)
			{
				// This is relative to the staging folder
				const DIRECTORY:String = "consolescripts/"
				var scriptName:String = "startup";
				if (args && args.length > 0)
				{
					scriptName = String(args[0]);
				}
				
				if (scriptName.toLowerCase().indexOf(".txt") == -1)
				{
					scriptName += ".txt";
				}
				
				var myTextLoader:URLLoader = new URLLoader();				
				myTextLoader.addEventListener(Event.COMPLETE, onLoaded);
				myTextLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				
				function onLoaded(e:Event):void {
					Logger.console("Script loaded: \"" + scriptName + "\"");
					myTextLoader.removeEventListener(Event.COMPLETE, onLoaded);
					myTextLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
					var lines:Array = e.target.data.split(/\n/);
					for each (var line:String in lines)
					{
						// Don't print out echo commands, just process them
						if (line.indexOf("echo ") != 0)
						{
							Logger.console("> " + line);
						}
						ParseInput(line);
					}
				}
				
				function onError(e:Event):void {
					myTextLoader.removeEventListener(Event.COMPLETE, onLoaded);
					myTextLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
					Logger.console("Error loading script " + scriptName);
				}
				
				myTextLoader.load(new URLRequest(DIRECTORY + scriptName));
			}
		}

		private function CmdClear(args:Array = null) : void
		{
			CONFIG::debug
			{
				Logger.clear();
			}
		}
		
		private function CmdHelp(args:Array = null) : void
		{
			CONFIG::debug
			{
				var cmdName:String;
				if (args && args.length > 0)
				{
					cmdName = args[0];
				}
				
				
				// If there was no command name attached used the default help text
				if (cmdName == null || cmdName == "")
				{
					// Show default help text
					cmdName = "help";
				}
				
				
				if (_Model.HasCommand(cmdName))
				{
					var helpText:String = _Model.GetHelpText(cmdName);
					if (helpText == null || helpText == "")
					{
						helpText = "Command \"" + cmdName + "\" has no help text";
					}
					
					helpText = "\n\n" + helpText + "\n";
					Logger.console(helpText);
				}
				else
				{
					Logger.error("Console: Could not find command \"" + cmdName + "\"");
					return;
				}
			} //CONFIG::debug
		}
		
		private function CmdEcho(args:Array = null) : void
		{
			CONFIG::debug
			{
				Logger.console(args.join(" ").replace(/\"/g,''));
			}
		}
		
		private function CmdList(args:Array = null) : void
		{
			CONFIG::debug
			{
				var title:String;
				var body:String;
				
				var showDefault:Boolean = (args == null || args.length == 0);
				if (showDefault == false)
				{
					switch (args[0] as String)
					{
						default:
						{
							showDefault = true;
						}
					}
				}
				
				if (showDefault)
				{
					var nameList:Vector.<String> = _Model.RegisteredCommandNames;
					if (nameList)
					{
						title = "List of registered commands:";
						body = "";
						
						nameList = nameList.sort(Array.CASEINSENSITIVE);
						for (var i:int = 0, length:int = nameList.length; i < length; ++i)
						{
							var name:String = nameList[i];
							if (name != null || name != "")
							{
								body += "\t" + name + "\n";
							}
						}
					}
				}
				
				var output:String = "\n\n" + title + "\n\n" + body + "\n";
				Logger.console(output);
			} //CONFIG::debug
		}
		
		private function CmdExit(args:Array = null) : void
		{
			CONFIG::debug
			{
				ToggleDisplay();
			} //CONFIG::debug
		}
		
		private function CmdKickup(args:Array = null) : void
		{
			CONFIG::debug
			{
				if (args && args.length > 0)
				{
					if (args[0] == "4d3d3d3")
					{
						Logger.console("4d3d3d3 engaged.");
					}
				}
			} //CONFIG::debug
		}
		
		private function CmdSetAlpha(args:Array = null) : void
		{
			CONFIG::debug
			{
				if (args && args.length > 0)
				{
					var backgroundAlpha:Number = Number(args[0]);
					_View.drawBackground(backgroundAlpha);
				}
			} //CONFIG::debug
		}
		
		private function CmdIsObfuscated(args:Array = null):void
		{
			if (getQualifiedClassName(this) == "com.cc.utils.console::ConsoleController")
			{
				Logger.debug("false");
			}
			else
			{
				Logger.debug("true");
			}
		}		
	}
}

// Used to enforce compile-time safety for the singleton
internal class SingletonBlocker {}