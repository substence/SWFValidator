package com.cc.utils.SharedConfig
{
	import com.adverserealms.log.Logger;
	import com.cc.utils.js_utils.WCJSON;
	import com.kixeye.net.proto.Config;
	import com.kixeye.wc.resources.CDNManifestDataManager;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class ConfigDataLoader
	{
		/**********************
		* Shared Config Names *
		**********************/
		
		// Map Data
		public static const CFG_TERRAIN:String =					"terrain";
		
		// Platoon/Squad Data
		public static const CFG_MAX_PLATOON_CAPACITY:String =		"max_platoon_capacity";
		public static const CFG_MAX_SQUAD_CAPACITY:String =			"max_squad_capacity";
		public static const CFG_MAX_PLATOON_DEPLOYABLE:String =		"max_platoon_deployable";
		
		// Unit Data
		public static const CFG_UNIT_MOVE_TIMES:String =			"unit_move_times";
		public static const CFG_UNIT_SIZES:String =					"unit_sizes";
		
		// Deposit Data
		public static const CFG_DEPOSIT_CAPACITIES:String =			"deposit_capacities";
		
		// Attack Data
		public static const CFG_ATTACK_CONFIG:String =				"attack_config";
		
		// Resource Data
		public static const CFG_RESOURCE_BONUS:String = 			"resource_bonus";
		
		// Operation Data
		public static const CFG_OPERATION_DATA:String =				"game_event_rules";
		public static const CFG_OPERATION_THORIUM_LOOT:String =		"thorium_event_drop";
		
		// Thorium Data
		public static const CFG_THORIUM_DATA:String =				"thorium_spawning_rules";
		
		// Spire Data
		public static const CFG_SPIRE_DATA:String =					"spire_spawning_rules";
		
		// Advanced Mission Spawning Data
		public static const CFG_ADVANCED_MISSION_DATA:String =		"adv_mission_rogue_spawning_rules";
		
		// Buff rules
		public static const CFG_BUFF_RULES:String =					"buff_rules";
		
		// Custom unit tech data
		public static const CFG_STATIC_TECH_DATA:String =			"static_tech";
		
		// Item Store data
		public static const CFG_ITEM_STORE:String =					"item_store_data";
		
		// PvP rewards configurations
		public static const CFG_PVP_REWARDS:String =				"pvp_rewards_config";
		
		// Ops (BlackOps, ShadowOps) configuration
		public static const CFG_OPSCONFIG:String = 					"ops_config";
		
		// PvE rewards configurations
		public static const CFG_PVE_REWARDS:String =				"loot_tables";
		
        // CDN Asset Manifest
        public static const CDN_ASSET_MANIFEST:String =             "manifest_config";
        
		// Event Dispatcher
		private static var _EventDispatcher:EventDispatcher = new EventDispatcher();
		
		private static var _configCache:Dictionary;
		private static var _configCacheTimeStamp:Number;
		
		public function ConfigDataLoader()
		{
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
		{
			if (_EventDispatcher)
			{
				_EventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
		{
			if (_EventDispatcher)
			{
				_EventDispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		public static function getCachedConfig(configName:String):Object
		{
			return _configCache[configName];
		}
		
		public static function configCacheTimeStamp():Number
		{
			return _configCacheTimeStamp;	
		}
		
		public static function LoadConfigData(configList:Array) : void
		{
			var data:Object;
			
			_configCache = new Dictionary();
			_configCacheTimeStamp = GLOBAL.getServerTimestampSeconds();
			for each (var config:Config in configList)
			{
				if (config == null)
				{
					continue;
				}
				
				// Data comes in as a String
				data = (config.values) ? WCJSON.decode(config.values) : null;
				
				//Store the data in a cache so other classes who don't need it on demand can access it later
				_configCache[config.name] = data;
				
				switch (config.name)
				{
					case CFG_TERRAIN:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_TERRAIN, data));
					}
					break;
					
					case CFG_MAX_PLATOON_CAPACITY:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_MAX_PLATOON_CAPACITY, data));
					}
					break;
					
					case CFG_MAX_SQUAD_CAPACITY:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_MAX_SQUAD_CAPACITY, data));
					}
					break;
					
					case CFG_MAX_PLATOON_DEPLOYABLE:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_MAX_PLATOON_DEPLOYABLE, data));
					}
					break;
					
					case CFG_UNIT_MOVE_TIMES:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_UNIT_MOVE_TIMES, data));
					}
					break;
					
					case CFG_UNIT_SIZES:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_UNIT_SIZES, data));
					}
					break;
					
					case CFG_DEPOSIT_CAPACITIES:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_DEPOSIT_CAPACITIES, data));
					}
					break;
					
					case CFG_ATTACK_CONFIG:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_ATTACK_CONFIG, data));
					}
					break;
					
					case CFG_RESOURCE_BONUS:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_RESOURCE_BONUS, data));
					}
					break;
					
					case CFG_OPERATION_DATA:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_OPERATION_DATA, data));
					}
					break;
					
					case CFG_ITEM_STORE:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_ITEM_STORE, data));
					}
					break;
					
					case CFG_PVP_REWARDS:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_PVP_REWARDS_CONFIG, data));
					}
					break;
										
					case CFG_OPERATION_THORIUM_LOOT:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_OPERATION_THORIUM_LOOT, data));
					}
					break;
					
					case CFG_THORIUM_DATA:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_THORIUM_DATA, data));
					}
					break;
					
					case CFG_SPIRE_DATA:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_SPIRE_DATA, data));
					}
					break;
					
					case CFG_ADVANCED_MISSION_DATA:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_ADVANCED_MISSION_DATA, data));
					}
					break;
					
					case CFG_BUFF_RULES:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_BUFF_DATA, data));
					}
					break;
					
					case CFG_STATIC_TECH_DATA:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_STATIC_TECH_DATA, data));
					}
						
					case CFG_PVE_REWARDS:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_PVE_REWARDS_CONFIG, data));
					}
					break;
					
					case CFG_OPSCONFIG:
					{
						_EventDispatcher.dispatchEvent(new ConfigDataLoadEvent(ConfigDataLoadEvent.LOAD_OPSCONFIG, data));
					}
					break;
                    
                    case CDN_ASSET_MANIFEST:
                    {
                        CDNManifestDataManager.proccessManifestData( data );
                    }
                    break;
				}
			}
		}
	}
}
