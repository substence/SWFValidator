package com.cc.utils.data_parsing
{
	public class VersionedDataParser
	{
		// Current version number used by the parser for the given data type it handles
		protected var _CurrentVersion:int = 0;
		
		public function VersionedDataParser()
		{
		}
		
		// Returns the version of the given data
		public function GetVersion(data:Object) : int
		{
			return 0;
		}
		
		// Returns the current version used by the game
		public function GetCurrentVersion() : int
		{
			return _CurrentVersion;
		}
		
		// Returns if the data is up to date
		public function IsCurrent(data:Object) : Boolean
		{
			if (data == null)
			{
				return false;
			}
			
			return GetVersion(data) == _CurrentVersion;
		}
		
		// Returns if the data is up to date
		public function IsOutdated(data:Object) : Boolean
		{
			if (data == null)
			{
				return false;
			}
			
			return GetVersion(data) != _CurrentVersion;
		}
		
		// Takes in data and returns it as the latest format if out of date
		public function ConvertToCurrent(data:Object) : Object
		{
			return null;
		}
		
		// Attempts to convert the passed in data to a given destination
		// version, returning null upon failure
		public function Convert(data:Object, dstVersion:Number) : Object
		{
			return null;
		}
		
		
		/******************************
		* Formatting helper functions *
		******************************/
		// Helper function that formats raw unit data to the V3.0 raw unit data format
		protected function FormatV3UnitData(id:Number, type:int, x:Number, y:Number, angle:Number, health:Number, stance:Number, isDeployed:Boolean) : Object
		{
			var output:Object =
				{
					"u":isNaN(id) ? 0 : id,
					"t":type,
					"x":isNaN(x) ? 0 : x,
					"y":isNaN(y) ? 0 : y,
					"a":isNaN(angle) ? 0 : angle,
					"h":isNaN(health) ? 0 : health,
					"s":isNaN(stance) ? 0 : stance,
					"d":Number(isDeployed)
				};
			
			return output;
		}
		
		// Helper function that formats raw building data to the latest building data format
		protected function FormatBuildingData(buildingID:String, buildingType:int, unitIDList:Array) : Object
		{
			var bid:Number = parseFloat(buildingID.substr(1));
			if (isNaN(bid))
			{
				bid = 0;
			}
			
			var output:Object =
				{
					"bid":bid,
					"type":buildingType,
					"unitIDs":unitIDList
				};
			
			return output;
		}
		
		// Helper function that formats raw base defender platoon data to the latest base defender platoon format
		protected function FormatPlatoon(id:String, name:String, squads:Array) : Object
		{
			var output:Object =
				{
					"id":id,
					"name":name,
					"squads":squads
				};
			
			return output;
		}
	}
}