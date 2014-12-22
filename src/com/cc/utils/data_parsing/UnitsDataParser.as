package com.cc.utils.data_parsing
{
	import com.adverserealms.log.Logger;
	import com.cc.units.C_Platoon;
	import com.cc.units.PlatoonManager;
	import com.cc.units.UnitManager;
	import com.cc.units.Units;
	import com.kixeye.wc.gamedata.constants.CommandSource;
	import com.kixeye.wc.gamedata.constants.CommandType;
	import com.kixeye.wc.gamedata.constants.UnitGroupID;

	public class UnitsDataParser extends VersionedDataParser
	{
		public function UnitsDataParser()
		{
			_CurrentVersion = 5;
		}
		
		// Returns the version of the given data
		override public function GetVersion(data:Object) : int
		{
			if (data == null)
			{
				Logger.debug("ERROR: UnitsDataParser::GetVersion : data is null. Returning 0.0");
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
			
			if (version == 0)
			{
				// No version found!
				// Attempt to find which version it is						
				if (data.ur)
				{
					// Version: 2.0 (WorldMap)
					version = 2;
				}
				else
				{
					// Version: 1.0 (pre-WorldMap)
					version = 1;
				}
			}
			
			return version;
		}
		
		// Takes in data and returns it as the latest format if out of date
		override public function ConvertToCurrent(data:Object) : Object
		{
			if (data == null)
			{
				Logger.debug("ERROR: UnitsDataParser::ConvertToCurrent : data is null. Returning empty default data.");
				return FormatBaseUnitsData([], [], [], null, null);
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
					output = v2_To_3(data);
				}
			}
			
			// Once we're at 3.0, iteravely update until we're caught up
			if (version == 3)
			{
				output = v3_To_4(output);
				version = 4;
			}
			
			if (version == 4)
			{
				output = v4_To_5(output);
				version = 5;
			}
			
			// Ensure valid format
			if (output == null)
			{
				output = FormatBaseUnitsData([], [], [], null, null);
			}
			
			
			return output;
		}
		
		
		/******************************
		* Legacy Conversion Functions *
		******************************/
		protected function v1_To_3(data:Object) : Object
		{
			var baseUnits:Array = [],
				fieldIDs:Array = [],
				airfield:Array = [],
				squadIDs:Array = [];
			
			
			var rawUnitList:Array = data as Array;
			if (rawUnitList)
			{
				// Process and add all units
				for (var i:int = 0, length:int = rawUnitList.length; i < length; ++i)
				{
					var rawUnitData:Array = rawUnitList[i];
					var rawUnitDataLength:int = rawUnitData.length;
					
					// Get legacy unit properties
					var unitID:Number =			(rawUnitDataLength > 6) ? rawUnitData[6] : UnitManager.Instance.GenerateUnitID();
					var unitType:int =			rawUnitData[0];
					var posX:int =				rawUnitData[1];
					var posY:int =				rawUnitData[2];
					var angle:int =				rawUnitData[3];
                    var health:int =			(rawUnitDataLength > 4) ? rawUnitData[4] : Units.GetMyProperty(unitType, "maxHealth");
					var stance:int =			(rawUnitDataLength > 5) ? rawUnitData[5] : 0;
					var isDeployed:Boolean =	(rawUnitDataLength > 7) ? rawUnitData[7] : false;
					
					
					// Create a unit Object formatted with the latest format
					var formattedUnit:Object = FormatV3UnitData(unitID, unitType, posX, posY, angle, health, stance, isDeployed);
					
					
					switch (Units.GetData(unitType).group)
					{
						case UnitGroupID.GROUP_AIR:
						{
							// Aircraft don't get placed into the Base Defender Platoon
							airfield.push(formattedUnit);
						}
						break;
						
						default:
						{
							baseUnits.push(formattedUnit);
							
							fieldIDs.push(unitID);
							squadIDs.push(unitID);
						}
					}
				}
			}
			
			
			// Build a Platoon if it there are units
			var platoon:Object;
			if (baseUnits.length > 0)
			{
				platoon = FormatPlatoon(PlatoonManager.Instance.GeneratePlatoonID(), PlatoonManager.Instance.GenerateRandomName(), [squadIDs]); 
			}
			
			
			// Build a Units Data 3.0 formatted Object
			var output:Object = FormatBaseUnitsData(baseUnits, [], fieldIDs, platoon, airfield);
			
			return output;
		}
		
		protected function v4_To_5(data:Object) : Object
		{
			if (data["units"] != null)
			{
				// Units field is an array of dictionaries
				for (var index:String in data.units)
				{
					data.units[index]["bfdata"] = 0;
				}
			}
			
			return data;	
		}
		
		protected function v3_To_4(data:Object) : Object
		{
			// Walk 3.0 data structure and remove stance from existing units
			// Add commandtype and commandsource to existing units for commands that should persist
			
			var aggressiveStance:int = 1;
			var standGroundStance:int = 2;
			if (data["units"] != null)
			{
				// Units field is an array of dictionaries
				for (var index:String in data.units)
				{
					if (data.units[index]["s"] != null )
					{
						if (data.units[index].s == standGroundStance)
						{
							data.units[index]["ct"] = CommandType.COMMAND_STAND_GROUND;
							data.units[index]["cs"] = CommandSource.COMMAND_SOURCE_PLAYER;
						}
						else if (data.units[index].s == aggressiveStance)
						{
							data.units[index]["ct"] = CommandType.COMMAND_FIRE_AT_WILL;
							data.units[index]["cs"] = CommandSource.COMMAND_SOURCE_PLAYER;
						}
						
						delete data.units[index]["s"];
					}
				}
			}
					
			return data;	
		}
		
		protected function v2_To_3(data:Object) : Object
		{
			var baseUnits:Array = [],
				fieldIDs:Array = [],
				buildings:Array = [],
				squadIDs:Array = [];
			
			
			// Move down a level to the "ur" object to access the unit data
			data = data.ur;
			if (data == null)
			{
				return FormatBaseUnitsData([], [], [], null, null);
			}
			
			
			// Iterate through each unit data roster
			for (var rosterID:String in data)
			{
				var rosterData:Object = data[rosterID];
				if (rosterData == null)
				{
					continue;
				}
				
				
				// Get the unit data list and type
				var unitsList:Array = rosterData.u as Array;
				var rosterType:int = rosterData.t as int;
				if (unitsList == null)
				{
					continue;
				}
				
				
				// Parse each roster type differently
				var rawUnit:Object;
				var formattedUnit:Object;
				var i:int,
					length:int;
				switch (rosterID)
				{
					// Field
					case "f":
					{
						for (i = 0, length = unitsList.length; i < length; ++i)
						{
							rawUnit = unitsList[i];
							if (rawUnit)
							{
								// Create a unit Object formatted with the latest format
								formattedUnit = FormatV3UnitData(rawUnit.u, rawUnit.t, rawUnit.x, rawUnit.y, rawUnit.a, rawUnit.h, rawUnit.s, rawUnit.d);
								
								baseUnits.push(formattedUnit);
								fieldIDs.push(formattedUnit.u);
								squadIDs.push(formattedUnit.u);
							}
						}
					}
					break;
					
					// Building
					default:
					{
						var unitIDList:Array = [];
						
						for (i = 0, length = unitsList.length; i < length; ++i)
						{
							rawUnit = unitsList[i];
							if (rawUnit && rawUnit.u)
							{
								// Create a unit Object formatted with the latest format
								formattedUnit = FormatV3UnitData(rawUnit.u, rawUnit.t, rawUnit.x, rawUnit.y, rawUnit.a, rawUnit.h, rawUnit.s, rawUnit.d);
								
								baseUnits.push(formattedUnit);
								unitIDList.push(formattedUnit.u);
								squadIDs.push(formattedUnit.u);
							}
							else
							{
								// Empty spot for Bunkers
								unitIDList.push(-1);
							}
						}
						
						// Create a base data Object with the latest format
						var buildingData:Object = FormatBuildingData(rosterID, rosterType, unitIDList);
						buildings.push(buildingData);
					}
					break;
				}
			}
			
			
			// Build a Platoon if it there are units
			var platoon:Object;
			if (baseUnits.length > 0)
			{
				platoon = FormatPlatoon(PlatoonManager.Instance.GeneratePlatoonID(), PlatoonManager.Instance.GenerateRandomName(), [squadIDs]); 
			}
			
			
			// Build a Units Data 3.0 formatted Object
			var output:Object = FormatBaseUnitsData(baseUnits, buildings, fieldIDs, platoon);
			
			return output;
		}
		
		
		/******************************
		* Formatting helper functions *
		******************************/
		// Helper function that formats raw unit data to the latest units data format
		protected function FormatBaseUnitsData(units:Array, buildings:Array, fieldIDList:Array, platoon:Object, airfieldUnits:Array = null) : Object
		{
			if (units == null)
			{
				units = [];
			}
			
			if (buildings == null)
			{
				buildings = [];
			}
			
			if (fieldIDList == null)
			{
				units = [];
			}
			
			var output:Object =
				{
					"units":units,
					"buildings":buildings,
					"field":fieldIDList,
					"platoon":platoon
				};
			
			if (airfieldUnits && airfieldUnits.length > 0)
			{
				output.airfield = airfieldUnits;
			}
			
			
			return output;
		}
	}
}
