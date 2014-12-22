package com.cc.utils
{
	import com.adverserealms.log.Logger;
	import com.cc.widget.WidgetGearWithBackground;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class GenericSWF extends EventDispatcher
	{
		private var _queuedImages:Vector.<WidgetGearWithBackground> = new Vector.<WidgetGearWithBackground>();
		private var _loader:Loader;
		private var _loadedData:LoaderInfo;
		private var _swfUrl:String;
		
		public function GenericSWF(swfUrl:String)
		{
			_swfUrl = swfUrl; 
			if (_swfUrl != null)
			{
				load(_swfUrl);
			}
		}
		
		public function load(swfUrl:String):void
		{
			_loader = new Loader();
			var request:URLRequest = new URLRequest(GLOBAL._storageURL + swfUrl);
			_loader.load(request, new LoaderContext(true));
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedImages);
		}
		
		public function get isLoaded():Boolean
		{
			return _loadedData != null;
		}
		
		private function ioErrorHandler(event:Event):void
		{
			Logger.error("Unable to load " + event.toString());
		}
		
		private function loadedImages(event:Event):void
		{
			_loadedData = event.target as LoaderInfo;
			processQueuedImages();
			dispatchEvent(event);
		}
		
		private function processQueuedImages():void
		{
			for (var i:int = 0; i < _queuedImages.length; i++) 
			{
				var placeHolder:WidgetGearWithBackground = _queuedImages[i];
				var container:DisplayObjectContainer = placeHolder.parent;
				if (container != null)
				{
					var image:DisplayObject = getGraphicFromLoadedData(placeHolder.name, new Point(placeHolder.width, placeHolder.height));
					if (image)
					{
						var index:int = container.getChildIndex(placeHolder);
						container.removeChild(placeHolder);
						container.addChildAt(image, index);
					}
				}
			}
			_queuedImages = null;
		}
		
		private function getGraphicFromLoadedData(name:String, dimensions:Point = null):DisplayObject
		{
			if (_loadedData.applicationDomain.hasDefinition(name))
			{
				var type:Class = _loadedData.applicationDomain.getDefinition(name) as Class;
				var instance:* = new type();
				var graphic:DisplayObject;
				if (instance is BitmapData)
				{
					graphic = new Bitmap(instance);
				}
				else if (instance is MovieClip)
				{
					graphic = instance as MovieClip;
				}
				else
				{
					Logger.warn("GenericSWF: Unknown datatype when trying to get asset " + name);
				}
				if (dimensions)
				{
					graphic.width = dimensions.x;
					graphic.height = dimensions.y;
				}
				return graphic;
			}
			return null;
		}
		
		public function getGraphicByName(name:String, dimensions:Point = null):DisplayObject
		{
			var graphic:DisplayObject;
			if (_loadedData != null)
			{
				graphic = getGraphicFromLoadedData(name, dimensions);
			}
			else
			{
				if (_loader == null)
				{
					load(_swfUrl);
				}
				if (dimensions != null)
				{
					graphic = new WidgetGearWithBackground(dimensions.x, dimensions.y);
					graphic.name = name;
					_queuedImages.push(graphic);
				}
			}
			return graphic;
		}
	}
}