package com.cc.utils
{
	import com.kixeye.wc.resources.WCLocalizer;
	
	import flash.utils.Dictionary;

	public class HaltErrorCodes
	{
		//*************//
		// ERROR CODES //
		//*************//
		public static const VALID:int = 0;
		
		// One-offs
		public static const GAME_DATA_PRELOAD_FAILED:int = 1000;
		public static const INVALID_MILITARY_RANK:int = 1001;
		public static const PENDING_PURCHASE_COLLISION:int = 1002;
		public static const DEPOSIT_INFO_MISSING_AFTER_BATTLE:int = 1003;
		public static const COLLECT_NULL_MISSION:int = 1004;
		public static const COLLECT_UNCOLLECTABLE_MISSION:int = 1005;
		public static const CALCULATE_FRACTION_COST:int = 1006;
		
		// Framework interaction
		public static const INVALID_WRAPPER:int = 2000;
		public static const INVALID_SIGNATURE:int = 2001;
		public static const MESSAGE_TOO_OLD:int = 2002;
		public static const MESSAGE_NOT_OLD_ENOUGH:int = 2003;
		public static const DUPLICATE_SIGNATURE:int = 2004;
		public static const GENERIC_RESPONSE_HASH_MISMATCH:int = 2005;
		
		public static const HOME_BASE_ID_MISMATCH:int = 2010;
		public static const BASE_LOCKED:int = 2011;
		public static const BASE_LOAD_ERROR_RECEIVED:int = 2012;
		
		public static const GENERIC_LOAD_ERROR_RECEIVED:int = 2020;
		public static const GENERIC_LOAD_REQUEST_FAILED:int = 2021;
		
		public static const GENERIC_SAVE_ERROR_RECEIVED:int = 2030;
		public static const GENERIC_SAVE_REQUEST_FAILED:int = 2031;
		public static const GENERIC_PAGE_REQUEST_FAILED:int = 2032;
		public static const BASE_SAVE_ERROR_RECEIVED:int = 2033;
		public static const BASE_PAGE_ERROR_RECEIVED:int = 2034;
		public static const DEPOSITS_SAVE_ERROR_RECEIVED:int = 2035;
		
		public static const PLAY_NOW_INVALID_RESPONSE:int = 2040;
		public static const PLAY_NOW_SAVE_REQUEST_FAILED:int = 2041;
		
		public static const FLAGS_ERROR_RECEIVED:int = 2050;
		
		public static const GET_FRIENDS_ERROR_RECEIVED:int = 2060;
		public static const GET_FRIENDS_REQUEST_FAILED:int = 2061;
		
		public static const LOAD_OWNED_DEPOSIT_DATA_ERROR_RECEIVED:int = 2070;
		public static const LOAD_OWNED_DEPOSIT_DATA_REQUEST_FAILED:int = 2071;
		
		public static const LOCAL_LOGIN_ERROR_RECEIVED:int = 2080;
		public static const LOCAL_LOGIN_REQUEST_FAILED:int = 2081;
		public static const JS_LOGIN_HASH_MISMATCH:int = 2082;
		public static const JS_LOGIN_ERROR_RECEIVED:int = 2083;
		public static const REST_LOGIN_ERROR_RECEIVED:int = 2084;
		
		public static const JS_CALL_FAILED:int = 2090;
		public static const JS_CALL_WITH_CALLBACK_FAILED:int = 2091;
		public static const JS_ADD_CALLBACK_EXPOSURE_FAILED:int = 2092;
		public static const JS_INITIAL_CALLBACK_EXPOSURE_FAILED:int = 2093;
		
		public static const UPDATE_CREDITS_ERROR_RECEIVED:int = 2100;
		
		// Home Base Transition errors
		public static const SET_STATE_HOME_BASE_NULL_BASE_PARAMS:int = 3000;
		public static const SET_STATE_HOME_BASE_INVALID_BASE_PARAMS:int = 3001;
		
		public static const LOAD_STATE_HOME_BASE_NULL_BASE_PARAMS:int = 3010;
		public static const LOAD_STATE_HOME_BASE_INVALID_BASE_PARAMS:int = 3011;
		
		// Data Validation
		public static const INVALID_DATA:int = 4000;
		public static const INVALID_REPAIRS:int = 4001;
		public static const UNIT_UPGRADE_CHECKSUM_MISMATCH:int = 4002;
		public static const UNIT_UPGRADE_COST_CHECKSUM_MISMATCH:int = 4003;
		
		public static const BAD_ACCU_SEC_NUM:int = 4010;
		public static const BAD_SEC_NUM:int = 4011;
		public static const BAD_SEC_STRING:int = 4012;
		
		public static const RESOURCE_PRODUCER_PRODUCTION_TIME_INVALID:int = 4020;
		public static const RESOURCE_PRODUCER_RESOURCES_PRODUCED_INVALID:int = 4021;
		
		// "Valid" crash reasons
		public static const UPDATE_MODE_ENABLED:int = 5000;
		public static const BELOW_MIN_CLIENT_VERSION:int = 5001;
		public static const GAME_VERSION_MISMATCH:int = 5002;
		
		//******************//
		// DESCRIPTION KEYS //
		//******************//
		private static const KEY_MISSING_DESCRIPTION:String = "error_code__snowbear";
		
		private static const KEY_PRELOAD_DATA_ERROR:String = "error_code__preload_data_error";
		private static const KEY_INVALID_MILITARY_RANK:String = "error_code__invalid_military_rank";
		private static const KEY_PURCHASE_ERROR:String = "error_code__purchase_error";
		private static const KEY_COLLECT_MISSION_ERROR:String = "error_code__collect_mission_error";

		private static const KEY_GENERIC_NETWORK_ERROR:String = "error_code__generic_network_error";
		private static const KEY_INVALID_PACKETS:String = "error_code__invalid_packets";
		private static const KEY_CORRUPTED_PACKETS:String = "error_code__corrupted_packets";
		private static const KEY_CLOCK_OUT_OF_SYNC:String = "error_code__clock_out_of_sync";
		private static const KEY_DUPLICATED_DATA:String = "error_code__duplicated_data";
		private static const KEY_BASE_LOAD_ERROR:String = "error_code__base_load_error";
		private static const KEY_BASE_LOCKED:String = "error_code__base_locked";
		private static const KEY_LOAD_ERROR:String = "error_code__load_error";
		private static const KEY_SAVE_ERROR:String = "error_code__save_error";
		private static const KEY_LOAD_OWNED_DEPOSITS_ERROR:String = "error_code__load_owned_deposits";
		private static const KEY_LOGIN_ERROR:String = "error_code__login_error";
		private static const KEY_JAVASCRIPT_ERROR:String = "error_code__javascript_error";

		private static const KEY_ACTIVE_STATE_HOME_BASE:String = "error_code__active_state_home_base";
		
		private static const KEY_INVALID_DATA:String = "error_code__missing_ui";
		
		private static const KEY_UPDATE_MODE:String = "error_code__update_mode";
		private static const KEY_NEWER_VERSION:String = "error_code__newer_version";
		
		//****************//
		// IMPLEMENTATION //
		//****************//
		private static var _descriptionLookup:Dictionary;
		
		public static function getDescriptionForErrorCode(errorCode:int):String
		{
			if (_descriptionLookup == null)
			{
				buildDescriptions();
			}
			
			if (errorCode in _descriptionLookup)
			{
				return WCLocalizer.getString(_descriptionLookup[errorCode]);
			}
			
			return WCLocalizer.getString(KEY_MISSING_DESCRIPTION);
		}
		
		private static function buildDescriptions():void
		{
			_descriptionLookup = new Dictionary();
			
			addDescription(GAME_DATA_PRELOAD_FAILED, KEY_PRELOAD_DATA_ERROR);
			addDescription(INVALID_MILITARY_RANK, KEY_INVALID_MILITARY_RANK);
			addDescription(PENDING_PURCHASE_COLLISION, KEY_PURCHASE_ERROR);
			addDescription(DEPOSIT_INFO_MISSING_AFTER_BATTLE, KEY_BASE_LOAD_ERROR);
			addDescription(COLLECT_NULL_MISSION, KEY_COLLECT_MISSION_ERROR);
			addDescription(COLLECT_UNCOLLECTABLE_MISSION, KEY_COLLECT_MISSION_ERROR);
			// Nebel: Intentionally using the missing description for this one,
			// as it should never fire anwyay as far as I can tell.
			addDescription(CALCULATE_FRACTION_COST, KEY_MISSING_DESCRIPTION);
			
			addDescription(INVALID_WRAPPER, KEY_INVALID_PACKETS);
			addDescription(INVALID_SIGNATURE, KEY_CORRUPTED_PACKETS);
			addDescription(MESSAGE_TOO_OLD, KEY_CLOCK_OUT_OF_SYNC);
			addDescription(MESSAGE_NOT_OLD_ENOUGH, KEY_CLOCK_OUT_OF_SYNC);
			addDescription(DUPLICATE_SIGNATURE, KEY_DUPLICATED_DATA);
			addDescription(GENERIC_RESPONSE_HASH_MISMATCH, KEY_GENERIC_NETWORK_ERROR);
			
			addDescription(HOME_BASE_ID_MISMATCH, KEY_BASE_LOAD_ERROR);
			addDescription(BASE_LOCKED, KEY_BASE_LOCKED);
			addDescription(BASE_LOAD_ERROR_RECEIVED, KEY_BASE_LOAD_ERROR);
			
			addDescription(GENERIC_LOAD_ERROR_RECEIVED, KEY_LOAD_ERROR);
			addDescription(GENERIC_LOAD_REQUEST_FAILED, KEY_LOAD_ERROR);
			
			addDescription(GENERIC_SAVE_ERROR_RECEIVED, KEY_SAVE_ERROR);
			addDescription(GENERIC_SAVE_REQUEST_FAILED, KEY_SAVE_ERROR);
			addDescription(GENERIC_PAGE_REQUEST_FAILED, KEY_SAVE_ERROR);
			addDescription(BASE_SAVE_ERROR_RECEIVED, KEY_SAVE_ERROR);
			addDescription(BASE_PAGE_ERROR_RECEIVED, KEY_SAVE_ERROR);
			addDescription(DEPOSITS_SAVE_ERROR_RECEIVED, KEY_SAVE_ERROR);
			
			addDescription(PLAY_NOW_INVALID_RESPONSE, KEY_GENERIC_NETWORK_ERROR);
			addDescription(PLAY_NOW_SAVE_REQUEST_FAILED, KEY_GENERIC_NETWORK_ERROR);
			
			addDescription(FLAGS_ERROR_RECEIVED, KEY_GENERIC_NETWORK_ERROR);

			addDescription(GET_FRIENDS_ERROR_RECEIVED, KEY_GENERIC_NETWORK_ERROR);
			addDescription(GET_FRIENDS_REQUEST_FAILED, KEY_GENERIC_NETWORK_ERROR);
			
			addDescription(LOAD_OWNED_DEPOSIT_DATA_ERROR_RECEIVED, KEY_LOAD_OWNED_DEPOSITS_ERROR);
			addDescription(LOAD_OWNED_DEPOSIT_DATA_REQUEST_FAILED, KEY_LOAD_OWNED_DEPOSITS_ERROR);
			
			addDescription(LOCAL_LOGIN_ERROR_RECEIVED, KEY_LOGIN_ERROR);
			addDescription(LOCAL_LOGIN_REQUEST_FAILED, KEY_LOGIN_ERROR);
			addDescription(JS_LOGIN_HASH_MISMATCH, KEY_LOGIN_ERROR);
			addDescription(JS_LOGIN_ERROR_RECEIVED, KEY_LOGIN_ERROR);
			addDescription(REST_LOGIN_ERROR_RECEIVED, KEY_LOGIN_ERROR);
			
			addDescription(JS_CALL_FAILED, KEY_JAVASCRIPT_ERROR);
			addDescription(JS_CALL_WITH_CALLBACK_FAILED, KEY_JAVASCRIPT_ERROR);
			addDescription(JS_ADD_CALLBACK_EXPOSURE_FAILED, KEY_JAVASCRIPT_ERROR);
			addDescription(JS_INITIAL_CALLBACK_EXPOSURE_FAILED, KEY_JAVASCRIPT_ERROR);
			
			addDescription(UPDATE_CREDITS_ERROR_RECEIVED, KEY_GENERIC_NETWORK_ERROR);
			
			addDescription(SET_STATE_HOME_BASE_NULL_BASE_PARAMS, KEY_ACTIVE_STATE_HOME_BASE);
			addDescription(SET_STATE_HOME_BASE_INVALID_BASE_PARAMS, KEY_ACTIVE_STATE_HOME_BASE);
			
			addDescription(LOAD_STATE_HOME_BASE_NULL_BASE_PARAMS, KEY_ACTIVE_STATE_HOME_BASE);
			addDescription(LOAD_STATE_HOME_BASE_INVALID_BASE_PARAMS, KEY_ACTIVE_STATE_HOME_BASE);
			
			addDescription(INVALID_DATA, KEY_INVALID_DATA);
			addDescription(INVALID_REPAIRS, KEY_INVALID_DATA);
			addDescription(UNIT_UPGRADE_CHECKSUM_MISMATCH, KEY_INVALID_DATA);
			addDescription(UNIT_UPGRADE_COST_CHECKSUM_MISMATCH, KEY_INVALID_DATA);
			
			addDescription(BAD_ACCU_SEC_NUM, KEY_INVALID_DATA);
			addDescription(BAD_SEC_NUM, KEY_INVALID_DATA);
			addDescription(BAD_SEC_STRING, KEY_INVALID_DATA);
			
			addDescription(RESOURCE_PRODUCER_PRODUCTION_TIME_INVALID, KEY_INVALID_DATA);
			addDescription(RESOURCE_PRODUCER_RESOURCES_PRODUCED_INVALID, KEY_INVALID_DATA);
			
			addDescription(UPDATE_MODE_ENABLED, KEY_UPDATE_MODE);
			addDescription(BELOW_MIN_CLIENT_VERSION, KEY_NEWER_VERSION);
			addDescription(GAME_VERSION_MISMATCH, KEY_NEWER_VERSION);
		}
		
		private static function addDescription(errorCode:int, description:String):void
		{
			DebugUtils.assert(!(errorCode in _descriptionLookup), "HaltErrorCodes.addDescription: Error code collision. Error code: " + errorCode + " Old description: " + _descriptionLookup[errorCode] + " New description: " + description);
			
			_descriptionLookup[errorCode] = description;
		}
	}
}

/*
_descriptionLookup[] = "error_code__";
*/