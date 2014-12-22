package com.cc.utils
{
	import be.dauntless.astar.core.IAstarTile;
	
	import com.cc.factions.Factions;
	import com.cc.models.HexMap;
	import com.cc.models.HexMapCell;
	import com.cc.models.PlayerInfo;
	import com.cc.utils.console.ConsoleController;
	import com.cc.worldmap.Deposits.DepositManager;
	import com.cc.worldmap.MapEntityAttributes;
	import com.cc.worldmap.PlayersEncountered;
	import com.cc.worldmap.SpecialAttributes;
	import com.cc.worldmap.WorldmapController;
	import com.kixeye.net.proto.atlas.EntityType;
	import com.kixeye.net.proto.atlas.MapEntity;
	import com.kixeye.net.proto.atlas.MapEntityStatus;
	import com.kixeye.net.proto.atlas.Pair;
	
	public class WorldmapUtils
	{
		private static var _debugBannedEntitied:Array = new Array();
		
		public static function setUp() : void
		{
			CONFIG::debug
			{
				ConsoleController.Instance.RegisterCommand("banEntity", debugBanEntity, "<x>, <y>");
			}
		}
		
		public static function getSpecialAttributes(entity:MapEntity):SpecialAttributes
		{
			var specAttString:String = getEntityAttribute(entity, SpecialAttributes.KEY);
			return new SpecialAttributes(specAttString);
		}
		
		public static function getEntityAttribute(entity:MapEntity, key:String) : String
		{
			if (entity == null ||
				entity.attributes == null ||
				entity.attributes.pairs == null)
			{
				return null;
			}
			
			for (var i:Number = 0; i < entity.attributes.pairs.length; i++)
			{
				var p:Pair = entity.attributes.pairs[i] as Pair;
				if (p.key == key)
				{
					return p.entry;
				}
			}
			return null;
		}
		
		public static function setEntityAttribute(entity:MapEntity, key:String, entry:String) : Boolean
		{
			if (entity == null ||
				entity.attributes == null ||
				entity.attributes.pairs == null)
			{
				return false;
			}
			
			for (var i:Number = 0; i < entity.attributes.pairs.length; i++)
			{
				var p:Pair = entity.attributes.pairs[i] as Pair;
				if (p.key == key)
				{
					p.entry = entry;
					return true;
				}
			}
			
			var newPair:Pair = new Pair();
			newPair.entry = entry;
			newPair.key = key;
			
			entity.attributes.pairs.push(newPair);
			return true;
		}
		
		public static function WasSpawnedForMe(entity:MapEntity) : Boolean
		{
			return LOGIN.playerInfo.id == parseInt(getEntityAttribute(entity, "su"));
		}
		
		public static function IsUnderDamageProtection(entity:MapEntity) : Boolean
		{
			return parseInt(getEntityAttribute(entity, 'dp')) / GLOBAL.ONE_THOUSAND.Get() - GLOBAL.getServerTimestampSeconds() > 0;
		}
		
		CONFIG::debug
		{
			public static function debugBanEntity(arguments:Array):void
			{
	
				_debugBannedEntitied[arguments[0] + arguments[1]] = true;
			}
		} // CONFIG::debug
		
		public static function isEntityBanned(entity:MapEntity) : Boolean
		{
			CONFIG::debug
			{
				if (_debugBannedEntitied[entity.x.toString() + entity.y.toString()])
				{
					return true;
				}
			}
			return entity.status == MapEntityStatus.BANNED;
		}
		
		public static function isBlockadingBase(h:HexMapCell, map:HexMap) : Boolean
		{
			var neighbors:Vector.<IAstarTile> = new Vector.<IAstarTile>();
			neighbors = map.getNeighbours(h);
			var playerBase:MapEntity = null;
			var cell:HexMapCell = null;
			var spacesTaken:int = 0;
			
			for each (cell in neighbors)
			{
				playerBase = cell.getBaseEntity();
				
				if (playerBase != null && 
					playerBase.entityType == EntityType.ENTITY_TYPE_PLAYER_BASE &&
					playerBase.entityId != LOGIN.playerInfo.homeBaseEntityId)
				{
					break;
				}
				playerBase = null;
			}
			
			if (playerBase == null)
			{
				return false;
			}
			
			var filterFunction:Function = function(item:IAstarTile, index:int, vector:Vector.<IAstarTile>):void
			{	
				var cell:HexMapCell = item as HexMapCell;
				var found: Boolean = false;
				
				var entities:Vector.<MapEntity> = cell.getEntities(true);
				  for each (var e:MapEntity in entities) 
				  {
					if (e.ownerId != playerBase.ownerId &&
						e.status != MapEntityStatus.MOVING &&
						e.status != MapEntityStatus.RETREATING)
					{
						found = true;
					}
				  }
				
				if (found)
				{
					spacesTaken += 1
				}
			};
			
			map.getNeighbours(cell).forEach(filterFunction, playerBase);			
				
			return spacesTaken >= 5;
		}

		public static function getAnnotation(entity:MapEntity) : String
		{
			var nameField:String = "";
			if (entity.ownerId)
			{
				var playerInfo:PlayerInfo = PlayersEncountered.getPlayerInfo(int(entity.ownerId));
				if (entity.entityType == EntityType.ENTITY_TYPE_PLATOON && playerInfo.id == LOGIN.playerInfo.id)
				{
					nameField += WorldmapUtils.getEntityAttribute(entity, MapEntityAttributes.PLATOON_NAME);
				}
				else if (playerInfo)
				{
					if (playerInfo.hasAlias())
					{
						nameField += playerInfo.alias;
					}
					else if (playerInfo.userName != "")
					{
						nameField += playerInfo.userName;
					}
					if (playerInfo.level)
					{
						nameField += " (" + playerInfo.level.toString() + ")";
					}
				}
			}
			else
			{
				// rogue faction
				var rfType:int = parseInt(WorldmapUtils.getEntityAttribute(entity, MapEntityAttributes.RF_TYPE));
				var rogueId:int = parseInt(WorldmapUtils.getEntityAttribute(entity, MapEntityAttributes.RF_ID));
				
				if (rogueId)
				{
					nameField = nameField.concat(Factions.GetName(rogueId));
					
					var rfLevel:String = "?";
					if (entity.entityType == EntityType.ENTITY_TYPE_ROGUE_BASE) 
					{
						rfLevel = parseInt(WorldmapUtils.getEntityAttribute(entity, MapEntityAttributes.LEVEL)).toString();
					}
					else if (WorldmapController.IsDeposit(entity.entityType))
					{
						nameField = DepositManager.Instance.getDespositDescription(entity);
						rfLevel = DepositManager.Instance.getDepositRFLvl(int(WorldmapUtils.getEntityAttribute(entity, MapEntityAttributes.SIZE)), entity.entityType).toString();
					}
					
					if (rfLevel)
					{
						nameField += " (" + rfLevel + ")";
					}
				}
			}
			
			return nameField;
		}
	}
}
