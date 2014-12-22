package com.cc.utils.graphics
{
	import com.cc.display.ImageText;
	import com.cc.utils.Colors;
	import com.kixeye.utils.movieclip.MovieClipUtils;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;

	public class GraphicsChannel
	{
		private var _name:String;
		private var _enabled:Boolean
		private var _canvas:Sprite;
		private var _subChannelByName:Dictionary = new Dictionary();
		private var _autoFlush:int = int.MAX_VALUE;
		
		public function GraphicsChannel(channelName:String)
		{
			_name = channelName;
			_canvas = new Sprite();
			_canvas.mouseEnabled = false;
			_canvas.mouseChildren = false;
			_canvas.tabChildren = false;
			_canvas.visible = false;
			_enabled = false;
		}
		
		public function get canvas():Sprite
		{
			return _canvas;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (value != _enabled)
			{
				_enabled = value;
				_canvas.visible = _enabled;
				
				if(!_enabled)
				{
					flush();
				}
			}
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function setAutoFlush(frameSkip:int):void
		{
			if(frameSkip > 0)
			{
				_autoFlush = frameSkip;
			}
		}
		
		public function flush():void
		{
			_canvas.graphics.clear();
			MovieClipUtils.clearChildren(_canvas);
			//Re-add any subchannels
			for each (var subChannel:GraphicsChannel in _subChannelByName)
			{
				_canvas.addChild(subChannel.canvas);
			}
		}
		
		public function addSubChannel(subChannelName:String):void
		{
			if(_subChannelByName == null)
			{
				_subChannelByName = new Dictionary();
			}
			var subChannel:GraphicsChannel = getSubChannel(subChannelName);
			if (subChannel == null)
			{
				subChannel = new GraphicsChannel(subChannelName);
				_subChannelByName[subChannelName] = subChannel;
				_canvas.addChild(subChannel.canvas);
			}
		}
		
		public function removeSubChannel(subChannelName:String):void
		{
			if(_subChannelByName == null || subChannelName == null)
			{
				return;
			}
			
			var subChannel:GraphicsChannel = getSubChannel(subChannelName);
			if (subChannel != null)
			{
				if (subChannel.canvas.parent != null)
				{
					subChannel.canvas.parent.removeChild(subChannel.canvas);
				}
				delete _subChannelByName[subChannelName];
			}
		}	
		
		public function getSubChannel(subChannelName:String):GraphicsChannel
		{
			if(_subChannelByName == null || subChannelName == null)
			{
				return null;
			}
			
			return _subChannelByName[subChannelName] as GraphicsChannel;
		}
		
		public function drawLine(x1:Number, y1:Number, x2:Number, y2:Number, thickness:Number, color:uint, alpha:Number ):void
		{
			_canvas.graphics.lineStyle(thickness,color,alpha);
			_canvas.graphics.moveTo(x1,y1);
			_canvas.graphics.lineTo(x2,y2);
		}
		
		public function drawCircle(x:Number, y:Number,radius:Number, thickness:Number, color:uint, alpha:Number, fillColor:uint = 0, fillAlpha:Number = 0):void
		{
			_canvas.graphics.lineStyle(thickness,color,alpha);
			
			if (fillAlpha > 0.0)
			{
				_canvas.graphics.beginFill(fillColor,fillAlpha);
				_canvas.graphics.drawCircle(x,y,radius);
				_canvas.graphics.endFill();
			}
			else
			{
				_canvas.graphics.drawCircle(x,y,radius);
			}
		}
		
		
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number, thickness:Number, color:uint, alpha:Number, fillColor:uint = 0, fillAlpha:Number = 0):void
		{
			_canvas.graphics.lineStyle(thickness,color,alpha);
			
			if (fillAlpha > 0.0)
			{
				_canvas.graphics.beginFill(fillColor,fillAlpha);
				_canvas.graphics.drawEllipse(x - (width / 2),y - (height / 2),width,height);
				_canvas.graphics.endFill();
			}
			else
			{
				_canvas.graphics.drawEllipse(x - (width / 2),y - (height / 2),width,height);
			}
		}
				
		public function drawText(x:Number, y:Number, text:String, fontSize:Number, fontColour:Number = Colors.WHITE, startAlpha:Number = 1.0, alignment:String = TextFormatAlign.LEFT, endAlpha:Number = 1.0, time:Number = Number.MAX_VALUE, endX:Number = Number.MAX_VALUE, endY:Number = Number.MAX_VALUE ):void
		{
			var txtBitmap:Bitmap = new Bitmap(ImageText.Get(text,fontSize, 0, null, fontColour));
			txtBitmap.x = x;
			txtBitmap.y = y;
			
			txtBitmap.alpha = startAlpha;
			var tweenNeeded:Boolean = false;
			var tween:Object = {ease:Quad.easeIn}	
			
			if (alignment == TextFormatAlign.CENTER)
			{
				txtBitmap.x -= txtBitmap.width/2;
				endX -= txtBitmap.width/2;
			}
			else if(alignment == TextFormatAlign.RIGHT)
			{
				txtBitmap.x -= txtBitmap.width;
				endX -= txtBitmap.width;
			}
				
			if (startAlpha != endAlpha)
			{
				tweenNeeded = true;
				tween.alpha = endAlpha;
			}
			
			if (endX != Number.MAX_VALUE && x != endX)
			{
				tweenNeeded = true;
				tween.x = endX;
			}
			
			if (endY != Number.MAX_VALUE && x != endY)
			{
				tweenNeeded = true;
				tween.y = endY;
			}
			
			if(tweenNeeded)
			{
				TweenMax.to( txtBitmap, time, tween);
			}
			
			_canvas.addChild(txtBitmap);
		}
		
		public function drawTriangles(vertices:Vector.<Number>, edgeColour:uint, edgeAlpha:Number, edgeThickness:Number, fillColor:uint, fillAlpha:Number):void
		{
			_canvas.graphics.lineStyle(edgeThickness,edgeColour,edgeAlpha);
			_canvas.graphics.beginFill(fillColor,fillAlpha);
			_canvas.graphics.drawTriangles(vertices);
			_canvas.graphics.endFill();			
		}
		
		public function drawRoundedRectangleISO(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number, thickness:Number, color:uint, alpha:Number, fillColor:uint = 0, fillAlpha:Number = 0):void
		{
			var rectContainer:Sprite = new Sprite();
			var rect:Shape = new Shape();
			rect.rotation = 45;
			rectContainer.scaleY = 0.5;
			
			rect.graphics.lineStyle(thickness, color, alpha);
			
			if (fillAlpha > 0.0)
			{
				rect.graphics.beginFill(fillColor, fillAlpha);
			}
			
			if (ellipseWidth != 0 || ellipseHeight != 0)
			{
				rect.graphics.drawRoundRect(0, 0, width*Math.SQRT2 , height*Math.SQRT2, ellipseWidth*Math.SQRT2, ellipseHeight*Math.SQRT2);
			}
			else
			{
				rect.graphics.drawRect(0, 0, width*Math.SQRT2 , height*Math.SQRT2);
			}
			
			if (fillAlpha > 0.0)
			{
				rect.graphics.endFill();
			}
			
			rect.y = -rect.height * 0.5;
			rectContainer.addChild(rect);
			rectContainer.x = x;
			rectContainer.y = y;

			_canvas.addChild(rectContainer);
		}
		
		public function tickFast():void
		{
			if(_autoFlush != int.MAX_VALUE && GLOBAL._frameNumber % _autoFlush == 0)
			{
				flush();
			}
			
			for each(var subChannel:GraphicsChannel in _subChannelByName)
			{
				subChannel.tickFast();
			}
		}
	}
}