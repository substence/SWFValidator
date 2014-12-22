package com.cc.utils
{
	import com.adverserealms.log.Logger;
	import com.cc.units.UnitManager;
	import com.cc.units.Units;
	import com.cc.utils.console.ConsoleController;
	import com.kixeye.wc.gamedata.constants.UnitTypeID;
	
	import flash.utils.getTimer;

	public class PerfTestUtils
	{
		CONFIG::debug
		{
			private static var _frameTime:int = 0;
			private static var _perfFrameStart:int = 0;
			private static var _perfEndTime:int = 0;
		}
		
		public static function setUp() : void
		{
			CONFIG::debug
			{
				ConsoleController.Instance.RegisterCommand("doPerfTest", debugDoPerfTest, "Do a performance test and score it");
			}
		}
		
		CONFIG::debug
		{
			private static function doPerfTest( args:Array ) : void
			{
				if( !_perfEndTime )
				{
					Units.ScrapUnits(UnitManager.Instance.GetFieldRoster(true).GetUnitList());
					
					var posx:int = 0;
					var posy:int = 0;
					var isAttacker:Boolean = false;
					var level:int = 1;
					var numUnits:int = (args.length >= 1) ? args[0] : 320;
					Units.DebugSpawnUnit( [UnitTypeID.UNIT_FOOT_RIFLE, posx, posy, isAttacker, level, numUnits] );
					
					const perfDurationMS:int = ((args.length >= 2) ? args[1] : 60) * 1000; //seconds to ms how long to run the test
					_perfEndTime = getTimer() + perfDurationMS;
					_frameTime = 0;
					
					GOGOBAR.goGoPerfTest( [] );
				}
			}
			
			public static function get doingPerfTest() : Boolean
			{
				return _perfEndTime != 0;	
			}
			
			public static function updatePerfTest( lastFrameTime:int, frameCount:int ) : void
			{
				DebugUtils.assert( _perfEndTime > 0, "Utils::updatePerfTestTime perfTestTime < 0" );
				
				_frameTime += lastFrameTime;
				if( !_perfFrameStart )
					_perfFrameStart = frameCount; 
				
				if( getTimer() >= _perfEndTime )
				{
					GOGOBAR.debugGoGoStop( [] );
					
					var frameTotal:int = frameCount - _perfFrameStart;
					Logger.debug( "PERF TEST COMPLETE\nFRAMES:" + frameTotal + "\nTotalTime:"+ _frameTime + "\nSCORE:" + ( _frameTime / frameTotal ) );
					_perfEndTime = 0;
					_frameTime = 0;
				}
			}
			
			private static function debugDoPerfTest(args:Array = null) : void
			{
				doPerfTest( args );
			}
		} //CONFIG::debug
	}
}