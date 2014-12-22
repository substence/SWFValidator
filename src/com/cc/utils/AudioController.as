package com.cc.utils
{
	import com.cc.playerdata.GlobalStats;
	import com.kixeye.audio.AudioConstants;
	import com.kixeye.audio.AudioOccurrenceModule;
	import com.kixeye.audio.model.AudioSettings;
	import com.kixeye.observer.GameOccurrenceObserver;
	import com.kixeye.observer.GameOccurrencePayload;
	import com.kixeye.observer.IGameOccurrenceObserverBehavior;

	public class AudioController implements IGameOccurrenceObserverBehavior
	{
		public static const DEFAULT_SOUND_VOLUME:Number = 80;
		public static const DEFAULT_MUSIC_VOLUME:Number = 66;
		
		// Singleton Data
		private static var _instance:AudioController;
		
		private var audioModule:AudioOccurrenceModule;
		private var _audioEngineReady:Boolean = false;
		private var _currentMusic:String;
		private var _prevVolumeMusic:Number = DEFAULT_MUSIC_VOLUME;
		private var _prevVolumeSound:Number = DEFAULT_SOUND_VOLUME;
		private var _mutedMusic:Boolean = false;
		private var _mutedSound:Boolean = false;
		
		public function AudioController(singletonBlocker:SingletonBlocker)
		{
			//
		}
		
		public static function get instance():AudioController
		{
			if (_instance == null)
			{
				_instance = new AudioController(new SingletonBlocker());
				GameOccurrenceObserver.getInstance().addObserver( _instance );
			}
			return _instance;
		}
		
		public function initializeAudio():void
		{
			var assetVersion:int = GLOBAL.LOCAL ? 0 : GLOBAL._soundVersion;
			audioModule = new AudioOccurrenceModule( GLOBAL._storageURL + "sounds/audio_config.xml", GLOBAL._storageURL, assetVersion );
			audioModule.ready.add( onAudioEngineReady );
			
			GameOccurrenceObserver.getInstance().addObserver( audioModule );
			
			_mutedMusic = GlobalStats.Get(GlobalStats.VOLUME_MUSIC) == 0;
			_mutedSound = GlobalStats.Get(GlobalStats.VOLUME_SFX) == 0;
			
			//repair volumes that are invalid (1)
			if (GlobalStats.Get(GlobalStats.VOLUME_MUSIC) == 1)
			{
				volumeMusic = DEFAULT_MUSIC_VOLUME;
			}
			if (GlobalStats.Get(GlobalStats.VOLUME_SFX) == 1)
			{
				volumeSound = DEFAULT_SOUND_VOLUME;
			}
			
			if (_mutedMusic)
			{
				GameOccurrenceObserver.getInstance().notify(AudioConstants.TOGGLE_MUSIC);
			}
			else
			{
				volumeMusic = GlobalStats.Get(GlobalStats.VOLUME_MUSIC);
			}
			
			if (_mutedSound)
			{
				GameOccurrenceObserver.getInstance().notify(AudioConstants.TOGGLE_SOUND);
			}
			else
			{
				volumeSound = GlobalStats.Get(GlobalStats.VOLUME_SFX);
			}
		}
		
		private function onAudioEngineReady():void
		{
			_audioEngineReady = true;
		}
		
		public function toggleMusic():void
		{
			var newVolume:Number = isMusicMuted ? _prevVolumeMusic : 0;
			_prevVolumeMusic = volumeMusic;
			volumeMusic = newVolume;
			GlobalStats.Set(GlobalStats.VOLUME_MUSIC, newVolume, true, true);
		}
		
		public function toggleSound():void
		{
			var newVolume:Number = isSoundMuted ? _prevVolumeSound : 0;
			_prevVolumeSound = volumeSound;
			volumeSound = newVolume;
			GlobalStats.Set(GlobalStats.VOLUME_SFX, newVolume, true, true);
		}
		
		public function get isSoundMuted():Boolean
		{
			return _mutedSound;
		}
		
		public function get isMusicMuted():Boolean
		{
			return _mutedMusic;
		}
		
		public function set volumeMusic(newVolume:int):void
		{
			if (newVolume == 0 && !isMusicMuted)
			{
				//turn off the music
				GameOccurrenceObserver.getInstance().notify(AudioConstants.TOGGLE_MUSIC);
				_mutedMusic = true;
				return;
			}
			
			var volume:Number = Math.min(100,Math.max(0,newVolume)) / 100.0;
			if (audioModule.musicVolume != volume)
			{
				audioModule.musicVolume = volume; //expects a value between 0 and 1
			}
			
			//if we're turning on the music, it's very important that we set the right volume and THEN toggle the muting so that the transition sounds right.  Otherwise it'll be too quiet for some reason or other
			if (newVolume > 0 && isMusicMuted)
			{	
				GameOccurrenceObserver.getInstance().notify(AudioConstants.TOGGLE_MUSIC);
				_mutedMusic = false;
			}
		}
		
		public function set volumeSound(newVolume:int):void
		{
			if (newVolume == 0 && !isSoundMuted)
			{
				GameOccurrenceObserver.getInstance().notify(AudioConstants.TOGGLE_SOUND);
				_mutedSound = true;
				return;
			}
			
			var volume:Number = Math.min(100,Math.max(0,newVolume)) / 100.0;
			if (audioModule.soundVolume != volume)
			{
				audioModule.soundVolume = volume; //expects a value between 0 and 1
			}
			
			if (newVolume > 0 && isSoundMuted)
			{	
				GameOccurrenceObserver.getInstance().notify(AudioConstants.TOGGLE_SOUND);
				_mutedSound = false;
			}
		}
		
		public function get volumeMusic():int
		{
			return audioModule.musicVolume * 100;
		}
		
		public function get volumeSound():int
		{
			return audioModule.soundVolume * 100;
		}
		
		public function announceMusicChange( newMusic:String ):void
		{
			if( _currentMusic != newMusic && _audioEngineReady == true )
			{
				GameOccurrenceObserver.getInstance().notify( AudioConstants.STOP_ALL );
				_currentMusic = newMusic;
				GameOccurrenceObserver.getInstance().notify( newMusic );
			}
		}
		
		public function playSound(soundName:String, payload:GameOccurrencePayload = null):void
		{
			if (!isSoundMuted)
			{
				GameOccurrenceObserver.getInstance().notify(soundName, payload);
			}
		}
		
		public function startLoopingSound( soundType:String, seed:String, modifications:Array = null ) : void
		{
			if(modifications == null)
			{
				modifications = [];
			}
			DebugUtils.assert(seed != null && seed.length > 0 , "AudioUtils::startLoopingSound Empty Seed. Seed cannopt be null or ''");
					
			var suffix:String = "_start";
			if( modifications.length > 0 )
			{
				suffix += "_" + modifications.join("_");
			}
			GameOccurrenceObserver.getInstance().notify( soundType + suffix, buildAudioSettingsPayload( seed ) );
		}
		
		public function stopLoopingSound( soundType:String, seed:String, modifications:Array = null ) : void
		{
			if(modifications == null)
			{
				modifications = [];
			}
			DebugUtils.assert(seed != null && seed.length > 0 , "AudioUtils::stopLoopingSound Empty Seed. Seed cannopt be null or ''");
			
			var suffix:String = "_stop";
			if( modifications.length > 0 )
			{
				suffix += "_" + modifications.join("_");
			}
			GameOccurrenceObserver.getInstance().notify( soundType + suffix, buildAudioSettingsPayload( seed ) );
		}
		
		private function buildAudioSettingsPayload( seed:String ):GameOccurrencePayload
		{
			var audioSettings:AudioSettings = new AudioSettings();
			audioSettings.tokenSeed = seed;
			var payload:GameOccurrencePayload = new GameOccurrencePayload();
			payload.audioSettings = audioSettings;
			return payload;
		}
		
		public function notify( occurrenceId:String, payload:GameOccurrencePayload = null ):void
		{
			//nothing to do yet
		}
	}
}

// Used to enforce compile-time safety for the singleton
internal class SingletonBlocker {}
//test commit to demo merge