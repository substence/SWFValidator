package com.cc.utils
{
	import com.cc.utils.js_utils.WCJSON;
	import com.kixeye.net.proto.atlas.EventTweak;
	import com.kixeye.net.proto.atlas.PlayerDamageDealt;
	import com.kixeye.net.proto.atlas.PlayerDamageReceived;
	import com.kixeye.net.proto.atlas.TaskTweak;
	import com.kixeye.net.proto.atlas.Tweak;
	import com.kixeye.net.proto.atlas.WaveTweak;
	
	/*
	hpark: This class must die! I'm doing this because i can't send protobufs straight across to AIBox.
	Look in tuning/tuningconfig.h for the matching shared code.
	
	Tweaks in json look like:
	
	eventTweak (Object)
	-eventNumber (Number)
	-taskTweaks (ArraY)
	--taskId (String)
	--tweaks (Array)
	playerDanageDealt (Object)
	-globalDamagePercentChange (Number)
	playerDamageReceived (Object)
    -globalDamagePercentChange (Number)
	
	Object format below.
	
	{
		et: {
			en: 32
			tts: [
				{
					tid: "rfid_12_level_10_eb",
					ts: [ { }, { } ] // tweaks
				}, ...
			]
		},
		pdd: {
			dam: 10
		},
		pdr: {
			dam: -10
		}
	}
	*/
	public class TweakUtils
	{
		public static function toString(tweak:Tweak):String
		{
			var object:Object = tweakToObject(tweak);
			
			return WCJSON.encode(object);
		}
		
		public static function tweakToObject(tweak:Tweak) : Object
		{
			var object:Object = {};
			
			if (tweak.eventTweak)
			{
				object.et = eventTweakToObject(tweak.eventTweak);
			}
			if (tweak.playerDamageDealt)
			{
				object.pdd = playerDamageDealtToObject(tweak.playerDamageDealt);
			}
			if (tweak.playerDamageReceived)
			{
				object.pdr = playerDamageReceivedToObject(tweak.playerDamageReceived);
			}
			return object;
		}
		
		public static function taskTweakToObject(taskTweak:TaskTweak) : Object
		{
			var object:Object = {};
			
			object.tid = taskTweak.taskId;
			if (taskTweak.tweak)
			{
				object.ts = [];
				
				for each (var tweak:Tweak in taskTweak.tweak)
				{
					object.ts.push(tweakToObject(tweak));
				}
			}
			return object;
		}
		
		public static function eventTweakToObject(eventTweak:EventTweak) : Object
		{
			var object:Object = {};
			
			object.en = eventTweak.eventNumber;
			if (eventTweak.taskTweak)
			{
				object.tts = [];
				
				for each (var taskTweak:TaskTweak in eventTweak.taskTweak)
				{
					object.tts.push(taskTweakToObject(taskTweak));
				}
			}
			return object;
		}
			
		public static function playerDamageDealtToObject(playerDamageDealt:PlayerDamageDealt) : Object
		{
			var object:Object = {};
			
			object.dam = playerDamageDealt.globalDamagePercentChange;
			return object;
		}
		
		public static function playerDamageReceivedToObject(playerDamageReceived:PlayerDamageReceived) : Object
		{
			var object:Object = {};
			
			object.dam = playerDamageReceived.globalDamagePercentChange;
			return object;
		}
	}
}