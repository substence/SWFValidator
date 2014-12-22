package com.cc.utils
{
	import com.cc.towers.TowerData;
	import com.cc.towers.TowerResearch;
	import com.cc.towers.Towers;
	import com.kixeye.wc.gamedata.constants.TowerMountType;
	import com.kixeye.wc.gamedata.constants.TowerTypeID;

	public class TowerPortraitUtil
	{
		public static function getImageURLForTower(towerID:int, level:int = -1 , locked:Boolean = false ):String
		{
			if (towerID == TowerTypeID.TOWER_BLITZ_PLATFORM)
			{
				towerID = TowerTypeID.TOWER_BLITZ;
			}
			
			var url:String = "ui/towerbuttons-v2/" + towerID;
			var data:TowerData = Towers.GetData(towerID);
			const maxTowerLevel:int = data.maxLevel;
			if (level > maxTowerLevel)
				level = maxTowerLevel;
			if (level == -1)
			{
				level = TowerResearch.GetLevel(towerID);
			}
			
			var levelIndex:int = level - 1;
			if (levelIndex < 0)
			{
				levelIndex = 0;
			}
			
			if (data.levelData[levelIndex].mountType == TowerMountType.MOUNT_ROCKET_SILO)
			{
				// The rocket silo rockets are special, they use the same portraits for all levels
				if (locked || level == 0)
				{
					url += "-locked";
				}
			}
			else
			{	
				if (locked)
				{
					url += "-lvl" + level;
					url += "-locked";			
				}
				else if (level == 0)
				{
					url += "-locked";
				}
				else
				{
					url += "-lvl" + level;
				}
			}
			
			switch (towerID)
			{
				case TowerTypeID.TOWER_BLITZ:
					url += ".v2";
					break;
				case TowerTypeID.TOWER_ION_AIR:
					url += ".v2";
					break;
			}
			
			url += ".jpg";
			
			return url;
		}
	}
}
