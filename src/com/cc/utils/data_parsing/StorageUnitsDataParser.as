package com.cc.utils.data_parsing
{
	import com.adverserealms.log.Logger;
	import com.kixeye.wc.gamedata.constants.CommandSource;
	import com.kixeye.wc.gamedata.constants.CommandType;

	public class StorageUnitsDataParser extends VersionedDataParser
	{
		public function StorageUnitsDataParser()
		{
			_CurrentVersion = 4;
		}

		// Returns the version of the given data
		override public function GetVersion(data:Object) : int
		{
			if (data == null)
			{
				Logger.debug("ERROR: StorageUnitsDataParser::GetVersion : data is null. Returning 0.0");
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
				Logger.debug("ERROR: StorageUnitsDataParser::ConvertToCurrent : data is null. Returning null.");
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
			
			// Ensure valid format
			if (output == null)
			{
				output = FormatStorageUnitsData([], [], [], []);
			}
			
			
			return output;
		}
		
		
		/******************************
		* Legacy Conversion Functions *
		******************************/
		protected function v1_To_2(data:Object) : Object
		{
			var storageUnits:Array = [],
				storageIDs:Array = [];
			
			
			// Move down a level to the "s" object to access the unit data
			data = data.s;
			if (data == null)
			{
				return FormatStorageUnitsData([], [], [], []);
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
						
						storageUnits.push(formattedUnit);
						storageIDs.push(formattedUnit.u);
					}
				}
			}
			
			
			// Build a Units Data 3.0 formatted Object
			var output:Object = FormatStorageUnitsData(storageUnits, storageIDs, [], []);
			
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
		
		/******************************
		* Formatting helper functions *
		******************************/
		// Helper function that formats raw unit data to the latest units data format
		protected function FormatStorageUnitsData(units:Array, storageIDs:Array, platoons:Array, hangarIDs:Array) : Object
		{
			if (units == null)
			{
				units = [];
			}
			
			if (storageIDs == null)
			{
				storageIDs = [];
			}
			
			if (platoons == null)
			{
				platoons = [];
			}
			
			if (hangarIDs == null)
			{
				hangarIDs = [];
			}
			
			var output:Object =
				{
					"units":units,
					"storageIDs":storageIDs,
					"platoons":platoons,
					"hangarIDs":hangarIDs
				};
			
			
			return output;
		}
	}
}
