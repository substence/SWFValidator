package com.cc.utils
{
	import com.cc.build.C_Buildings;
	import com.cc.bunker.Bunkers;
	import com.kixeye.wc.gamedata.constants.BuildingTypeID;
	
	import flash.sampler.getLexicalScopes;
	
	import flashx.textLayout.elements.BreakElement;
	
	public class BuildingPortraitUtil
	{
		public static function getBuildingPortraitUrl(buildingType:int, level:int, locked:Boolean = false) : String
		{
			if (buildingType == BuildingTypeID.BUILDING_NONE || C_Buildings.GetData(buildingType) == null)
			{
				return null;
			}
			
			level = C_Buildings.GetBuildingImageDataClosestLevel(buildingType,level);
			
			var imageURL:String = "buildingbuttons/" + buildingType + "-" + level;
			
			if (locked)
			{
				imageURL += "-locked";
			}
			
			imageURL += "-s";
			
			switch (buildingType)
			{
				case BuildingTypeID.BUILDING_PLATFORM:
					imageURL += ".v3";
					break;
				case BuildingTypeID.BUILDING_WALL:
				case BuildingTypeID.BUILDING_BARRACKS:
				case BuildingTypeID.BUILDING_COMMAND_CENTER:
				case BuildingTypeID.BUILDING_GOGO_BAR:
				case BuildingTypeID.BUILDING_E26_DECORATION:
					imageURL += ".v2";
					break;
				case BuildingTypeID.BUILDING_BUNKER:
				case BuildingTypeID.BUILDING_BUNKER_ANTITANK:
				case BuildingTypeID.BUILDING_BUNKER_ANTIAIR:
					return Bunkers.getImageURLForBunker(buildingType, level);
					break;
			}
			
			imageURL += ".jpg";
			
			return imageURL;
		}
		
		public static function getDefaultUrl(buildingType:int) : String
		{
			return getBuildingPortraitUrl(buildingType, 1, false);
		}
	}
}
