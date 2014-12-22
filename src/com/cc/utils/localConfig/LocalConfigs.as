package com.cc.utils.localConfig
{
	import com.cc.utils.DebugUtils;
	import com.cc.utils.js_utils.WCJSON;
	
	import flash.utils.getTimer;

	public class LocalConfigs
	{
		private static var _instance:LocalConfigs;
		
		private var _environment:int;
		private var _fbData:Object;
		private var _salt:String;
		private var _savingEnabled:Boolean;
		private var _forceTutorial:Boolean;
		private var _RFAttacksEnabled:Boolean;
		private var _debugKeysEnabled:Boolean;
		private var _localSmartFox:Boolean;
		private var _doesAssertLoadTimes:Boolean;
		private var _encodedSalt:String;
		private var _decodedSalt:String;
		private var _playlogPath:String;
		
		public function LocalConfigs(blocker:SingletonBlocker)
		{
			// Set default values
			
			_environment = GLOBAL.DEV_ENVIRONMENT_ONE;
			_fbData = "";
			_savingEnabled = true;
			_forceTutorial = false;
			_salt = "";
			_RFAttacksEnabled = false;
			_encodedSalt = "";
			_decodedSalt = "";
			_debugKeysEnabled = false;
			_localSmartFox = false;
			_playlogPath = "";
		}
		
		CONFIG::local
		{
			public static function get instance() : LocalConfigs
			{
				if (_instance == null)
				{
					_instance = new LocalConfigs(new SingletonBlocker);
				}
				
				return _instance;
			}
		
			public function loadConfigData(configString:String) : void
			{
				var commentlessString:String = stripComments(configString);				
				
				var data:Object = WCJSON.decode(commentlessString);
				
				DebugUtils.assert(data != null, "LocalConfigs::loadConfigData- No config data found");
				
				var envKey:String = data.environment;
				_environment = getDevEnvironment(envKey);
				
				if (_environment == GLOBAL.LIVE_ENVIRONMENT)
				{
					CONFIG::debug
					{
						throw new Error("LocalConfigs::loadConfigData - \"environment\" set to \"live\" but the game is compiling as debug. Please switch the debug compile flag off and recompile before logging into Live.");
						return;
					}
					
					if (!data.allowLive)
					{
						throw new Error("LocalConfigs::loadConfigData - \"environment\" set to \"live\" but the \"allowLive\" parameter is missing or false. Are you sure you know what you're doing?");
						return;
					}
				}
				
				if (data.fbData == null || data.fbData[envKey] == null)
				{
					throw new Error("LocalConfigs::loadConfigData- No valid fbdata found in config file for environment " + envKey);
					return;
				}
				
				_fbData = data.fbData[envKey];
				
				if (data.hasOwnProperty("assertLoadTimes"))
				{
					_doesAssertLoadTimes = data.checkAIBoxLoadTimes;
				}
				
				if (data.hasOwnProperty("enableSaving"))
				{
					// savingEnabled is always false for the Live environment.
					// Only change this if you desperately need to for some reason.
					_savingEnabled = (data.enableSaving && _environment != GLOBAL.LIVE_ENVIRONMENT);
				}
				
				if (data.hasOwnProperty("forceTutorial"))
				{
					_forceTutorial = data.forceTutorial;
				}
				
				if (data.hasOwnProperty("enableRFAttacks"))
				{
					_RFAttacksEnabled = data.enableRFAttacks;
				}
				
				if (data.hasOwnProperty("enableDebugKeys"))
				{
					_debugKeysEnabled = data.enableDebugKeys;
				}
				
				if (data.hasOwnProperty("localSmartFox"))
				{
					_localSmartFox = data.localSmartFox;
				}
				
				if (data.hasOwnProperty("playlogPath"))
				{
					_playlogPath = data.playlogPath;
				}
				
				// For now, use the dev salt on any environment with 'dev' in its name
				var useDevSalt:Boolean = envKey.indexOf("dev") > -1;
				
				DebugUtils.assert(data.saltData != null, "LocalConfigs::loadConfigData- No salt data found in config file");
				
				var saltData:Object;
				if (useDevSalt)
				{
					saltData = data.saltData.dev;
				}
				else
				{
					saltData = data.saltData.nondev;
				}
				
				// If we have a salt we know isn't encoded, cache it immediately as decoded
				if (saltData.hasOwnProperty("encoded")
					&& !saltData.encoded)
				{
					_decodedSalt = saltData.salt;
				}
				else
				{
					_encodedSalt = saltData.salt;
				}
			}
			
			private function stripComments(input:String) : String
			{
				// Strip out // comments
				var regex:RegExp = /(\/\/.*$)/m;
				var output:String = input;
				while (regex.test(output))
				{
					output = output.replace(regex, "");
				}
				
				return output;
			}
			
			private function getDevEnvironment(config:String) : int
			{
				switch (config)
				{
					case "dev1":
						return GLOBAL.DEV_ENVIRONMENT_ONE;
					case "dev2":
						return GLOBAL.DEV_ENVIRONMENT_TWO;
					case "dev3":
						return GLOBAL.DEV_ENVIRONMENT_THREE;
					case "dev4":
						return GLOBAL.DEV_ENVIRONMENT_FOUR;
					case "dev5":
						return GLOBAL.DEV_ENVIRONMENT_FIVE;
					case "dev6":
						return GLOBAL.DEV_ENVIRONMENT_SIX;
                    case "dev7":
                        return GLOBAL.DEV_ENVIRONMENT_SEVEN;
                    case "dev8":
                        return GLOBAL.DEV_ENVIRONMENT_EIGHT;
                    case "dev9":
                        return GLOBAL.DEV_ENVIRONMENT_NINE;
                    case "dev10":
                        return GLOBAL.DEV_ENVIRONMENT_TEN;
                    case "dev11":
                        return GLOBAL.DEV_ENVIRONMENT_ELEVEN;
					case "qatest":
						return GLOBAL.WCQA_ENVIRONMENT;
					case "live":
						return GLOBAL.LIVE_ENVIRONMENT;
					default:
						return GLOBAL.DEV_ENVIRONMENT_INVALID;
				}
			}
			
			public function getSalt(decoder:Function) : String
			{
				DebugUtils.assert(decoder != null, "LocalConfigs::getSalt- No decoder provided");
				
				// Return the decoded salt if it's cached
				if (_decodedSalt == "" || _decodedSalt == null)
				{
					DebugUtils.assert(_encodedSalt != null && _encodedSalt != "", "LocalConfigs::getSalt- No valid decoded or encoded salt found");
					_decodedSalt = decoder(_encodedSalt);
				}
				
				DebugUtils.assert(_decodedSalt != null && _decodedSalt != "", "LocalConfigs::getSalt- Decoded salt was invalid");
				
				return _decodedSalt;
			}
			
			public function get environment() : int
			{
				return _environment;
			}
			
			public function get doesAssertLoadTimes():Boolean
			{
				return _doesAssertLoadTimes;
			}
			
			public function get fbData() : Object
			{
				return _fbData;
			}
			
			public function get forceTutorial() : Boolean
			{
				return _forceTutorial;
			}
			
			public function get savingEnabled() : Boolean
			{
				return _savingEnabled;
			}
			
			public function get RFAttacksEnabled() : Boolean
			{
				return _RFAttacksEnabled;
			}
			
			public function get debugKeysEnabled() : Boolean
			{
				return _debugKeysEnabled;
			}
			
			public function get localSmartFox() : Boolean
			{
				return _localSmartFox;
			}
			
			public function get playlogPath() : String
			{
				return _playlogPath;
			}
		} // CONFIG::local
	}
}

// Used to enforce compile-time safety for the singleton
internal class SingletonBlocker {}
