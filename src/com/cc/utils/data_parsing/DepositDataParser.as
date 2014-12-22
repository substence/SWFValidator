package com.cc.utils.data_parsing
{
	import com.adverserealms.log.Logger;
	import com.cc.units.PlatoonManager;

	public class DepositDataParser extends VersionedDataParser
	{
		public function DepositDataParser()
		{
			_CurrentVersion = 3;
		}
		
		// Returns the version of the given data
		override public function GetVersion(data:Object) : int
		{
			if (data == null)
			{
				Logger.debug("ERROR: DepositsDataParser::GetVersion : data is null. Returning 0.0");
				return 0;
			}
			
			// Check for version:
			var version:int;
			if (data["version"] != null)
			{
				version = int(data.version);
			}
			
			if (isNaN(version))
			{
				version = 0;
			}
			
			// No version found!
			if (version == 0)
			{
				// Version 1.0: WorldMap
				version = 1;
			}
						
			return version;
		}
		
		// Takes in data and returns it as the latest format if out of date
		override public function ConvertToCurrent(data:Object) : Object
		{
			if (data == null)
			{
				Logger.debug("ERROR: DepositsDataParser::ConvertToCurrent : data is null. Returning null.");
				return null;
			}
			
			
			// Get the version and raw data
			var version:int = GetVersion(data);
			var output:Object = data.data;
			
			
			// If legacy version, convert it
			if (IsOutdated(data))
			{
				if (version == 1)
				{
					output = v1_To_3(data);
				}
				else if (version == 2)
				{
					// Do nothing; version 2 is the same as version 3 due to an error
				}				
			}
			
			// Ensure valid format
			if (output == null)
			{
				output = FormatDepositData(0, [], [], [], []);
			}
			
			
			return output;
		}
		
		
		/******************************
		 * Legacy Conversion Functions *
		 ******************************/
		protected function v1_To_3(data:Object) : Object
		{
			// Move down a level to the "unitdata" object to access the deposit's unit data
			var unitData:Object = data.unitdata;
			
			// See if we need to legacy convert the Unit data
			var unitParser:UnitsDataParser = new UnitsDataParser();
			unitData = unitParser.ConvertToCurrent(unitData);
			
			
			// At the top level try to grab the extra buildingdata
			var extraBuildingDataList:Array = [];
			var buildingData:Object = data.buildingdata;
			if (buildingData)
			{
				// Iterate through each building data
				for (var buildingID:String in buildingData)
				{
					var rawData:Object = buildingData[buildingID];
					if (rawData)
					{
						extraBuildingDataList.push(FormatExtraBuildingData(rawData));
					}
				}
			}
			
			
			// Build a Deposit data 2.0 formatted Object
			var output:Object = FormatDepositData(0, unitData.units, unitData.field, unitData.buildings, extraBuildingDataList, unitData.platoon);
			
			return output;
		}
		
		
		/******************************
		* Formatting helper functions *
		******************************/
		// Helper function that formats raw deposit data to the latest deposit data format
		protected function FormatDepositData(id:int, units:Array, fieldIDs:Array, buildings:Array, buildingData:Array, platoon:Object = null) : Object
		{
			if (units == null)
			{
				units = [];
			}
			
			if (fieldIDs == null)
			{
				fieldIDs = [];
			}
			
			if (buildings == null)
			{
				buildings = [];
			}
			
			if (buildingData == null)
			{
				buildingData = [];
			}
			
			
			var output:Object =
				{
					"id":id,
					"units":units,
					"field":fieldIDs,
					"buildings":buildings,
					"buildingData":buildingData,
					"platoon":platoon
				};
			
			
			return output;
		}
		
		protected function FormatExtraBuildingData(buildingData:Object) : Object
		{
			var output:Object = {};
			
			if ("id" in buildingData)
			{
				output.id = buildingData.id;
			}
			
			if ("hp" in buildingData)
			{
				output.hp = buildingData.hp;
			}
			
			if ("l" in buildingData)
			{
				output.hp = buildingData.hp;
			}
			
			if ("X" in buildingData)
			{
				output.X = buildingData.X;
			}
			
			if ("Y" in buildingData)
			{
				output.Y = buildingData.Y;
			}
			
			return output;
		}
	}
}