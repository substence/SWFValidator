package com.cc.utils.data_parsing
{
	import com.adverserealms.log.Logger;
	import com.cc.units.C_Platoon;
	import com.cc.units.PlatoonPropManifest;
	import com.cc.units.PlatoonProperties;
	import com.kixeye.wc.gamedata.constants.CommandSource;
	import com.kixeye.wc.gamedata.constants.CommandType;

	public class AirfieldUnitsDataParser extends VersionedDataParser
	{
		public function AirfieldUnitsDataParser()
		{
			_CurrentVersion = 5;
		}
		
		// Returns the version of the given data
		override public function GetVersion(data:Object) : int
		{
			if (data == null)
			{
				Logger.debug("ERROR: AirfieldUnitsDataParser::GetVersion : data is null. Returning 0.0");
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
				Logger.debug("ERROR: AirfieldUnitsDataParser::ConvertToCurrent : data is null. Returning null.");
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
					output = v1_To_2(data);
				}
			}
			
			// Once we're at 2.0, iteravely update until we're caught up
			if (version == 2)
			{
				output = v2_To_3(output);
				version = 3;
			}
			
			if (version == 3)
			{
				output = v3_To_4(output);
				version = 4;
			}
			
			if (version == 4)
			{
				output = v4_To_5(output);
			}
			
			// Ensure valid format
			if (output == null)
			{
				output = FormatAirfieldUnitsData([], []);
			}
			
			
			return output;
		}
		
		
		/******************************
		* Legacy Conversion Functions *
		******************************/
		protected function v1_To_2(data:Object) : Object
		{
			var airfieldUnits:Array = [];
			
			// Move down a level to the "a" object to access the unit data
			data = data.a;
			if (data == null)
			{
				return FormatAirfieldUnitsData([], []);
			}
			
			
			var rawUnitsList:Array = data.u as Array;
			if (rawUnitsList)
			{
				for (var i:int = 0, length:int = rawUnitsList.length; i < length; ++i)
				{
					var rawUnit:Object = rawUnitsList[i];
					if (rawUnit)
					{
						var formattedUnit:Object = FormatV3UnitData(rawUnit.u, rawUnit.t, rawUnit.x, rawUnit.y, rawUnit.a, rawUnit.h, rawUnit.s, rawUnit.d);
						
						airfieldUnits.push(formattedUnit);
					}
				}
			}
			
			
			// Build a Units Data 3.0 formatted Object
			var output:Object = FormatAirfieldUnitsData(airfieldUnits,[]);
			
			return output;
		}
		
		protected function v2_To_3(data:Object) : Object
		{
			// Walk 2.0 data structure and remove stance from existing units
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
		
		protected function v3_To_4(data:Object) : Object
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
		
		protected function v4_To_5(data:Object):Object
		{
			if (data != null
				&& data.units is Array)
			{
				// Shove all units into the first squad of the mixed aircraft platoon
				var squadsData:Array = [];
				var unitIds:Array = [];
				squadsData.push(unitIds);
				
				for each (var unit:Object in data.units)
				{
					if (unit != null)
					{
						unitIds.push(unit.u);
					}
				}
				
				var platoonProperties:PlatoonProperties = PlatoonPropManifest.instance.getPlatoonPropertiesForType(C_Platoon.TYPE_AIRCRAFT);
				var platoonData:Object =
					{
						"type":platoonProperties.type,
						"id":platoonProperties.uniqueId,
						"name":platoonProperties.getRandomPlatoonName(),
						"squads":squadsData
					};
				
				data.platoons = [platoonData];
			}
			
			return data;
		}
		
		/******************************
		* Formatting helper functions *
		******************************/
		// Helper function that formats raw unit data to the latest units data format
		protected function FormatAirfieldUnitsData(units:Array, platoons:Array) : Object
		{
			if (units == null)
			{
				units = [];
			}
			
			if (platoons == null)
			{
				platoons = [];
			}
			
			var output:Object =
				{
					"units":units,
					"platoons":platoons
				};
			
			return output;
		}
	}
}