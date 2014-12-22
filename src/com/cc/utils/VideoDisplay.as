package com.cc.utils
{
	/*
	* Borrowed from BP
	* Original package com.waterworld.utils.display.video
	*/
	
	import com.adverserealms.log.Logger;
	import com.cc.display.Fonts;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class VideoDisplay extends Sprite
	{
		private var _background:Sprite;
		
		private var _videoURL:String;
		private var _displayWidth:int;
		private var _displayHeight:int;
		
		private var _video:Video;
		private var _netConnection:NetConnection;
		private var _netStream:NetStream;
		
		private var _videoWidth:int;
		private var _videoHeight:int;
		private var _videoRatio:Number;
		private var _videoDuration:Number;
		private var _videoVolume:Number = 1;
		
		private var _videoSoundTranform:SoundTransform;
		
		private var _topBuffer:int;
		
		private var _isVideoComplete:Boolean;
		private var _videoCompleteCallback:Function;
		
		private var _loopBackTo:Number;
		private var _bufferImage:Sprite;
		
		public function VideoDisplay( videoURL:String, displayWidth:int, displayHeight:int, isAutoPlay:Boolean = false, topBuffer:int = 0, bufferImage:Sprite = null )
		{
			this._videoURL = videoURL;
			this._displayWidth = displayWidth;
			this._displayHeight = displayHeight;
			this._topBuffer = topBuffer;
			
			this.drawBackground();
			
			if ( isAutoPlay )
			{
				this.playVideo();
			}

			_bufferImage = bufferImage;
		}
		
		public function playVideo():void
		{
			this.initVideo();
		}
		
		public function getPercentPlayed():Number
		{
			return ( this._netStream.time / this._videoDuration ) * 100;
		}
		
		public function getPercentDownloaded():Number
		{
			return ( this._netStream.bytesLoaded / this._netStream.bytesTotal ) * 100;
		}
		
		public function isVideoComplete():Boolean
		{
			return this._isVideoComplete;
		}
		
		public function set videoCompleteCallback( videoCompleteCallback:Function ):void
		{
			this._videoCompleteCallback = videoCompleteCallback;
		}
		
		public function set loopBackTo( loopBackTo:Number ):void
		{
			this._loopBackTo = loopBackTo;
		}
		
		public function resize( displayWidth:int = -1, displayHeight:int = -1 ):void
		{
			if ( displayWidth > 0 )
			{
				this._displayWidth = displayWidth;
				this._displayHeight = displayHeight;
			}
			
			this._background.width = this._displayWidth;
			this._background.height = this._displayHeight;
			
			if ( this._video != null )
			{
				this._video.width = this._displayWidth;
				this._video.height = this._video.width * this._videoRatio;
			
				if ( this._video.height > this._displayHeight )
				{
					this._video.height = this._displayHeight
					this._video.width = this._video.height / this._videoRatio;
				}
			}
			
			this._video.x = ( this._displayWidth - this._video.width ) / 2;
			this._video.y = this._topBuffer + ( this._displayHeight - this._video.height ) / 2;
		}
		
		private function initVideo():void
		{
			if ( this._video == null )
			{
				this._video = new Video();
				this._video.addEventListener( Event.RENDER, this.handleRender );
				this.addChild( this._video );
				addChild(_bufferImage);
			}
			
			if ( this._netConnection == null )
			{
				this._netConnection = new NetConnection();
				this._netConnection.addEventListener( NetStatusEvent.NET_STATUS, this.handleNetStatus );
				this._netConnection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, this.handleSecurityError );
				this._netConnection.connect( null );
			}
		}
		
		private function connectNetStream():void
		{
			this._netStream = new NetStream( this._netConnection );
			this._netStream.addEventListener( NetStatusEvent.NET_STATUS, this.handleNetStatus );
			this._netStream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			this._netStream.client = this;
			this._netStream.inBufferSeek = true;
			
			this._video.attachNetStream( this._netStream );
			this._netStream.play( this._videoURL );
		}
		
		private function handleRender(e:Event):void
		{
			if(_bufferImage && this.contains(_bufferImage))
			{
				removeChild(_bufferImage);
				this._video.removeEventListener(Event.RENDER,this.handleRender);
			}			
		}
		
		//This method is expected buy the as video player and is needed
		//to prevent and exception that was being thrown without it.
		//All of our video controls are handled in handleNetStatus,
		//so it doesn't need to handle anything
		public function onPlayStatus(infoObject:Object):void
		{
		}
		
		private function handleNetStatus( e:NetStatusEvent ):void
		{
			Logger.debug(e.info.code);
			switch ( e.info.code )
			{
				case "NetConnection.Connect.Success":
					this.connectNetStream();
					break;
				
				case "NetStream.Play.StreamNotFound":
					if(_bufferImage && !this.contains(_bufferImage))
					{
						Logger.console("Stream not found");
						addChild(_bufferImage);
					}
					break;
				
				case "NetStream.Play.Stop":
					Logger.console("Play Stop");
					this._isVideoComplete = true;
					break;
				
				case "NetStream.Buffer.Empty":
				
					if(!this._isVideoComplete && _bufferImage && !this.contains(_bufferImage))
					{
						Logger.console("Buffering");
						addChild(_bufferImage);
					}
					
					if(this._isVideoComplete && !isNaN( this._loopBackTo ) )
					{
						Logger.console("Restarting Video");
						this._netStream.seek(this._loopBackTo );
						this._netStream.play(this._videoURL);
						this._isVideoComplete = false;
					}
					
										
					break;
				
				case "NetStream.Buffer.Full":
					if(_bufferImage && this.contains(_bufferImage))
					{
						removeChild(_bufferImage);
					}
					break;
			}
		}
		
		private function asyncErrorHandler( e:AsyncErrorEvent ):void
		{
		}
		
		private function handleSecurityError( e:SecurityErrorEvent ):void
		{
		}
		
		public function onXMPData( data:Object ):void
		{
			
		}
		
		public function onMetaData( data:Object ):void
		{
			this._videoHeight = data.height;
			this._videoWidth = data.width;
			this._videoRatio = this._videoHeight / this._videoWidth;
			this._videoDuration = data.duration;
			
			/* props of the data Object
			audiocodecid: 2
			videodatarate: 308.511
			audiodelay: 0.027
			framerate: 30
			videocodecid: 4
			height: 350
			audiodatarate: 96
			canSeekToEnd: true
			width: 760
			duration: 41.966
			*/
			
			this.resize();
		}
		
		public function onCuePoint( data:Object ):void
		{
		}
		
		private function drawBackground():void
		{
			this._background = new Sprite();
			
			with ( this._background.graphics )
			{
				beginFill( 0x000000 );
				drawRect( 0, 0, this._displayWidth, this._displayHeight );
			}
			
			this.addChild( this._background );
		}
		
		public function get videoX():int
		{
			if ( this._video != null )
			{
				return this._video.x;
			}
			
			return 0;
		}
		
		public function get videoY():int
		{
			if ( this._video != null )
			{
				return this._video.y;
			}
			
			return 0;
		}
		
		public function get videoHeight():int
		{
			return this._videoHeight;
		}
		
		public function get videoWidth():int
		{
			return this._videoWidth;
		}
		
		public function toggleMute():void
		{
			if ( this._netStream != null )
			{
				this._videoSoundTranform = this._netStream.soundTransform;
				
				if ( this._videoSoundTranform.volume > 0 )
				{
					this._videoVolume = this._videoSoundTranform.volume;
					this._videoSoundTranform.volume = 0;
				}
				else {
					this._videoSoundTranform.volume = this._videoVolume;
				}
				
				this._netStream.soundTransform = this._videoSoundTranform;
			}
		}
		
		public function get videoVolume():Number
		{
			return this._netStream.soundTransform.volume;
		}
			
		public function finalize():void
		{
			this._netStream.close();
			this._netConnection.close();
			this.removeChild( this._video );
			this._video = null;
			this._netStream = null;
			this._netConnection = null;
		}
	}
}