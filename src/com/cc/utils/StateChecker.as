package com.cc.utils
{
	// Converts ActiveState state constants into useful booleans
	
	public class StateChecker
	{
		public static function isUndefined(state:int):Boolean
		{
			return state == ActiveState.STATE_UNDEFINED;
		}
		
		public static function isScouting(state:int):Boolean
		{
			return state == ActiveState.STATE_SCOUT_BASE
				|| state == ActiveState.STATE_SCOUT_DEPOSIT
				|| state == ActiveState.STATE_SCOUT_PLATOON;
		}
		
		public static function isSyncBattleDefender(state:int):Boolean
		{
			return state == ActiveState.STATE_DEFEND_BASE
				|| state == ActiveState.STATE_DEFEND_DEPOSIT
				|| state == ActiveState.STATE_DEFEND_PLATOON;
		}
		
		public static function isSyncBattleAttacker(state:int):Boolean
		{
			return state == ActiveState.STATE_ENEMY_BASE
				|| state == ActiveState.STATE_ENEMY_DEPOSIT
				|| state == ActiveState.STATE_ENEMY_PLATOON;
		}
		
		public static function isSyncBattle(state:int):Boolean
		{
			return isSyncBattleDefender(state)
				|| isSyncBattleAttacker(state);
		}
		
		public static function isBattle(state:int):Boolean
		{
			return isSyncBattle(state)
				|| isScouting(state);
		}
		
		public static function isHomeBase(state:int):Boolean
		{
			return state == ActiveState.STATE_HOME_BASE;
		}
		
		public static function isPlayerOwnedBase(state:int):Boolean
		{
			return state == ActiveState.STATE_DEFEND_BASE
				|| state == ActiveState.STATE_HOME_BASE;
		}
		
		public static function isPlayersDeposit(state:int):Boolean
		{
			return state == ActiveState.STATE_DEFEND_DEPOSIT
				|| state == ActiveState.STATE_PLAYER_DEPOSIT;
		}
		
		public static function isPlayersPlatoon(state:int):Boolean
		{
			return state == ActiveState.STATE_DEFEND_PLATOON;
		}
		
		public static function isPlayerOwned(state:int):Boolean
		{
			return isPlayerOwnedBase(state)
				|| isPlayersDeposit(state)
				|| isPlayersPlatoon(state);
		}
		
		public static function isPlayerOwnedNonBattle(state:int):Boolean
		{
			return isPlayerOwned(state)
				&& !isBattle(state);
		}
		
		public static function isEnemyBase(state:int):Boolean
		{
			return state == ActiveState.STATE_ENEMY_BASE
				|| state == ActiveState.STATE_SCOUT_BASE;
		}
		
		public static function isEnemyDeposit(state:int):Boolean
		{
			return state == ActiveState.STATE_ENEMY_DEPOSIT
				|| state == ActiveState.STATE_SCOUT_DEPOSIT;
		}
		
		public static function isEnemyPlatoon(state:int):Boolean
		{
			return state == ActiveState.STATE_ENEMY_PLATOON
				|| state == ActiveState.STATE_SCOUT_PLATOON;
		}
		
		public static function isEnemyOwned(state:int):Boolean
		{
			return isEnemyBase(state)
				|| isEnemyDeposit(state)
				|| isEnemyPlatoon(state);
		}
		
		public static function isBase(state:int):Boolean
		{
			return state == ActiveState.STATE_ENEMY_BASE
				|| state == ActiveState.STATE_HOME_BASE
				|| state == ActiveState.STATE_HELP
				|| state == ActiveState.STATE_DEFEND_BASE
				|| state == ActiveState.STATE_SCOUT_BASE;
		}
		
		public static function isDeposit(state:int):Boolean
		{
			return state == ActiveState.STATE_PLAYER_DEPOSIT
				|| state == ActiveState.STATE_ENEMY_DEPOSIT
				|| state == ActiveState.STATE_DEFEND_DEPOSIT
				|| state == ActiveState.STATE_SCOUT_DEPOSIT;
		}
		
		public static function isPlatoon(state:int):Boolean
		{
			return state == ActiveState.STATE_ENEMY_PLATOON
				|| state == ActiveState.STATE_DEFEND_PLATOON
				|| state == ActiveState.STATE_SCOUT_PLATOON;
		}
		
		public static function isReplay(state:int):Boolean
		{
			return state == ActiveState.STATE_REPLAY;
		}
	}
}