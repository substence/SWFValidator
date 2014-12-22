package com.cc.utils.SharedConfig
{
	import flash.events.Event;
	
	public class ConfigDataLoadEvent extends Event
	{
		/**************
		* Event Types *
		**************/
		
		// Map Data
		public static const LOAD_TERRAIN:String =					"load_terrain";
		
		// Platoon/Squad Data
		public static const LOAD_MAX_PLATOON_CAPACITY:String =		"load_max_platoon_capacity";
		public static const LOAD_MAX_SQUAD_CAPACITY:String =		"load_max_squad_capacity";
		public static const LOAD_MAX_PLATOON_DEPLOYABLE:String =	"load_max_platoon_deployable";
		
		// Unit Data
		public static const LOAD_UNIT_MOVE_TIMES:String =			"load_unit_move_times";
		public static const LOAD_UNIT_SIZES:String =				"load_unit_sizes";
		
		// Deposit Data
		public static const LOAD_DEPOSIT_CAPACITIES:String = 		"load_deposit_capacities";
		
		// Attack Data
		public static const LOAD_ATTACK_CONFIG:String =				"load_attack_config";
		
		// Resource Data
		public static const LOAD_RESOURCE_BONUS:String =			"load_resource_bonus";
		
		// Operation Data
		public static const LOAD_OPERATION_DATA:String =			"load_operation_data";
		public static const LOAD_OPERATION_THORIUM_LOOT:String =	"load_operation_thorium_loot";
		
		// Thorium Data
		public static const LOAD_THORIUM_DATA:String =				"load_thorium_data";
		
		// Spire Data
		public static const LOAD_SPIRE_DATA:String =				"load_spire_data";
		
		// Adv Mission Data
		public static const LOAD_ADVANCED_MISSION_DATA:String =		"load_advanced_mission_data";
		
		// Buff Data
		public static const LOAD_BUFF_DATA:String =					"load_buff_data";
		
		// Custom unit tech data
		public static const LOAD_STATIC_TECH_DATA:String =			"load_static_tech";
		
		// Item store data
		public static const LOAD_ITEM_STORE:String =				"load_item_store";
		
		// PvP Rewards Payout data
		public static const LOAD_PVP_REWARDS_CONFIG:String =		"load_pvp_rewards_config";
		
		// Ops (BlackOps, ShadowOps) configuration
		public static const LOAD_OPSCONFIG:String = 				"load_opsconfig";
		
		// PvE Rewards Payout data
		public static const LOAD_PVE_REWARDS_CONFIG:String =		ConfigDataLoader.CFG_PVE_REWARDS;
		
        // CDN Manifest Data
        public static const LOAD_CDN_MANIFEST_DATA:String =         "load_cdn_manifest_data";
        
        
		protected var _Data:Object;
		
		
		public function ConfigDataLoadEvent(type:String, data:Object, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
			_Data = data;
		}
		
		public function get Data() : Object
		{
			return _Data;
		}
	}
}
