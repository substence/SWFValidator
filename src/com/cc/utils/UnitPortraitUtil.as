package com.cc.utils
{
	import com.cc.units.ImportedSpriteSheetData;
	import com.cc.units.UnitData;
	import com.cc.units.UnitLevelData;
	import com.cc.units.Units;
	import com.kixeye.wc.gamedata.constants.UnitGroupID;
	import com.kixeye.wc.gamedata.constants.UnitTypeID;

	public class UnitPortraitUtil
	{
		public static const SIZE_TINY:int = 40;
		public static const SIZE_TINY_HEIGHT:int = 32;
		public static const SIZE_SMALL:int = 60;
		public static const SIZE_SMALL_HEIGHT:int = 48;
		public static const SIZE_MEDIUM:int = 90;
		public static const SIZE_LARGE:int = 150;
		public static const WIDTH_TO_HEIGHT_RATIO:Number = 0.8;
		
		public static function getUnitPortraitUrl(unitType:int, portraitSize:int, forcePortrait:Boolean = false, useDefaultSkin:Boolean = false, customSkin:int = 0) : String
		{
			var url:String = "units/portrait/" + unitType + "-" + portraitSize;
			
			var locked:Boolean;
			if (forcePortrait)
			{
				locked = false;
			}
			else
			{
				locked = (ActiveState.IsHomeBase() && HomeBaseSummary.GetUnitLevel(unitType) == 0);
			}
			
			var skin:int;
			if (useDefaultSkin)
			{
				skin = 0;
			}
			else
			{
				skin = customSkin == 0 ? HomeBaseSummary.GetUnitSkin(unitType) : customSkin;
			}
			
			return getImageURLForUnit(unitType,portraitSize,locked,skin);
		}
		
		public static function getImageURLForUnit(unitID:int, portraitSize:int, locked:Boolean, skin:int):String
		{
			// Don't generate a bogus url
			if (!unitID)
			{
				return null;
			}
			
			var unitData:UnitData = Units.GetData(unitID);
			var level:int = HomeBaseSummary.GetUnitLevel(unitID);
			if (level < 1)
			{
				level = 1;
			}
			
			var unitLevelData:UnitLevelData = unitData.levelData[level-1];
			var portraitKey:String = ImportedSpriteSheetData.instance.getUnitPortraitKey(unitLevelData.spriteSkinID, (skin == 2));
			
			if (unitData != null && unitData.group == UnitGroupID.GROUP_MISSILE)
			{
				//missiles have unique portraits per level...
				level = skin == 0 ? level : skin;
				portraitKey = unitID.toString() + '.' + Math.max(level, 1).toString();
			}
			else
			{
				portraitKey = ImportedSpriteSheetData.instance.getUnitPortraitKey(unitLevelData.spriteSkinID, (skin == 2));
			}
			
			var url:String = "units/portrait/" + portraitKey + "-" + portraitSize;
			
			if (locked) 
			{
				url += "-locked";
			}
			
			url += ".jpg";
			
			return url;
		}
	}
}
